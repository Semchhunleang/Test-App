import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/am/schedule_truck_driver/schedule_truck_driver.dart';
import 'package:umgkh_mobile/models/base/data/static_selection.dart';
import 'package:umgkh_mobile/services/api/am/schedule_truck_driver/schedule_truck_driver_service.dart';
import '../models/base/custom_ui/api_response.dart';

class ScheduleTruckDriverViewModel extends ChangeNotifier {
  bool loaded = false;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  List<ScheduleTruckDriver> _listData = [];
  List<ScheduleTruckDriver> _showedData = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<ScheduleTruckDriver> get listData => _listData;
  List<ScheduleTruckDriver> get showedData => _showedData;
  StaticSelection selectedState = StaticSelection(name: 'All', value: 'all');
  StaticSelection selectedTag = StaticSelection(name: 'All', value: 'all');
  ApiResponse _apiResponse = ApiResponse(statusCode: 0, data: []);
  ApiResponse get apiResponse => _apiResponse;
  TextEditingController searchCtrl = TextEditingController();
  String _search = '', _state = 'all', _tag = 'all';

  resetData() {
    searchCtrl.clear();
    loaded = false;
    _errorMessage = null;
    _listData = [];
    _showedData = [];
    selectedState = StaticSelection(name: 'All', value: 'all');
    selectedTag = StaticSelection(name: 'All', value: 'all');
  }

  Future<void> fetchData() async {
    resetFilter();
    _isLoading = true;

    final response = await ScheduleTruckDriverAPIService().fetchData();
    _apiResponse = response;
    if (response.error != null) {
      _errorMessage = response.error;
      debugPrint("_errorMessage: $_errorMessage");
    } else if (response.data != null) {
      _listData = response.data!;
      _showedData = response.data!;
      loaded = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  void onStateChanged(StaticSelection v) => notify(v, (val) {
        selectedState = val;
        _state = val.value;
        onFilter();
      });

  void onTagChanged(StaticSelection v) => notify(v, (val) {
        selectedTag = val;
        _tag = val.value;
        onFilter();
      });

  onSearchChanged(String text) => notify(text, (val) {
        _search = text;
        onFilter();
      });

  void onFilter() {
    _showedData = _listData.where((item) {
      final matchSearch = toSearch(item.name, _search) ||
          toSearch(item.driver?.name, _search) ||
          toSearch(item.requestor.name, _search) ||
          toSearch(item.requestor.department?.name, _search);
      final matchState = _state == 'all' || item.state == _state;
      final matchTag = _tag == 'all' || item.tag == _tag;
      return matchSearch && matchState && matchTag;
    }).toList();
    notifyListeners();
  }

  bool toSearch(String? source, String text) {
    return source.toString().toLowerCase().contains(text.toLowerCase());
  }

  resetFilter() {
    searchCtrl.clear();
    selectedState = selectedTag = StaticSelection(name: 'All', value: 'all');
    _search = '';
    _state = _tag = 'all';
  }
}
