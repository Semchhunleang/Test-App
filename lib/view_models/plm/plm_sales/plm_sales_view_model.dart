import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/plm/plm_sales/plm_sales.dart';
import 'package:umgkh_mobile/services/api/plm/plm_service.dart';

class PLMSalesViewModel extends ChangeNotifier {
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  List<PLMSales> _listData = [];
  List<PLMSales> _showedData = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<PLMSales> get listData => _listData;
  List<PLMSales> get showedData => _showedData;
  ApiResponse _apiResponse = ApiResponse(statusCode: 0, data: []);
  ApiResponse get apiResponse => _apiResponse;
  TextEditingController searchCtrl = TextEditingController();
  String _search = '';

  resetData() {
    searchCtrl.clear();
    _errorMessage = null;
    _listData = [];
    _showedData = [];
  }

  resetFilter() {
    searchCtrl.clear();
    _search = '';
  }

  Future<void> fetchData() async {
    resetFilter();
    _isLoading = true;
    final response = await PLMAPIService().fetchPLMSales();
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
  }

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  onSearchChanged(BuildContext context, String text) => notify(text, (val) {
        _search = text;
        onFilter();
      });

  void onFilter() {
    _showedData = _listData.where((item) {
      final matchSearch = toSearch(item.sales.name, _search) ||
          toSearch(item.sales.jobTitle, _search) ||
          toSearch(item.year, _search) ||
          toSearch(item.month, _search);
      return matchSearch;
    }).toList();
    notifyListeners();
  }

  bool toSearch(String? source, String text) {
    return source.toString().toLowerCase().contains(text.toLowerCase());
  }
}
