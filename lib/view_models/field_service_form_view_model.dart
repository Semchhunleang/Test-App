import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/service-project_task/job_assign_line/job_assign_line.dart';
import 'package:umgkh_mobile/services/api/field_service/fs_api_service.dart';
// import 'package:umgkh_mobile/services/local_storage/models/offline_actions_local_storage_service.dart';

class FieldServiceFormViewModel extends ChangeNotifier {
  bool isHideDrop = false;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _status = false;
  bool get status => _status;
  final TextEditingController reason = TextEditingController();
  bool validateReason = false;
  String validateText = '';

  Future<bool> updateStateJobAssign(int jobAssignId, String state, JobAssignLine jobAssignLine, String dtAction,
      {String reason = ""}) async {
    _isLoading = true;
    notifyListeners();

    final response = await FieldServiceAPIService().updateStateJobAssign(
      jobAssignId: jobAssignId,
      state: state,
      reason: reason,
      jobAssignLine: jobAssignLine,
      dtAction: dtAction
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      _status = true;
    } else {
      _status = false;
    }

    _isLoading = false;
    notifyListeners();

    return _status;
  }

  onValidateReason(String v) {
    String trimmedValue = v.replaceAll(RegExp(r'\s+'), '');
    if (trimmedValue.length >= 15) {
      validateReason = false;
      validateText = 'Text ${trimmedValue.length} is OK';
    } else {
      validateReason = true;
      validateText = v.isEmpty
          ? 'Please enter reason'
          : 'Reason must be at least 15 (${trimmedValue.length})';
    }
    if (v.isEmpty) {
      validateReason = true;
      validateText = 'Please enter reason';
    }
    notifyListeners();
  }

  onchangeDrop() {
    isHideDrop = !isHideDrop;
    notifyListeners();
  }

  void resetForm() {
    reason.clear();
    validateReason = false;
    isHideDrop = false;
    validateText = '';
  }
}
