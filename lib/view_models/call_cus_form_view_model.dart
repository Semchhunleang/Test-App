import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/services/api/field_service/fs_api_service.dart';
import 'package:umgkh_mobile/utils/image_picker.dart';
import 'package:umgkh_mobile/utils/show_dialog.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/field_service_view_model.dart';

class CallCustomerFormViewModel extends ChangeNotifier {
  bool isNote = false, isDuration = false, isEvidence = false;
  TextEditingController durationCtrl = TextEditingController();
  TextEditingController noteCtrl = TextEditingController();
  String validateText = '';
  File? picture;
  File? get selectedPicture => picture;

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  onChangeDuration(String v) => notify(
      v, (val) => trimStr(v).isEmpty ? isDuration = true : isDuration = false);

  onChangeNotes(String v) =>
      notify(v, (val) => trimStr(v).isEmpty ? isNote = true : isNote = false);

  void onChangeNote(String v) => notify(v, (val) {
        String trimed = v.replaceAll(RegExp(r'\s+'), '');
        if (trimed.length >= 25) {
          isNote = false;
          validateText = 'Text ${trimed.length} is OK';
        } else {
          isNote = true;
          validateText = v.isEmpty
              ? 'Field required'
              : 'Note must be at least 25 characters (${trimed.length})';
        }
      });

  onChangeEvidence() => notify(null, (val) {
        selectedPicture != null ? isEvidence = false : isEvidence = true;
      });

  bool isValidated() {
    onChangeNote(noteCtrl.text);
    onChangeDuration(durationCtrl.text);
    onChangeEvidence();
    return isNote || isDuration || isEvidence;
  }

  Future<void> imagePicker(bool isCapture) async {
    File? image = isCapture ? await takePhoto() : await pickImageFromGallery();
    if (image != null) {
      picture = image;
      onChangeEvidence();
    }
  }

  Future<void> insertCallToCustomer(
      BuildContext context, int id, String serviceType) async {
    try {
      Map<String, dynamic> data = {
        "call_to_customer_id": id,
        "call_duration": durationCtrl.text,
        "note": noteCtrl.text
      };

      await FieldServiceAPIService()
          .insertCallToCustomer(selectedPicture, data)
          .then((value) {
        if (context.mounted) {
          !value.message!.contains('error')
              ? showResultDialog(context, '${value.message}',
                  isBackToList: true)
              : showResultDialog(context, '${value.message}',
                  isBackToList: false);
          if (!value.message!.contains('error')) {
            final viewModelFS =
                Provider.of<FieldServiceViewModel>(context, listen: false);
            viewModelFS.fetchDataByData(id, serviceType, context: context);
          }
        }
        notifyListeners();
      });
    } catch (e) {
      debugPrint('$e');
    }
  }

  onRemovePic() => notify(null, (val) => picture = null);
  resetValidate() => isNote = isDuration = isEvidence = false;

  resetForm() {
    durationCtrl.clear();
    noteCtrl.clear();
    picture = null;
  }
}
