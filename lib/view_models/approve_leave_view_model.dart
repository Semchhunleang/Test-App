import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/hr/leave/leave.dart';
import 'package:umgkh_mobile/models/hr/leave/leave_dept_summary.dart';
import 'package:umgkh_mobile/models/hr/leave/leave_employee_summary.dart';
import 'package:umgkh_mobile/models/hr/leave/leave_summary.dart';
import 'package:umgkh_mobile/models/hr/leave/leave_type.dart';
import 'package:umgkh_mobile/services/api/hr/leave/leave_service.dart';
import 'package:umgkh_mobile/utils/show_dialog.dart';

const String defaultState = 'confirm';

class ApproveLeaveViewModel extends ChangeNotifier {
  List<Leave> _leaves = [];
  List<Leave> _leavesByDept = [];
  List<Leave> _filteredLeaves = [];
  List<Leave> storeLeaves = [];
  bool _isLoading = false;
  String _search = '';
  DateTime _endDate = DateTime.now();
  DateTime _startDate = DateTime(DateTime.now().year - 1, 12, 26);
  int _year = DateTime.now().year;
  double _totalLeave = 0.0, _totalLeaveByDept = 0.0;
  List<LeaveEmployeeSummary> _leaveSummaries = [];
  List<LeaveDeptSummary> _leaveDeptSummaries = [];
  ApiResponse _apiResponse = ApiResponse(statusCode: 0, data: []);

  List<Leave> get leaves => _leaves;
  List<Leave> get leavesByDept => _leavesByDept;
  List<Leave> get filteredLeaves => _filteredLeaves;
  bool get isLoading => _isLoading;
  String get search => _search;
  DateTime get endDate => _endDate;
  DateTime get startDate => _startDate;
  int get year => _year;
  double get totalLeave => _totalLeave;
  double get totalLeaveByDept => _totalLeaveByDept;
  List<LeaveEmployeeSummary> get leaveSummaries => _leaveSummaries;
  List<LeaveDeptSummary> get leaveDeptSummaries => _leaveDeptSummaries;
  ApiResponse get apiResponse => _apiResponse;
  String selectedState = defaultState, _status = defaultState;
  bool isFilterLocal = true, isShowFilter = false;

  Future<void> setDate(DateTime date, bool isStart) async {
    notifyListeners();
    _year = year;
    _startDate = DateTime(_year - 1, 12, 26);
    _endDate = DateTime(_year, 12, 25);
    fetchLeaves();
    notifyListeners();
  }

  Future<void> setYear(int year) async {
    isFilterLocal = false;
    notifyListeners();
    _year = year;
    _startDate = DateTime(_year - 1, 12, 26);
    _endDate = DateTime(_year, 12, 25);
    fetchLeaves();
    notifyListeners();
  }

  resetData() {
    setSearch('');
    if (DateTime.now().month == 12 && DateTime.now().day >= 26) {
      setYear(DateTime.now().year + 1);
    } else {
      setYear(DateTime.now().year);
    }
  }

  Future<void> setSearch(String search) async {
    notifyListeners();
    _search = search;
    fetchLeaves();
    notifyListeners();
  }

  Future<void> fetchLeaves() async {
    _isLoading = true;
    notifyListeners();

    final response = await LeaveAPIService().fetchLeaveDH();
    _apiResponse = response;
    if (response.statusCode == 200 || response.statusCode == 201) {
      _leaves = response.data!.where((leave) {
        return leave.dateFrom.isAfter(_startDate) &&
            leave.dateFrom.isBefore(_endDate);
      }).toList();
      _filteredLeaves = response.data!
        ..where((leave) {
          return leave.description
                  .toLowerCase()
                  .contains(_search.toLowerCase()) &&
              leave.dateFrom.isAfter(_startDate) &&
              leave.dateFrom.isBefore(_endDate);
        }).toList();
      // set data to state - To Approve
      isFilterLocal
          ? onStateChanged(defaultState)
          : onStateChanged(selectedState);
    } else {
      _leaves = [];
      _filteredLeaves = [];
    }
    _updateLeaveSummaries();
    _isLoading = false;
    notifyListeners();
  }

// =========== start: PUTHEA ===========
  Future<void> fetchLeaveByDept(int detpId) async {
    // reset
    _totalLeaveByDept = 0.0;
    _leaveDeptSummaries.clear();
    final response = await LeaveAPIService().fetchLeaveByDept(detpId);
    if (response.data != null) {
      _leavesByDept = response.data!.where((leave) {
        return leave.dateFrom.isAfter(_startDate) &&
            leave.dateFrom.isBefore(_endDate);
      }).toList();
    }
    _updateLeaveDeptSummaries();
    notifyListeners();
  }

