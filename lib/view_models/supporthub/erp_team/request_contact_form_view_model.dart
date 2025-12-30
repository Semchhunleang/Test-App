import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/base/data/static_selection.dart';
import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/models/supporthub/erp/erp_ticket.dart';
import 'package:umgkh_mobile/models/supporthub/file_attachment.dart';
import 'package:umgkh_mobile/services/api/supporthub/erp_team/erp_team_service.dart';
import 'package:umgkh_mobile/utils/image_picker.dart';
import 'package:umgkh_mobile/utils/show_dialog.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/supporthub/erp_team/request_contact_view_model.dart';
import '../../../utils/static_state.dart';

class RequestContactFormViewModel extends ChangeNotifier {
  bool isDesc = false, isName = false, isReadOnly = false, isFiles = false;
  bool _isButtonDisabled = false, isContact = false, isNotFiles = false;
  bool isLoading = false, isLocalImgLoading = false, isApiImgLoading = false;
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController contactCtrl = TextEditingController();
  TextEditingController descCtrl = TextEditingController();
  TextEditingController assigneeCtrl = TextEditingController();
  TextEditingController rejectReasonCtrl = TextEditingController();
  List<File> pictures = [];
  List<File> get selectedPictures => pictures;
  List<File> files = [];
  List<File> get selectedFiles => files;
  bool get isButtonDisabled => _isButtonDisabled;
  int apiImageId = 0;
  List<FileAttachment> downloadedFiles = [];
  StaticSelection selectType = StaticSelection(name: 'New', value: 'new');
  User selectSalesperson = User.defaultUser(id: 0, name: 'Select salesperson');

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  onChangeName(String v) => notify(v, (v) => isName = trimStr(v).isEmpty);
  onChangeContact(String v) => notify(v, (v) => isContact = trimStr(v).isEmpty);
  onChangeDesc(String v) => notify(v, (v) => isDesc = trimStr(v).isEmpty);
  onChangeType(dynamic v) => notify(v, (val) => selectType = v);
  onChangeSalePerson(dynamic v) => notify(v, (val) => selectSalesperson = v);
  onChangeFiles() => notify(
      null,
      (val) => isNotFiles
          ? isFiles = false
          : isFiles = (pictures.isEmpty && files.isEmpty));

  bool isValidated() {
    onChangeName(nameCtrl.text);
    onChangeContact(contactCtrl.text);
    onChangeDesc(descCtrl.text);
    onChangeFiles();
    return isName || isDesc || isContact || isFiles;
  }

  Future<void> imagePicker(bool isCapture) async {
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
    onChangeFiles();
    notifyListeners();
  }

  Future<void> filePicker() async {
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
    onChangeFiles();
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
      "contact": contactCtrl.text,
      "description": descCtrl.text,
      if (selectType.value.isNotEmpty) "contact_type": selectType.value,
      if (selectSalesperson.id != 0) "salesperson": selectSalesperson.id,
    };
  }

  Future<void> insertData(BuildContext context) async {
    isLoading = true;
    if (_isButtonDisabled) return;
    _isButtonDisabled = true;
    notifyListeners();
    try {
      await ERPTeamAPIService()
          .insert(fileImages: pictures, files: files, data: buildMap())
          .then((value) {
        isLoading = false;
        if (context.mounted) {
          final p1 =
              Provider.of<RequestContactViewModel>(context, listen: false);
          p1.checkOutsideWorkingHours();
          if (p1.outsideworkinghour != null &&
              (!p1.outsideworkinghour!.isOutsideWorkHours &&
                  !p1.outsideworkinghour!.isHoliday)) {
            showResultDialog(context, '${value.message}',
                isBackToList: !value.message!.contains('error'));
          } else {
            showResultDialog(context,
                "Your request has been successfully submitted. Requests made outside office hours may be processed slower than during office hours.");
          }
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

  Future<void> updateData(BuildContext context, int id) async {
    isLoading = true;
    Map<String, dynamic> data = buildMap()..addAll({'id': id});
    try {
      await ERPTeamAPIService()
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
    }
  }

  Future<bool> deleteImage(BuildContext context, int id) async {
    isApiImgLoading = true;
    apiImageId = id;
    notifyListeners();
    try {
      final value = await ERPTeamAPIService().deleteImage(id);
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

  removeApiImageInLocal(ERPTicket data, int id) => notify(null, (_) {
        data.images.remove(id);
        isNotFiles = data.images.isNotEmpty;
      });

  removeApiFileInLocal(ERPTicket data, int id) => notify(null, (_) {
        data.files.removeWhere((file) => file.id == id);
        isNotFiles = data.files.isNotEmpty;
      });

  checkReadOnly(String state) => isReadOnly = (state != waiting);
  resetValidate() => isName = isContact = isDesc = isFiles = _isButtonDisabled =
      isNotFiles = isLoading = isLocalImgLoading = isApiImgLoading = false;
  resetReadOnly() => isReadOnly = false;
  resetForm() {
    nameCtrl.clear();
    contactCtrl.clear();
    descCtrl.clear();
    pictures.clear();
    files.clear();
    assigneeCtrl.clear();
    rejectReasonCtrl.clear();
    apiImageId = 0;
    downloadedFiles.clear();
    selectSalesperson = User.defaultUser(id: 0, name: 'Select salesperson');
    selectType = StaticSelection(name: 'New', value: 'new');
  }

  setInfo(ERPTicket data) {
    isNotFiles = data.images.isNotEmpty || data.files.isNotEmpty;
    nameCtrl.text = data.name;
    contactCtrl.text = data.contact;
    descCtrl.text = data.description;
    if (data.assignee != null) assigneeCtrl.text = data.assignee!.name;
    if (data.rejectReason != null) rejectReasonCtrl.text = data.rejectReason!;
    if (data.salesperson != null) selectSalesperson = data.salesperson!;
    data.contactType != null
        ? selectType = StaticSelection(
            name: toTitleCase(data.contactType!), value: data.contactType!)
        : selectType = StaticSelection(name: 'Select type');
  }

  Future<void> downloadFile(List<FileAttachment> ls) async {
    try {
      final value = await ERPTeamAPIService().fetchDownloadFilePath(ls);
      downloadedFiles.addAll(value);
      notifyListeners();
    } catch (e) {
      debugPrint('$e');
    }
  }
}
