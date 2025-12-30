import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/models/plm/plm_supporting/plm_target/plm_supporting.dart';
import 'package:umgkh_mobile/services/api/plm/plm_supporting/plm_supporting_service.dart';

class MonthlyPlmTargetViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  List<PLMTarget> _listData = [];
  List<PLMTarget> _showedData = [];
  List<PLMTarget> get listData => _listData;
  List<PLMTarget> get showedData => _showedData;
  User selectEmployee = User.defaultUser(id: 0, name: 'Select employee');
  int departmentId = 0;
  String selectedMonth = "01";
  String selectedYear = "2022";
  ApiResponse _apiResponse = ApiResponse(statusCode: 0, data: []);
  ApiResponse get apiResponse => _apiResponse;

  MonthlyPlmTargetViewModel() {
    final now = DateTime.now();
    selectedMonth = now.month.toString().padLeft(2, "0");
    selectedYear = now.year.toString();
  }

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  void onChangeEmployee(dynamic v) => notify(v, (val) {
        selectEmployee = val;
        _applyFilters();
      });

  void setDefaultEmployee(User user, {bool isDh = false}) {
    if (isDh) {
      selectEmployee = User.defaultUser(id: 0, name: "All Employees");
      departmentId = user.department?.id ?? 0;
    } else {
      selectEmployee = user;
    }

    notifyListeners();
  }

  void onChangedMonth(BuildContext context, String v) => notify(v, (val) {
        selectedMonth = val;
        fetchMonthlyPLMTarget();
      });
  void onChangedYear(BuildContext context, String v) => notify(v, (val) {
        selectedYear = val;
        fetchMonthlyPLMTarget();
      });

  Future<void> fetchMonthlyPLMTarget() async {
    _isLoading = true;
    final response = await PLMSupportingAPIService()
        .fetchMonthlyPLMTarget(selectedMonth, selectedYear);
    _apiResponse = response;
    if (response.error != null) {
      _errorMessage = response.error;
      debugPrint("_errorMessage: $_errorMessage");
    } else if (response.data != null) {
      _listData = response.data!;
      _applyFilters();
    }

    _isLoading = false;
    notifyListeners();
  }

  void _applyFilters() {
    _showedData = List.from(_listData);

    // Filter by employee
    if (selectEmployee.id != 0) {
      _showedData =
          _showedData.where((e) => e.employee.id == selectEmployee.id).toList();
    }

    // Filter by year
    if (selectedYear.isNotEmpty) {
      _showedData = _showedData
          .where((e) => e.year.trim() == selectedYear.trim())
          .toList();
    }

    // Filter by month
    if (selectedMonth.isNotEmpty) {
      Map<String, String> monthMap = {
        "january": "01",
        "february": "02",
        "march": "03",
        "april": "04",
        "may": "05",
        "june": "06",
        "july": "07",
        "august": "08",
        "september": "09",
        "october": "10",
        "november": "11",
        "december": "12",
      };

      _showedData = _showedData.where((e) {
        final normalizedMonth = e.month.trim().toLowerCase();
        final monthNum = monthMap[normalizedMonth] ?? "00";
        // debugPrint(
        //     "API month = '${e.month}', normalized = $normalizedMonth, mapped = $monthNum, selected = $selectedMonth");
        return monthNum == selectedMonth;
      }).toList();
    }

    notifyListeners();
  }

  void onClearFilter(User user, {bool isDh = false}) {
    if (isDh) {
      selectEmployee = User.defaultUser(id: 0, name: "All Employees");
      departmentId = user.department?.id ?? 0;
    } else {
      selectEmployee = user;
    }
    final now = DateTime.now();
    selectedMonth = now.month.toString().padLeft(2, "0");
    selectedYear = now.year.toString();
  }
}