  void _updateLeaveDeptSummaries() {
    // reset
    _totalLeaveByDept = 0.0;
    _leaveDeptSummaries.clear();
    Map<String, double> totalLeaveByName = {};
    Map<String, Map<String, double>> leaveTypesByName = {};

    for (var leave in _leavesByDept) {
      _totalLeaveByDept += leave.numberOfDays;

      String name = leave.user.name;
      String type = leave.leaveType.name;

      // Total leave days
      totalLeaveByName[name] =
          (totalLeaveByName[name] ?? 0) + leave.numberOfDays;

      // Leave types per employee
      leaveTypesByName[name] ??= {};
      leaveTypesByName[name]![type] =
          (leaveTypesByName[name]![type] ?? 0) + leave.numberOfDays;
    }

    _leaveDeptSummaries = totalLeaveByName.entries.map((entry) {
      String name = entry.key;
      double total = entry.value;

      List<LeaveType> typeSummaries = (leaveTypesByName[name] ?? {})
          .entries
          .map((e) => LeaveType(id: 0, name: e.key, numberOfDays: e.value))
          .toList();

      return LeaveDeptSummary(
        employeeName: name,
        employeeTotalLeave: total,
        leaveTypes: typeSummaries,
      );
    }).toList();

    notifyListeners();
  }

// =========== end: PUTHEA ===========

  Future<void> updateLeaveStatus(
      BuildContext context, String state, int id) async {
    _isLoading = true;
    notifyListeners();

    ApiResponse response = await LeaveAPIService().updateState(state, id);

    if (context.mounted) {
      await showResultDialog(context, response.error ?? response.message!,
          onTap: () {
        Navigator.pop(context); // close dialog 1
        Navigator.pop(context); // close dialog 2
        Navigator.pop(context); // close page
        fetchLeaves();
      });
    }
    _isLoading = false;
    notifyListeners();
  }

  void _updateLeaveSummaries() {
    Map<String, Map<String, LeaveSummary>> summaryMap = {};
    Map<String, double> totalLeaveMap =
        {}; // Map to track total leave days for each employee

    for (var leave in _leaves) {
      String userName = leave.user.name;
      String leaveTypeName = leave.leaveType.name;

      if (!summaryMap.containsKey(userName)) {
        summaryMap[userName] = {};
        totalLeaveMap[userName] = 0; // Initialize total leave days for the user
      }

      if (!summaryMap[userName]!.containsKey(leaveTypeName)) {
        summaryMap[userName]![leaveTypeName] = LeaveSummary(
          leaveType: leave.leaveType,
          numberOfDays: 0,
          leaveIds: [],
        );
      }

      LeaveSummary leaveSummary = summaryMap[userName]![leaveTypeName]!;

      if (!leaveSummary.leaveIds!.contains(leave.id)) {
        leaveSummary.leaveIds!.add(leave.id);
        leaveSummary.numberOfDays += leave.numberOfDays;
        totalLeaveMap[userName] = totalLeaveMap[userName]! + leave.numberOfDays;
      }
    }

    _leaveSummaries = summaryMap.entries.map((entry) {
      int userId = _leaves.firstWhere((l) => l.user.name == entry.key).user.id;
      return LeaveEmployeeSummary(
        userId: userId,
        name: entry.key,
        summaries: entry.value.values.toList(),
        numberOfDays: totalLeaveMap[entry.key]!, // Assign total leave days
      );
    }).toList();

    // Sort the list by name
    _leaveSummaries.sort((a, b) => b.numberOfDays.compareTo(a.numberOfDays));

    _totalLeave =
        totalLeaveMap.values.reduce((a, b) => a + b); // Sum all total leaves
  }

  // puthea start changed
  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  onSearchChanged(String text) => notify(text, (val) {
        _search = text;
        onFilter();
      });

  void onStateChanged(String v) => notify(v, (val) {
        selectedState = val;
        _status = val;
        onFilter();
      });

  onShowFilter() => notify(null, (val) {
        isShowFilter = !isShowFilter;
      });

  void onFilter() {
    _filteredLeaves = _leaves.where((item) {
      final matchSearch = toSearch(item.description, search);
      final matchStatus = _status == 'all' || item.state == _status;
      return matchSearch && matchStatus;
    }).toList();
    notifyListeners();
  }

  bool toSearch(String? source, String text) {
    return source.toString().toLowerCase().contains(text.toLowerCase());
  }

  resetStateToDefault() {
    selectedState = _status = defaultState;
    isFilterLocal = true;
    isShowFilter = false;
  }

  resetStateToAll() => selectedState = _status = 'all';
}
