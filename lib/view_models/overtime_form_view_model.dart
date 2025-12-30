import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/hr/overtime/local_multi_submit_ot.dart';
import 'package:umgkh_mobile/models/hr/overtime/overtime.dart';
import 'package:umgkh_mobile/models/hr/overtime/overtime_attendance.dart';
import 'package:umgkh_mobile/models/hr/request_overtime/request_overtime.dart';
import 'package:umgkh_mobile/services/api/hr/overtime/overtime_service.dart';
import 'package:umgkh_mobile/utils/show_dialog.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/access_levels_view_model.dart';

class OvertimeFormViewModel with ChangeNotifier {
  bool _isLoading = false, isReadOnly = false;
  OvertimeAttendance overtimeAttendance = OvertimeAttendance();
  TextEditingController distanceCtrl = TextEditingController(text: '0');
  TextEditingController approveHrCtrl = TextEditingController(text: '0');
  TextEditingController approveMinCtrl = TextEditingController(text: '0');
  TextEditingController checkinCtrl = TextEditingController();
  TextEditingController checkoutCtrl = TextEditingController();
  TextEditingController createByCtrl = TextEditingController();
  TextEditingController reasonCtrl = TextEditingController();
  RequestOvertime selectedRequest = RequestOvertime(
      name: 'Select employee request overtime',
      id: 0,
      overtimeHours: 0,
      overtimeDate: null,
      dhOvertimeHours: 0,
      dhOvertimeMinutes: 0);
  FocusNode focusNode = FocusNode();
  bool loaded = false;
  bool validate = false;
  bool validateReason = false;
  String validateText = '';

  bool get isLoading => _isLoading;

  void onChangeSelectedRequest(RequestOvertime selected) {
    distanceCtrl = TextEditingController(text: '0');
    overtimeAttendance = OvertimeAttendance();
    selectedRequest = selected;
    reasonCtrl.text = selected.reason!;
    fetchAttendance();
    notifyListeners();
  }

  OvertimeFormViewModel() {
    focusNode.addListener(distanceFocus);
  }

  bool toSearch(String? source, String text) {
    return source!.toLowerCase().contains(
          text.toLowerCase(),
        );
  }

  void resetForm() {
    _isLoading = false;
    isReadOnly = false;
    selectedRequest = RequestOvertime(
        name: 'Select employee request overtime',
        id: 0,
        overtimeHours: 0,
        overtimeDate: null,
        dhOvertimeHours: 0,
        dhOvertimeMinutes: 0);
    overtimeAttendance = OvertimeAttendance();
    validate = false;
    validateReason = false;
    validateText = '';
    distanceCtrl = TextEditingController(text: '0');
    approveHrCtrl = TextEditingController(text: '0');
    approveMinCtrl = TextEditingController(text: '0');
    checkinCtrl = TextEditingController();
    checkoutCtrl = TextEditingController();
    reasonCtrl = TextEditingController();
    createByCtrl.clear();
    notifyListeners();
  }

  Future<void> insertData(BuildContext context) async {
    if (_isLoading == false) {
      _isLoading = true;
      notifyListeners();
      Map<String, dynamic> data = {
        "request_id": selectedRequest.id,
        "date": toApiformatDate(
            toApiformatDateTime(selectedRequest.submitDatetime ?? nullDt)),
        "overtime_date": toApiformatDate(
            toApiformatDateTime(selectedRequest.overtimeDate ?? nullDt)),
        "employee_id": selectedRequest.employee?.id,
        "department_id": selectedRequest.employee?.department?.id,
        "resource_calendar_id": selectedRequest.resourceCalendarId,
        "check_in": toApiformatDateTime(overtimeAttendance.checkIn ?? nullDt),
        "check_out": toApiformatDateTime(overtimeAttendance.checkOut ?? nullDt),
        // "check_in": toApiformatDate(toApiformatDateTime(overtimeAttendance.checkIn ?? nullDt)),
        // "check_out": toApiformatDate(toApiformatDateTime(overtimeAttendance.checkOut ?? nullDt)),
        "distance": distanceCtrl.text,
        "overtime_hours": overtimeAttendance.workedDurationHour,
        "overtime_minutes": overtimeAttendance.workedDurationMinute,
        "approved_overtime_hours": overtimeAttendance.durationHour,
        "approved_overtime_minutes": overtimeAttendance.durationMinute,
        // "approved_overtime_hours": approveHrCtrl.text,
        // "approved_overtime_minutes": approveMinCtrl.text,
        "amount_overtime": overtimeAttendance.amount,
        "company_id": selectedRequest.companyId,
        "currency_id": selectedRequest.currencyId,
        "is_first_30_min": overtimeAttendance.isFirst30Min,
        "name": selectedRequest.name,
        "reason": reasonCtrl.text,
      };
      final response = await OvertimeAPIService().insert(data);
      if (context.mounted) {
        await showResultDialog(context, response.error ?? response.message!,
            isDone: true,
            isBackToList:
                response.statusCode == 200 || response.statusCode == 201);
      }

      _isLoading = false;
      notifyListeners();
    }
  }

