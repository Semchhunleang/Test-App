import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:umgkh_mobile/services/api/field_service/fs_api_service.dart';
import 'package:umgkh_mobile/utils/image_picker.dart';
import 'package:umgkh_mobile/utils/show_dialog.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class OverallCheckingFormViewModel extends ChangeNotifier {
  bool isHr = false, isKm = false, isNote = false, isEvidence = false;
  TextEditingController machineHrCtrl = TextEditingController();
  TextEditingController machineKmCtrl = TextEditingController();
  TextEditingController noteCtrl = TextEditingController();
  List<File> _pictures = [];
  List<File> get pictures => _pictures;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  onChange(String v, TextEditingController ctrl) =>
      notify(v, (v) => isKm = isHr = v.isEmpty && ctrl.text.isEmpty);
  onChangeKm(String v) => onChange(v, machineHrCtrl);
  onChangeHr(String v) => onChange(v, machineKmCtrl);
  onChangeNote(String v) => notify(v, (val) => isNote = trimStr(v).isEmpty);
  onChangePictures() => notify(null, (val) => isEvidence = pictures.isEmpty);

  bool isValidated() {
    onChangeHr(machineHrCtrl.text);
    onChangeKm(machineKmCtrl.text);
    onChangeNote(noteCtrl.text);
    onChangePictures();
    return isHr || isKm || isNote || isEvidence;
  }

  Future<void> imagePicker(bool isCapture) async {
    File? capture;
    List<File> select = [];
    isCapture
        ? capture = await takePhoto()
        : select = await pickMultiImageFromGallery();
    if (select.isNotEmpty) pictures.addAll(select);
    if (capture != null) pictures.add(capture);
    onChangePictures();
    notifyListeners();
  }

  void onRemoveImage(int index) {
    pictures.removeAt(index);
    notifyListeners();
  }

  String defaultMachine(String text) => text.isEmpty ? '0' : text;

  Future<void> insertData(BuildContext context, int id) async {
    _isLoading = true;
    try {
      List<String> imagePaths = pictures.map((file) => file.path).toList();
      final data = {
        "tab_overall_checking_id": id,
        "current_machine_hour": defaultMachine(machineHrCtrl.text),
        "current_machine_km": defaultMachine(machineKmCtrl.text),
        "note": noteCtrl.text,
        "check_datetime": rollbackParseDateTime(DateTime.now(),),
        "off_id": "$id-oc-${DateTime.now().toIso8601String()}",
        "image_paths": jsonEncode(imagePaths),
      };

      await FieldServiceAPIService()
          .insertOverallChecking(pictures, data)
          .then((value) {
        if (context.mounted) {
          showResultDialog(context, '${value.message}',
              isBackToList: !value.message!.contains('error'),);
        }
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('$e');
    }
  }

  resetValidate() => isHr = isKm = isNote = isEvidence = false;

  resetForm() {
    _isLoading = false;
    machineHrCtrl.clear();
    machineKmCtrl.clear();
    noteCtrl.clear();
    _pictures = [];
  }
}
