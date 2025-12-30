import 'dart:io';

import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/cms/a4/selection/selection.dart';
import 'package:umgkh_mobile/models/supporthub/file_attachment.dart';
import 'package:umgkh_mobile/models/supporthub/marketing/marketing_product_type.dart';
import 'package:umgkh_mobile/models/supporthub/marketing/marketing_ticket.dart';
import 'package:umgkh_mobile/services/api/attachment/ir_attachment_service.dart';
import 'package:umgkh_mobile/services/api/supporthub/marketing_team/marketing_team_service.dart';
import 'package:umgkh_mobile/utils/image_picker.dart';
import 'package:umgkh_mobile/utils/show_dialog.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class MarketingTicketFormViewModel extends ChangeNotifier {
  bool isDesc = false,
      isName = false,
      isTypeEmpty = false,
      isProductModelEmpty = false;
  bool isPictures = false, isNotPicture = false;
  bool _isButtonDisabled = false, isReadOnly = false;
  bool isLoading = false, isLocalImgLoading = false, isApiImgLoading = false;
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController doneDTCtrl = TextEditingController();
  TextEditingController remarkCtrl = TextEditingController();
  TextEditingController assigneeCtrl = TextEditingController();
  TextEditingController assignedDTCtrl = TextEditingController();
  Selection productModel = Selection(id: 0, name: 'Select');
  MarketingProductType type = MarketingProductType(id: 0, name: 'Select');
  List<File> pictures = [];
  List<File> get selectedPictures => pictures;
  List<File> files = [];
  List<File> get selectedFiles => files;
  bool get isButtonDisabled => _isButtonDisabled;
  int apiImageId = 0;
  List<FileAttachment> downloadedFiles = [];
  String productModelStr = "";

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  onChangeName(String v) => notify(v, (v) => isName = trimStr(v).isEmpty);
  onChangeDesc(String v) => notify(v, (v) => isDesc = trimStr(v).isEmpty);
  onChangedProductModel(dynamic selection) {
    productModel = selection;
    isProductModelEmpty =
        (selection == null || selection.id == null || selection.id == 0) &&
            productModelStr == "";
    notifyListeners();
  }

  // onChangedType(dynamic selection) {
  //   type = selection;
  //   isTypeEmpty =
  //       selection == null || selection.id == null || selection.id == 0;
  //   notifyListeners();
  // }

  onChangedType(dynamic selection) {
    type = selection;
    isTypeEmpty =
        selection == null || selection.id == null || selection.id == 0;

    if (type.name.toLowerCase() != "catalog") {
      productModel = Selection(id: 0, name: 'Select');
      isProductModelEmpty = false;
    }

    notifyListeners();
  }

  onCreateProductModel(String newModel) {
    productModelStr = newModel;

    productModel = Selection(id: 0, name: newModel);
    isProductModelEmpty = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  bool isValidated() {
    onChangeName(nameCtrl.text);
    onChangeDesc(remarkCtrl.text);
    onChangedType(type);

    if (type.name.toLowerCase() == "catalog") {
      onChangedProductModel(productModel);
    } else {
      isProductModelEmpty = false;
    }

    return isName || isDesc || isTypeEmpty || isProductModelEmpty;
  }

  // bool isValidated() {
  //   onChangeName(nameCtrl.text);
  //   onChangeDesc(remarkCtrl.text);
  //   onChangedProductModel(productModel);
  //   onChangedType(type);
  //   return isName || isDesc || isTypeEmpty || isProductModelEmpty;
  // }

  Future<bool> deleteImage(BuildContext context, int id) async {
    isApiImgLoading = true;
    apiImageId = id;
    notifyListeners();
    try {
      final value = await IrAttachmentAPIService().deleteAttachment(id);
      if (context.mounted) {
        showResultDialog(context, '${value.message}', isBackToList: false);
      }
      isApiImgLoading = false;
      notifyListeners();
      return value.statusCode == 200;
    } catch (e) {
      isApiImgLoading = false;
      return false;
    }
  }

  Future<void> imagePicker(BuildContext context, bool isCapture) async {
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

  Future<void> filePicker(BuildContext context) async {
    isLocalImgLoading = true;
    notifyListeners();
    List<File> select = [];
    select = await pickMultiFiles();
    if (select.isNotEmpty) {
      files.addAll(select);
      if (select.last.isAbsolute) isLocalImgLoading = false;
    } else {
      isLocalImgLoading = false;
    }
    if (files.isNotEmpty) isLocalImgLoading = false;
    notifyListeners();
  }

  void onRemoveImage(int index) {
    pictures.removeAt(index);
    notifyListeners();
  }

  void onRemoveFile(int index) {
    files.removeAt(index);
    notifyListeners();
  }

  bool loadImageApi(int id) => isApiImgLoading && id == apiImageId;

  removeApiImageInLocal(MarketingTicket data, int id) => notify(null, (_) {
        data.images.remove(id);
        isNotPicture = data.images.isNotEmpty;
      });

  removeApiFileInLocal(MarketingTicket data, int id) => notify(null, (_) {
        data.files.removeWhere((file) => file.id == id);
        isNotPicture = data.files.isNotEmpty;
      });

  Map<String, dynamic> buildMap() {
    return {
      "name": nameCtrl.text,
      if (productModel.id != 0) "model_id": productModel.id,
      if (productModelStr != "") "product_model": productModelStr,
      if (productModelStr != "") "is_new": true,
      if (type.id != 0) "marketing_product_type_id": type.id,
      "description": remarkCtrl.text,
    };
  }

  Future<void> insertData(BuildContext context) async {
    isLoading = true;
    if (_isButtonDisabled) return;
    _isButtonDisabled = true;
    notifyListeners();
    try {
      await MarketingTeamAPIService()
          .insert(fileImages: pictures, files: files, data: buildMap())
          .then((value) {
        isLoading = false;
        if (context.mounted) {
          showResultDialog(context, '${value.message}',
              isBackToList: !value.message!.contains('error'));
        }
      });
    } catch (e) {
      isLoading = false;
      debugPrint('$e');
    } finally {
      isLoading = false;
      _isButtonDisabled = false;
      notifyListeners();
    }
  }

  Future<void> updateData(BuildContext context, int id, String state) async {
    isLoading = true;
    Map<String, dynamic> data = buildMap()..addAll({'id': id, 'state': state});
    try {
      await MarketingTeamAPIService()
          .update(fileImages: pictures, files: files, data: data)
          .then((value) {
        isLoading = false;
        if (context.mounted) {
          showResultDialog(context, '${value.message}',
              isBackToList: !value.message!.contains('error'));
        }
        notifyListeners();
      });
    } catch (e) {
      isLoading = false;
      debugPrint('$e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  checkReadOnly(String state) => isReadOnly = (state != open);
  resetReadOnly() => isReadOnly = false;
  resetValidate() => isName = isDesc = isPictures = _isButtonDisabled =
      isNotPicture = isLoading = isLocalImgLoading =
          isApiImgLoading = isProductModelEmpty = isTypeEmpty = false;

  resetForm() {
    nameCtrl.clear();
    remarkCtrl.clear();
    pictures.clear();
    files.clear();
    assigneeCtrl.clear();
    assignedDTCtrl.clear();
    doneDTCtrl.clear();
    apiImageId = 0;
    downloadedFiles.clear();
    productModel = Selection(id: 0, name: 'Select');
    type = MarketingProductType(id: 0, name: 'Select');
    productModelStr = "";
  }

  setInfo(MarketingTicket data) {
    isNotPicture = data.images.isNotEmpty || data.files.isNotEmpty;
    nameCtrl.text = data.name;
    type = MarketingProductType(
        name: toTitleCase(data.type.name), id: data.type.id);

    if (data.productModelStr != "") {
      productModel =
          Selection(name: data.productModelStr, id: data.productModel.id);
    } else {
      productModel = Selection(
          name: data.productModel.name != null
              ? toTitleCase(data.productModel.name!)
              : "",
          id: data.productModel.id);
    }
    if (data.assignee != null) assigneeCtrl.text = data.assignee!.name;
    if (data.assignedDT != null) {
      assignedDTCtrl.text = formatReadableDT(data.assignedDT!);
    }
    if (data.doneDt != null) {
      doneDTCtrl.text = formatReadableDT(data.doneDt!);
    }
    remarkCtrl.text = data.description;
  }

  Future<void> downloadFile(List<FileAttachment> ls) async {
    try {
      final value = await MarketingTeamAPIService().fetchDownloadFilePath(ls);
      downloadedFiles.addAll(value);
      notifyListeners();
    } catch (e) {
      debugPrint('$e');
    }
  }
}