  Future fetchAttendance() async {
    final response = await OvertimeAPIService().fetchAttendanceByEmp(
      selectedRequest.overtimeDate,
      selectedRequest.dhOvertimeHours,
      selectedRequest.dhOvertimeMinutes,
      int.parse(distanceCtrl.text.isEmpty ? '0' : distanceCtrl.text),
      selectedRequest.employee!.id,
    );
    if (response.data != null) {
      overtimeAttendance = response.data!;
      approveHrCtrl.text = overtimeAttendance.durationHour.toString();
      approveMinCtrl.text = overtimeAttendance.durationMinute.toString();
    }
    notifyListeners();
  }

  onValidateReason(String v) {
    String trimmedValue = v.replaceAll(RegExp(r'\s+'), '');
    if (trimmedValue.length >= 25) {
      validateReason = false;
      validateText = 'Text ${trimmedValue.length} is OK';
    } else {
      validateReason = true;
      validateText = v.isEmpty
          ? 'Please enter reason'
          : 'Reason must be at least 25 (${trimmedValue.length})';
    }
    notifyListeners();
  }

  void distanceFocus() {
    if (!focusNode.hasFocus) {
      if (distanceCtrl.text.isEmpty) distanceCtrl.text = '0';
    }
    notifyListeners();
  }

  onValidateInsertSingle(BuildContext context) {
    validate = selectedRequest.id == 0;
    onValidateReason(reasonCtrl.text);
    if (selectedRequest.id != 0 &&
        !validateReason &&
        overtimeAttendance.amount != 0 &&
        overtimeAttendance.amount != null) {
      insertData(context);
    }
  }

  onValidateStoreLocal(BuildContext context) {
    validate = selectedRequest.id == 0;
    onValidateReason(reasonCtrl.text);
    if (selectedRequest.id != 0 &&
        !validateReason &&
        overtimeAttendance.amount != 0 &&
        overtimeAttendance.amount != null) {
      onStoreLocalMutli();
    }
  }

  void setInfo(BuildContext context, Overtime data) {
    selectedRequest = RequestOvertime(
        name: data.requestName ?? '',
        id: data.requestId ?? 0,
        overtimeHours: 0,
        overtimeDate: null,
        dhOvertimeHours: 0,
        dhOvertimeMinutes: 0);

    distanceCtrl.text = data.distance.toString();
    // checkinCtrl.text = toApiformatDateTime(data.checkIn);
    // checkoutCtrl.text = toApiformatDateTime(data.checkOut);
    overtimeAttendance = OvertimeAttendance(
      checkIn: data.checkIn,
      checkOut: data.checkOut,
      workedDurationHour: data.overtimeHours,
      workedDurationMinute: data.overtimeMinutes,
      durationHour: data.approvedOvertimeHours,
      durationMinute: data.approvedOvertimeMinutes,
      amount: data.amountOvertime,
    );
    reasonCtrl.text = data.reason ?? '';
    createByCtrl.text = data.createBy;
    final vm = Provider.of<AccessLevelViewModel>(context, listen: false);
    isReadOnly = vm.hasReadOT();
    notifyListeners();
  }

  // start: ==================================================== multi: [PUTHEA]
  List<LocalMultiSubmitOT> localMultiSubmitOT = [];
  onStoreLocalMutli() {
    localMultiSubmitOT.add(LocalMultiSubmitOT(
      request: selectedRequest,
      otAttendance: overtimeAttendance,
      reason: reasonCtrl,
      distance: distanceCtrl,
      approveHr: approveHrCtrl,
      approveMin: approveMinCtrl,
    ));

    resetForm();
    notifyListeners();
  }

  void updateSelectedRequest(int index, dynamic v) {
    localMultiSubmitOT[index].distance = TextEditingController(text: "0");
    localMultiSubmitOT[index].otAttendance = OvertimeAttendance();
    localMultiSubmitOT[index].request = v;
    localMultiSubmitOT[index].reason = TextEditingController(text: v.reason);
    fetchAttendanceByMulti(index);
    notifyListeners();
  }

  void updateMultiDistance(int index, dynamic v) => notify(v, (v) async {
        localMultiSubmitOT[index].distance.text = v;
        fetchAttendanceByMulti(index);
      });

  void updateMultiApproveHr(int index, dynamic v) => notify(v, (v) async {
        localMultiSubmitOT[index].approveHr.text = v;
      });

  void updateMultiApproveMin(int index, dynamic v) => notify(v, (v) async {
        localMultiSubmitOT[index].approveMin.text = v;
      });

