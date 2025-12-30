import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/am/schedule_truck_driver/schedule_truck_driver.dart';
import 'package:umgkh_mobile/models/am/vehicle_check/fleet_vehicle.dart';
import 'package:umgkh_mobile/models/base/data/static_selection.dart';
import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/services/api/am/schedule_truck_driver/schedule_truck_driver_service.dart';
import 'package:umgkh_mobile/utils/show_dialog.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import '../utils/static_state.dart';

class ScheduleTruckDriverFormViewModel extends ChangeNotifier {
  String? message;
  bool isPurpose = false, isReadOnly = false;
  bool _isButtonDisabled = false, _isLoading = false;
  bool isRequiredDriverVehicle = false;
  bool isRequiredDriver = false, isRequiredVehicle = false;
  bool isRequiredKmStart = false, isRequiredKmEnd = false;
  bool isRequiredAppDT = false;
  bool isRequiredScheduleDeliDT = false, isRequiredActualDeliDT = false;
  bool isRequiredScheduleArriDT = false, isRequiredActualArriDT = false;
  DateTime? selectedDTRequest, selectedDTApprove;
  DateTime? selectedDTScheduleDeli, selectedDTActualDeli;
  DateTime? selectedDTScheduleArri, selectedDTActualArri;
  TextEditingController requestorCtrl = TextEditingController();
  TextEditingController deptCtrl = TextEditingController();
  TextEditingController purposeCtrl = TextEditingController();
  TextEditingController kmStartCtrl = TextEditingController();
  TextEditingController kmEndCtrl = TextEditingController();
  TextEditingController totalKmCtrl = TextEditingController();
  TextEditingController driverCtrl = TextEditingController();
  TextEditingController vehicleCtrl = TextEditingController();
  TextEditingController scheduleDeliDTCtrl = TextEditingController();
  TextEditingController actualDeliDTCtrl = TextEditingController();
  TextEditingController scheduleArriveDTCtrl = TextEditingController();
  TextEditingController actualArriveDTCtrl = TextEditingController();
  TextEditingController approveDTCtrl = TextEditingController();
  TextEditingController requestDTCtrl =
      TextEditingController(text: formatReadableDT(DateTime.now()));
  bool get isButtonDisabled => _isButtonDisabled;
  bool get isLoading => _isLoading;
  StaticSelection selectedTag = StaticSelection(name: 'Light', value: 'light');
  User selectedDriver = User.defaultUser(id: 0, name: 'Select driver');
  FleetVehicle selectedVehicle = FleetVehicle(id: 0, name: "Select vehicle");
  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  onChangePurpose(String v) => notify(
      v, (v) => trimStr(v).isEmpty ? isPurpose = true : isPurpose = false);

  onChangeKmStart(String v) => notify(v, (v) {
        final value = trimStr(v);
        // required when vehicle is selected
        if (selectedVehicle.id != 0) {
          if (value.isEmpty) {
            isRequiredKmStart = true;
          } else {
            final numVal = double.tryParse(value) ?? 0;
            isRequiredKmStart = (numVal <= 0);
          }
        }
      });

  onChangeKmEnd(String v) => notify(v, (v) {
        String value = trimStr(v);
        double kmEnd = double.tryParse(value) ?? 0;
        double kmStart = double.tryParse(kmStartCtrl.text) ?? 0;
        if (selectedVehicle.id != 0) {
          if (value.isEmpty || kmEnd <= 0 || kmEnd <= kmStart) {
            totalKmCtrl.text = '0';
            isRequiredKmEnd = true;
          } else {
            totalKmCtrl.text = (kmEnd - kmStart).toStringAsFixed(2);
            isRequiredKmEnd = false;
          }
        }
      });

  onTagChanged(StaticSelection v) => notify(v, (v) => selectedTag = v);

  onApproveDTChanged(DateTime? v) => notify(v, (v) {
        selectedDTApprove = v;
        isRequiredAppDT = selectedDTApprove == null;
      });

  onChangeDTScheduleDeli(DateTime? v) => notify(v, (v) {
        selectedDTScheduleDeli = v;
        isRequiredScheduleDeliDT = selectedDTScheduleDeli == null;
      });
  onChangeDTActualDeli(DateTime? v) => notify(v, (v) {
        selectedDTActualDeli = v;
        isRequiredActualDeliDT = selectedDTActualDeli == null;
      });
  onChangeDTScheduleArri(DateTime? v) => notify(v, (v) {
        selectedDTScheduleArri = v;
        isRequiredScheduleArriDT = selectedDTScheduleArri == null;
      });
  onChangeDTActualArri(DateTime? v) => notify(v, (v) {
        selectedDTActualArri = v;
        isRequiredActualArriDT = selectedDTActualArri == null;
      });

  onChangeDriver(dynamic v, BuildContext context) => notify(v, (v) {
        selectedDriver = v;
        isRequiredDriver = selectedDriver.id == 0;
        onChangeDriverVehicle(selectedVehicle, selectedDriver);
        context.read<SelectionsViewModel>().fetchAllEmployee();
      });

