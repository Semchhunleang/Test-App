import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/services/api/hr/request_overtime/request_overtime_service.dart';

import 'package:umgkh_mobile/models/hr/request_overtime/request_overtime.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class RequestOvertimeViewModel extends ChangeNotifier {
  int _year = DateTime.now().year;
  String? _search;
  String? _selectedState = "all";
  List<RequestOvertime> _requestOvertimeList = [];
  List<RequestOvertime> _filteredRequestOvertimeList = [];
  bool _isLoading = false;
  ApiResponse _apiResponse = ApiResponse(statusCode: 0, data: []);

  List<RequestOvertime> get requestOvertimeList => _requestOvertimeList;
  List<RequestOvertime> get filterRequestOvertimeList =>
      _filteredRequestOvertimeList;
  bool get isLoading => _isLoading;
  ApiResponse get apiResponse => _apiResponse;
  final TextEditingController searchController = TextEditingController();

  Map<String, String> get optionStates => {
        "all": "All",
        "draft": "Draft",
        "submit": "Submit",
        "approve_dh": "Approved DH",
        "reject": "Rejected",
        "claim": "Claimed",
      };

  /// Get data by Select year
  int? get year => _year;
  set year(int? value) {
    _year = value!;
    fetchRequestOvertimes();
  }

  /// Get data by Search (overtimeDate,reason,departmentName, overtimeTimeMatch,dhOvertimeTimeMatch)
  String? get search => _search;
  set search(String? value) {
    _search = value;
    _filterData(); // Apply filter when search changes
  }

  /// Get data by Select state
  String? get selectedState => _selectedState;
  set selectedState(String? state) {
    _selectedState = state;
    _filterData(); // Filter data when state changes
    notifyListeners();
  }

  /// ********* Get data by request Overtime ****************************
  Future<void> fetchRequestOvertimes() async {
    _isLoading = true;
    notifyListeners();

    final response =
        await RequestOvertimeAPIService().fetchOvertimeRequests(_year);
    _apiResponse = response;

    if (response.data != null) {
      _requestOvertimeList = response.data!;
      _filterData(); // Apply filter after fetching data
    }

    _isLoading = false;
    notifyListeners();
  }

  /// ********** filter data when state changes and search results ***********
  void _filterData() {
    List<RequestOvertime> filtered = _requestOvertimeList;
    final searchText = _search?.toLowerCase() ?? '';

    //filter by state
    if (_selectedState != "all" && _selectedState != null) {
      filtered =
          filtered.where((request) => request.state == _selectedState).toList();
    }

    // Filter by search text across multiple fields
    if (searchText.isNotEmpty) {
      filtered = filtered.where((request) {
        final overtimeDateMatch = formatDDMMMMYYYY(request.overtimeDate!)
            .toLowerCase()
            .contains(searchText);
        final reasonMatch = request.reason != null &&
            request.reason!.toLowerCase().contains(searchText);
        final departmentNameMatch = request.employee!.department!.name
            .toLowerCase()
            .contains(searchText);
        final overtimeTimeString =
            "${request.overtimeHours} hours ${request.overtimeMinutes ?? 0} minute"
                .toLowerCase();
        final dhOvertimeTimeString =
            "${request.dhOvertimeHours} hours ${request.dhOvertimeMinutes} minute"
                .toLowerCase();
        final overtimeTimeMatch = overtimeTimeString.contains(searchText);
        final dhOvertimeTimeMatch = dhOvertimeTimeString.contains(searchText);

        return overtimeDateMatch ||
            reasonMatch ||
            departmentNameMatch ||
            overtimeTimeMatch ||
            dhOvertimeTimeMatch;
      }).toList();
    }

    _filteredRequestOvertimeList = filtered;
    notifyListeners();
  }

  // for validation reason
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
}
