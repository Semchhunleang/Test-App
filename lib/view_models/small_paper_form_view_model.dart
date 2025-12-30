import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/am/small_paper/small_paper.dart';
import 'package:umgkh_mobile/services/api/am/small_paper/small_paper_service.dart';
import 'package:umgkh_mobile/utils/image_picker.dart';
import 'package:umgkh_mobile/utils/show_dialog.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart';
import '../utils/static_state.dart';

class SmallPaperFormViewModel extends ChangeNotifier {
  bool isDesc = false, isType = false, isReadOnly = false, isPictures = false;
  bool _isButtonDisabled = false;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String selectedTransportation = "car";
  DateTime? _selectedDt;
  TextEditingController requestorCtrl = TextEditingController();
  TextEditingController approverCtrl = TextEditingController();
  TextEditingController descCtrl = TextEditingController();
  TextEditingController plannedDTCtrl =
      TextEditingController(text: formatReadableDT(DateTime.now()));
  TextEditingController actualDTCtrl = TextEditingController();
  List<File> pictures = [];
  List<File> get selectedPictures => pictures;
  bool get isButtonDisabled => _isButtonDisabled;

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  onChangeDesc(String v) =>
      notify(v, (val) => trimStr(v).isEmpty ? isDesc = true : isDesc = false);

  onChangeTransportation(String v) => notify(v, (val) {
        selectedTransportation = val;
        selectedTransportation.isEmpty ? isType = true : isType = false;
      });

  onChangePictures() => notify(null, (val) {
        selectedPictures.isNotEmpty ? isPictures = false : isPictures = true;
      });

  bool isValidated() {
    onChangeDesc(descCtrl.text);
    onChangeTransportation(selectedTransportation);
    return isDesc || isType;
  }

  bool isValidatImage() {
    onChangePictures();
    return isPictures;
  }

  Future<void> selectDateTime(BuildContext context) async {
    final DateTime currentDt = DateTime.now();
    final DateTime firstDt = DateTime(2021);
    final DateTime lastDt = DateTime(2100);
    final DateTime initialDt = currentDt.isBefore(lastDt) ? currentDt : lastDt;

    Future<void> dateAndTimeSelection(DateTime selectedDate) async {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: _selectedDt != null
            ? TimeOfDay(hour: _selectedDt!.hour, minute: _selectedDt!.minute)
            : TimeOfDay.now(),
      );

      if (selectedTime != null) {
        final DateTime selectedDT = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        _selectedDt = selectedDT;
        plannedDTCtrl.text = formatReadableDT(selectedDT);
        notifyListeners();
      }
    }

    final DateTime? selectedDt = await showDatePicker(
      context: context,
      initialDate: _selectedDt ?? initialDt,
      firstDate: firstDt,
      lastDate: lastDt,
    );

    if (selectedDt != null) await dateAndTimeSelection(selectedDt);
  }

  // Future<void> imagePicker(bool isCapture) async {
  //   File? image = isCapture ? await takePhoto() : await pickImageFromGallery();
  //   if (image != null) {
  //     pictures.add(image);
  //     onChangePictures();
  //     notifyListeners();
  //   }
  // }

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

  Map<String, dynamic> buildMap() {
    return {
      "planned_datetime": toApiSubtract7Hours(plannedDTCtrl.text),
      "transportation_type": selectedTransportation,
      "description": descCtrl.text
    };
  }

  Future<void> insertData(BuildContext context) async {
    if (_isButtonDisabled) return;
    _isButtonDisabled = true;
    _isLoading = true;
    notifyListeners();
    try {
      await SmallPaperAPIService()
          .insert(selectedPictures, buildMap())
          .then((value) {
        if (context.mounted) {
          showResultDialog(context, '${value.message}',
              isBackToList: !value.message!.contains('error'),
              isDone: !value.message!.contains('error'));
        }
      });
    } catch (e) {
      debugPrint('$e');
    } finally {
      _isButtonDisabled = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateData(BuildContext context, int id, String state) async {
    Map<String, dynamic> data = buildMap()..addAll({'id': id, 'state': state});
    _isLoading = true;
    notifyListeners();
    try {
      await SmallPaperAPIService().update(selectedPictures, data).then((value) {
        if (context.mounted) {
          showResultDialog(context, '${value.message}',
              isBackToList: !value.message!.contains('error'),
              isDone: !value.message!.contains('error'));
        }
        notifyListeners();
      });
    } catch (e) {
      debugPrint('$e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateDone(BuildContext context, int id) async {
    if (_isButtonDisabled) return;
    _isButtonDisabled = true;
    _isLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> data = {"id": id};
      await SmallPaperAPIService()
          .updateDone(selectedPictures, data)
          .then((value) {
        if (context.mounted) {
          showResultDialog(context, '${value.message}',
              isBackToList: !value.message!.contains('error'));
        }
        notifyListeners();
      });
    } catch (e) {
      debugPrint('$e');
    } finally {
      _isButtonDisabled = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isDHOfRequestor(BuildContext context, int id) =>
      Provider.of<ProfileViewModel>(context, listen: false).user.id == id;

  bool isRequestor(BuildContext context, int id) =>
      Provider.of<ProfileViewModel>(context, listen: false).user.id == id;

  void checkReadOnly(String state, BuildContext context, int id) =>
      isReadOnly = (state == submit ||
          state == approve ||
          state == done ||
          state == reject ||
          !isRequestor(context, id));

  resetValidate() => isDesc = isType = isPictures = _isButtonDisabled = false;

  resetReadOnly() => isReadOnly = false;

  resetForm(BuildContext context) {
    final p = Provider.of<ProfileViewModel>(context, listen: false);
    _selectedDt = null;
    plannedDTCtrl.text = formatReadableDT(DateTime.now());
    actualDTCtrl.clear();
    requestorCtrl.text = p.user.name;
    approverCtrl.text = p.user.manager?.name ?? '';
    selectedTransportation = 'car';
    descCtrl.clear();
    pictures.clear();
  }

  setInfo(SmallPaper data) {
    _selectedDt = data.plannedDatetime;
    plannedDTCtrl.text = formatReadableDT(data.plannedDatetime);
    data.actualDatetime != null
        ? actualDTCtrl.text = formatReadableDT(data.actualDatetime!)
        : null;
    requestorCtrl.text = data.requestor.name;
    approverCtrl.text = data.approver.name;
    selectedTransportation = data.transportationType;
    descCtrl.text = data.description;
  }
}
