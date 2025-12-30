import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/base/data/static_selection.dart';
import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/models/service-project_task/job_assign_line/job_assign_line.dart';
import 'package:umgkh_mobile/models/service-project_task/project_task/project_task.dart';
import 'package:umgkh_mobile/models/service-project_task/project_task_rel/project_task_rel.dart';
import 'package:umgkh_mobile/models/service-project_task/stage/stage.dart';
import 'package:umgkh_mobile/services/api/base/auth/token_service.dart';
import 'package:umgkh_mobile/services/api/field_service/fs_api_service.dart';
import 'package:umgkh_mobile/services/local_storage/models/offline_actions_local_storage_service.dart';
import 'package:umgkh_mobile/services/local_storage/models/project_task/project_task_local_storage_service.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart';
import 'package:umgkh_mobile/view_models/timesheet_form_view_model.dart';
import '../models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/utils/static_state.dart';

class Item<T> {
  final String title;
  final T data;
  final bool disable;

  Item({required this.title, required this.data, this.disable = false});
}

class FieldServiceViewModel extends ChangeNotifier {
  final AuthAPIService _tokenManager = AuthAPIService();
  final ProjectTaskLocalStorageService _projectTaskService =
      ProjectTaskLocalStorageService();
  bool loaded = false;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  ProjectTask? _selectedData;
  List<User>? _optionUser;
  List<ProjectTask> _listData = [];
  List<ProjectTask> _showedData = [];
  List<ProjectTask>? _selectedReleatedData;
  List<Item>? _lines;
  int _selected = 0;
  String? _currentServiceType = '';
  String? _token = '';
  bool? _showFilter = false;
  Stage? _excludedStage = Stage(id: 12, name: 'Close', sequence: 0);
  DateTime _endDate = DateTime.now();
  DateTime _startDate = DateTime(
      DateTime.now().year, DateTime.now().month - 6, DateTime.now().day);

  DateTime get endDate => _endDate;
  DateTime get startDate => _startDate;
  bool _isLoading = false;
  String? get token => _token;
  String? get currentServiceType => _currentServiceType;
  Stage? get excludedStage => _excludedStage;
  bool? get showFilter => _showFilter;
  int get selected => _selected;
  bool get isLoading => _isLoading;
  List<Item>? get lines => _lines;
  List<User>? get optionUser => _optionUser;
  List<ProjectTask> get listData => _listData;
  ProjectTask? get selectedData => _selectedData;
  List<ProjectTask> get showedData => _showedData;
  ApiResponse _apiResponse = ApiResponse(statusCode: 0, data: []);
  ApiResponse get apiResponse => _apiResponse;
  TextEditingController searchCtrl = TextEditingController();
  Stage selectedStage = Stage(id: 0, name: 'All');
  StaticSelection selectedStatus = StaticSelection(id: 0, name: 'All');
  List<ProjectTask>? get selectedReleatedData => _selectedReleatedData;

  Future<void> setDate(DateTime date, bool isStart, String serviceType) async {
    notifyListeners();
    if (isStart) {
      _startDate = date;
    } else {
      _endDate = date;
    }
    fetchData(serviceType);
    notifyListeners();
  }

  changeShowFilter() {
    if (_showFilter == false) {
      _showFilter = true;
    } else {
      _showFilter = false;
    }
    notifyListeners();
  }

  setSelected(int num) {
    _selected = num;
    notifyListeners();
  }

