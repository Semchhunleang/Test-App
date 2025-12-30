import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/services/api/log_note/log_note_service.dart';
import 'package:umgkh_mobile/utils/image_picker.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/log_note_view_model.dart';
import 'package:umgkh_mobile/widgets/dialog.dart';

class LogNoteFormViewModel extends ChangeNotifier {
  bool isLocalImgLoading = false, isTextNotEmpty = false, isBtDisabled = false;
  TextEditingController bodyCtrl = TextEditingController();
  List<File> pictures = [];
  List<File> get selectedPictures => pictures;

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  Future<void> imagePicker(BuildContext context, bool isCapture) async {
    killDialog(context);
    isLocalImgLoading = true;
    notifyListeners();
    File? capture;
    List<File> select = [];
    isCapture
        ? capture = await takePhoto()
        : select = await pickMultiImageFromGallery();
    if (select.isNotEmpty) {
      pictures.addAll(select);
      if (select.last.isAbsolute) isLocalImgLoading = false;
    } else {
      isLocalImgLoading = false;
    }
    if (capture != null) pictures.add(capture);
    if (pictures.isNotEmpty) isLocalImgLoading = false;
    notifyListeners();
  }

  void onRemoveImage(int index) =>
      notify(null, (v) => pictures.removeAt(index));

  Future<void> insertData(BuildContext context, int resId, String model) async {
    showLoadingDialog(context);
    FocusScope.of(context).requestFocus(FocusNode());
    if (isBtDisabled) return;
    isBtDisabled = true;
    notifyListeners();
    try {
      Map<String, dynamic> data = {
        "res_id": resId,
        "model": model,
        "body": bodyCtrl.text,
      };

      await LogNoteAPIService().insert(pictures, data).then((value) {
        resetForm();
        if (context.mounted) {
          Provider.of<LogNoteViewModel>(context, listen: false)
              .insertToList(context, resId, model);
          debugPrint('log note=========== ${value.message}');
        }
      });
    } catch (e) {
      if (context.mounted) killDialog(context);
      debugPrint('$e');
    } finally {
      if (context.mounted) killDialog(context);
      isBtDisabled = false;
      notifyListeners();
    }
  }

  void onChangedText(String v) =>
      notify(v, (v) => isTextNotEmpty = trimStr(v).isNotEmpty);

  void killDialog(BuildContext context) {
    if (Navigator.canPop(context)) Navigator.pop(context);
  }

  resetForm() {
    bodyCtrl.clear();
    pictures.clear();
    isTextNotEmpty = isLocalImgLoading = false;
  }
}
