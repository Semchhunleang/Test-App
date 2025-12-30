import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
// import 'package:heic_to_jpg/heic_to_jpg.dart';
import 'package:path/path.dart' as path;
import 'package:heif_converter/heif_converter.dart';

final ImagePicker picker = ImagePicker();
Future<File?> pickImageFromGallery() async {
  final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
  if (photo != null) {
    final String filePath = photo.path;
    final String extension = path.extension(filePath).toLowerCase();

    if (extension == '.heic' || extension == '.heif') {
      String? pngPath = await HeifConverter.convert(filePath, format: 'png');
      if (pngPath != null) {
        return File(pngPath);
      } else {
        return null;
      }
    } else {
      return File(filePath);
    }
  } else {
    return null;
  }
}

Future<File?> takePhoto() async {
  final XFile? photo = await picker.pickImage(source: ImageSource.camera);
  if (photo != null) {
    final String filePath = photo.path;
    final String extension = path.extension(filePath).toLowerCase();

    if (extension == '.heic' || extension == '.heif') {
      String? pngPath = await HeifConverter.convert(filePath, format: 'png');
      if (pngPath != null) {
        return File(pngPath);
      } else {
        return null;
      }
    } else {
      return File(filePath);
    }
  } else {
    return null;
  }
}

// https://www.geeksforgeeks.org/how-to-select-multiple-images-from-image_picker-in-flutter/
// Future<List<File>> pickMultiImageFromGallery() async {
//   List<File> files = [];
//   final pickedFile = await picker.pickMultiImage();
//   List<XFile> xfilePick = pickedFile;
//   if (xfilePick.isNotEmpty) {
//     for (var i = 0; i < xfilePick.length; i++) {
//       files.add(File(xfilePick[i].path));
//     }
//   }
//   return files;
// }

Future<List<File>> pickMultiImageFromGallery() async {
  List<File> files = [];
  final List<XFile> pickedFiles = await picker.pickMultiImage();

  if (pickedFiles.isNotEmpty) {
    for (var xfile in pickedFiles) {
      final String filePath = xfile.path;
      final String extension = path.extension(filePath).toLowerCase();

      if (extension == '.heic' || extension == '.heif') {
        // final jpgPath = await HeicToJpg.convert(filePath);
        String? pngPath = await HeifConverter.convert(filePath, format: 'png');
        if (pngPath != null) {
          files.add(File(pngPath));
        } 
      } else {
        files.add(File(filePath));
      }
    }
  }

  return files;
}

Future<List<File>> pickMultiFiles({bool allowMulti = true}) async {
  List<File> files = [];
  FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: allowMulti,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'xlsx', 'doc', 'docx', 'ppt', 'pptx']);
  if (result != null) {
    for (var file in result.files) {
      if (file.path != null) {
        File selectedFile = File(file.path!);
        int fileSize = selectedFile.lengthSync(); // Get file size in bytes

        // upload (Max size 50MB)
        if (fileSize > 50 * 1024 * 1024) {
          debugPrint("File '${file.name}' exceeds the 50MB limit.");
        } else {
          files.add(selectedFile);
          debugPrint(
              "File selected: ${file.name} (Size: ${(fileSize / (1024 * 1024)).toStringAsFixed(2)} MB)");
        }
      }
    }
  }

  return files;
}

openFiles(String path) async {
  try {
    OpenResult result = await OpenFile.open(
      path,
      isIOSAppOpen: Platform.isIOS, // Set only for iOS
    );
    if (result.type != ResultType.done) {
      debugPrint("Error opening file: ${result.message}");
    }
  } catch (e) {
    debugPrint("Failed to open file: $e");
  }
}

String getFileExt(File file) {
  String fileName = file.path.split('/').last;
  String fileExtension = fileName.split('.').last.toLowerCase();
  return fileExtension;
}

IconData getIconExt(String fileExtension) {
  IconData fileIcon;
  switch (fileExtension) {
    case 'pdf':
      fileIcon = Icons.picture_as_pdf_rounded;
      break;
    case 'xlsx':
      fileIcon = Icons.assessment_rounded;
      break;
    case 'doc':
    case 'docx':
      fileIcon = Icons.description_rounded;
      break;
    case 'ppt':
    case 'pptx':
      fileIcon = Icons.auto_awesome_motion_rounded;
      break;
    case 'txt':
      fileIcon = Icons.text_fields_rounded;
      break;
    case 'csv':
      fileIcon = Icons.table_chart_rounded;
      break;
    case 'jpg':
    case 'jpeg':
    case 'png':
    case 'gif':
      fileIcon = Icons.image_rounded;
      break;
    case 'mp4':
    case 'mov':
    case 'avi':
      fileIcon = Icons.videocam_rounded;
      break;
    case 'mp3':
    case 'wav':
    case 'flac':
      fileIcon = Icons.audiotrack_rounded;
      break;
    case 'zip':
    case 'rar':
      fileIcon = Icons.archive_rounded;
      break;
    case 'html':
    case 'htm':
      fileIcon = Icons.language_rounded;
      break;
    case 'md':
      fileIcon = Icons.note_add_rounded;
      break;
    case 'json':
      fileIcon = Icons.code_rounded;
      break;
    default:
      fileIcon = Icons.insert_drive_file_rounded;
  }

  return fileIcon;
}
