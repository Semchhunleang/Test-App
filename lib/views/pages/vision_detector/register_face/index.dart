import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/face_recognition/ml_service.dart';
import 'package:umgkh_mobile/utils/face_recognition/painters/face_detector_painter.dart';
import 'package:umgkh_mobile/view_models/attendance_view_model.dart';
import 'package:umgkh_mobile/view_models/register_face_view_model.dart';

import 'detector_view.dart';

class FaceDetectorRFView extends StatefulWidget {
  // final String state;

  const FaceDetectorRFView({Key? key}) : super(key: key);

  @override
  State<FaceDetectorRFView> createState() => _FaceDetectorRFViewState();
}

class _FaceDetectorRFViewState extends State<FaceDetectorRFView> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
        enableContours: true,
        enableLandmarks: true,
        enableClassification: true),
  );
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  List<String> landmarks = [];
  var _cameraLensDirection = CameraLensDirection.front;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceViewModel>(builder: (context, viewModel, child) {
      if (viewModel.isLoading) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return DetectorRFView(
          title: 'Face Detector',
          customPaint: _customPaint,
          text: _text,
          onImage: _processImage,
          // upload: _upload,
          initialCameraLensDirection: _cameraLensDirection,
          onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
        );
      }
    });
  }

  Future<void> _processImage(InputImage inputImage, CameraImage cameraImage,
      CameraController? cameraController) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final faces = await _faceDetector.processImage(inputImage);
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = FaceDetectorPainter(
        faces,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
      for (final Face face in faces) {
        if (face.smilingProbability != null &&
            face.smilingProbability! > 0.75 &&
            face.leftEyeOpenProbability! > 0.7 &&
            face.rightEyeOpenProbability! > 0.7 &&
            landmarks.length < 4) {
          var val = await _predictFacesFromImage(
              cameraImage, face, inputImage, cameraController);
          if (val != null && landmarks.length < 4) {
            landmarks.add(val);
          }
        }
        if (face.smilingProbability != null &&
            face.smilingProbability! > 0.75 &&
            face.leftEyeOpenProbability! > 0.7 &&
            face.rightEyeOpenProbability! > 0.7 &&
            landmarks.length == 4) {
          if (mounted) {
            final viweModel =
                Provider.of<RegisterFaceViewModel>(context, listen: false);
            await viweModel.registerFace(context, landmarks.toString());
          }
        }
      }
    } else {
      String text = 'Faces found: ${faces.length}\n\n';
      for (final face in faces) {
        text += 'face: ${face.boundingBox}\n\n';
      }
      _text = text;
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<String?> _predictFacesFromImage(CameraImage cameraImage, Face face,
      InputImage inputImage, CameraController? cameraController) async {
    var landmarks = await MLService().getLandmarks(cameraImage, face);
    return landmarks.toString();
    // if (user != null && mounted) {
    // final attendanceViewModel =
    //     Provider.of<AttendanceViewModel>(context, listen: false);

    // switch (widget.state) {
    //   case 'ci':
    //     await attendanceViewModel.checkIn(context, null);
    //     break;
    //   case 'com':
    //     await attendanceViewModel.checkOutMorning(context, null);
    //     break;
    //   case 'cia':
    //     await attendanceViewModel.checkInAfternoon(context, null);
    //     break;
    //   case 'co':
    //     await attendanceViewModel.checkOut(context, null);
    //     break;
    //   default:
    //     return;
    // }
    //   if (mounted) {
    //     Navigator.pop(context);
    //   }
    //   if (cameraController != null && cameraController.value.isInitialized) {
    //     // await cameraController.stopImageStream();
    //   }

    // }
  }
}
