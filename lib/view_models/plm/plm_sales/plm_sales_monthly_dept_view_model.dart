import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/plm/plm_sales/monthly_dept_plm_sales.dart';
import 'package:umgkh_mobile/services/api/plm/plm_service.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class PLMSalesMonthlyDeptViewModel extends ChangeNotifier {
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  List<MonthlyDepartmentPLMSales> _listData = [];
  List<MonthlyDepartmentPLMSales> _showedData = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<MonthlyDepartmentPLMSales> get listData => _listData;
  List<MonthlyDepartmentPLMSales> get showedData => _showedData;
  ApiResponse _apiResponse = ApiResponse(statusCode: 0, data: []);
  ApiResponse get apiResponse => _apiResponse;
  TextEditingController searchCtrl = TextEditingController();
  String _search = '';
  String year = '${DateTime.now().year}';
  String month = DateTime.now().month.toString();

  resetData() {
    searchCtrl.clear();
    _errorMessage = null;
    _listData = [];
    _showedData = [];
  }

  resetFilter() {
    searchCtrl.clear();
    _search = '';
    year = '${DateTime.now().year}';
    month = DateTime.now().month.toString();
  }

  Future<void> fetchData() async {
    resetFilter();
    _isLoading = true;
    try {
      final response = await PLMAPIService().fetcMonthlyDepartmenthPLMSales();
      _apiResponse = response;
      if (response.error != null) {
        _errorMessage = response.error;
        debugPrint("_errorMessage: $_errorMessage");
      } else if (response.data != null) {
        _listData = response.data!;
        _showedData = response.data!;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('error fetching: ${e.toString()}');
    } finally {
      onFilter();
    }
  }

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  onSearchChanged(String text) => notify(text, (val) {
        _search = text;
        onFilter();
      });
  onYearChanged(String text) => notify(text, (val) {
        year = text;
        onFilter();
      });
  onMonthChanged(String text) => notify(text, (val) {
        month = text;
        onFilter();
      });

  void onFilter() {
    _showedData = _listData.where((item) {
      // SEARCH
      final matchSearch = [
        item.department.name,
        item.year,
        item.month,
        item.score.toString(),
      ].any((field) => toSearch(field, _search));

      // YEAR
      final matchYear = year == "00" ? true : item.year == year;

      // MONTH
      final matchMonth = month == "00"
          ? true
          : item.month == formatMonthName(int.parse(month));

      return matchSearch && matchYear && matchMonth;
    }).toList();

    notifyListeners();
  }

  bool toSearch(String? source, String text) {
    return source.toString().toLowerCase().contains(text.toLowerCase());
  }
}