  setSelectData(ProjectTask data) async {
    List<User>? users = [];
    if (data.jobAssignLines != null) {
      for (var element in data.jobAssignLines!) {
        users.add(element.mechanic);
      }
    }
    _optionUser = users;
    _selectedData = data;
    List<ProjectTaskRel>? dataLocalPTRel =
        await _projectTaskService.getProjectTaskRelByTaskId(data.id);
    List<ProjectTask> relatedTasks = [];
    if (dataLocalPTRel != null) {
      for (var dataLocal in dataLocalPTRel) {
        var res = await _projectTaskService
            .getProjectTaskById(dataLocal.relatedTaskId!);
        if (res != null) {
          relatedTasks.add(res);
        }
      }
    }
    _selectedReleatedData = relatedTasks;

    _lines = [
      Item(title: "Description", data: selectedData!.description),
      Item(
          title: "Job Assign",
          data: selectedData!.jobAssignLines,
          disable: data.jobAssignLines == null),
      Item(
          title: "Timesheet",
          data: selectedData!.timesheetProjectTasks ?? [],
          disable: data.jobAssignLines == null ||
              data.jobAssignLines!.isEmpty ||
              data.jobAssignLines!
                  .any((e) => e.state == wait || e.state == reject)),
      Item(
          title: "Call Customer",
          data: [1, 2],
          disable: data.jobAssignLines == null ||
              data.jobAssignLines!.isEmpty ||
              data.jobAssignLines!
                  .any((e) => e.state == wait || e.state == reject)),
      Item(
          title: "Overall Checking",
          data: selectedData!.overallCheckings ?? [],
          disable: data.jobAssignLines == null ||
              data.jobAssignLines!.isEmpty ||
              data.jobAssignLines!
                  .any((e) => e.state == wait || e.state == reject)),
      Item(
          title: "Service Report",
          data: selectedData!.serviceReports ?? [],
          disable: data.jobAssignLines == null ||
              data.jobAssignLines!.isEmpty ||
              data.jobAssignLines!
                  .any((e) => e.state == wait || e.state == reject)),
      Item(
          title: "Job Finish",
          data: selectedData!.jobFinishes ?? [],
          disable: data.jobAssignLines == null ||
              data.jobAssignLines!.isEmpty ||
              data.jobAssignLines!
                  .any((e) => e.state == wait || e.state == reject)),
      Item(
          title: "Job Analytic",
          data: selectedData!.jobAnalytics ?? [],
          disable: data.jobAssignLines == null ||
              data.jobAssignLines!.isEmpty ||
              data.jobAssignLines!
                  .any((e) => e.state == wait || e.state == reject))
    ];
    notifyListeners();
  }

  resetData(String serviceType) {
    loaded = false;
    _errorMessage = null;
    _currentServiceType = serviceType;
    // _listData = [];
    // _showedData = [];
    _selected = 0;
    clearFilter();
    notifyListeners();
  }

  clearFilter() {
    searchCtrl.clear();
    selectedStage = Stage(id: 0, name: 'All');
    selectedStatus = StaticSelection(id: 0, name: 'All');

    _endDate = DateTime.now();
    _startDate = DateTime(
        DateTime.now().year, DateTime.now().month - 6, DateTime.now().day);
  }

