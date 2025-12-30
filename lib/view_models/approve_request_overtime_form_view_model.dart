import 'package:flutter/material.dart';
import 'package:umgkh_mobile/services/api/hr/request_overtime/request_overtime_service.dart';
import 'package:umgkh_mobile/utils/show_dialog.dart';

class ApproveRequestOvertimeFormViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool _status = false;
  String? _errorMessage;
  bool get isLoading => _isLoading;
  bool get status => _status;
  String? get errorMessage => _errorMessage;

  final TextEditingController hourCtrl = TextEditingController();
  final TextEditingController minuteCtrl = TextEditingController();
  final FocusNode minuteFocusNode = FocusNode();

  /// ***************** Update state by DH  of request Overtime ******************
  Future<void> updateApproveRequestOvertime(int requestOvertimeId, String state,
      {required BuildContext context}) async {
    final hours = int.tryParse(hourCtrl.text) ?? 0;
    final minutes = int.tryParse(minuteCtrl.text) ?? 0;
    _isLoading = true;
    notifyListeners();

    final response =
        await RequestOvertimeAPIService().updateStateRequestOvertime(
      requestOvertimeId: requestOvertimeId, // Replace with actual employee ID
      state: state,
      dhApproveHours: hours,
      dhApproveMinute: minutes,
    );

    if (context.mounted) {
      await showResultDialog(context, response.error ?? response.message!,
          isDone: true, isBackToList: false);
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      _status = true;
    } else {
      _status = false;
    }
  }

  /// ***************** validation ********************
  /// for validation of create request overtime
  ApproveRequestOvertimeFormViewModel() {
    hourCtrl.addListener(_validateHourField);
    minuteCtrl.addListener(_validateMinuteField);
    minuteFocusNode.addListener(_handleMinuteFocusChange);
    minuteCtrl.text = '0'; // Initialize with '0'
  }

  void _handleMinuteFocusChange() {
    final hours = int.tryParse(hourCtrl.text) ?? 0;
    if (hours == 24) {
      minuteCtrl.text = '00'; // Ensure minute field is set to 00
      minuteFocusNode.unfocus(); // Remove focus from minute field
    } else if (!minuteFocusNode.hasFocus) {
      final minuteText = minuteCtrl.text;
      if (minuteText.isEmpty && hourCtrl.text != '24') {
        // Set to '0' only if minute is empty and hour is not 24
        minuteCtrl.text = '0';
        minuteCtrl.selection = TextSelection.fromPosition(
          TextPosition(offset: minuteCtrl.text.length),
        );
      }
    }
  }

  void _validateHourField() {
    // limit input of hour field
    final value = hourCtrl.text;
    if (value.isNotEmpty) {
      int? hour = int.tryParse(value);
      if (hour != null && hour > 24) {
        // If the hour exceeds 24, revert to the last valid value
        hourCtrl.text = '24';
        hourCtrl.selection = TextSelection.fromPosition(
          TextPosition(offset: hourCtrl.text.length),
        );
      }

      if (hour == 24) {
        // When hour reaches 24, set minute to 00 and disable minute field
        minuteCtrl.text = '00';
        minuteCtrl.selection = TextSelection.fromPosition(
          TextPosition(offset: minuteCtrl.text.length),
        );
        minuteFocusNode.unfocus(); // Remove focus from minute field
      }
    } else if (value.isEmpty && minuteCtrl.text.isEmpty ||
        minuteCtrl.text == '00') {
      // If hour field is empty, reset minute field to '0'
      minuteCtrl.text = '0';
      minuteCtrl.selection = TextSelection.fromPosition(
        TextPosition(offset: minuteCtrl.text.length),
      );
    }

    notifyListeners();
  }

  void _validateMinuteField() {
    final value = minuteCtrl.text;
    if (value.isNotEmpty) {
      int? minute = int.tryParse(value);
      if (minute != null && minute > 59) {
        // If the minute exceeds 59, revert to the last valid value
        minuteCtrl.text = '59';
        minuteCtrl.selection = TextSelection.fromPosition(
          TextPosition(offset: minuteCtrl.text.length),
        );
      }
    }

    notifyListeners();
  }

  bool validateHour = false;
  String validateHourText = '';
  onValidateHour(String v) {
    final hours = int.tryParse(hourCtrl.text) ?? 0;
    if (hours > 0) {
      validateHour = false;
      validateHourText = "";
    } else {
      validateHour = true;
      validateHourText =
          v.isEmpty ? 'Please enter hours' : 'Hour must be greater than 0.';
    }
    notifyListeners();
  }

  /// reset the form after submit success
  void resetForm() {
    hourCtrl.clear();
    minuteCtrl.text = '0'; // Reset to '0'
    validateHour = false;
    validateHourText = '';
  }
}
