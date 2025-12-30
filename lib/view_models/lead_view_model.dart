import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/crm/lead/lead.dart';
import 'package:umgkh_mobile/services/api/crm/lead/lead_service.dart';

import '../models/base/custom_ui/api_response.dart';

class LeadViewModel extends ChangeNotifier {
  bool loaded = false;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  TextEditingController searchCtrl = TextEditingController();
  List<Lead> _listData = [];
  List<Lead> _showedData = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<Lead> get listData => _listData;
  List<Lead> get showedData => _showedData;

  ApiResponse _apiResponse = ApiResponse(statusCode: 0, data: []);
  ApiResponse get apiResponse => _apiResponse;

  resetData() {
    loaded = false;
    _errorMessage = null;
    _listData = [];
    _showedData = [];
    searchCtrl.clear();
  }

  Future<void> fetchData(bool isLeadUnit) async {
    _isLoading = true;

    final response = await LeadAPIService().fetchLead(isLeadUnit);
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

  onSearchChanged(String text) {
    if (text.isEmpty) {
      _showedData = listData;
      notifyListeners();
      return;
    }
    _showedData = listData.where((e) => toSearch(e.name, text),).toList();
    notifyListeners();
  }

  bool toSearch(String? source, String text) {
    return source!.toLowerCase().contains(text.toLowerCase(),);
  }
}
