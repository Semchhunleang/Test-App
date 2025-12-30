import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/cms/tsb/tsb.dart';
import 'package:umgkh_mobile/models/cms/tsb/tsb_line.dart';
import 'package:umgkh_mobile/services/api/cms/tsb/tsb_service.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class TsbViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  ApiResponse _apiResponse = ApiResponse(statusCode: 0, data: []);
  ApiResponse? get apiResponse => _apiResponse;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  List<TSBData> _tsbDataList = [];
  List<TSBData> get tsbDataList => _tsbDataList;
  List<TSBData> _filteredTsbDataList = [];
  List<TSBData> get filteredTsbDataList => _filteredTsbDataList;
  String? _search;
  List<TsbLine> _tsbDataLineList = [];
  List<TsbLine> get tsbDataLineList => _tsbDataLineList;
  final TextEditingController searchController = TextEditingController();

  set search(String? value) {
    _search = value;
    _filterData();
  }

  //Fetch TSB
  Future<void> fetchTsbData() async {
    _setLoading(true);
    final response = await TSBAPIService().fetchTsbData();
    _apiResponse = response;

    if (response.error != null) {
      _handleError(response.error!);
      // _resetData();
    } else if (response.data != null) {
      _tsbDataList = response.data!;
      _filterData();
    }

    _setLoading(false);
  }

  Future<void> fetchTsbLineData(int id) async {
    _setLoading(true);
    final response = await TSBAPIService().fetchTsbLineData(id);
    _apiResponse = response;

    if (response.error != null) {
      _handleError(response.error!);
      // _resetData();
    } else if (response.data != null) {
      _tsbDataLineList = response.data!;
      _filterData();
    }

    _setLoading(false);
  }

  // Filter TSB data based on search text
  void _filterData() {
    if (_search == null || _search!.isEmpty) {
      _filteredTsbDataList = List.from(_tsbDataList);
    } else {
      final searchText = _search!.toLowerCase();
      _filteredTsbDataList = _tsbDataList.where((a4) {
        final nameMatch =
            a4.transactionNo?.toLowerCase().contains(searchText) ?? false;
        final stateMatch =
            a4.state != null && a4.state!.toLowerCase().contains(searchText);
        final date = a4.date != null ? formatDDMMMMYYYY(a4.date!) : "";
        final manufacturer =
            a4.manufacturer?.name?.toLowerCase().contains(searchText) ?? false;
        final dateSearch = date.toLowerCase().contains(searchText);
        return nameMatch || stateMatch || dateSearch || manufacturer;
      }).toList();
    }
    notifyListeners();
  }

  void clearSearch() {
    searchController.clear();
    search = "";
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _handleError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
}
