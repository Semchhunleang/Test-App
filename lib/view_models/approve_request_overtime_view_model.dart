import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/hr/request_overtime/request_overtime.dart';
import 'package:umgkh_mobile/services/api/hr/request_overtime/approve_request_overtime_service.dart';
import 'package:umgkh_mobile/services/api/hr/request_overtime/request_overtime_service.dart';
import 'package:umgkh_mobile/utils/show_dialog.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class ApproveRequestOvertimeViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  String? _selectedState = "all";
  int _year = DateTime.now().year;
  bool _isLoading = false;
  ApiResponse _apiResponse = ApiResponse(statusCode: 0, data: []);
  String? _search;
  List<RequestOvertime> _approvalOvertimeList = [];
  List<RequestOvertime> _filteredApprovalOTList = [];

  List<RequestOvertime> get approvalOvertimeList => _approvalOvertimeList;
  List<RequestOvertime> get filterApprovalOTList => _filteredApprovalOTList;
  bool get isLoading => _isLoading;
  // String? get errorMessage => _errorMessage;
  String? get search => _search;
  int? get year => _year;
  String? get selectedState => _selectedState;
  ApiResponse get apiResponse => _apiResponse;
  Map<String, String> get optionStates => {
        "all": "All",
        "draft": "Draft",
        "submit": "Submit",
        "approve_dh": "Approved DH",
        "reject": "Rejected",
        "claim": "Claimed",
      };
  bool _isLoadingBatch = false;
  bool get isLoadingBatch => _isLoadingBatch;
  bool _isSelected = false;
  bool get isSelected => _isSelected;
  bool _isSelectedAll = false;
  bool get isSelectedAll => _isSelectedAll;
  final Set<int> _selectedRequests = {};
  Set<int> get selectedRequests => _selectedRequests;
  //
  List<RequestOvertime> _filteredRequestOvertimeList = [];
  List<RequestOvertime> get filterRequestOvertimeList =>
      _filteredRequestOvertimeList;
  //

  set isSelected(bool value) {
    _isSelected = value;
    notifyListeners();
  }

  void toggleSelection(int requestId, String state, BuildContext context) {
    if (state != submit) {
      showResultDialog(
        context,
        'Cannot select this OT. Only requests with a "submit" state are allowed.',
        isBackToList: false,
      );
      return;
    }

    if (_selectedRequests.contains(requestId)) {
      _selectedRequests.remove(requestId);
      if (_selectedRequests.isEmpty) {
        _isSelectedAll = false;
      }
    } else {
      _selectedRequests.add(requestId);
    }
    notifyListeners();
  }

  onSelected() {
    _isSelected = !_isSelected;
    if (!_isSelected) {
      _selectedRequests.clear();
      _isSelectedAll = false;
    }
    notifyListeners();
  }

  void onSelectedAll(List<RequestOvertime> requestList) {
    _isSelectedAll = !_isSelectedAll;

    if (_isSelectedAll) {
      _selectedRequests.clear();
      for (var request in requestList) {
        if (request.state == submit) {
          _selectedRequests.add(request.id);
        }
      }
    } else {
      _selectedRequests.clear();
    }

    notifyListeners();
  }

  Future<void> batchApproveRequestOvertime(
      List<int> requestOvertimeIds, String state,
      {required BuildContext context}) async {
    _isLoadingBatch = true;
    notifyListeners();
    if (requestOvertimeIds.isEmpty) {
      showResultDialog(
        context,
        state == reject
            ? 'No requests selected for batch reject.'
            : 'No requests selected for batch approval.',
        isBackToList: false,
      );
      return;
    }

    final response = await ApproveRequestOvertimeAPIService()
        .batchApprovalRequestOvertime(
            requestOvertimeIds: requestOvertimeIds, state: state);
    if (context.mounted) {
      await showResultDialog(context, response.error ?? response.message!,
          isDone: true, isBackToList: false);
      if (response.statusCode == 200 || response.statusCode == 201) {
        _isSelected = false;
        _selectedRequests.clear();
      }
    }

    _isLoadingBatch = false;
    notifyListeners();
  }

  onClearSelect() {
    _isSelected = false;
    _selectedRequests.clear();
    _isSelectedAll = false;
    notifyListeners();
  }

  set search(String? value) {
    _search = value;
    _filterData(); // Apply filter when search changes
    _filterReqOTData();
  }

  set year(int? value) {
    _year = value!;
    fetchApproveRequestOT();
  }

  set selectedState(String? state) {
    _selectedState = state;
    _filterData(); // Filter data when state changes
    _filterReqOTData();
    fetchApproveRequestOT();
    notifyListeners();
  }

  Future<void> fetchApproveRequestOT() async {
    _isLoading = true;
    // _errorMessage = null;
    notifyListeners();

    final response =
        await RequestOvertimeAPIService().fetchApprovalOvertime(_year);
    _apiResponse = response;

    if (response.error != null) {
      // _errorMessage = response.error;
      _approvalOvertimeList = [];
    } else if (response.data != null) {
      _approvalOvertimeList = response.data!;
      _filterData(); // Apply filter after fetching data
      _filterReqOTData();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// ********** filter data when state changes and search results ***********
  void _filterData() {
    List<RequestOvertime> filtered = _approvalOvertimeList;
    final searchText = _search?.toLowerCase() ?? '';

    //filter by state
    if (_selectedState != "all" && _selectedState != null) {
      filtered =
          filtered.where((request) => request.state == _selectedState).toList();
    }

    // Filter by search text across multiple fields
    if (searchText.isNotEmpty) {
      filtered = filtered.where((request) {
        final overtimeDateMatch = formatDate(request.overtimeDate!)
            .toLowerCase()
            .contains(searchText);
        final employeeName =
            request.employee!.name.toLowerCase().contains(searchText);
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

  //
  /// ********** filter data when state changes and search results ***********
  void _filterReqOTData() {
    List<RequestOvertime> filtered = _approvalOvertimeList;
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
  //
}
