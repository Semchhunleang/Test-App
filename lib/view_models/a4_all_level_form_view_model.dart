import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/base/data/static_selection.dart';
import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/models/cms/a4/a4.dart';
import 'package:umgkh_mobile/services/api/cms/a4_service.dart';
import 'package:umgkh_mobile/utils/image_picker.dart';
import 'package:umgkh_mobile/utils/show_dialog.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/a4_under_level_view_model.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import '../utils/constants.dart';

class A4AllLevelFormViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool isImproveTheme = false,
      isCurrentCondition = false,
      isImproveSuggestion = false,
      isObjective1 = false,
      isObjective2 = false,
      is5sOjective = false,
      isImproveScope = false,
      isDeliverables = false,
      isNextImprovePlan = false,
      isImageBefore = false,
      isImageAfter = false;
  TextEditingController startPeriodCtrl = TextEditingController();
  TextEditingController endPeriodCtrl = TextEditingController();
  TextEditingController creatorCtrl = TextEditingController();
  TextEditingController positionCtrl = TextEditingController();
  TextEditingController departmentCtrl = TextEditingController();
  TextEditingController managerCtrl = TextEditingController();
  TextEditingController documentNoCtrl = TextEditingController();
  TextEditingController gradeBySuperiorCtrl = TextEditingController();
  TextEditingController gradeByCbCtrl = TextEditingController();
  TextEditingController scoreCtrl = TextEditingController();
  TextEditingController improvementThemeCtrl = TextEditingController();
  TextEditingController currentConditionCtrl = TextEditingController();
  TextEditingController improvementSuggestionCtrl = TextEditingController();
  TextEditingController deliverablesCtrl = TextEditingController();
  TextEditingController nextImprovementCtrl = TextEditingController();
  DateTime? _selectedStartDt;
  Map<int, bool> selectedObjectives1 = {};
  Map<int, bool> selectedObjectives2 = {};
  Map<int, bool> selectedSheetProblem = {};
  StaticSelection improvScop =
      StaticSelection(id: 0, name: 'Selection Improvement Scope');
  File? _selectedImageBefore;
  File? _selectedImageAfter;

  File? get selectedImageBefore => _selectedImageBefore;
  File? get selectedImageAfter => _selectedImageAfter;
  User selectedProsposedBy =
      User.defaultUser(id: 0, name: 'Select prosposed by');
  int documentNo = 0;

  A4AllLevelFormViewModel() {
    _initializeDates();
  }

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  void _initializeDates() {
    getCurrentDate();
    notifyListeners();
  }

  getCurrentDate() {
    final DateTime currentDt = DateTime.now();
    final DateTime firstDayOfMonth =
        DateTime(currentDt.year, currentDt.month, 1);
    final DateTime lastDayOfMonth =
        DateTime(currentDt.year, currentDt.month + 1, 0);

    _selectedStartDt = firstDayOfMonth;
    final DateFormat dateFormat = DateFormat("dd MMM yyyy");
    startPeriodCtrl.text = dateFormat.format(firstDayOfMonth);

    endPeriodCtrl.text = dateFormat.format(lastDayOfMonth);
  }

  void toggleSelectionObj1(int index, bool? isSelected) {
    if (isSelected == true) {
      selectedObjectives1[index] = true;
    } else {
      selectedObjectives1.remove(index);
    }
    selectedObjectives1.isEmpty ? isObjective1 = true : isObjective1 = false;
    notifyListeners();
  }

  void toggleSelectionObj2(int index, bool? isSelected) {
    if (isSelected == true) {
      selectedObjectives2[index] = true;
    } else {
      selectedObjectives2.remove(index);
    }
    selectedObjectives2.isEmpty ? isObjective2 = true : isObjective2 = false;
    notifyListeners();
  }

  void toggleSelectionSheetProblem(int index, bool? isSelected) {
    if (isSelected == true) {
      selectedSheetProblem[index] = true;
    } else {
      selectedSheetProblem.remove(index);
    }
    selectedSheetProblem.isEmpty ? is5sOjective = true : is5sOjective = false;
    notifyListeners();
  }

  onChangeImprovScope(dynamic v) => notify(v, (val) {
        improvScop = val;
        improvScop.id == 0 ? isImproveScope = true : isImproveScope = false;
      });
  onChangeImprovTheme(String v) => notify(
      v,
      (val) =>
          trimStr(v).isEmpty ? isImproveTheme = true : isImproveTheme = false);
  onChangeCurrentCondition(String v) => notify(
      v,
      (val) => trimStr(v).isEmpty
          ? isCurrentCondition = true
          : isCurrentCondition = false);
  onChangeImproveSuggestion(String v) => notify(
      v,
      (val) => trimStr(v).isEmpty
          ? isImproveSuggestion = true
          : isImproveSuggestion = false);
  onChangeDeliverables(String v) => notify(
      v,
      (val) =>
          trimStr(v).isEmpty ? isDeliverables = true : isDeliverables = false);
  onChangeNextImprove(String v) => notify(
      v,
      (val) => trimStr(v).isEmpty
          ? isNextImprovePlan = true
          : isNextImprovePlan = false);

  Future<void> _handleImageAction({
    required bool isBefore,
    required Future<File?> Function() pickImageFunction,
  }) async {
    File? image = await pickImageFunction();

    if (image != null) {
      if (isBefore) {
        _selectedImageBefore = image;
        isImageBefore = false;
      } else {
        _selectedImageAfter = image;
        isImageAfter = false;
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

  Future<void> selectStartDateTime(BuildContext context) async {
    if (!context.mounted) return;

    final DateTime firstDt = DateTime(2021);
    final DateTime lastDt = DateTime(2100);

    final DateTime? selectedDt = await showDatePicker(
      context: context,
      initialDate: (startPeriodCtrl.text.isNotEmpty
          ? parseDateFormat(startPeriodCtrl.text)
          : _selectedStartDt ?? DateTime.now()),
      firstDate: firstDt,
      lastDate: lastDt,
    );

    if (selectedDt != null) {
      _selectedStartDt = selectedDt;
      final DateFormat dateFormat = DateFormat("dd MMM yyyy");

      startPeriodCtrl.text = dateFormat.format(selectedDt);

      DateTime lastDayOfMonth =
          DateTime(selectedDt.year, selectedDt.month + 1, 0);

      endPeriodCtrl.text = dateFormat.format(lastDayOfMonth);

      notifyListeners();
    }
  }

  Future<void> updateStateA4(
      BuildContext context, int id, String submit) async {
    _isLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> data = {"id": id, "state": submit};

      await A4APIService().updateStateA4(data).then((value) {
        if (context.mounted) {
          showResultDialog(context, '${value.message}',
              isBackToList: !value.message!.contains('error'));
        }
        if (!value.message!.contains('error')) {
          if (context.mounted) {
            showResultDialog(context, '${value.message}',
                isBackToList: true, isDone: true);
            final viewModelFS =
                Provider.of<A4UnderLevelViewModel>(context, listen: false);
            viewModelFS.fetchA4Data();
            Navigator.pop(context);
          }
        }
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('error : $e');
    }
  }

  Map<String, dynamic> buildMap({int? id}) {
    return {
      if (id != null) "form_a4_id": id,
      "start_period": startPeriodCtrl.text,
      "end_period": endPeriodCtrl.text,
      "document_no": documentNo,
      "improv_scope": improvScop.value,
      "improv_theme": improvementThemeCtrl.text,
      "current_cond": currentConditionCtrl.text,
      "improv_suggest": improvementSuggestionCtrl.text,
      "deliverables": deliverablesCtrl.text,
      "next_improv": nextImprovementCtrl.text,
      if (selectedObjectives1.isNotEmpty)
        "objectives1Array": selectedObjectives1.entries
            .where((entry) => entry.value)
            .map((entry) => entry.key)
            .toList(),
      if (selectedObjectives2.isNotEmpty)
        "objectives2Array": selectedObjectives2.entries
            .where((entry) => entry.value)
            .map((entry) => entry.key)
            .toList(),
      if (selectedSheetProblem.isNotEmpty)
        "sheetProblemsArray": selectedSheetProblem.entries
            .where((entry) => entry.value)
            .map((entry) => entry.key)
            .toList(),
    };
  }

  Future<void> insertA4(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> data = buildMap();
      await A4APIService().insertA4(
          data, [_selectedImageBefore!, _selectedImageAfter!]).then((value) {
        if (context.mounted) {
          showResultDialog(context, '${value.message}',
              isBackToList: !value.message!.contains('error'));
        }
        if (!value.message!.contains('error')) {
          if (context.mounted) {
            showResultDialog(context, '${value.message}',
                isBackToList: true, isDone: true);

            final viewModelFS =
                Provider.of<A4UnderLevelViewModel>(context, listen: false);
            viewModelFS.fetchA4Data();
            Navigator.pop(context);
          }
        }
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('error : $e');
    }
  }

  Future<void> updateA4(BuildContext context, int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> data = buildMap(id: id);
      File? beforeImprov =
          (_selectedImageBefore != null && _selectedImageBefore is File)
              ? _selectedImageBefore as File
              : null;

      File? afterImprov =
          (_selectedImageAfter != null && _selectedImageAfter is File)
              ? _selectedImageAfter as File
              : null;
      await A4APIService()
          .updateA4(data, beforeImprov, afterImprov)
          .then((value) {
        if (context.mounted) {
          showResultDialog(context, '${value.message}',
              isBackToList: !value.message!.contains('error'));
        }
        if (!value.message!.contains('error')) {
          if (context.mounted) {
            showResultDialog(context, '${value.message}',
                isBackToList: !value.message!.contains('error'), isDone: true);
            final viewModelFS =
                Provider.of<A4UnderLevelViewModel>(context, listen: false);
            viewModelFS.fetchA4Data();
          }
        }
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('error update : $e');
    }
  }

  bool isValidated(BuildContext context, A4UnderLevelViewModel a4UnLevelView,
      {A4Data? a4, bool isForm = false}) {
    onChangeImprovTheme(improvementThemeCtrl.text);
    onChangeCurrentCondition(currentConditionCtrl.text);
    onChangeImproveSuggestion(improvementSuggestionCtrl.text);
    onChangeDeliverables(deliverablesCtrl.text);
    onChangeNextImprove(nextImprovementCtrl.text);
    if (improvScop.id == 0) onChangeImprovScope(improvScop);
    isObjective1 = selectedObjectives1.isEmpty;
    isObjective2 = selectedObjectives2.isEmpty;
    is5sOjective = selectedSheetProblem.isEmpty;
    isImageBefore = isForm
        ? selectedImageBefore == null
        : (Constants.getImageA4(a4!.id, "before_improv") == "");

    isImageAfter = isForm
        ? selectedImageAfter == null
        : (Constants.getImageA4(a4!.id, "after_improv") == "");

    return isImproveTheme ||
        isCurrentCondition ||
        isImproveSuggestion ||
        isNextImprovePlan ||
        isImproveScope ||
        isDeliverables ||
        isObjective1 ||
        isObjective2 ||
        is5sOjective ||
        isImageBefore ||
        isImageAfter;
  }

  resetForm(ProfileViewModel p, SelectionsViewModel select) {
    creatorCtrl.text = p.user.name;
    positionCtrl.text = p.user.jobTitle;
    managerCtrl.text = p.user.manager!.name;
    departmentCtrl.text = p.user.department!.name;
    documentNoCtrl.text = select.documentNumber!.name!;
    documentNo = select.documentNumber!.id!;
    improvementThemeCtrl.clear();
    currentConditionCtrl.clear();
    improvementSuggestionCtrl.clear();
    deliverablesCtrl.clear();
    nextImprovementCtrl.clear();
    startPeriodCtrl.clear();
    endPeriodCtrl.clear();
    scoreCtrl.clear();
    gradeByCbCtrl.clear();
    gradeBySuperiorCtrl.clear();
    getCurrentDate();
    _selectedImageBefore = null;
    _selectedImageAfter = null;
    improvScop = StaticSelection(id: 0, name: 'Selection Improvement Scope');
    selectedObjectives1 = {};
    selectedObjectives2 = {};
    selectedSheetProblem = {};
    isImproveTheme = isCurrentCondition = isImproveSuggestion = isObjective1 =
        isObjective2 = is5sOjective = isImproveScope = isDeliverables =
            isNextImprovePlan = isImageBefore = isImageAfter = false;
  }

  setInfo(A4Data a4, SelectionsViewModel selectView,
      A4UnderLevelViewModel a4UnLevelView) {
    startPeriodCtrl.text = formatReadableDate(a4.startPeriod!);
    endPeriodCtrl.text = formatReadableDate(a4.endPeriod!);
    creatorCtrl.text = a4.creator != null ? a4.creator!.name : "";
    managerCtrl.text = a4.manager != null ? a4.manager!.name : "";
    positionCtrl.text = a4.creator != null ? a4.creator!.jobTitle : "";
    departmentCtrl.text = a4.creator != null && a4.creator!.department != null
        ? a4.creator!.department!.name
        : "";
    documentNoCtrl.text = a4.documentNo != null && a4.documentNo!.name != null
        ? a4.documentNo!.name!
        : "";
    scoreCtrl.text = a4.score.toString();
    gradeBySuperiorCtrl.text = (a4.gradeBySuperior ?? "").toUpperCase();
    gradeByCbCtrl.text = (a4.gradeByCb ?? "").toUpperCase();
    improvementThemeCtrl.text =
        a4.improvTheme != null ? convertHtmlToText(a4.improvTheme!) : "";
    currentConditionCtrl.text =
        a4.currentCond != null ? convertHtmlToText(a4.currentCond!) : "";
    improvementSuggestionCtrl.text =
        a4.improvSuggest != null ? convertHtmlToText(a4.improvSuggest!) : "";
    deliverablesCtrl.text =
        a4.deliverables != null ? convertHtmlToText(a4.deliverables!) : "";
    nextImprovementCtrl.text =
        a4.nextImprov != null ? convertHtmlToText(a4.nextImprov!) : "";
    improvScop = selectView.improvScope.firstWhere(
      (scope) => scope.value == a4.improvScope,
      orElse: () => StaticSelection(id: 0, name: 'Selection Improvement Scope'),
    );
    isImageBefore = a4UnLevelView.beforeImage == Uint8List(0);
    isImageAfter = a4UnLevelView.afterImage == Uint8List(0);
    selectedObjectives1.clear();
    selectedObjectives2.clear();
    selectedSheetProblem.clear();

    for (var obj in a4.isoObjective1Names ?? []) {
      selectedObjectives1[obj.id] = true;
    }
    for (var obj in a4.isoObjective2Names ?? []) {
      selectedObjectives2[obj.id] = true;
    }
    for (var obj in a4.isoObjective3Names ?? []) {
      selectedSheetProblem[obj.id] = true;
    }
  }
}
