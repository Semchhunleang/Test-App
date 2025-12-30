import 'package:flutter/foundation.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/hr/leave/leave.dart';
import 'package:umgkh_mobile/models/hr/leave/leave_summary.dart';
import 'package:umgkh_mobile/services/api/hr/leave/leave_service.dart';

class TakeLeaveViewModel extends ChangeNotifier {
  List<Leave> _leaves = [];
  List<Leave> _filteredLeaves = [];
  bool _isLoading = false;
  String _search = '';
  DateTime _endDate = DateTime.now();
  DateTime _startDate = DateTime(DateTime.now().year - 1, 12, 26);
  int _year = DateTime.now().year;
  double _totalLeave = 0.0;
  List<LeaveSummary> _leaveSummaries = [];
  ApiResponse _apiResponse = ApiResponse(statusCode: 0, data: []);

  List<Leave> get leaves => _leaves;
  List<Leave> get filteredLeaves => _filteredLeaves;
  bool get isLoading => _isLoading;
  String get search => _search;
  DateTime get endDate => _endDate;
  DateTime get startDate => _startDate;
  int get year => _year;
  double get totalLeave => _totalLeave;
  List<LeaveSummary> get leaveSummaries => _leaveSummaries;
  ApiResponse get apiResponse => _apiResponse;

  resetData() async{
    await setSearch('');
    if (DateTime.now().month == 12 && DateTime.now().day >= 26) {
      await setYear(DateTime.now().year + 1);
    } else {
      await setYear(DateTime.now().year);
    }
  }
  Future<void> setDate(DateTime date, bool isStart) async {
    notifyListeners();
    _year = year;
    _startDate = DateTime(_year - 1, 12, 26);
    _endDate = DateTime(_year, 12, 26);
    fetchLeaves();
    notifyListeners();
  }

  Future<void> setYear(int year) async {
    notifyListeners();
    _year = year;
    _startDate = DateTime(_year - 1, 12, 26);
    _endDate = DateTime(_year, 12, 26);
    fetchLeaves();
    notifyListeners();
  }

  Future<void> setSearch(String search) async {
    notifyListeners();
    _search = search;
    fetchLeaves();
    notifyListeners();
  }

  Future<void> fetchLeaves() async {
    _isLoading = true;
    _leaveSummaries = [];
    _totalLeave = 0;
    notifyListeners();

    final response = await LeaveAPIService().fetchLeave();
    _apiResponse = response;
    if (response.statusCode == 200 || response.statusCode == 201) {
      final leaves = response.data!;
      _leaves = leaves.where((leave) {
        return leave.dateFrom.isAfter(_startDate) &&
            leave.dateFrom.isBefore(_endDate);
      }).toList();
      _filteredLeaves = leaves.where((leave) {
        return leave.description
                .toLowerCase()
                .contains(_search.toLowerCase()) &&
            leave.dateFrom.isAfter(_startDate) &&
            leave.dateFrom.isBefore(_endDate) ;
      }).toList();
    }else{
      _leaves = [];
      _filteredLeaves = [];
    }
      _updateLeaveSummaries();
    _isLoading = false;
    notifyListeners();
  }

  void _updateLeaveSummaries() {
    double totalLeave = 0;
    Map<String, LeaveSummary> summaryMap = {};
    for (var leave in _leaves) {
      if (summaryMap.containsKey(leave.leaveType.name)) {
        if (summaryMap[leave.leaveType.name]!.leaveIds!.contains(leave.id)) {
        } else {
          List<int>? leaveIdAssigned =
              summaryMap[leave.leaveType.name]!.leaveIds;
          if (leaveIdAssigned != null) {
            leaveIdAssigned.add(leave.id);
          }
          summaryMap[leave.leaveType.name]!.leaveIds = leaveIdAssigned;
          summaryMap[leave.leaveType.name]!.numberOfDays += leave.numberOfDays;
          totalLeave += leave.numberOfDays;
        }
      } else {
        List<int> leaveIds = [leave.id];
        summaryMap[leave.leaveType.name] = LeaveSummary(
          leaveType: leave.leaveType,
          numberOfDays: leave.numberOfDays,
          leaveIds: leaveIds,
        );
        totalLeave += leave.numberOfDays;
      }
    }
    _leaveSummaries = summaryMap.values.toList();
    _totalLeave = totalLeave;
  }
}
