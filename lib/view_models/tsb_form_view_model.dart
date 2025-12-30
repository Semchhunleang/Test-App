import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/base/data/static_selection.dart';
import 'package:umgkh_mobile/models/cms/a4/selection/selection.dart';
import 'package:umgkh_mobile/models/cms/tsb/tsb.dart';
import 'package:umgkh_mobile/models/cms/tsb/tsb_line.dart';
import 'package:umgkh_mobile/services/api/cms/tsb/tsb_service.dart';
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/utils/image_picker.dart';
import 'package:umgkh_mobile/utils/show_dialog.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/view_models/tsb_view_model.dart';

class TsbFormViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool isProductBrand = false,
      isTsbProductCateg = false,
      isEngineModel = false,
      isComponentGroup = false,
      isProductModel = false,
      isStockProductionLot = false,
      isImageBefore = false,
      isImageAfter = false,
      isSubject = false,
      isSymptom = false,
      isHistory = false,
      isProblem = false,
      isTypePart = false,
      isProduct = false;
  TextEditingController dateCtrl = TextEditingController();
  TextEditingController preparedByCtrl = TextEditingController();
  TextEditingController positionCtrl = TextEditingController();
  TextEditingController departmentCtrl = TextEditingController();
  TextEditingController managerCtrl = TextEditingController();
  TextEditingController documentNoCtrl = TextEditingController();
  TextEditingController gradeBySuperiorCtrl = TextEditingController();
  TextEditingController gradeByCbCtrl = TextEditingController();
  TextEditingController scoreCtrl = TextEditingController();
  TextEditingController subjectCtrl = TextEditingController();
  TextEditingController problemCtrl = TextEditingController();
  TextEditingController symptomCtrl = TextEditingController();
  TextEditingController historyCtrl = TextEditingController();
  TextEditingController causeAnalysisCtrl = TextEditingController();
  TextEditingController actionCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController qtyCtrl = TextEditingController();

  DateTime? _selectedDt;
  Selection productBrand = Selection(id: 0, name: 'Select');
  Selection tsbProductCateg = Selection(id: 0, name: 'Select');
  Selection engineModel = Selection(id: 0, name: 'Select');
  Selection componentGroup = Selection(id: 0, name: 'Select');
  Selection productModel = Selection(id: 0, name: 'Select');
  Selection stockProductionLot = Selection(id: 0, name: 'Select');
  StaticSelection typePart =
      StaticSelection(id: 0, name: 'Select', value: 'Select');
  Selection product = Selection(id: 0, name: 'Select');
  File? _selectedImageBefore;
  File? _selectedImageAfter;
  // List<TsbLine> tsbLineList = [];
  File? get selectedImageBefore => _selectedImageBefore;
  File? get selectedImageAfter => _selectedImageAfter;
  int documentNo = 0;
  TsbFormViewModel() {
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
    _selectedDt = currentDt;
    final DateFormat dateFormat = DateFormat("dd MMM yyyy");
    dateCtrl.text = dateFormat.format(currentDt);
  }

  Future<void> selectDateTime(BuildContext context) async {
    if (!context.mounted) return;

    final DateTime firstDt = DateTime(2021);
    final DateTime lastDt = DateTime(2100);

    final DateTime? selectedDt = await showDatePicker(
      context: context,
      initialDate: (dateCtrl.text.isNotEmpty
          ? parseDateFormat(dateCtrl.text)
          : _selectedDt ?? DateTime.now()),
      firstDate: firstDt,
      lastDate: lastDt,
    );

    if (selectedDt != null) {
      _selectedDt = selectedDt;
      final DateFormat dateFormat = DateFormat("dd MMM yyyy");

      dateCtrl.text = dateFormat.format(selectedDt);

      notifyListeners();
    }
  }

  onChangeProductBrand(dynamic v) => notify(v, (val) {
        productBrand = val;
        productBrand.id == 0 ? isProductBrand = true : isProductBrand = false;
      });
  onChangeTsbProductCateg(dynamic v) => notify(v, (val) {
        tsbProductCateg = val;
        tsbProductCateg.id == 0
            ? isTsbProductCateg = true
            : isTsbProductCateg = false;
      });
  onChangeEngineModel(dynamic v) => notify(v, (val) {
        engineModel = val;
        engineModel.id == 0 ? isEngineModel = true : isEngineModel = false;
      });
  onChangeComponentGroup(dynamic v) => notify(v, (val) {
        componentGroup = val;
        componentGroup.id == 0
            ? isComponentGroup = true
            : isComponentGroup = false;
      });
  onChangeProductModel(dynamic v) => notify(v, (val) {
        productModel = val;
        productModel.id == 0 ? isProductModel = true : isProductModel = false;
      });
  onChangeStockProductLot(dynamic v) => notify(v, (val) {
        stockProductionLot = val;
        stockProductionLot.id == 0
            ? isStockProductionLot = true
            : isStockProductionLot = false;
      });

  onChangeTypePart(dynamic v) => notify(v, (val) {
        typePart = val;
        typePart.value == "" || typePart.value == "Select"
            ? isTypePart = true
            : isTypePart = false;
      });

  onChangeProduct(dynamic v) => notify(v, (val) {
        product = val;
        product.id == 0 ? isProduct = true : isProduct = false;
        descriptionCtrl.text = product.productName ?? "";
      });
  onChangeSubject(String v) => notify(
      v, (val) => trimStr(v).isEmpty ? isSubject = true : isSubject = false);
  onChangeProblem(String v) => notify(
      v, (val) => trimStr(v).isEmpty ? isProblem = true : isProblem = false);
  onChangeSymptom(String v) => notify(
      v, (val) => trimStr(v).isEmpty ? isSymptom = true : isSymptom = false);
  onChangeHistory(String v) => notify(
      v, (val) => trimStr(v).isEmpty ? isHistory = true : isHistory = false);

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

  Map<String, dynamic> buildMap({int? id}) {
    return {
      if (id != null) "tsb_id": id,
      "date": dateCtrl.text,
      if (documentNo != 0) "document_no": documentNo,
      if (productBrand.id != 0) "manufacturer_id": productBrand.id,
      if (tsbProductCateg.id != 0) "tsb_product_categ_id": tsbProductCateg.id,
      if (engineModel.id != 0) "engine_model_id": engineModel.id,
      if (componentGroup.id != 0) "comp_group_id": componentGroup.id,
      if (productModel.id != 0) "model_id": productModel.id,
      if (stockProductionLot.id != 0) "lot_id": stockProductionLot.id,
      "subject": subjectCtrl.text,
      "problem": problemCtrl.text,
      "symptom": symptomCtrl.text,
      "history": historyCtrl.text,
      "cause_analysis": causeAnalysisCtrl.text,
      "action": actionCtrl.text
    };
  }

  Map<String, dynamic> buildLineMap({int? id, int? tsbLineId}) {
    return {
      if (id != null) "tsb_id": id,
      if (tsbLineId != null) "tsb_line_id": tsbLineId,
      if (product.id != 0) "product_id": product.id,
      if (typePart.value != "") "type_part": typePart.value,
      "description": descriptionCtrl.text,
      if (qtyCtrl.text != "") "qty_line": int.parse(qtyCtrl.text)
    };
  }

  Future<void> updateStateTsb(
      BuildContext context, int id, String state) async {
    _isLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> data = {"id": id, "state": state};

      await TSBAPIService().updateStateTsb(data).then((value) {
        if (context.mounted) {
          showResultDialog(context, '${value.message}',
              isBackToList: !value.message!.contains('error'));
        }
        if (!value.message!.contains('error')) {
          if (context.mounted) {
            showResultDialog(context, '${value.message}',
                isBackToList: true, isDone: true);
            final viewModelFS =
                Provider.of<TsbViewModel>(context, listen: false);
            viewModelFS.fetchTsbData();
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

  Future<void> insertTsb(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> data = buildMap();
      await TSBAPIService().insertTsb(
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
                Provider.of<TsbViewModel>(context, listen: false);
            viewModelFS.fetchTsbData();

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

  Future<void> insertTsbLine(BuildContext context, int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = buildLineMap(id: id);
      await TSBAPIService().insertTsbLine(data).then((value) {
        if (context.mounted) {
          showResultDialog(context, '${value.message}',
              isBackToList: !value.message!.contains('error'));
        }
        if (!value.message!.contains('error')) {
          if (context.mounted) {
            showResultDialog(context, '${value.message}',
                isBackToList: true, isDone: true);
            final viewModelFS =
                Provider.of<TsbViewModel>(context, listen: false);
            viewModelFS.fetchTsbData();
            Navigator.pop(context);
          }
        }
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('error tsb line: $e');
    }
  }

  Future<void> updateA4(BuildContext context, int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> data = buildMap(id: id);
      File? beforePict =
          (_selectedImageBefore != null && _selectedImageBefore is File)
              ? _selectedImageBefore as File
              : null;

      File? afterPict =
          (_selectedImageAfter != null && _selectedImageAfter is File)
              ? _selectedImageAfter as File
              : null;
      await TSBAPIService()
          .updateTsb(data, beforePict, afterPict)
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
                Provider.of<TsbViewModel>(context, listen: false);
            viewModelFS.fetchTsbData();
          }
        }
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('error update : $e');
    }
  }

  Future<void> updateTsbLine(BuildContext context, int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = buildLineMap(tsbLineId: id);
      await TSBAPIService().updateTsbLine(data).then((value) {
        if (context.mounted) {
          showResultDialog(context, '${value.message}',
              isBackToList: !value.message!.contains('error'));
        }
        if (!value.message!.contains('error')) {
          if (context.mounted) {
            showResultDialog(context, '${value.message}',
                isBackToList: true, isDone: true);
            final viewModelFS =
                Provider.of<TsbViewModel>(context, listen: false);
            viewModelFS.fetchTsbData();
            Navigator.pop(context);
          }
        }
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('error tsb line part: $e');
    }
  }

  resetForm(ProfileViewModel p, SelectionsViewModel select) {
    preparedByCtrl.text = p.user.name;
    managerCtrl.text = p.user.manager!.name;
    departmentCtrl.text = p.user.department!.name;
    positionCtrl.text = p.user.jobTitle;
    productBrand = Selection(id: 0, name: 'Select');
    tsbProductCateg = Selection(id: 0, name: 'Select');
    engineModel = Selection(id: 0, name: 'Select');
    componentGroup = Selection(id: 0, name: 'Select');
    productModel = Selection(id: 0, name: 'Select');
    stockProductionLot = Selection(id: 0, name: 'Select');
    _selectedImageBefore = null;
    _selectedImageAfter = null;
    documentNoCtrl.clear();
    documentNo = 0;
    documentNoCtrl.text =
        select.documentNumber != null ? select.documentNumber!.name! : "";
    documentNo = select.documentNumber != null ? select.documentNumber!.id! : 0;
    dateCtrl.clear();
    subjectCtrl.clear();
    problemCtrl.clear();
    symptomCtrl.clear();
    historyCtrl.clear();
    causeAnalysisCtrl.clear();
    actionCtrl.clear();
    getCurrentDate();
    isProblem = false;
    isHistory = false;
    isSubject = false;
    isSymptom = false;
    isComponentGroup = false;
    isProductBrand = false;
    isProductModel = false;
    isEngineModel = false;
    isStockProductionLot = false;
    isImageAfter = false;
    isImageBefore = false;
  }

  setInfo(TSBData tsb) {
    preparedByCtrl.text = tsb.prepareBy != null ? tsb.prepareBy!.name : "";
    managerCtrl.text = tsb.manager != null ? tsb.manager!.name : "";
    positionCtrl.text = tsb.prepareBy != null ? tsb.prepareBy!.jobTitle : "";
    departmentCtrl.text =
        tsb.prepareBy != null && tsb.prepareBy!.department != null
            ? tsb.prepareBy!.department!.name
            : "";
    documentNoCtrl.text = tsb.documentNo != null && tsb.documentNo!.name != null
        ? tsb.documentNo!.name!
        : "";
    scoreCtrl.text = tsb.score.toString();
    gradeBySuperiorCtrl.text = (tsb.gradeBySuperior ?? "").toUpperCase();
    gradeByCbCtrl.text = (tsb.gradeByCb ?? "").toUpperCase();
    dateCtrl.text = formatReadableDate(tsb.date!);
    productBrand = tsb.manufacturer != null
        ? Selection(id: tsb.manufacturer!.id, name: tsb.manufacturer!.name)
        : Selection(id: 0, name: 'Select');
    tsbProductCateg = tsb.productLine != null
        ? Selection(id: tsb.productLine!.id, name: tsb.productLine!.name)
        : Selection(id: 0, name: 'Select');
    debugPrint("tsbProductCateg : ${tsbProductCateg.id}");
    engineModel = tsb.engineModel != null
        ? Selection(id: tsb.engineModel!.id, name: tsb.engineModel!.name)
        : Selection(id: 0, name: 'Select');
    componentGroup = tsb.componentGroup != null
        ? Selection(id: tsb.componentGroup!.id, name: tsb.componentGroup!.name)
        : Selection(id: 0, name: 'Select');
    productModel = tsb.model != null
        ? Selection(id: tsb.model!.id, name: tsb.model!.name)
        : Selection(id: 0, name: 'Select');
    stockProductionLot = tsb.series != null
        ? Selection(id: tsb.series!.id, name: tsb.series!.name)
        : Selection(id: 0, name: 'Select');
    subjectCtrl.text = tsb.subject ?? "";
    problemCtrl.text = tsb.problem ?? "";
    symptomCtrl.text = tsb.symptom ?? "";
    historyCtrl.text = tsb.history ?? "";
    causeAnalysisCtrl.text = tsb.causeAnalysis ?? "";
    actionCtrl.text = tsb.action ?? "";
  }

  bool isValidated({TSBData? tsb, bool isForm = false}) {
    onChangeSubject(subjectCtrl.text);
    onChangeProblem(problemCtrl.text);
    onChangeSymptom(symptomCtrl.text);
    onChangeHistory(historyCtrl.text);
    if (productBrand.id == 0) onChangeProductBrand(productBrand);
    if (engineModel.id == 0) onChangeEngineModel(engineModel);
    if (componentGroup.id == 0) onChangeComponentGroup(componentGroup);
    if (productModel.id == 0) onChangeProductModel(productModel);
    if (stockProductionLot.id == 0) onChangeStockProductLot(stockProductionLot);
    // if (typePart.id == 0) onChangeTypePart(typePart);
    isImageBefore = isForm
        ? selectedImageBefore == null
        : (Constants.getImageA4(tsb!.id, "before_pict") == "");

    isImageAfter = isForm
        ? selectedImageAfter == null
        : (Constants.getImageTsb(tsb!.id, "after_pict") == "");

    return isSubject ||
        isProblem ||
        isSymptom ||
        isHistory ||
        isProductBrand ||
        isEngineModel ||
        isComponentGroup ||
        isProductModel ||
        isStockProductionLot ||
        isImageBefore ||
        isImageAfter;
  }

  bool isValidatedPart() {
    if (typePart.value == "" || typePart.value == "Select") {
      onChangeTypePart(typePart);
    }
    if (product.id == 0) onChangeProduct(product);

    return isTypePart || isProduct;
  }

  resetFormLine() {
    isTypePart = false;
    isProduct = false;
    typePart = StaticSelection(id: 0, name: 'Select', value: 'Select');
    product = Selection(id: 0, name: 'Select');
    descriptionCtrl.clear();
    qtyCtrl.clear();
  }

  setInfoLine(TsbLine tsbLine) {
    product = tsbLine.product != null
        ? Selection(id: tsbLine.product!.id, name: tsbLine.product!.name)
        : Selection(id: 0, name: 'Select');
    typePart = tsbLine.typePart != null
        ? StaticSelection(value: tsbLine.typePart!)
        : StaticSelection(id: 0, name: 'Select');
    descriptionCtrl.text =
        tsbLine.description != null ? tsbLine.description! : "";
    qtyCtrl.text = tsbLine.qtyLine.toString();
  }
}
