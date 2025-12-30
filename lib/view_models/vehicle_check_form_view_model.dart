import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/am/vehicle_check/fleet_vehicle.dart';
import 'package:umgkh_mobile/models/am/vehicle_check/vehicle_check.dart';
import 'package:umgkh_mobile/models/base/user/department.dart';
import '../models/base/user/user.dart';
import '../models/crm/country_state/country_state.dart';
import '../services/api/am/vehicle_check/vehicle_check_service.dart';
import '../utils/show_dialog.dart';
import '../utils/static_state.dart';
import '../utils/utlis.dart';
import 'profile_view_model.dart';
import 'selections_view_model.dart';

class VehicleCheckFormViewModel extends ChangeNotifier {
  bool isReadOnly = false,
      isCheckType = false,
      isKmStart = false,
      isKmEnd = false,
      isFleetVehicle = false,
      isKmCurrent = false,
      isPurpose = false,
      isReadOnlyChecker = false;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  DateTime? _selectedDt;
  DateTime? actualDatetimeOut;
  String stateString = "";
  TextEditingController departmentCtrl = TextEditingController();
  TextEditingController requestorCtrl = TextEditingController();
  TextEditingController approverCtrl = TextEditingController();
  TextEditingController kmCurrentCtrl = TextEditingController();
  TextEditingController kmStartCtrl = TextEditingController();
  TextEditingController kmEndCtrl = TextEditingController();
  User userData = User.defaultUser(id: 0, name: '');
  User manager = User.defaultUser(id: 0, name: '');
  User userUpdate = User.defaultUser(id: 0, name: '');
  User approver = User.defaultUser(id: 0, name: '');
  User selectedChecker = User.defaultUser(id: 0, name: 'Select employee');
  Department department = Department(id: 0, code: '', name: '');
  TextEditingController auditDateTimeCtrl =
      TextEditingController(text: formatReadableDT(DateTime.now()));
  TextEditingController plannedDateTimeOutCtrl =
      TextEditingController(text: formatReadableDT(DateTime.now()));
  TextEditingController plannedDateTimeInCtrl =
      TextEditingController(text: formatReadableDT(DateTime.now()));
  TextEditingController purposeCtrl = TextEditingController();
  TextEditingController actualDateTimeOutCtrl = TextEditingController();
  TextEditingController actualDateTimeInCtrl = TextEditingController();
  TextEditingController kmEndStoreCtrl = TextEditingController();
  String selectedCheckType = "Select an option";
  FleetVehicle selectFleetVehicle =
      FleetVehicle(name: "Select an option", id: 0);
  CountryState selectedState = CountryState.defaultValue();

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Map<String, dynamic> buildMap({bool isUpdate = false}) {
    return {
      "name":
          "${selectFleetVehicle.name} ($selectedCheckType) - ${requestorCtrl.text} (${departmentCtrl.text})",
      "requestor_id": isUpdate ? userUpdate.id : userData.id,
      "requestor_user_id": isUpdate ? userUpdate.userId : userData.userId,
      "approver_id": isUpdate ? approver.id : manager.id,
      "approver_user_id": isUpdate ? approver.userId : manager.userId,
      "checker_id": selectedChecker.id,
      "checker_user_id": selectedChecker.userId,
      "department_id": department.id,
      "check_type": selectedCheckType,
      "fleet_id": selectFleetVehicle.id,
      "km_current":
          kmCurrentCtrl.text.isEmpty ? null : double.parse(kmCurrentCtrl.text),
      "km_start":
          kmStartCtrl.text.isEmpty ? null : double.parse(kmStartCtrl.text),
      "km_end": kmEndCtrl.text.isEmpty ? null : double.parse(kmEndCtrl.text),
      "audit_datetime": toApiSubtract7Hours(auditDateTimeCtrl.text),
      "planned_datetime_out": toApiSubtract7Hours(plannedDateTimeOutCtrl.text),
      "planned_datetime_in": toApiSubtract7Hours(plannedDateTimeInCtrl.text),
      "location_id": selectedState.id,
      "purpose": purposeCtrl.text,
      "actual_datetime_in": stateString == "on_progress" &&
              (selectedCheckType == "inout" || selectedCheckType == "borrow")
          ? toApiSubtract7HoursNoParseDt(DateTime.now())
          : null,
      "actual_datetime_out": actualDatetimeOut != null
          ? toApiAdd7HoursNoParseDt(actualDatetimeOut!)
          : (stateString == "approve" &&
                  (selectedCheckType == "inout" ||
                      selectedCheckType == "borrow"))
              ? toApiSubtract7HoursNoParseDt(DateTime.now())
              : null
    };
  }

