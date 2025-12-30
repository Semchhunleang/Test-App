import 'dart:io';
import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/crm/activity/activity.dart';
import 'package:umgkh_mobile/models/crm/activity/activity_type.dart';
import 'package:umgkh_mobile/services/api/base/activity/activity_service.dart';
import 'package:umgkh_mobile/utils/image_picker.dart';
import 'package:umgkh_mobile/utils/show_dialog.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class ActivityFormViewModel extends ChangeNotifier {
  bool isSummary = false, isType = false, isEvidence = false;
  ActivityType selectedType = ActivityType(name: 'Select type', id: 0);
  TextEditingController summaryCtrl = TextEditingController();
  File? picture;
  File? get selectedPicture => picture;

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  onChangeSummary(String v) => notify(
      v, (val) => trimStr(v).isEmpty ? isSummary = true : isSummary = false);

  onChangeType(dynamic v) => notify(v, (val) {
        selectedType = val;
        selectedType.id == 0 ? isType = true : isType = false;
      });

  onChangeEvidence() => notify(null, (val) {
        isEvidence =
            selectedType.attachmentRequired == true && selectedPicture == null;
      });

  bool isValidated(bool isNotRequiredPic) {
    onChangeSummary(summaryCtrl.text);
    onChangeType(selectedType);
    if (!isNotRequiredPic) onChangeEvidence();
    return isSummary || isType || isEvidence;
  }

  Future<void> pickOrCapture({required bool isGallery}) async {
    await _handleImageAction(
        onPick: isGallery ? pickImageFromGallery : takePhoto);
  }

  Future<void> _handleImageAction(
      {required Future<File?> Function() onPick}) async {
    File? image = await onPick();
    if (image != null) {
      picture = image;
      onChangeEvidence();
      notifyListeners();
    } else {
      debugPrint('No image selected.');
    }
  }

  Future<void> insertActivity(BuildContext context, int leadId,
      {int? mailActivityId}) async {
    try {
      // String body = "<p> \n <span class='fa ${selectedType.icon}'></span><span>${selectedType.name}</span> done \n <span>:</span><span>${summaryCtrl.text}</span>\n </p>";
      Map<String, dynamic> data = {
        "res_id": leadId,
        "mail_activity_type_id": selectedType.id,
        "body": convertTextToHtml(summaryCtrl.text),
        "parent_id": 1,
        "record_name": 'Nenam V2',
        'email_from': "",
        "message_id": 'Nenam${DateTime.now().millisecondsSinceEpoch}',
        if (mailActivityId != null) "mail_activity_id": mailActivityId,
      };

      await ActivityAPIService()
          .insertData(selectedPicture, data)
          .then((value) {
        if (context.mounted) {
          showResultDialog(context, '${value.message}',
              isBackToList: !value.message!.contains('error'),);
        }
        notifyListeners();
      });
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> insertSchedule(BuildContext context, int leadId) async {
    try {
      Map<String, dynamic> data = {
        "res_id": leadId,
        "mail_activity_type_id": selectedType.id,
        "body": convertTextToHtml(summaryCtrl.text)
      };

      await ActivityAPIService()
          .insertSchedule(selectedPicture, data)
          .then((value) {
        if (context.mounted) {
          showResultDialog(context, '${value.message}',
              isBackToList: !value.message!.contains('error'),);
        }
        notifyListeners();
      });
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> updateSchedule(BuildContext context, int activityId) async {
    try {
      Map<String, dynamic> data = {
        "id": activityId,
        "mail_activity_type_id": selectedType.id,
        "body": convertTextToHtml(summaryCtrl.text)
      };

      await ActivityAPIService()
          .updateData(selectedPicture, data)
          .then((value) {
        if (context.mounted) {
          showResultDialog(context, '${value.message}',
              isBackToList: !value.message!.contains('error'),);
        }
        notifyListeners();
      });
    } catch (e) {
      debugPrint('$e');
    }
  }

  resetValidate() {
    isSummary = isType = isEvidence = false;
    selectedType = ActivityType(name: 'Select type', id: 0);
  }

  resetForm() {
    selectedType = ActivityType(name: 'Select type', id: 0);
    summaryCtrl.clear();
    picture = null;
  }

  setInfo(Activity data) {
    selectedType = data.type!;
    summaryCtrl.text = convertHtmlToText(data.body!);
    picture = null;
  }
}
