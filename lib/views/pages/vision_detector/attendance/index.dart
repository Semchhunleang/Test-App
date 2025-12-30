import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/face_recognition/ml_service.dart';
import 'package:umgkh_mobile/utils/face_recognition/painters/face_detector_painter.dart';
import 'package:umgkh_mobile/view_models/attendance_view_model.dart';

import 'detector_view.dart';

class FaceDetectorView extends StatefulWidget {
  final String state;

  const FaceDetectorView({Key? key, required this.state}) : super(key: key);

  @override
  State<FaceDetectorView> createState() => _FaceDetectorViewState();
}

class _FaceDetectorViewState extends State<FaceDetectorView> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
      enableClassification: true,
    ),
  );
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
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
        return DetectorView(
          title: 'Face Detector',
          customPaint: _customPaint,
          text: _text,
          onImage: _processImage,
          upload: _upload,
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
            face.rightEyeOpenProbability! > 0.7 
            ) {
          await _predictFacesFromImage(
              cameraImage, face, inputImage, cameraController);
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

  Future<void> _predictFacesFromImage(CameraImage cameraImage, Face face,
      InputImage inputImage, CameraController? cameraController) async {
    var user = await MLService().predict(cameraImage, face);
    if (user != null && mounted) {
      Provider.of<AttendanceViewModel>(context, listen: false);

      cameraController?.setFlashMode(FlashMode.off);
      await cameraController?.stopImageStream();
      XFile? file = await cameraController?.takePicture();
      file = XFile(file!.path);
      _upload(File(file.path));
      // setState(() {
      //   isLoading = false;
      // });
      // _startLiveFeed();

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

      // if (mounted) {
      //   Navigator.pop(context);
      // }
      // if (cameraController != null && cameraController.value.isInitialized) {
      //   // await cameraController.stopImageStream();
      // }
    }
  }

  Future<void> _upload(File imageFile) async {
    final attendanceViewModel =
        Provider.of<AttendanceViewModel>(context, listen: false);
    // bool isSaturday = DateTime.now().weekday == DateTime.saturday;

    switch (widget.state) {
      case 'ci':
        await attendanceViewModel.checkIn(context, imageFile);
        break;
      case 'com':
        // if (isSaturday) {
        // await attendanceViewModel.checkOutSaturday(context, imageFile);
        // } else {
        await attendanceViewModel.checkOutMorning(context, imageFile);
        // }
        break;
      case 'cia':
        await attendanceViewModel.checkInAfternoon(context, imageFile);
        break;
      case 'co':
        await attendanceViewModel.checkOut(context, imageFile);
        break;
      default:
        return;
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }
}
