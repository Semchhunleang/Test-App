import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/models/hr/request_overtime/local_multi_req_ot.dart';
import 'package:umgkh_mobile/models/hr/request_overtime/request_overtime.dart';
import 'package:umgkh_mobile/services/api/hr/request_overtime/request_overtime_service.dart';
import 'package:umgkh_mobile/utils/show_dialog.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/access_levels_view_model.dart';

class RequestOvertimeFormViewModel extends ChangeNotifier {
  bool _isLoading = false, validEmployee = false, isReadOnly = false;
  String? _errorMessage;
  String? _errorValidateMessage;
  String? _errorSubmitOTMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get errorValidateMessage => _errorValidateMessage;
  String? get errorSubmitOTMessage => _errorSubmitOTMessage;

  //Create overtime
  final TextEditingController dateCtrl = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  final TextEditingController hourCtrl = TextEditingController();
  final TextEditingController minuteCtrl = TextEditingController();
  final TextEditingController textarea = TextEditingController();
  TextEditingController createByCtrl = TextEditingController();
  TextEditingController approveDTCtrl = TextEditingController();
  TextEditingController rejectDTCtrl = TextEditingController();
  final FocusNode minuteFocusNode = FocusNode();
  DateTime? _selectedDate;
  User selectEmployee = User.defaultUser(id: 0, name: 'Select employee');

  /// ********** set DateTime picker in Create Request Overtime ********
  Future<void> selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime firstDate = DateTime.now();
    final DateTime lastDate = DateTime(2100);