  onChangeVehicle(dynamic v, BuildContext context) => notify(v, (v) {
        selectedVehicle = v;
        isRequiredVehicle = selectedVehicle.id == 0;
        onChangeDriverVehicle(selectedVehicle, selectedDriver);
        context.read<SelectionsViewModel>().fetchFleetVehicle();
      });

  onChangeDriverVehicle(FleetVehicle vehicle, User driver) {
    isRequiredDriverVehicle = vehicle.id == 0 && driver.id == 0;
  }

  autoFillKM() {
    if (selectedVehicle.id != 0 && selectedVehicle.odometer != null) {
      kmStartCtrl.text = (selectedVehicle.odometer as num).toStringAsFixed(2);
      onChangeKmStart(kmStartCtrl.text);
    }
  }

  bool isValidated() {
    onChangePurpose(purposeCtrl.text);
    return isPurpose;
  }

  bool isValidatedApprove(BuildContext context) {
    onApproveDTChanged(selectedDTApprove);
    onChangeDriver(selectedDriver, context);
    onChangeVehicle(selectedVehicle, context);
    onChangeKmStart(kmStartCtrl.text);
    onChangeDriverVehicle(selectedVehicle, selectedDriver);
    return isRequiredAppDT ||
        isRequiredDriverVehicle ||
        // isRequiredDriver ||
        // isRequiredVehicle ||
        isRequiredKmStart;
  }

  bool isValidatedDone(BuildContext context) {
    onChangeDTScheduleDeli(selectedDTScheduleDeli);
    onChangeDTActualDeli(selectedDTActualDeli);
    onChangeDTScheduleArri(selectedDTScheduleArri);
    onChangeDTActualArri(selectedDTActualArri);
    onChangeKmEnd(kmEndCtrl.text);

    return isRequiredScheduleDeliDT ||
        isRequiredActualDeliDT ||
        isRequiredScheduleArriDT ||
        isRequiredActualArriDT ||
        isRequiredKmEnd;
  }

  Future<void> selectDateTime(BuildContext context,
      {required TextEditingController ctrl,
      DateTime? initialValue,
      required void Function(DateTime) onSelected}) async {
    final DateTime currentDt = DateTime.now();
    DateTime firstDt = DateTime(2021);
    final DateTime lastDt = DateTime(2100);
    DateTime initialDt = initialValue ?? currentDt;
    // set retrict range select datetime
    if (requestDTCtrl.text.isNotEmpty) {
      firstDt = parseConvertDT(requestDTCtrl.text);
    }
    // FIX: clamp initialDt so it’s inside [firstDt, lastDt]
    if (initialDt.isBefore(firstDt)) initialDt = firstDt;
    if (initialDt.isAfter(lastDt)) initialDt = lastDt;

    Future<void> dateAndTimeSelection(DateTime selectedDate) async {
      final TimeOfDay? selectedTime = await showTimePicker(
          context: context,
          initialTime: initialValue != null
              ? TimeOfDay(hour: initialValue.hour, minute: initialValue.minute)
              : TimeOfDay.now());

      if (selectedTime != null) {
        final DateTime selectedDT = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        ctrl.text = formatReadableDT(selectedDT);
        onSelected(selectedDT); // let caller update its own variable
        notifyListeners();
      }
    }

    final DateTime? selectedDt = await showDatePicker(
        context: context,
        // initialDate: initialValue ?? initialDt,
        initialDate: initialDt,
        firstDate: firstDt,
        lastDate: lastDt);

    if (selectedDt != null) await dateAndTimeSelection(selectedDt);
  }

  Map<String, dynamic> buildMap() {
    return {
      if (selectedDTRequest != null)
        "request_datetime": toApiSubtract7Hours(requestDTCtrl.text),
      "name": purposeCtrl.text,
    };
  }