  Future<void> fetchData(String serviceType) async {
    _isLoading = true;
    notifyListeners();
    await OfflineActionStorageService().getOfflineAction();
    final response = await FieldServiceAPIService()
        .fetchData(serviceType, excludedStage!.id, startDate, endDate);
    _token = await _tokenManager.getValidToken();
    _apiResponse = response;
    if (response.error != null) {
      _errorMessage = response.error;
      debugPrint("_errorMessage: $_errorMessage");
    } else if (response.data != null) {
      _listData = response.data!['project_tasks']!;
      _showedData = response.data!['project_tasks']!;
      loaded = true;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchDataByData(int id, String serviceType,
      {BuildContext? context}) async {
    _isLoading = true;

    _token = await _tokenManager.getValidToken();
    final response =
        await FieldServiceAPIService().fetchDataById(id, serviceType);
    _apiResponse = response;
    if (response.error != null) {
      _errorMessage = response.error;
      debugPrint("_errorMessage: $_errorMessage");
    } else if (response.data != null) {
      ProjectTask updatedTask = response.data!['project_task']!;
      int index = _listData.indexWhere((model) => model.id == updatedTask.id);
      if (index != -1) {
        _listData[index] = updatedTask;
        List<User>? users = [];
        if (updatedTask.jobAssignLines != null) {
          for (var element in updatedTask.jobAssignLines!) {
            users.add(element.mechanic);
          }
        }
        _optionUser = users;
        _selectedData = updatedTask;

        await onUpdateStageFieldService(id, data: updatedTask);
        await onUpdateStageFieldServiceLocal(id, data: updatedTask);

        List<ProjectTaskRel>? dataLocalPTRel =
            await _projectTaskService.getProjectTaskRelByTaskId(updatedTask.id);
        if (dataLocalPTRel != null) {
          for (var data in dataLocalPTRel) {
            final relatedResponse = await FieldServiceAPIService()
                .fetchDataById(data.relatedTaskId!, serviceType);
            ProjectTask updatedTask = relatedResponse.data!['project_task']!;
            int index =
                _listData.indexWhere((model) => model.id == updatedTask.id);
            if (index != -1) {
              _listData[index] = updatedTask;
              List<User>? users = [];
              if (updatedTask.jobAssignLines != null) {
                for (var element in updatedTask.jobAssignLines!) {
                  users.add(element.mechanic);
                }
              }
            }
          }
        }
        await setSelectData(updatedTask);
        if (context != null) {
          if (context.mounted) {
            final p =
                Provider.of<TimesheetFormViewModel>(context, listen: false);
            p.isCheckButtonTimesheet(0, updatedTask);
          }
        }

        _showedData = [..._listData];
      }
      loaded = true;
      // clearFilter();
      notifyListeners();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateStageFieldService(int id, String stageName) async {
    try {
      Map<String, dynamic> data = {"id": id, "stage_name": stageName};

      await FieldServiceAPIService()
          .updateUpdateStageFieldService(data)
          .then((value) {
      });
    } catch (e) {
      debugPrint('$e');
    }
  }

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  onChangeStage(dynamic v) => notify(
        v,
        (val) {
          selectedStage = val;
          if (selectedStage.id == 0) {
            _showedData = listData;
            notifyListeners();
            return;
          }
          _showedData =
              _listData.where((e) => e.stage!.id == selectedStage.id).toList();
        },
      );

  onChangeExcludeStageByParam(Stage stage) {
    _excludedStage = stage;
    notifyListeners();
  }

  onChangeExcludeStage(dynamic v) => notify(
        v,
        (val) {
          _excludedStage = val;
          fetchData(currentServiceType!);
        },
      );

  onChangeStatus(dynamic v, BuildContext context) => notify(v, (val) {
        selectedStatus = val;
        if (selectedStatus.id == 0) {
          _showedData = listData;
          notifyListeners();
          return;
        }
        _showedData = _listData
            .where((e) =>
                titleState(context, e.jobAssignLines ?? []) ==
                selectedStatus.value)
            .toList();
      });

  onSearchChanged(String text) {
    if (text.isEmpty) {
      _showedData = listData;
      notifyListeners();
      return;
    }
    debugPrint('==> $text');
    _showedData = listData
        .where((e) =>
            toSearch(e.name, text) ||
            toSearch(e.jobOrderNo, text) ||
            toSearch(e.operatorName, text))
        .toList();

    notifyListeners();
  }

  bool toSearch(String? source, String text) =>
      source.toString().toLowerCase().contains(text.toLowerCase());

  bool isUser(BuildContext context, int id) {
    return Provider.of<ProfileViewModel>(context, listen: false).user.id == id;
  }

  String? titleState(BuildContext context, List<JobAssignLine> e) {
    final data = e.where((i) => isUser(context, i.mechanic.id));
    return data.isNotEmpty ? data.first.state : null;
  }

  bool isUpdateStage = false;
  String tapType = "";

  checkUpdateStage(ProjectTask data) {
    final expectedUserIds =
        data.jobAssignLines?.map((line) => line.mechanic.id).toSet() ?? {};
    final selectedUserIds = data.jobAnalytics
            ?.expand((analytic) => analytic.actionsBy ?? [])
            .map((user) => user.id)
            .toSet() ??
        {};

    final hasExpected = expectedUserIds.isNotEmpty;
    final isSubset = selectedUserIds.containsAll(expectedUserIds);
    final isPartialOverlap =
        selectedUserIds.intersection(expectedUserIds).isNotEmpty;

    isUpdateStage = false;
    tapType = "";
    if (data.jobAssignLines!.where((line) => line.state == "wait").length ==
            1 &&
        data.jobAssignLines!.where((line) => line.state == "accept").length ==
            data.jobAssignLines!.length - 1) {
      isUpdateStage = true;
      tapType = "job_assign";
    }
    // New logic
    else if (data.jobAssignLines!.every((line) => line.state == "accept")) {
      if (hasExpected && !isSubset && isPartialOverlap) {
        tapType = "job_analytic_evaluate";
        isUpdateStage = true;
      } else if (hasExpected && isSubset) {
        tapType = "job_analytic_close";
        isUpdateStage = true;
      }
    }

    // else if (data.jobAssignLines != null &&
    //     data.jobAssignLines!.length > 1 &&
    //     (data.jobAnalytics == null ||
    //         data.jobAnalytics != null &&
    //             (data.jobAssignLines!.length - 1 !=
    //                 data.jobAnalytics!.length)) &&
    //     data.jobAssignLines!.every((line) => line.state == "accept")) {
    //   tapType = "job_analytic_evaluate";
    //   isUpdateStage = true;
    // } else if (data.jobAssignLines != null &&
    //     (data.jobAssignLines!.length == 1 ||
    //         (data.jobAnalytics != null &&
    //             (data.jobAssignLines!.length - 1 ==
    //                 data.jobAnalytics!.length))) &&
    //     data.jobAssignLines!.every((line) => line.state == "accept")) {
    //   tapType = "job_analytic_close";
    //   isUpdateStage = true;
    // }
    else {
      isUpdateStage = false;
      tapType = "";
    }
  }

  onUpdateStageFieldService(int id, {ProjectTask? data}) async {
    if (data != null) {
      checkUpdateStage(data);
    }
    if (tapType == "job_assign" && isUpdateStage) {
      updateStageFieldService(id, "In Progress");
    }
    if (tapType == "job_analytic_evaluate" && isUpdateStage) {
      updateStageFieldService(id, "Evaluate");
    }
    if (tapType == "job_analytic_close" && isUpdateStage) {
      updateStageFieldService(id, "Close");
    }
  }

  onUpdateStageFieldServiceLocal(int id, {ProjectTask? data}) async {
    if (data != null) {
      checkUpdateStage(data);
    }
    if (tapType == "job_assign" && isUpdateStage) {
      await OfflineActionStorageService().saveOfflineAction(
          'project.task', id, 'update', jsonEncode("In Progress"));
    }
    if (tapType == "job_analytic_evaluate" && isUpdateStage) {
      await OfflineActionStorageService().saveOfflineAction(
          'project.task', id, 'update', jsonEncode("Evaluate"));
    }
    if (tapType == "job_analytic_close" && isUpdateStage) {
      await OfflineActionStorageService()
          .saveOfflineAction('project.task', id, 'update', jsonEncode("Close"));
    }
  }

  Set<int> getTakenActionByUserIds(int jobId, BuildContext context) {
    final fieldServiceVM = Provider.of<FieldServiceViewModel>(
      context,
      listen: false,
    );

    final selectedData = fieldServiceVM.selectedData;
    if (selectedData == null || selectedData.jobAnalytics == null) return {};

    final jobs = selectedData.jobAnalytics!
        .where((job) => job.projectTaskId == jobId)
        .toList();

    if (jobs.isEmpty) return {};

    final takenIds = <int>{};

    for (final job in jobs) {
      for (final user in job.actionsBy ?? []) {
        final id = user?.id;
        if (id != null) {
          takenIds.add(id);
        }
      }
    }
    return takenIds;
  }
}
