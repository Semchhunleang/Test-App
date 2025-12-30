import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:umgkh_mobile/view_models/small_paper_view_model.dart';
import 'package:umgkh_mobile/view_models/vehicle_check_form_view_model.dart';
import 'package:umgkh_mobile/views/pages/am/small_paper/form_and_info.dart';
import 'package:umgkh_mobile/views/pages/am/vehicle_check/form_and_info.dart';
import '../../../../utils/show_dialog.dart';
import '../../../../view_models/vehicle_check_view_model.dart';

class ScanVehicleCheckPage extends StatefulWidget {
  const ScanVehicleCheckPage({Key? key}) : super(key: key);

  @override
  State<ScanVehicleCheckPage> createState() => _ScanVehicleCheckPageState();
}

class _ScanVehicleCheckPageState extends State<ScanVehicleCheckPage> {
  CameraController? controller;
  late QRViewController qrController;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    qrController.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
    );

    controller =
        CameraController(camera, ResolutionPreset.high, enableAudio: false);

    await controller!.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan QR"),
      ),
      body: Consumer<VehicleCheckViewModel>(builder: (context, p, child) {
        return Stack(
          children: [
            CameraPreview(controller!),
            QRView(
              key: _qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 2,
                borderLength: 40,
                borderWidth: 4,
                cutOutSize: MediaQuery.of(context).size.width * 0.7,
              ),
            ),
            if (p.isLoadingDataById)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        );
      }),
    );
  }

  void _onQRViewCreated(QRViewController qrCtrl) {
    qrController = qrCtrl;
    qrController.scannedDataStream.listen((data) {
      stopCamera();
      if (data.code != null) {
        try {
          final decodedCode = jsonDecode(data.code!);
          final decodedData = decodedCode['data'];
          String hash = '';
          if (decodedData['type'] == 'vehicle_check') {
            hash = sha256
                .convert(
                  utf8.encode(
                    jsonEncode({
                      "id": decodedData['id'],
                      "kmEndStore": decodedData['kmEndStore'],
                      "type": "vehicle_check",
                      "lockkey": "umgkhmererp"
                    }),
                  ),
                )
                .toString();
          } else if (decodedData['type'] == 'small_paper') {
            hash = sha256
                .convert(
                  utf8.encode(
                    jsonEncode({
                      "id": decodedData['id'],
                      "type": "small_paper",
                      "lockkey": "umgkhmererp"
                    }),
                  ),
                )
                .toString();
          }
          if (hash == decodedCode['hash']) {
            if (decodedData != null && decodedData is Map<String, dynamic>) {
              if (decodedData['type'] == 'vehicle_check') {
                int? id = decodedData['id'] as int?;
                String? kmEndStore = decodedData['kmEndStore'] as String?;
                if (id != null) {
                  if (mounted) {
                    final pForm = Provider.of<VehicleCheckFormViewModel>(
                        context,
                        listen: false);
                    pForm.kmEndStoreCtrl.text = kmEndStore ?? "";
                  }
                  onUpdateVehicleCheck(id);
                } else {
                  if (mounted) {
                    showResultDialog(context, 'Invalid QR code: No ID found.');
                  }
                }
              } else if (decodedData['type'] == 'small_paper') {
                int? id = decodedData['id'] as int?;
                if (id != null) {
                  onUpdateSmallPaper(id);
                } else {
                  if (mounted) {
                    showResultDialog(context, 'Invalid QR code: No ID found.');
                  }
                }
              } else {
                if (mounted) {
                  showResultDialog(context, 'Invalid QR code format.');
                }
              }
            } else {
              if (mounted) {
                showResultDialog(
                    context, 'Invalid QR, Not Small Paper or Vehicle Check.');
              }
            }
          } else {
            if (mounted) {
              showResultDialog(context, 'Your QR is not valid!');
            }
          }
        } catch (e) {
          if (mounted) {
            showResultDialog(context, 'Failed to parse QR code.');
          }
        }
      }
    });
  }

  void stopCamera() {
    qrController.pauseCamera();
    if (controller != null && controller!.value.isStreamingImages) {
      controller!.stopImageStream();
    }
  }

  void navPushAndClear(BuildContext context, Widget page,
      {Duration delay = const Duration(milliseconds: 200)}) {
    Future.delayed(delay, () {
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => page),
        );
      }
    });
  }

  onUpdateVehicleCheck(int id) {
    final p = Provider.of<VehicleCheckViewModel>(context, listen: false);
    final pForm =
        Provider.of<VehicleCheckFormViewModel>(context, listen: false);

    p.fetchVehicleCheckById(id).then((value) {
      if (!p.isLoadingDataById) {
        if (value != null) {
          if (mounted) {
            navPushAndClear(
              context,
              VehicleCheckFormInfoPage(
                isForm: false,
                data: value,
                isScan: true,
                kmEnd: pForm.kmEndStoreCtrl.text,
              ),
              delay: const Duration(milliseconds: 200),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No data found for this vehicle check.'),
              ),
            );
          }
        }
      }
    }).catchError((error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching vehicle check: $error'),
          ),
        );
      }
    });
  }

  onUpdateSmallPaper(int id) {
    final p = Provider.of<SmallPaperViewModel>(context, listen: false);
    p.fetchInfo(id).then((value) {
      if (mounted) {
        navPushAndClear(
          context,
          SmallPaperFormAndInfoPage(isForm: false, data: value),
        );
      }
    });
  }
}
