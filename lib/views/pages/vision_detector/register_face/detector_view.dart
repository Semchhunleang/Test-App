import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

import 'camera_view.dart';

enum DetectorRFViewMode { liveFeed, gallery }

class DetectorRFView extends StatefulWidget {
  const DetectorRFView({
    Key? key,
    required this.title,
    required this.onImage,
    // required this.upload,
    this.customPaint,
    this.text,
    this.initialDetectionMode = DetectorRFViewMode.liveFeed,
    this.initialCameraLensDirection = CameraLensDirection.back,
    this.onCameraFeedReady,
    this.onCameraLensDirectionChanged,
  }) : super(key: key);

  final String title;
  final CustomPaint? customPaint;
  final String? text;
  final DetectorRFViewMode initialDetectionMode;
  final Function(InputImage inputImage, CameraImage cameraImage,
      CameraController? cameraController) onImage;
  // final Function(File imageFile) upload;
  final Function()? onCameraFeedReady;
  final Function(CameraLensDirection direction)? onCameraLensDirectionChanged;
  final CameraLensDirection initialCameraLensDirection;

  @override
  State<DetectorRFView> createState() => _DetectorRFViewState();
}

class _DetectorRFViewState extends State<DetectorRFView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CameraRFView(
      customPaint: widget.customPaint,
      onImage: widget.onImage,
      // upload: widget.upload,
      onCameraFeedReady: widget.onCameraFeedReady,
      initialCameraLensDirection: widget.initialCameraLensDirection,
      onCameraLensDirectionChanged: widget.onCameraLensDirectionChanged,
    );
  }
}