  void fetchAttendanceByMulti(int index) async {
    RequestOvertime req = localMultiSubmitOT[index].request;
    TextEditingController distance = localMultiSubmitOT[index].distance;
    final response = await OvertimeAPIService().fetchAttendanceByEmp(
      req.overtimeDate,
      req.dhOvertimeHours,
      req.dhOvertimeMinutes,
      int.parse(distance.text.isEmpty ? '0' : distance.text),
      req.employee!.id,
    );
    if (response.data != null) {
      localMultiSubmitOT[index].otAttendance = response.data!;
    }
    notifyListeners();
  }

  void updateMultiReason(int index, dynamic v) =>
      notify(v, (v) => localMultiSubmitOT[index].reason.text = v);

  onRemoveMulti(int index) {
    localMultiSubmitOT.removeAt(index);
    notifyListeners();
  }

  Future<void> insertMultiOvertime(BuildContext context) async {
    if (_isLoading == false) {
      _isLoading = true;
      notifyListeners();

      final newItem = {
        "request_id": selectedRequest.id,
        "date": toApiformatDate(
            toApiformatDateTime(selectedRequest.submitDatetime ?? nullDt)),
        "overtime_date": toApiformatDate(
            toApiformatDateTime(selectedRequest.overtimeDate ?? nullDt)),
        "employee_id": selectedRequest.employee?.id,
        "department_id": selectedRequest.employee?.department?.id,
        "resource_calendar_id": selectedRequest.resourceCalendarId,
        "check_in": toApiformatDateTime(overtimeAttendance.checkIn ?? nullDt),
        "check_out": toApiformatDateTime(overtimeAttendance.checkOut ?? nullDt),
        // "check_in": toApiformatDate(toApiformatDateTime(overtimeAttendance.checkIn ?? nullDt)),
        // "check_out": toApiformatDate(toApiformatDateTime(overtimeAttendance.checkOut ?? nullDt)),
        "distance": distanceCtrl.text,
        "overtime_hours": overtimeAttendance.workedDurationHour,
        "overtime_minutes": overtimeAttendance.workedDurationMinute,
        "approved_overtime_hours": overtimeAttendance.durationHour,
        "approved_overtime_minutes": overtimeAttendance.durationMinute,
        "amount_overtime": overtimeAttendance.amount,
        "company_id": selectedRequest.companyId,
        "currency_id": selectedRequest.currencyId,
        "is_first_30_min": overtimeAttendance.isFirst30Min,
        "name": selectedRequest.name,
        "reason": reasonCtrl.text,
      };

      List<Map<String, dynamic>> toJsonList() {
        return [
          ...localMultiSubmitOT.map((item) {
            return {
              "request_id": item.request.id,
              "date": toApiformatDate(
                  toApiformatDateTime(item.request.submitDatetime ?? nullDt)),
              "overtime_date": toApiformatDate(
                  toApiformatDateTime(item.request.overtimeDate ?? nullDt)),
              "employee_id": item.request.employee?.id,
              "department_id": item.request.employee?.department?.id,
              "resource_calendar_id": item.request.resourceCalendarId,
              "check_in":
                  toApiformatDateTime(item.otAttendance.checkIn ?? nullDt),
              "check_out":
                  toApiformatDateTime(item.otAttendance.checkOut ?? nullDt),
              // "check_in": toApiformatDate(toApiformatDateTime(item.otAttendance.checkIn ?? nullDt)),
              // "check_out": toApiformatDate(toApiformatDateTime(item.otAttendance.checkOut ?? nullDt)),
              "distance": item.distance.text,
              "reason": item.reason.text,
              "overtime_hours": item.otAttendance.workedDurationHour,
              "overtime_minutes": item.otAttendance.workedDurationMinute,
              "approved_overtime_hours": item.otAttendance.durationHour,
              "approved_overtime_minutes": item.otAttendance.durationMinute,
              "amount_overtime": item.otAttendance.amount,
              "company_id": item.request.companyId,
              "currency_id": item.request.currencyId,
              "is_first_30_min": item.otAttendance.isFirst30Min,
              "name": item.request.name,
            };
          }).toList(),
          newItem
        ];
      }

      Map<String, dynamic> data = {
        "requests": toJsonList(),
      };

      final response = await OvertimeAPIService().insertMultiOT(data);
      if (context.mounted) {
        await showResultDialog(context, response.error ?? response.message!,
            isDone: true,
            isBackToList:
                response.statusCode == 200 || response.statusCode == 201);
      }

      _isLoading = false;
      notifyListeners();
    }
  }

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  resetMulti() {
    localMultiSubmitOT.clear();
    notifyListeners();
  }
  // end: ====================================================== multi: [PUTHEA]
}