  Future<void> insertVehicleCheck(BuildContext context) async {
    _isLoading = true;
    try {
      await VehicleCheckService().insertVehicleCheck(buildMap()).then((value) {
        if (context.mounted) {
          !value.message!.contains('error')
              ? showResultDialog(context, '${value.message}',
                  isBackToList: true, isDone: true)
              : showResultDialog(context, '${value.message}',
                  isBackToList: false);
        }
        notifyListeners();
      });
    } catch (e) {
      debugPrint('$e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateVehicleCheck(
      BuildContext context, int id, String state, bool isUpdate) async {
    Map<String, dynamic> data = buildMap(
      isUpdate: isUpdate,
    )..addAll({'id': id, 'state': state});
    _isLoading = true;
    try {
      await VehicleCheckService().updateVehicleCheck(data).then((value) {
        if (context.mounted) {
          !value.message!.contains('error')
              ? showResultDialog(context, '${value.message}',
                  isBackToList: true, isDone: true)
              : showResultDialog(context, '${value.message}',
                  isBackToList: false);
        }
        notifyListeners();
      });
    } catch (e) {
      debugPrint('$e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void onChangeChecker(dynamic v, BuildContext context) {
    notify(v, (val) {
      selectedChecker = v;
    });
    Provider.of<SelectionsViewModel>(context, listen: false).fetchAllEmployee();
  }

  void onCheckTypeChanged(String v) => notify(v, (val) {
        selectedCheckType = val;
        selectedCheckType == "Select an option"
            ? isCheckType = true
            : isCheckType = false;
        isKmCurrent = false;
        isKmStart = false;
        autoFillKM();
      });

  void onChangeFleetVehicle(dynamic v, BuildContext context) {
    notify(v, (val) {
      selectFleetVehicle = v;
      selectFleetVehicle.id == 0
          ? isFleetVehicle = true
          : isFleetVehicle = false;
      autoFillKM();
    });
    Provider.of<SelectionsViewModel>(context, listen: false)
        .fetchFleetVehicle();
  }

  autoFillKM() {
    if (selectFleetVehicle.odometer != null) {
      kmCurrentCtrl.text =
          selectedCheckType == "audit" || selectedCheckType == "check"
              ? selectFleetVehicle.odometer.toString()
              : "";

      kmStartCtrl.text =
          selectedCheckType == "inout" || selectedCheckType == "borrow"
              ? selectFleetVehicle.odometer.toString()
              : "";
    } else {
      kmCurrentCtrl.clear();
      kmStartCtrl.clear();
    }
  }

  // onChangeKmStart(String v) => notify(
  //     v, (val) => trimStr(v).isEmpty ? isKmStart = true : isKmStart = false);

  onChangeKmStart(String v) => notify(v, (v) {
        isKmStart = trimStr(v).isEmpty;

        final parsed = num.tryParse(trimStr(v));
        if (parsed != null) {
          selectFleetVehicle = selectFleetVehicle.copyWith(odometer: parsed);
        } else if (trimStr(v).isEmpty) {
          selectFleetVehicle = selectFleetVehicle.copyWith(odometer: 0);
        }
      });

  onChangeKmEnd(String v) {
    final kmStart = kmStartCtrl.text;

    notify(v, (val) {
      if (trimStr(v).isEmpty) {
        isKmEnd = true;
      } else {
        isKmEnd = false;

        if (double.tryParse(v) != null && double.tryParse(kmStart) != null) {
          isKmEnd = double.parse(v) < double.parse(kmStart);
        }
      }
    });
  }

  // onChangeKmCurrent(String v) => notify(v,
  //     (val) => trimStr(v).isEmpty ? isKmCurrent = true : isKmCurrent = false);

  onChangeKmCurrent(String v) => notify(v, (v) {
        isKmCurrent = trimStr(v).isEmpty;

        final parsed = num.tryParse(trimStr(v));
        if (parsed != null) {
          selectFleetVehicle = selectFleetVehicle.copyWith(odometer: parsed);
        } else if (trimStr(v).isEmpty) {
          selectFleetVehicle = selectFleetVehicle.copyWith(odometer: 0);
        }
      });

  onChangePurpose(String v) => notify(
      v, (val) => trimStr(v).isEmpty ? isPurpose = true : isPurpose = false);

  void onChangeState(dynamic v, BuildContext context) {
    notify(v, (val) {
      selectedState = v;
    });
    Provider.of<SelectionsViewModel>(context, listen: false).fetchState(116);
  }

  resetKmEnd() {
    kmEndStoreCtrl.text = "";
  }

  resetForm(BuildContext context, ProfileViewModel p) {
    _selectedDt = null;
    departmentCtrl.text = p.user.department!.name;
    requestorCtrl.text = p.user.name;
    approverCtrl.text = p.user.manager != null ? p.user.manager!.name : "";
    selectedChecker = User(
        id: p.user.id,
        userId: p.user.userId,
        name: p.user.name,
        username: p.user.username,
        registrationNumber: p.user.registrationNumber,
        jobTitle: p.user.jobTitle);

    selectFleetVehicle = FleetVehicle(name: "Select an option", id: 0);
    selectedCheckType = "Select an option";
    kmCurrentCtrl.text = "";
    kmStartCtrl.text = "";
    kmEndCtrl.text = "";
    userData = p.user;
    manager = p.user.manager != null
        ? p.user.manager!
        : User(
            id: 0,
            userId: 0,
            name: '',
            username: '',
            registrationNumber: '',
            jobTitle: '');
    department = p.user.department != null
        ? p.user.department!
        : Department(id: 0, code: '', name: '');
    selectedState = CountryState(name: 'Phnom Penh', id: 1559);
    purposeCtrl.text = "";
    auditDateTimeCtrl =
        TextEditingController(text: formatReadableDT(DateTime.now()));
    plannedDateTimeOutCtrl =
        TextEditingController(text: formatReadableDT(DateTime.now()));
    plannedDateTimeInCtrl =
        TextEditingController(text: formatReadableDT(DateTime.now()));
    actualDateTimeOutCtrl.text = "";
    actualDateTimeInCtrl.text = "";
  }

  void setInfo(VehicleCheck data) {
    departmentCtrl.text = data.requestor!.department!.name;
    requestorCtrl.text = data.requestor!.name;
    approverCtrl.text = data.approver!.name;
    selectedChecker = data.checker != null
        ? User(
            id: data.checker!.id,
            userId: data.checker!.userId,
            name: data.checker!.name,
            username: data.checker!.username,
            registrationNumber: data.checker!.registrationNumber,
            jobTitle: data.checker!.jobTitle)
        : User.defaultUser(id: 0, name: '');
    selectedCheckType = data.checkType ?? "Select an option";

    if (isCheckTypeInOrBorrow(selectedCheckType)) {
      kmStartCtrl.text = data.kmStart?.toString() ?? "";
      kmEndCtrl.text = data.kmEnd?.toString() ?? "";
      plannedDateTimeOutCtrl.text =
          formatReadableDT(data.plannedDatetimeOut ?? DateTime.now());
      plannedDateTimeInCtrl.text =
          formatReadableDT(data.plannedDatetimeIn ?? DateTime.now());
      // set vehicle
      selectFleetVehicle = data.fleetVehicle != null
          ? FleetVehicle(
              name: data.fleetVehicle!.name,
              id: data.fleetVehicle!.id,
              odometer: data.kmStart)
          : FleetVehicle(name: "Select an option", id: 0);
    } else if (isCheckTypeAuditOrCheck(selectedCheckType)) {
      _selectedDt = data.auditDatetime;
      kmCurrentCtrl.text = data.kmCurrent?.toString() ?? "";
      auditDateTimeCtrl.text =
          formatReadableDT(data.auditDatetime ?? DateTime.now());
      // set vehicle
      selectFleetVehicle = data.fleetVehicle != null
          ? FleetVehicle(
              name: data.fleetVehicle!.name,
              id: data.fleetVehicle!.id,
              odometer: data.kmCurrent)
          : FleetVehicle(name: "Select an option", id: 0);
    }

    selectedState = data.location != null
        ? CountryState(name: data.location!.name, id: data.location!.id)
        : CountryState.defaultValue();

    purposeCtrl.text = data.purpose ?? "";
    stateString = data.state ?? "";
    userUpdate = data.requestor != null
        ? User(
            id: data.requestor!.id,
            userId: data.requestor!.userId,
            name: data.requestor!.name,
            username: data.requestor!.username,
            registrationNumber: data.requestor!.registrationNumber,
            jobTitle: data.requestor!.jobTitle)
        : User.defaultUser(id: 0, name: '');
    approver = data.approver != null
        ? User(
            id: data.approver!.id,
            userId: data.approver!.userId,
            name: data.approver!.name,
            username: data.approver!.username,
            registrationNumber: data.approver!.registrationNumber,
            jobTitle: data.approver!.jobTitle)
        : User.defaultUser(id: 0, name: '');
    actualDatetimeOut = data.actualDatetimeOut;
    actualDateTimeOutCtrl.text = data.actualDatetimeOut != null
        ? formatReadableDT(data.actualDatetimeOut!)
        : "";
    actualDateTimeInCtrl.text = data.actualDatetimeIn != null
        ? formatReadableDT(data.actualDatetimeIn!)
        : "";
  }

  bool isCheckTypeInOrBorrow(String checkType) {
    return checkType == "inout" || checkType == "borrow";
  }

  bool isCheckTypeAuditOrCheck(String checkType) {
    return checkType == "audit" || checkType == "check";
  }

  Future<void> selectDateTime(BuildContext context, String field,
      {VehicleCheck? data}) async {
    final DateTime currentDt = DateTime.now();
    final DateTime firstDt = DateTime(2021);
    final DateTime lastDt = DateTime(2100);

    DateTime initialDt;
    switch (field) {
      case 'audit':
        initialDt = (auditDateTimeCtrl.text.isNotEmpty
            ? parseDateTimeFormat(auditDateTimeCtrl.text)
            : _selectedDt ?? data?.auditDatetime ?? currentDt);
        break;
      case 'plannedOut':
        initialDt = (plannedDateTimeOutCtrl.text.isNotEmpty
            ? parseDateTimeFormat(plannedDateTimeOutCtrl.text)
            : _selectedDt ?? data?.plannedDatetimeOut ?? currentDt);
        break;
      case 'plannedIn':
        initialDt = (plannedDateTimeInCtrl.text.isNotEmpty
            ? parseDateTimeFormat(plannedDateTimeInCtrl.text)
            : _selectedDt ?? data?.plannedDatetimeIn ?? currentDt);
        break;
      default:
        initialDt = currentDt;
    }

    Future<void> dateAndTimeSelection(DateTime selectedDate) async {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime:
            // _selectedDt != null
            //     ? TimeOfDay(hour: _selectedDt!.hour, minute: _selectedDt!.minute)
            //     :
            TimeOfDay.fromDateTime(initialDt),
      );

      if (selectedTime != null) {
        final DateTime selectedDT = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        _selectedDt = selectedDT;

        switch (field) {
          case 'audit':
            auditDateTimeCtrl.text = formatReadableDT(selectedDT);
            break;
          case 'plannedOut':
            plannedDateTimeOutCtrl.text = formatReadableDT(selectedDT);
            break;
          case 'plannedIn':
            plannedDateTimeInCtrl.text = formatReadableDT(selectedDT);
            break;
        }
        notifyListeners();
      }
    }

    final DateTime? selectedDt = await showDatePicker(
      context: context,
      initialDate: initialDt.isBefore(lastDt) ? initialDt : lastDt,
      firstDate: firstDt,
      lastDate: lastDt,
    );

    if (selectedDt != null) await dateAndTimeSelection(selectedDt);
  }

  bool isValidated(BuildContext context) {
    onCheckTypeChanged(selectedCheckType);
    if (selectedCheckType == "inout" || selectedCheckType == "borrow") {
      onChangeKmStart(kmStartCtrl.text);
    }
    if (selectedCheckType == "audit" || selectedCheckType == "check") {
      onChangeKmCurrent(kmCurrentCtrl.text);
    }
    onChangePurpose(purposeCtrl.text);
    onChangeFleetVehicle(selectFleetVehicle, context);
    if (kmEndCtrl.text.isNotEmpty) isValidatedKmEnd(context);

    return isCheckType ||
        isKmStart ||
        isFleetVehicle ||
        isKmCurrent ||
        isKmEnd ||
        isPurpose;
  }

  bool isValidatedKmEnd(BuildContext context) {
    if (selectedCheckType == "inout" || selectedCheckType == "borrow") {
      onChangeKmEnd(kmEndCtrl.text);
    }

    return isKmEnd;
  }

  resetValidate() => isCheckType = isKmStart = isFleetVehicle = isKmCurrent =
      isPurpose = isKmEnd = isReadOnlyChecker = isReadOnly = false;

  void checkReadOnly(String state) => isReadOnly = (state == submit ||
      state == confirm ||
      state == approve ||
      state == done ||
      state == reject ||
      state == onProgress);

  void checkReadOnlyChecker(String state) =>
      isReadOnlyChecker = (state == confirm ||
          state == approve ||
          state == onProgress ||
          state == done);
  resetReadOnly() {
    isReadOnly = false;
    isReadOnlyChecker = false;
  }

  resetFormCreate(BuildContext context, ProfileViewModel p) {
    resetValidate();
    resetForm(context, p);
  }

  bool isDH(BuildContext context, int id) =>
      Provider.of<ProfileViewModel>(context, listen: false).user.id == id;
  bool isRequestor(BuildContext context, int id) =>
      Provider.of<ProfileViewModel>(context, listen: false).user.id == id;
}
