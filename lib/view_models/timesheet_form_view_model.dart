import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/am/vehicle_check/fleet_vehicle.dart';
import 'package:umgkh_mobile/models/base/data/static_selection.dart';
import 'package:umgkh_mobile/models/service-project_task/project_task/project_task.dart';
import 'package:umgkh_mobile/models/service-project_task/timesheet_project_task/timesheet_project_task.dart';
import 'package:umgkh_mobile/services/api/field_service/fs_api_service.dart';
import 'package:umgkh_mobile/utils/show_dialog.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/field_service_view_model.dart';

class TimesheetFormViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isLoadingButton = false;
  bool get isLoadingButton => _isLoadingButton;
  bool isSelectVehicle = false, isOdometerStart = false, isOdometerEnd = false;
  bool isDispatch = false,
      isArriveSite = false,
      isJobStart = false,
      isJobComplete = false,
      isLeaveFromSite = false,
      isArriveOffice = false,
      isNextTrip = false,
      isDispatchFrom = false,
      isArriveAt = false;
  TextEditingController odometerStartCtrl = TextEditingController();
  TextEditingController odometerEndCtrl = TextEditingController();
  TextEditingController remarkCtrl = TextEditingController();
  FleetVehicle selectFleetVehicle =
      FleetVehicle(name: "Select an option", id: 0);
  String trip = "";
  int indexLast = 0;
  int lastIndexPause = 0;
  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;
  StaticSelection dispatchFrom =
      StaticSelection(id: 0, name: 'Selection dispatch from');
  StaticSelection arriveAt =
      StaticSelection(id: 0, name: 'Selection arrive at');

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  onChangeVehicle(dynamic v) =>
      notify(v, (val) => isSelectVehicle = (selectFleetVehicle = val).id == 0);

  onChangeOdometerStart(String v) =>
      notify(v, (val) => isOdometerStart = trimStr(v).isEmpty);

  onChangeOdometerEnd(String v, int odometerStart) {
    final odometerEnd = int.tryParse(v) ?? 0;

    bool isValidOdometerEnd =
        trimStr(v).isEmpty || odometerEnd <= odometerStart;
    notify(v, (val) => isOdometerEnd = isValidOdometerEnd);
  }

  onChangeDispatchFrom(dynamic v) => notify(v, (val) {
        dispatchFrom = val;
        isDispatchFrom = dispatchFrom.id == 0;
      });

  onChangeArriveAt(dynamic v) => notify(v, (val) {
        arriveAt = val;
        isArriveAt = arriveAt.id == 0;
      });

  bool isValidated() {
    onChangeDispatchFrom(dispatchFrom);
    onChangeVehicle(selectFleetVehicle);
    onChangeOdometerStart(odometerStartCtrl.text);
    return isSelectVehicle || isOdometerStart || isDispatchFrom;
  }

  bool setIsLoadingButton(bool load) {
    notifyListeners();
    _isLoadingButton = load;
    notifyListeners();
    return load;
  }

  bool isValidatedOdometerEnd(int odometerStart) {
    onChangeOdometerEnd(odometerEndCtrl.text, odometerStart);
    onChangeArriveAt(arriveAt);
    return isOdometerEnd || isArriveAt;
  }

  Future<void> insertTimesheet(
    BuildContext context,
    int id,
    String serviceType,
  ) async {
    try {
      // var tripOffId =
      //     'off-id-trip-${id.toString()}-$trip-${DateTime.now().toIso8601String()}';
      // TripProjectTask insertDataTripProjectTask = TripProjectTask(
      //     fleetVehicle: selectFleetVehicle,
      //     offId: tripOffId,
      //     dispatchDt: DateTime.now(),
      //     odometerStart: int.parse(odometerStartCtrl.text),
      //     smallPaperId: smallPaperId);
      // TripProjectTaskRel insertTPTRData =
      //     TripProjectTaskRel(taskId: id, tripId: null, tripOffId: tripOffId);
      TimesheetProjectTask insertData = TimesheetProjectTask(
          trip: trip != '' ? int.parse(trip) : 0,
          fleetVehicle: selectFleetVehicle,
          offId: '${id.toString()}-$trip-${DateTime.now().toIso8601String()}',
          dispatchDt: DateTime.now(),
          odometerStart: int.parse(odometerStartCtrl.text),
          projectTaskId: id,
          // tripOffId: tripOffId,
          dispatchFrom: dispatchFrom.value);
      // await FieldServiceAPIService()
      //     .insertTimesheet(
      //         insertData, id, insertDataTripProjectTask, insertTPTRData)

      await FieldServiceAPIService()
          .insertTimesheet(insertData, id)
          .then((value) async {
        if (context.mounted) {
          final p1 = Provider.of<FieldServiceViewModel>(context, listen: false);
          p1.fetchDataByData(id, serviceType, context: context);
        }
        if (context.mounted) {
          await showResultDialog(context, '${value.message}',
              isBackToList: !value.message!.contains('error'),
              isDone: !value.message!.contains('error'));
        }
      });
    } catch (e, tracking) {
      debugPrint('==========> insertimesheet $e and tracking $tracking');
    }
  }

  Future<void> insertPauseTask(BuildContext context,
      {int? id, int? workshopId}) async {
    try {
      Map<String, dynamic> data = {
        "timesheet_task_project_id": id,
        "timesheet_task_project_workshop_id": workshopId
      };

      await FieldServiceAPIService().insertPauseTask(data).then((value) {
        if (context.mounted) {
          showResultDialog(context, '${value.message}',
              isBackToList: !value.message!.contains('error'),
              isDone: !value.message!.contains('error'));
        }
        notifyListeners();
      });
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> updateContinueTask(BuildContext context, int id) async {
    try {
      Map<String, dynamic> data = {"id": id};

      await FieldServiceAPIService().updateContinueTask(data).then((value) {
        if (context.mounted) {
          showResultDialog(context, '${value.message}',
              isBackToList: !value.message!.contains('error'),
              isDone: !value.message!.contains('error'));
        }
        notifyListeners();
      });
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> insertTimesheetWorkshop(
      BuildContext context, int id, String serviceType) async {
    try {
      Map<String, dynamic> data = {"timesheet_task_project_workshop_id": id};

      await FieldServiceAPIService()
          .insertTimesheetWorkshop(data)
          .then((value) {
        if (context.mounted) {
          showResultDialog(context, '${value.message}',
              isBackToList: false, isDone: !value.message!.contains('error'));

          final p1 = Provider.of<FieldServiceViewModel>(context, listen: false);
          p1.fetchDataByData(id, serviceType, context: context);
        }
        notifyListeners();
      });
    } catch (e, tracking) {
      debugPrint('==========> insertimesheet $e and trancking : $tracking');
    }
  }

  Future<void> updateTimesheetWorkshop(BuildContext context, int id,
      String serviceType, int projectTaskId) async {
    try {
      Map<String, dynamic> data = {"id": id, "remark": remarkCtrl.text};

      await FieldServiceAPIService()
          .updateTimesheetWorkshop(data)
          .then((value) {
        if (context.mounted) {
          showResultDialog(context, '${value.message}',
              isBackToList: false, isDone: !value.message!.contains('error'));
        }

        if (!value.message!.contains('error')) {
          resetForm();
        }

        if (context.mounted) {
          final p1 = Provider.of<FieldServiceViewModel>(context, listen: false);
          p1.fetchDataByData(projectTaskId, serviceType, context: context);
        }
        notifyListeners();
      });
    } catch (e) {
      debugPrint('$e');
    }
  }

  String getFormattedCurrentDateTime() {
    return DateTime.now().toUtc().toString();
  }

  Future<void> updateTimesheet(BuildContext context, int id,
      TimesheetProjectTask timesheet, int projectTaskId) async {
    _isLoading = true;
    notifyListeners();

    String? arriveAtSite;
    String? jobStartDt;
    String? jobCompleteDt;
    String? leaveFromSiteDt;
    String? arriveAtOfficeDt;

    if (isArriveSite) {
      arriveAtSite = getFormattedCurrentDateTime();
    } else if (isJobStart) {
      jobStartDt = getFormattedCurrentDateTime();
    } else if (isJobComplete) {
      jobCompleteDt = getFormattedCurrentDateTime();
    } else if (isLeaveFromSite) {
      leaveFromSiteDt = getFormattedCurrentDateTime();
    } else if (isArriveOffice) {
      arriveAtOfficeDt = getFormattedCurrentDateTime();
    }

    if (timesheet.arrivalAtSiteDt != null) {
      arriveAtSite = timesheet.arrivalAtSiteDt.toString();
    }
    if (timesheet.jobStartDt != null) {
      jobStartDt = timesheet.jobStartDt.toString();
    }
    if (timesheet.jobCompleteDt != null) {
      jobCompleteDt = timesheet.jobCompleteDt.toString();
    }
    if (timesheet.leaveFromSiteDt != null) {
      leaveFromSiteDt = timesheet.leaveFromSiteDt.toString();
    }
    if (timesheet.arriveAtOfficeDt != null) {
      arriveAtOfficeDt = timesheet.arriveAtOfficeDt.toString();
    }
    try {
      Map<String, dynamic> data = {
        "id": id,
        "arrival_at_site_dt": arriveAtSite,
        "job_start_dt": jobStartDt,
        "job_complete_dt": jobCompleteDt,
        "leave_from_site_dt": leaveFromSiteDt,
        "arrive_at_office_dt": arriveAtOfficeDt,
        "odometer_end":
            odometerEndCtrl.text.isEmpty ? null : odometerEndCtrl.text,
        "arrive_at": arriveAt.value
      };

      final response = await FieldServiceAPIService()
          .updateTimesheet(data, timesheet, projectTaskId);
      if (response.statusCode == 201 || response.statusCode == 200) {
        _isSuccess = true;
        notifyListeners();
      } else {
        _isSuccess = false;
        notifyListeners();
      }
    } catch (e) {
      _isSuccess = false;
      notifyListeners();
      debugPrint('$e');
    }

    _isLoading = false;
    notifyListeners();
  }

  resetValidate() => isSelectVehicle =
      isOdometerStart = isOdometerEnd = isDispatchFrom = isArriveAt = false;

  resetForm() {
    trip = "";
    selectFleetVehicle = FleetVehicle(id: 0, name: 'Select an option');
    dispatchFrom = StaticSelection(id: 0, name: 'Selection dispatch from');
    arriveAt = StaticSelection(id: 0, name: 'Selection arrive at');
    odometerStartCtrl.clear();
    odometerEndCtrl.clear();
    remarkCtrl.clear();
  }

  setInfoForm(ProjectTask projectTask) {
    trip = projectTask.timesheetProjectTasks != null
        ? "${projectTask.timesheetProjectTasks!.length + 1}"
        : "1";
  }

  isCheckButtonTimesheet(int index, ProjectTask data) {
    isDispatch = false;
    isJobComplete = false;
    isArriveSite = false;
    isJobStart = false;
    isLeaveFromSite = false;
    isArriveOffice = false;
    isNextTrip = false;
    notifyListeners();

    if (data.timesheetProjectTasks != null &&
        data.timesheetProjectTasks![index].dispatchDt == null) {
      isDispatch = true;
    } else if (data.timesheetProjectTasks != null &&
        data.timesheetProjectTasks![index].arrivalAtSiteDt == null) {
      isArriveSite = true;
    } else if (data.timesheetProjectTasks != null &&
        data.timesheetProjectTasks![index].jobStartDt == null) {
      isJobStart = true;
    } else if (data.timesheetProjectTasks != null &&
        data.timesheetProjectTasks![index].jobCompleteDt == null) {
      isJobComplete = true;
    } else if (data.timesheetProjectTasks != null &&
        data.timesheetProjectTasks![index].leaveFromSiteDt == null) {
      isLeaveFromSite = true;
    } else if (data.timesheetProjectTasks != null &&
        data.timesheetProjectTasks![index].arriveAtOfficeDt == null) {
      isArriveOffice = true;
    } else if (data.timesheetProjectTasks != null &&
        data.timesheetProjectTasks!.isNotEmpty &&
        data.timesheetProjectTasks![index].arrivalAtSiteDt != null &&
        data.timesheetProjectTasks![index].jobStartDt != null &&
        data.timesheetProjectTasks![index].jobCompleteDt != null &&
        data.timesheetProjectTasks![index].leaveFromSiteDt != null &&
        data.timesheetProjectTasks![index].arriveAtOfficeDt != null) {
      isNextTrip = true;
    } else {
      isDispatch = false;
      isJobComplete = false;
      isArriveSite = false;
      isJobStart = false;
      isLeaveFromSite = false;
      isArriveOffice = false;
      isNextTrip = false;
    }

    // bool hasPendingTasks = isDispatch ||
    //     isArriveSite ||
    //     isJobStart ||
    //     isJobComplete ||
    //     isLeaveFromSite ||
    //     isArriveOffice ||
    //     isNextTrip;

    notifyListeners();

    // return hasPendingTasks;
  }

  getLastIndex(ProjectTask data) {
    indexLast = 0;
    lastIndexPause = 0;
    if (data.timesheetProjectTasks != null) {
      indexLast = data.timesheetProjectTasks!.length - 1;
    } else if (data.timesheetWorkshop != null) {
      indexLast = data.timesheetWorkshop!.length - 1;
    } else {
      indexLast = 0;
    }

    if (data.timesheetProjectTasks != null &&
        data.timesheetProjectTasks![0].pauseContinue != null &&
        data.timesheetProjectTasks![0].pauseContinue!.isNotEmpty) {
      lastIndexPause = data.timesheetProjectTasks![0].pauseContinue!.length - 1;
    } else if (data.timesheetWorkshop != null &&
        data.timesheetWorkshop![0].pauseContinue != null &&
        data.timesheetWorkshop![0].pauseContinue!.isNotEmpty) {
      lastIndexPause = data.timesheetWorkshop![0].pauseContinue!.length - 1;
    } else {
      lastIndexPause = 0;
    }
  }

  bool onContinueTask(ProjectTask task) {
    bool isContinue = false;
    if (task.timesheetProjectTasks != null &&
        task.timesheetProjectTasks![0].pauseContinue != null &&
        task.timesheetProjectTasks![0].pauseContinue!.isNotEmpty &&
        task.timesheetProjectTasks![0].pauseContinue![lastIndexPause].pauseDt !=
            null &&
        task.timesheetProjectTasks![0].pauseContinue![lastIndexPause]
                .continueDt ==
            null) {
      isContinue = true;
    } else if (task.timesheetWorkshop != null &&
        task.timesheetWorkshop![0].pauseContinue != null &&
        task.timesheetWorkshop![0].pauseContinue!.isNotEmpty &&
        task.timesheetWorkshop![0].pauseContinue![lastIndexPause].pauseDt !=
            null &&
        task.timesheetWorkshop![0].pauseContinue![lastIndexPause].continueDt ==
            null) {
      isContinue = true;
    } else {
      isContinue = false;
    }
    return isContinue;
  }
}
