import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/services/api/hr/overtime/overtime_service.dart';
import 'package:umgkh_mobile/models/hr/overtime/overtime.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class ApproveEmployeeOvertimeHRViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  String? _selectedState = "all";
  int _year = DateTime.now().year;
  bool _isLoading = false;
  String? _search;
  List<Overtime> _approvalOvertimeList = [];
  List<Overtime> _filteredApprovalOTList = [];
  ApiResponse _apiResponse = ApiResponse(statusCode: 0, data: []);

  int? get year => _year;
  List<Overtime> get approvalOvertimeList => _approvalOvertimeList;
  List<Overtime> get filterApprovalOTList => _filteredApprovalOTList;
  bool get isLoading => _isLoading;
  String? get search => _search;
  ApiResponse get apiResponse => _apiResponse;
  int? _selectedDepartment = 0;
  Map<String, String> get optionStates => {
        "all": "All",
        "draft": "Draft",
        "submit": "Submit",
        "approve_dh": "Approved DH",
        "reject": "Rejected",
        "claim": "Claimed",
      };
  set search(String? value) {
    _search = value;
    _filterData(); // Apply filter when search changes
  }

  set year(int? value) {
    _year = value!;
    fetchApproveEmployeeOT();
  }

  /// Get data by Select state
  String? get selectedState => _selectedState;
  set selectedState(String? state) {
    _selectedState = state;
    _filterData();
    notifyListeners();
  }

//Get Department
  int? get selectedDepartment => _selectedDepartment;
  set selectedDepartment(int? id) {
    _selectedDepartment = id;
    _filterData();
    notifyListeners();
  }

  /// ********* Get data by employee Overtime ****************************
  Future<void> fetchApproveEmployeeOT() async {
    _isLoading = true;
    // _errorMessage = null;
    notifyListeners();

    final response = await OvertimeAPIService().fetchApprovalOvertimeHr(_year);
    _apiResponse = response;

    if (response.data != null) {
      _approvalOvertimeList = response.data!;
      _filterData(); // Apply filter after fetching data
    }

    _isLoading = false;
    notifyListeners();
  }

  /// ********** filter data when state changes and search results ***********
  void _filterData() {
    List<Overtime> filtered = _approvalOvertimeList;
    final searchText = _search?.toLowerCase() ?? '';

    //filter by state
    if (_selectedState != "all" && _selectedState != null) {
      filtered =
          filtered.where((request) => request.state == _selectedState).toList();
    }
    if (_selectedDepartment != 0 && _selectedDepartment != null) {
      filtered = filtered
          .where((request) =>
              request.employee!.department!.id == _selectedDepartment)
          .toList();
    }

    // Filter by search text across multiple fields
    if (searchText.isNotEmpty) {
      filtered = filtered.where((request) {
        final overtimeDateMatch = formatDMMMMYYYY(request.overtimeDate)
            .toLowerCase()
            .contains(searchText);
        final employeeName = request.employee!.name
            .toString()
            .toLowerCase()
            .contains(searchText);
        final reasonMatch = request.reason != null &&
            request.reason!.toLowerCase().contains(searchText);
        final departmentNameMatch = request.employee!.department!.name
            .toString()
            .toLowerCase()
            .contains(searchText);
        final overtimeTimeString =
            "${request.overtimeHours} hours ${request.overtimeMinutes ?? 0} minute"
                .toLowerCase();
        final dhOvertimeTimeString =
            "${request.approvedOvertimeHours} hours ${request.approvedOvertimeMinutes} minute"
                .toLowerCase();
        final overtimeTimeMatch = overtimeTimeString.contains(searchText);
        final dhOvertimeTimeMatch = dhOvertimeTimeString.contains(searchText);

        return overtimeDateMatch ||
            employeeName ||
            reasonMatch ||
            departmentNameMatch ||
            overtimeTimeMatch ||
            dhOvertimeTimeMatch;
      }).toList();
    }

    _filteredApprovalOTList = filtered;
    notifyListeners();
  }
}
