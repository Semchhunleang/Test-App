import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/services/api/field_service/fs_api_service.dart';
import 'package:umgkh_mobile/utils/image_picker.dart';
import 'package:umgkh_mobile/utils/show_dialog.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/field_service_view_model.dart';

class ServiceReportFormViewModel extends ChangeNotifier {
  bool isProblem = false, isRootCuase = false, isAction = false;
  bool isEvidence = false;
  TextEditingController problemCtrl = TextEditingController();
  TextEditingController rootCauseCtrl = TextEditingController();
  TextEditingController actionCtrl = TextEditingController();
  List<File> _pictures = [];
  List<File> get pictures => _pictures;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  onChangeProblem(String v) => notify(v, (v) => isProblem = trimStr(v).isEmpty);
  onChangeRootCause(String v) =>
      notify(v, (v) => isRootCuase = trimStr(v).isEmpty);
  onChangeAction(String v) => notify(v, (v) => isAction = trimStr(v).isEmpty);
  onChangeEvidence() => notify(null, (val) => isEvidence = pictures.isEmpty);

  bool isValidated() {
    onChangeProblem(problemCtrl.text);
    onChangeRootCause(rootCauseCtrl.text);
    onChangeAction(actionCtrl.text);
    onChangeEvidence();
    return isProblem || isRootCuase || isAction || isEvidence;
  }

  Future<void> imagePicker(bool isCapture) async {
    File? capture;
    List<File> select = [];
    isCapture
        ? capture = await takePhoto()
        : select = await pickMultiImageFromGallery();
    if (select.isNotEmpty) pictures.addAll(select);
    if (capture != null) pictures.add(capture);
    onChangeEvidence();
    notifyListeners();
  }

  void onRemoveImage(int index) {
    pictures.removeAt(index);
    notifyListeners();
  }

  Future<void> insertData(
      BuildContext context, int id, String serviceType) async {
    _isLoading = true;
    try {
      List<String> imagePaths = pictures.map((file) => file.path).toList();
      Map<String, dynamic> data = {
        "service_report_project_id": id,
        "problem": problemCtrl.text,
        "root_cause": rootCauseCtrl.text,
        "action": actionCtrl.text,
        "image_paths": jsonEncode(imagePaths),
      };
      await FieldServiceAPIService()
          .insertServiceReport(pictures, data)
          .then((value) async {
        if (context.mounted) {
          showResultDialog(context, '${value.message}',
              isBackToList: !value.message!.contains('error'));
          final p1 = Provider.of<FieldServiceViewModel>(context, listen: false);
          await p1.fetchDataByData(id, serviceType, context: context);
        }
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('$e');
    }
  }

  resetValidate() => isProblem = isRootCuase = isAction = isEvidence = false;

  resetForm() {
    _isLoading = false;
    problemCtrl.clear();
    rootCauseCtrl.clear();
    actionCtrl.clear();
    _pictures = [];
  }
}
