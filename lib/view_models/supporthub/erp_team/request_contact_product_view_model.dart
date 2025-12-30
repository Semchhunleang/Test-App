import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/base/data/static_selection.dart';
import 'package:umgkh_mobile/models/supporthub/erp/erp_ticket.dart';
import 'package:umgkh_mobile/services/api/supporthub/erp_team/erp_team_service.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import '../../../models/base/custom_ui/api_response.dart';

class RequestContactProductViewModel extends ChangeNotifier {
  bool loaded = false;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  List<ERPTicket> _listData = [];
  List<ERPTicket> _showedData = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<ERPTicket> get listData => _listData;
  List<ERPTicket> get showedData => _showedData;
  ApiResponse _apiResponse = ApiResponse(statusCode: 0, data: []);
  ApiResponse get apiResponse => _apiResponse;
  TextEditingController searchCtrl = TextEditingController();
  StaticSelection selectedState = StaticSelection(name: 'All', value: 'all');
  String _search = '', _status = 'all';

  resetData() {
    searchCtrl.clear();
    loaded = false;
    _errorMessage = null;
    _listData = [];
    _showedData = [];
    selectedState = StaticSelection(name: 'All', value: 'all');
  }

  Future<void> fetchData(String type) async {
    resetFilter();
    _isLoading = true;
    final response = await ERPTeamAPIService().fetchAllDataErpTeam(type);
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

  void onStateChanged(dynamic v) => notify(v, (val) {
        selectedState = val;
        _status = selectedState.value;
        onFilter();
      });

  onSearchChanged(BuildContext context, String text) => notify(text, (val) {
        _search = text;
        onFilter();
      });

  void onFilter() {
    _showedData = _listData.where((item) {
      final matchSearch = toSearch(item.description, _search) ||
          toSearch(item.name, _search) ||
          toSearch(item.contact, _search) ||
          toSearch(formatReadableDT(item.createDate), _search);
      final matchStatus = _status == 'all' || item.state == _status;
      return matchSearch && matchStatus;
    }).toList();
    notifyListeners();
  }

  bool toSearch(String? source, String text) =>
      source.toString().toLowerCase().contains(text.toLowerCase());

  resetFilter() {
    searchCtrl.clear();
    selectedState = StaticSelection(name: 'All', value: 'all');
    _search = '';
    _status = 'all';
  }
}