  Future<void> insert(BuildContext context) async {
    if (_isButtonDisabled) return;
    _isButtonDisabled = _isLoading = true;
    notifyListeners();
    try {
      Map<String, dynamic> data = {
        "request_datetime": toApiSubtract7Hours(requestDTCtrl.text),
        "name": purposeCtrl.text,
      };
      final response = await ScheduleTruckDriverAPIService().insert(data);
      if (context.mounted) {
        _isLoading = false;
        await showResultDialog(context, '${response.message}',
            isBackToList: !response.message!.contains('error'),
            isDone: !response.message!.contains('error'));
      }
    } catch (e) {
      debugPrint('$e');
      _isLoading = false;
    } finally {
      _isButtonDisabled = _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> update(BuildContext context, data) async {
    _isLoading = true;
    notifyListeners();
    try {
      await ScheduleTruckDriverAPIService().update(data).then((value) {
        _isLoading = false;
        notifyListeners();
        if (context.mounted) {
          showResultDialog(context, '${value.message}',
              isBackToList: !value.message!.contains('error'),
              isDone: !value.message!.contains('error'));
        }
      });
    } catch (e) {
      _isLoading = false;
      debugPrint('$e');
    }
  }

  bool isRequestor(BuildContext context, int id) =>
      Provider.of<ProfileViewModel>(context, listen: false).user.id == id;

  void checkReadOnly(String state, BuildContext context, int id) =>
      isReadOnly = ((isRequestor(context, id)) ||
          state == submit ||
          state == approve ||
          state == done ||
          state == reject ||
          !isRequestor(context, id));

  resetValidate() => isPurpose = _isButtonDisabled = false;
  resetReadOnly() => isReadOnly = false;

  resetForm(BuildContext context) {
    final vm = Provider.of<ProfileViewModel>(context, listen: false);
    requestDTCtrl.text = formatReadableDT(DateTime.now());
    selectedDTRequest = null;
    selectedDTApprove = null;
    selectedDTScheduleDeli = null;
    selectedDTActualDeli = null;
    selectedDTScheduleArri = null;
    selectedDTActualArri = null;
    approveDTCtrl.clear();
    purposeCtrl.clear();
    kmStartCtrl.clear();
    kmEndCtrl.clear();
    totalKmCtrl.clear();
    driverCtrl.clear();
    vehicleCtrl.clear();
    scheduleDeliDTCtrl.clear();
    actualDeliDTCtrl.clear();
    scheduleArriveDTCtrl.clear();
    actualArriveDTCtrl.clear();
    requestorCtrl.text = vm.user.name;
    deptCtrl.text = vm.user.department?.name ?? '';

    // BOOL
    _isLoading = isPurpose = _isButtonDisabled = isRequiredDriver =
        isRequiredVehicle = isRequiredKmStart = isRequiredKmEnd = false;
    isRequiredAppDT = isRequiredScheduleDeliDT = isRequiredActualDeliDT =
        isRequiredScheduleArriDT =
            isRequiredActualArriDT = isRequiredDriverVehicle = false;

    // MODEL
    selectedDriver = User.defaultUser(id: 0, name: 'Select driver');
    selectedVehicle = FleetVehicle(id: 0, name: "Select vehicle");
    selectedTag = StaticSelection(name: 'Light', value: 'light');
  }

  setInfo(ScheduleTruckDriver data) {
    // CTRL
    requestorCtrl.text = data.requestor.name;
    deptCtrl.text = data.requestor.department?.name ?? '';
    purposeCtrl.text = data.name;
    kmStartCtrl.text = (data.kmStart ?? 0).toStringAsFixed(2);
    kmEndCtrl.text = (data.kmEnd ?? 0).toStringAsFixed(2);
    totalKmCtrl.text = (data.totalKm ?? 0).toStringAsFixed(2);
    driverCtrl.text = data.driver?.name ?? '';
    vehicleCtrl.text = data.vehicle?.name ?? '';

    // DATETIME
    // selectedDTRequest = data.requestDatetime;
    if (data.approveDatetime != null) selectedDTApprove = data.approveDatetime;
    if (data.scheduleDeliveryDatetime != null) {
      selectedDTScheduleDeli = data.scheduleDeliveryDatetime;
    }
    if (data.actualDeliveryDatetime != null) {
      selectedDTActualDeli = data.actualDeliveryDatetime;
    }
    if (data.scheduleArriveDatetime != null) {
      selectedDTScheduleArri = data.scheduleArriveDatetime;
    }
    if (data.actualArriveDatetime != null) {
      selectedDTActualArri = data.actualArriveDatetime;
    }

    // DATE TEXT
    requestDTCtrl.text = formatReadableDT(data.requestDatetime);
    data.approveDatetime != null
        ? approveDTCtrl.text = formatReadableDT(data.approveDatetime!)
        : null;
    data.scheduleDeliveryDatetime != null
        ? scheduleDeliDTCtrl.text =
            formatReadableDT(data.scheduleDeliveryDatetime!)
        : null;
    data.actualDeliveryDatetime != null
        ? actualDeliDTCtrl.text = formatReadableDT(data.actualDeliveryDatetime!)
        : null;
    data.scheduleArriveDatetime != null
        ? scheduleArriveDTCtrl.text =
            formatReadableDT(data.scheduleArriveDatetime!)
        : null;
    data.actualArriveDatetime != null
        ? actualArriveDTCtrl.text = formatReadableDT(data.actualArriveDatetime!)
        : null;

    // MODEL
    selectedTag = StaticSelection(
        name: toTitleCase(data.tag.toString()),
        value: data.tag.toString().toLowerCase());
    if (data.driver != null) {
      selectedDriver =
          User.defaultUser(id: data.driver!.id, name: data.driver!.name);
    }
    if (data.vehicle != null) {
      selectedVehicle =
          FleetVehicle(id: data.vehicle?.id, name: data.vehicle?.name);
    }
  }
}