    final DateTime initialDate =
        currentDate.isBefore(lastDate) ? currentDate : lastDate;
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate != null) {
      _selectedDate = selectedDate;
      dateCtrl.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      notifyListeners(); // Notify listeners to update UI
    }
  }

  /// ***************** Create request Overtime ******************
  Future<void> createOvertimeRequest({BuildContext? context}) async {
    final date = dateCtrl.text;
    final hours = int.tryParse(hourCtrl.text) ?? 0;
    final minutes = int.tryParse(minuteCtrl.text) ?? 0;
    final reason = textarea.text;
    if (_isLoading == false) {
      _isLoading = true;
      _errorValidateMessage = null;
      notifyListeners();

      final response = await RequestOvertimeAPIService().createOvertimeRequest(
        employeeId: selectEmployee.id,
        overtimeDate: date,
        overtimeHours: hours,
        overtimeMinutes: minutes,
        reason: reason,
      );

      await Future.delayed(const Duration(milliseconds: 600));

      if (response.error != null) {
        if (context != null) {
          if (context.mounted) {
            await showResultDialog(context, '${response.error}',
                isDone: true, isBackToList: false);
          }
        }
        _errorSubmitOTMessage = response.error;
      } else if (response.data != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (context != null) {
            if (context.mounted) {
              await showResultDialog(context, ' ${response.message}',
                  isDone: true);
            }
          }
        });
        resetForm();
        resetMulti();
        _errorValidateMessage = null;
      }

      _isLoading = false;
      notifyListeners();
    }
  }

  /// for validation of create request overtime
  RequestOvertimeFormViewModel() {
    hourCtrl.addListener(_validateHourField);
    minuteCtrl.addListener(_validateMinuteField);
    minuteFocusNode.addListener(_handleMinuteFocusChange);
    minuteCtrl.text = '0';
  }

  void _handleMinuteFocusChange() {
    final hours = int.tryParse(hourCtrl.text) ?? 0;
    if (hours == 24) {
      minuteCtrl.text = '00';
      minuteFocusNode.unfocus();
    } else if (!minuteFocusNode.hasFocus) {
      final minuteText = minuteCtrl.text;
      if (minuteText.isEmpty && hourCtrl.text != '24') {
        minuteCtrl.text = '0';
        minuteCtrl.selection = TextSelection.fromPosition(
          TextPosition(offset: minuteCtrl.text.length),
        );
      }
    }
  }

  void _validateHourField() {
    final value = hourCtrl.text;
    if (value.isNotEmpty) {
      int? hour = int.tryParse(value);
      if (hour != null && hour > 24) {
        hourCtrl.text = '24';
        hourCtrl.selection = TextSelection.fromPosition(
          TextPosition(offset: hourCtrl.text.length),
        );
      }

      if (hour == 24) {
        minuteCtrl.text = '00';
        minuteCtrl.selection = TextSelection.fromPosition(
          TextPosition(offset: minuteCtrl.text.length),
        );
        minuteFocusNode.unfocus();
      }
    } else if (value.isEmpty && minuteCtrl.text.isEmpty ||
        minuteCtrl.text == '00') {
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

  bool validateReason = false;
  String validateText = '';

  onValidateReason(String v) {
    String trimmedValue = v.replaceAll(RegExp(r'\s+'), '');
    if (trimmedValue.length >= 25) {
      validateReason = false;
      validateText = "";
    } else {
      validateReason = true;
      validateText = v.isEmpty
          ? 'Please enter reason'
          : 'Reason must be at least 25 (${trimmedValue.length})';
    }
    notifyListeners();
  }

  void onValidation(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    onChangeEmployee(selectEmployee);
    onValidateReason(textarea.text);
    onValidateHour(hourCtrl.text);
  }

  void clearValidationErrors() {
    _errorValidateMessage = null;
    notifyListeners();
  }

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  void onChangeEmployee(dynamic v) => notify(v, (val) {
        selectEmployee = val;
        validEmployee = selectEmployee.id == 0;
      });

  void resetForm() {
    selectEmployee = User.defaultUser(id: 0, name: 'Select employee');
    dateCtrl.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    hourCtrl.clear();
    minuteCtrl.text = '0'; // Reset to '0'
    textarea.clear();
    createByCtrl.clear();
    approveDTCtrl.clear();
    rejectDTCtrl.clear();
    validateReason = false;
    validateText = '';
    validateHour = false;
    validateHourText = '';
    _isLoading = false;
    validEmployee = false;
    isReadOnly = false;
  }

  void setInfo(BuildContext context, RequestOvertime data) {
    if (data.employee != null) {
      selectEmployee =
          User.defaultUser(id: data.employee!.id, name: data.employee!.name);
    }
    if (data.overtimeDate != null) {
      dateCtrl.text = formatYYYYMMDD(data.overtimeDate!);
    }

    hourCtrl.text = data.overtimeHours.toString();
    data.overtimeMinutes != null
        ? minuteCtrl.text = data.overtimeMinutes.toString()
        : minuteCtrl.text = '0';
    if (data.reason != null) textarea.text = data.reason.toString();
    if (data.createBy != null) createByCtrl.text = data.createBy ?? '';
    if (data.approveDhDatetime != null) {
      approveDTCtrl.text = formatDateTime(data.approveDhDatetime!);
    }
    if (data.rejectDatetime != null) {
      rejectDTCtrl.text = formatDateTime(data.rejectDatetime!);
    }
    //
    final vm = Provider.of<AccessLevelViewModel>(context, listen: false);
    isReadOnly = vm.hasReadReqOT();
    notifyListeners();
  }

  // start: ==================================================== multi: [PUTHEA]
  List<LocalMultiReqOT> localMultiReqOT = [];
  onStoreLocalMutli() {
    // final hours = int.tryParse(hourCtrl.text) ?? 0;
    // final minutes = int.tryParse(minuteCtrl.text) ?? 0;

    //
    localMultiReqOT.add(LocalMultiReqOT(
      overtimeHours: TextEditingController(text: hourCtrl.text),
      overtimeMinutes: TextEditingController(text: minuteCtrl.text),
      reason: TextEditingController(text: textarea.text),
      employee: selectEmployee,
      overtimeDate: TextEditingController(text: dateCtrl.text),
      // overtimeHours: hourCtrl,
      // overtimeMinutes: minuteCtrl,
      // // dhOvertimeHours: hours,
      // // dhOvertimeMinutes: minutes,
      // reason: textarea,
      // employee: selectEmployee,
      // overtimeDate: dateCtrl,
    ));
    //
    resetForm();
    notifyListeners();
  }

  void updateMultiEmplyee(int index, dynamic v) =>
      notify(v, (v) => localMultiReqOT[index].employee = v);

  Future<void> updateMultiDate(int index, BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime firstDate = DateTime.now();
    final DateTime lastDate = DateTime(2100);

    final DateTime initialDate =
        currentDate.isBefore(lastDate) ? currentDate : lastDate;
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate != null) {
      _selectedDate = selectedDate;
      localMultiReqOT[index].overtimeDate.text =
          DateFormat('yyyy-MM-dd').format(selectedDate);
      notifyListeners();
    }
  }

  void updateMultiHr(int index, dynamic v) =>
      notify(v, (v) => localMultiReqOT[index].overtimeHours.text = v);

  void updateMultiMin(int index, dynamic v) =>
      notify(v, (v) => localMultiReqOT[index].overtimeMinutes.text = v);

  void updateMultiReason(int index, dynamic v) =>
      notify(v, (v) => localMultiReqOT[index].reason.text = v);

  onRemoveMulti(int index) {
    localMultiReqOT.removeAt(index);
    notifyListeners();
  }

  Future<void> createMultiOvertimeRequest({BuildContext? context}) async {
    if (_isLoading == false) {
      _isLoading = true;
      _errorValidateMessage = null;
      notifyListeners();

      final date = dateCtrl.text;
      final hours = int.tryParse(hourCtrl.text) ?? 0;
      final minutes = int.tryParse(minuteCtrl.text) ?? 0;
      final reason = textarea.text;

      final newItem = {
        "employee_id": selectEmployee.id.toString(),
        "overtime_date": date,
        "overtime_hours": hours,
        "overtime_minutes": minutes,
        "reason": reason,
      };

      List<Map<String, dynamic>> toJsonList() {
        return [
          ...localMultiReqOT.map((item) {
            return {
              "employee_id": item.employee.id.toString(),
              "overtime_date": item.overtimeDate.text,
              "overtime_hours": int.tryParse(item.overtimeHours.text) ?? 0,
              "overtime_minutes": int.tryParse(item.overtimeMinutes.text) ?? 0,
              "reason": item.reason.text,
            };
          }).toList(),
          newItem
        ];
      }

      Map<String, dynamic> data = {
        "requests": toJsonList(),
      };

      final response =
          await RequestOvertimeAPIService().createMultiOvertimeRequest(data);

      await Future.delayed(const Duration(milliseconds: 600));

      if (response.error != null) {
        if (context != null) {
          if (context.mounted) {
            await showResultDialog(context, '${response.error}',
                isDone: true, isBackToList: false);
          }
        }
        _errorSubmitOTMessage = response.error;
      } else if (response.message != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (context != null) {
            if (context.mounted) {
              await showResultDialog(context, ' ${response.message}',
                  isDone: true);
            }
          }
        });
        resetForm();
        resetMulti();
        _errorValidateMessage = null;
      }

      _isLoading = false;
      notifyListeners();
    }
  }

  resetMulti() {
    localMultiReqOT.clear();
    notifyListeners();
  }
  // end: ====================================================== multi: [PUTHEA]
}
