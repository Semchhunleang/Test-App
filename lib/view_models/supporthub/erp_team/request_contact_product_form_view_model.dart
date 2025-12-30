import 'dart:async';
import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/supporthub/erp/erp_ticket.dart';
import 'package:umgkh_mobile/models/supporthub/file_attachment.dart';
import 'package:umgkh_mobile/services/api/supporthub/erp_team/erp_team_service.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class RequestContactProductFormViewModel extends ChangeNotifier {
  bool isLoading = false, hasAttach = false;
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController requestorCtrl = TextEditingController();
  TextEditingController assigneeCtrl = TextEditingController();
  TextEditingController contactCtrl = TextEditingController();
  TextEditingController contactTypeCtrl = TextEditingController();
  TextEditingController descCtrl = TextEditingController();
  TextEditingController salespersonCtrl = TextEditingController();
  TextEditingController rejectReasonCtrl = TextEditingController();
  List<FileAttachment> downloadedFiles = [];

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  resetForm() {
    nameCtrl.clear();
    requestorCtrl.clear();
    assigneeCtrl.clear();
    contactCtrl.clear();
    contactTypeCtrl.clear();
    descCtrl.clear();
    salespersonCtrl.clear();
    rejectReasonCtrl.clear();
    downloadedFiles.clear();
  }

  setInfo(ERPTicket data) {
    hasAttach = data.images.isNotEmpty || data.files.isNotEmpty;
    nameCtrl.text = data.name;
    requestorCtrl.text = data.requestor.name;
    contactCtrl.text = data.contact;
    descCtrl.text = data.description;
    if (data.assignee != null) assigneeCtrl.text = data.assignee!.name;
    if (data.salesperson != null) salespersonCtrl.text = data.salesperson!.name;
    if (data.rejectReason != null) rejectReasonCtrl.text = data.rejectReason!;
    data.contactType != null
        ? contactTypeCtrl.text = toTitleCase(data.contactType!)
        : contactTypeCtrl.clear();
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
