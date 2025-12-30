import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/base/data/static_selection.dart';
import 'package:umgkh_mobile/models/supporthub/file_attachment.dart';
import 'package:umgkh_mobile/models/supporthub/ict/ict_device.dart';
import 'package:umgkh_mobile/models/supporthub/ict/ict_request_category.dart';
import 'package:umgkh_mobile/models/supporthub/ict/ict_ticket.dart';
import 'package:umgkh_mobile/services/api/attachment/ir_attachment_service.dart';
import 'package:umgkh_mobile/services/api/supporthub/ict_team/ict_team_service.dart';
import 'package:umgkh_mobile/utils/image_picker.dart';
import 'package:umgkh_mobile/utils/show_dialog.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import '../../../utils/static_state.dart';

class ICTTicketFormViewModel extends ChangeNotifier {
  bool isDesc = false, isName = false;
  bool isPictures = false, isNotPicture = false;
  bool _isButtonDisabled = false, isReadOnly = false;
  bool isLoading = false, isLocalImgLoading = false, isApiImgLoading = false;
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController closeTicketDTCtrl = TextEditingController();
  TextEditingController summaryCtrl = TextEditingController();
  TextEditingController assigneeCtrl = TextEditingController();
  TextEditingController assignedDTCtrl = TextEditingController();
  List<File> pictures = [];
  List<File> get selectedPictures => pictures;
  List<File> files = [];
  List<File> get selectedFiles => files;
  bool get isButtonDisabled => _isButtonDisabled;
  int apiImageId = 0;
  List<FileAttachment> downloadedFiles = [];
  StaticSelection selectPriority = StaticSelection(name: 'Low', value: 'low');
  ICTRequestCategory selectCategory =
      ICTRequestCategory(id: 0, name: 'Select category');
  List<ICTDevices> selectDevices = [];

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  onChangedPriority(dynamic v) => notify(v, (val) => selectPriority = val);
  onChangedCategory(dynamic v) => notify(v, (val) => selectCategory = val);
  onChangedDevices(dynamic v) => notify(v, (val) => selectDevices = val);
  onRemoveDevices(ICTDevices v) =>
      notify(v, (val) => selectDevices = List.from(selectDevices)..remove(v));
  onChangeName(String v) => notify(v, (v) => isName = trimStr(v).isEmpty);
  onChangeDesc(String v) => notify(v, (v) => isDesc = trimStr(v).isEmpty);
  // onChangeFiles() => notify(
  //     null,
  //     (val) => isNotPicture
  //         ? isPictures = false
  //         : isPictures = (pictures.isEmpty && files.isEmpty));

  bool isValidated() {
    onChangeName(nameCtrl.text);
    onChangeDesc(summaryCtrl.text);
    // onChangeFiles();
    // return isName || isDesc || isPictures;
    return isName || isDesc;
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
    // onChangeFiles();
    notifyListeners();
  }

  Future<void> filePicker(BuildContext context) async {
    isLocalImgLoading = true;
    notifyListeners();
    List<File> select = [];
    select = await pickMultiFiles();
    if (select.isNotEmpty) {
      // files.clear(); // condition: for one file only
      files.addAll(select);
      if (select.last.isAbsolute) isLocalImgLoading = false;
    } else {
      isLocalImgLoading = false;
    }
    if (files.isNotEmpty) isLocalImgLoading = false;
    // onChangeFiles();
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

  Map<String, dynamic> buildMap() {
    return {
      "name": nameCtrl.text,
      if (selectCategory.id != 0) "ict_request_category_id": selectCategory.id,
      "priority": selectPriority.value,
      "ict_devices": selectDevices.map((e) => e.id).toList(),
      "description": summaryCtrl.text,
    };
  }

  Future<void> insertData(BuildContext context) async {
    isLoading = true;
    if (_isButtonDisabled) return;
    _isButtonDisabled = true;
    notifyListeners();
    try {
      await ICTTeamAPIService()
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
      await ICTTeamAPIService()
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

  bool loadImageApi(int id) => isApiImgLoading && id == apiImageId;

  removeApiImageInLocal(ICTTicket data, int id) => notify(null, (_) {
        data.images.remove(id);
        isNotPicture = data.images.isNotEmpty;
      });

  removeApiFileInLocal(ICTTicket data, int id) => notify(null, (_) {
        data.files.removeWhere((file) => file.id == id);
        isNotPicture = data.files.isNotEmpty;
      });

  checkReadOnly(String state) => isReadOnly = (state != open);
  resetReadOnly() => isReadOnly = false;
  resetValidate() => isName = isDesc = isPictures = _isButtonDisabled =
      isNotPicture = isLoading = isLocalImgLoading = isApiImgLoading = false;
  resetForm() {
    nameCtrl.clear();
    summaryCtrl.clear();
    pictures.clear();
    files.clear();
    assigneeCtrl.clear();
    assignedDTCtrl.clear();
    closeTicketDTCtrl.clear();
    apiImageId = 0;
    downloadedFiles.clear();
    selectPriority = StaticSelection(name: 'Low', value: 'low');
    selectCategory = ICTRequestCategory(id: 0, name: 'Select category');
    selectDevices = [];
  }

  setInfo(ICTTicket data) {
    isNotPicture = data.images.isNotEmpty || data.files.isNotEmpty;
    nameCtrl.text = data.name;
    selectPriority = StaticSelection(
        name: toTitleCase(data.priority), value: data.priority.toLowerCase());
    if (data.category != null) selectCategory = data.category!;
    selectDevices = data.devices;
    if (data.assignee != null) assigneeCtrl.text = data.assignee!.name;
    if (data.assignedDT != null) {
      assignedDTCtrl.text = formatReadableDT(data.assignedDT!);
    }
    if (data.closeTicketDT != null) {
      closeTicketDTCtrl.text = formatReadableDT(data.closeTicketDT!);
    }
    summaryCtrl.text = data.description;
  }

  Future<void> downloadFile(List<FileAttachment> ls) async {
    try {
      final value = await ICTTeamAPIService().fetchDownloadFilePath(ls);
      downloadedFiles.addAll(value);
      notifyListeners();
    } catch (e) {
      debugPrint('$e');
    }
  }
}
