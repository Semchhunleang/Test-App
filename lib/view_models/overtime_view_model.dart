import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/hr/overtime/overtime.dart';
import 'package:umgkh_mobile/services/api/hr/overtime/overtime_service.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class OvertimeViewModel with ChangeNotifier {
  TextEditingController searchCtrl = TextEditingController();
  bool _isLoading = false;
  // bool loaded = false;

  List<Overtime> _listData = [];
  List<Overtime> _showedData = [];
  int _year = DateTime.now().year;
  String _selectedState = "all";
  ApiResponse _apiResponse = ApiResponse(statusCode: 0, data: []);

  List<Overtime> get listData => _listData;
  List<Overtime> get showedData => _showedData;
  int get year => _year;
  bool get isLoading => _isLoading;
  String get selectedState => _selectedState;
  ApiResponse get apiResponse => _apiResponse;
  Map<String, String> get optionStates => {
        "all": "All",
        "draft": "Draft",
        "submit": "Submit",
        "approve_dh": "Approved DH",
        "approve_hr": "Approved HR",
        "reject": "Rejected",
        "claim": "Claimed",
      };

  Future<void> setSelectedState(String selectedState) async {
    _selectedState = selectedState;
    notifyListeners();
  }

  Future<void> setYear(int year) async {
    _year = year;
    fetchData();
    notifyListeners();
  }

  Future<void> fetchData() async {
    _isLoading = true;
    final response = await OvertimeAPIService().fetchEmployeeOvertime(_year);
    _apiResponse = response;
    if (response.error == null) {
      _listData = response.data!;
      _showedData = response.data!;
    } else {
      _listData = [];
      _showedData = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> filterState() async {
    try {
      _showedData = _listData.where((e) => e.state == _selectedState).toList();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {}
    }
  }

  onSearchChanged(String text) {
    if (text.isEmpty) {
      _showedData = listData;
      notifyListeners();
      return;
    }
    _showedData = listData
        .where((e) =>
            toSearch(formatDDMMMMYYYY(e.overtimeDate), text) ||
            toSearch(e.employee!.department!.name, text) ||
            toSearch(e.overtimeHours.toString(), text) ||
            toSearch(e.overtimeMinutes.toString(), text) ||
            toSearch(e.approvedOvertimeHours.toString(), text) ||
            toSearch(e.approvedOvertimeMinutes.toString(), text) ||
            toSearch(e.reason, text),)
        .toList();
    notifyListeners();
  }

  bool toSearch(String? source, String text) {
    return source!.toLowerCase().contains(text.toLowerCase(),);
  }
}
