import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart';
import 'package:image/image.dart' as imglib;
import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/services/local_storage/models/user_local_storage_service.dart';
import 'image_converter.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class MLService {
  final UserLocalStorageService _userLocalStorageService =
      UserLocalStorageService();
  late Interpreter interpreter;
  late Future<User> futureUser;
  List? predictedArray;

  List<double> extractLandmarkVector(Face face) {
    List<FaceLandmarkType> landmarkTypes = [
      FaceLandmarkType.leftEye,
      FaceLandmarkType.rightEye,
      FaceLandmarkType.noseBase,
      FaceLandmarkType.leftCheek,
      FaceLandmarkType.rightCheek,
      FaceLandmarkType.leftEar,
      FaceLandmarkType.rightEar,
      FaceLandmarkType.leftMouth,
      FaceLandmarkType.rightMouth,
      FaceLandmarkType.bottomMouth,
    ];

    List<double> vector = [];

    for (var type in landmarkTypes) {
      final landmark = face.landmarks[type];
      if (landmark != null) {
        vector.add(landmark.position.x.toDouble());
        vector.add(landmark.position.y.toDouble());
      } else {
        // Tambahkan placeholder kalau landmark tidak ada
        vector.add(0.0);
        vector.add(0.0);
      }
    }

    return vector;
  }

  Future<List<dynamic>?> getLandmarks(
      CameraImage cameraImage, Face face) async {
    List input = _preProcess(cameraImage, face);
    input = input.reshape([1, 112, 112, 3]);

    List output = List.generate(1, (index) => List.filled(192, 0));

    await initializeInterpreter();

    interpreter.run(input, output);
    output = output.reshape([192]);

    predictedArray = List.from(output);
    // User? user = await _userLocalStorageService.getUser();
    // double currDist = 0.0;
    // User? predictedResult;
    // currDist = euclideanDistance(user!.faceLandmarks!, predictedArray!);
    // // if (currDist <= 0.7) {
    //   predictedResult = user;
    // // }
    return predictedArray;
  }

  Future<User?> predict(CameraImage cameraImage, Face face) async {
    List input = _preProcess(cameraImage, face);
    input = input.reshape([1, 112, 112, 3]);

    List output = List.generate(1, (index) => List.filled(192, 0));

    await initializeInterpreter();

    interpreter.run(input, output);
    output = output.reshape([192]);

    predictedArray = List.from(output);
    User? user = await _userLocalStorageService.getUser();
    double currDist = 0.0;
    User? predictedResult;
    if (user != null && user.faceLandmarks != null) {
      for (final landmarks in user.faceLandmarks!) {
        currDist = euclideanDistance(landmarks, predictedArray!);
        // currDist = euclideanDistance(user!.faceLandmarks!, predictedArray!);
        if (currDist <= 0.7) {
          predictedResult = user;
        }
      }
    }
    return predictedResult;
  }

  euclideanDistance(List l1, List l2) {
    double sum = 0;
    for (int i = 0; i < l1.length; i++) {
      sum += pow((l1[i] - l2[i]), 2);
    }
    return pow(sum, 0.5);
  }

  Future<void> initializeInterpreter() async {
    try {
      var interpreterOptions = InterpreterOptions()..threads = 4;

      if (Platform.isIOS) {
        // For iOS, we need to load the model differently in release mode
        final byteData =
            await rootBundle.load('assets/models/mobilefacenet.tflite');
        interpreter = Interpreter.fromBuffer(byteData.buffer.asUint8List(),
            options: interpreterOptions);
      } else {
        interpreter = await Interpreter.fromAsset(
          'assets/models/mobilefacenet.tflite',
          options: interpreterOptions,
        );
      }
    } catch (e) {
      debugPrint('Error initializing interpreter: $e');

      rethrow;
    }
  }

  // Future<void> initializeInterpreter() async {
  //   try {
  //     // Load asset
  //     final byteData =
  //         await rootBundle.load('assets/models/mobilefacenet.tflite');

  //     // Create temp file
  //     final tempDir = await getTemporaryDirectory();
  //     final modelFile = File('${tempDir.path}/mobilefacenet.tflite');
  //     await modelFile.writeAsBytes(byteData.buffer.asUint8List());

  //     // Option 1: Using File object (recommended)
  //     interpreter = await Interpreter.fromFile(modelFile);

  //     // Option 2: Using path string (alternative)
  //     // interpreter = await Interpreter.fromFile(modelFile.path);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

//   initializeInterpreter() async {
//     try {
//       if (Platform.isAndroid) {
//         var interpreterOptions = InterpreterOptions()..threads = 4;
//         interpreter = await Interpreter.fromAsset('mobilefacenet.tflite',
//             options: interpreterOptions);
//       } else if (Platform.isIOS) {
//         // Create GPU delegate
//         final gpuDelegate = GpuDelegateV2();

// // Create interpreter options and add delegate
//         final interpreterOptions = InterpreterOptions()
//           ..addDelegate(gpuDelegate);

// // Create interpreter with options
//         interpreter = await Interpreter.fromAsset('mobilefacenet.tflite',
//             options: interpreterOptions);

//         // var interpreterOptions = InterpreterOptions()..threads = 4;
//         // interpreter = await Interpreter.fromAsset('mobilefacenet.tflite',
//         //     options: interpreterOptions);
//       }
//     } catch (e) {
//     }
//   }

  List _preProcess(CameraImage image, Face faceDetected) {
    imglib.Image croppedImage = _cropFace(image, faceDetected);
    imglib.Image img = imglib.copyResizeCropSquare(croppedImage, 112);
    Float32List imageAsList = _imageToByteListFloat32(img);
    _saveImage(img);
    return imageAsList;
  }

  void _saveImage(imglib.Image image) async {
    Image thumbnail = copyResize(image, width: 120);
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    File('$appDocPath/thumbnail-test.png')
        .writeAsBytesSync(encodePng(thumbnail));
  }

  imglib.Image _cropFace(CameraImage image, Face faceDetected) {
    imglib.Image convertedImage = _convertCameraImage(image);
    double x = faceDetected.boundingBox.left - 10.0;
    double y = faceDetected.boundingBox.top - 10.0;
    double w = faceDetected.boundingBox.width + 10.0;
    double h = faceDetected.boundingBox.height + 10.0;
    return imglib.copyCrop(
        convertedImage, x.round(), y.round(), w.round(), h.round());
  }

  imglib.Image _convertCameraImage(CameraImage image) {
    var img = convertToImage(image);
    var img1 = imglib.copyRotate(img!, -90);
    return img1;
  }

  Float32List _imageToByteListFloat32(imglib.Image image) {
    var convertedBytes = Float32List(1 * 112 * 112 * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (var i = 0; i < 112; i++) {
      for (var j = 0; j < 112; j++) {
        var pixel = image.getPixel(j, i);
        buffer[pixelIndex++] = (imglib.getRed(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getGreen(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getBlue(pixel) - 128) / 128;
      }
    }
    return convertedBytes.buffer.asFloat32List();
  }
}
