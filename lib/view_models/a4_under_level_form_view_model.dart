import 'dart:io';

import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/services/api/cms/a4/a4_under_level_service.dart';
import '../utils/image_picker.dart';
import '../utils/show_dialog.dart';

class A4UnderLevelFormViewModel extends ChangeNotifier {
  File? _selectedImageBefore;
  bool _isLoading = false;
  File? _selectedImageAfter;

  File? get selectedImageBefore => _selectedImageBefore;
  File? get selectedImageAfter => _selectedImageAfter;
  bool get isLoading => _isLoading;

  Future<void> _handleImageAction({
    required bool isBefore,
    required Future<File?> Function() pickImageFunction,
  }) async {
    File? image = await pickImageFunction();

    if (image != null) {
      if (isBefore) {
        _selectedImageBefore = image;
      } else {
        _selectedImageAfter = image;
      }
      notifyListeners();
    }
  }

  Future<void> pickOrCaptureImage(
      {required bool isBefore, required bool fromGallery}) async {
    await _handleImageAction(
      isBefore: isBefore,
      pickImageFunction: fromGallery ? pickImageFromGallery : takePhoto,
    );
  }

  Future<void> createA4UnderLevel(BuildContext context) async {
    if (_isLoading == false) {
      _isLoading = true;
      notifyListeners();

      if (_selectedImageBefore == null || _selectedImageAfter == null) {
        await showResultDialog(
            context, 'The before and after image cannot be empty.',
            isDone: true, isBackToList: false);
        // _isLoading = false;
        notifyListeners();
        return;
      }
    }

    ApiResponse<String> response = await A4UnderLevelAPIService()
        .createA4UnderLevel([_selectedImageBefore!, _selectedImageAfter!]);

    String message = '';
    if (response.message != null) {
      message = response.message!;
    } else {
      message = response.error!;
    }

    if (context.mounted) {
      await showResultDialog(context, message,
          isDone: true, isBackToList: true);
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      resetData();
    }

    _isLoading = false;
    notifyListeners();
  }

  resetData() {
    _selectedImageBefore = null;
    _selectedImageAfter = null;
    notifyListeners();
  }
}
