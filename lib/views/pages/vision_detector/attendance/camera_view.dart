import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:umgkh_mobile/utils/face_recognition/painters/face_detector_painter.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/widgets/float_bt.dart';

class CameraView extends StatefulWidget {
  const CameraView(
      {Key? key,
      required this.customPaint,
      required this.onImage,
      required this.upload,
      this.onCameraFeedReady,
      this.onCameraLensDirectionChanged,
      this.initialCameraLensDirection = CameraLensDirection.front})
      : super(key: key);

  final CustomPaint? customPaint;
  final Function(InputImage inputImage, CameraImage cameraImage,
      CameraController? cameraController) onImage;
  final Function(File imageFile) upload;
  final VoidCallback? onCameraFeedReady;
  final Function(CameraLensDirection direction)? onCameraLensDirectionChanged;
  final CameraLensDirection initialCameraLensDirection;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  static List<CameraDescription> _cameras = [];
  CameraController? _controller;
  int _cameraIndex = -1;
  bool isLoading = false;
  bool isFaceDetected = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
    }
    for (var i = 0; i < _cameras.length; i++) {
      if (_cameras[i].lensDirection == widget.initialCameraLensDirection) {
        _cameraIndex = i;
        break;
      }
    }
    if (_cameraIndex != -1) {
      _startLiveFeed();
    }
  }

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _liveFeedBody(),
      floatingActionButton:
          isFaceDetected ? _floatingActionButton() : sizedBoxShrink,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget? _floatingActionButton() {
    if (_cameras.length == 1) return null;
    return DefaultFloatButton(
      height: 70,
      width: 70,
      background: isLoading ? Colors.black12 : primaryColor,
      onTap: takePicture,
      icon: isLoading ? Icons.camera_alt_outlined : Icons.camera_alt_rounded,
      iconSize: 40,
    );
    // return SizedBox(
    //   height: 70.0,
    //   width: 70.0,
    //   child: FloatingActionButton(
    //     backgroundColor: isLoading? Colors.grey:primaryColor,
    //     onPressed: takePicture,
    //     child:  Icon(
    //       isLoading? Icons.camera_alt_outlined:Icons.camera_alt_rounded,
    //       size: 40,
    //     ),
    //   ),
    // );
  }

  Future takePicture() async {
    setState(() {
      isLoading = true;
    });
    _controller?.setFlashMode(FlashMode.off);
    await _controller?.stopImageStream();
    XFile? file = await _controller?.takePicture();
    file = XFile(file!.path);
    widget.upload(File(file.path));
    setState(() {
      isLoading = false;
    });
    _startLiveFeed();
  }

  Widget _liveFeedBody() {
    if (_cameras.isEmpty) return Container();
    if (_controller == null) return Container();
    if (_controller?.value.isInitialized == false) return Container();
    // check if face detected else if NOT block button
    final painter = widget.customPaint?.painter;
    if (painter is FaceDetectorPainter) {
      if (painter.faces.isNotEmpty) {
        for (final face in painter.faces) {
          final boundingBox = face.boundingBox;

          // Hitung rasio wajah terhadap layar
          final faceArea = boundingBox.height * boundingBox.width;
          final screenSize = MediaQuery.of(context).size;
          final screenArea = screenSize.height * screenSize.width;
          final faceAreaRatio = faceArea / screenArea;

          // Cek landmarks
          final landmarks = face.landmarks;
          final landmarksAvailable =
              landmarks[FaceLandmarkType.leftEye] != null &&
                  landmarks[FaceLandmarkType.rightEye] != null &&
                  landmarks[FaceLandmarkType.noseBase] != null &&
                  landmarks[FaceLandmarkType.leftMouth] != null &&
                  landmarks[FaceLandmarkType.rightMouth] != null &&
                  landmarks[FaceLandmarkType.bottomMouth] != null &&
                  landmarks[FaceLandmarkType.leftCheek] != null &&
                  landmarks[FaceLandmarkType.rightCheek] != null 
                  ;

          // Cek kondisi wajah
          if (face.leftEyeOpenProbability != null &&
              face.rightEyeOpenProbability != null &&
              face.leftEyeOpenProbability! > 0.7 &&
              face.rightEyeOpenProbability! > 0.7 &&
              faceAreaRatio > 0.3 &&
              landmarksAvailable) {
            isFaceDetected = true;
            debugPrint("✅ Full face detected!");
            break;
          }
        }
      } else {
        isFaceDetected = false;
        debugPrint("❌ No face detected in the frame.");
      }
    }

    //
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera", style: Theme.of(context).textTheme.titleLarge),
      ),
      body: ColoredBox(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Center(
              child: CameraPreview(
                _controller!,
                child: widget.customPaint,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _startLiveFeed() async {
    final camera = _cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      // Set to ResolutionPreset.high. Do NOT set it to ResolutionPreset.max because for some phones does NOT work.
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }

      _controller?.startImageStream(_processCameraImage).then((value) {
        if (widget.onCameraFeedReady != null) {
          widget.onCameraFeedReady!();
        }
        if (widget.onCameraLensDirectionChanged != null) {
          widget.onCameraLensDirectionChanged!(camera.lensDirection);
        }
      });
      setState(() {});
    });
  }

  Future _stopLiveFeed() async {
    if (_controller != null && _controller!.value.isInitialized) {
      await _controller?.stopImageStream();
      await _controller?.dispose();
      _controller = null;
    }
  }

  void _processCameraImage(CameraImage image) async {
    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) return;
    widget.onImage(inputImage, image, _controller);
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_controller == null) return null;

    // get image rotation

    final camera = _cameras[_cameraIndex];
    final sensorOrientation = camera.sensorOrientation;

    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[_controller!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }

    if (rotation == null) return null;
    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }
}
