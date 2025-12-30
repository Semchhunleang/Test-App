import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/crm/stage/crm_stages.dart';
import 'package:umgkh_mobile/services/api/crm/opportunity/opportunity_service.dart';

import '../models/base/custom_ui/api_response.dart';
import '../models/crm/opportunity/opportunity.dart';

class OpportunityViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  List<Opportunity> _getOpportunityList = [];
  List<Opportunity> get getOpportunityList => _getOpportunityList;
  List<Opportunity> _filterOpportunity = [];
  List<Opportunity> get filterOpportunity => _filterOpportunity;
  ApiResponse _apiResponse = ApiResponse(statusCode: 0, data: []);
  ApiResponse get apiResponse => _apiResponse;

  CrmStages selectedStage = CrmStages(name: 'All', id: 0);
  final TextEditingController searchController = TextEditingController();
  String? _search;
  String? get search => _search;

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  set search(String? value) {
    _search = value;
    _filterData();
  }

  onChangeStage(dynamic v) {
    notify(v, (val) => selectedStage = val);
    _filterData();
  }

  Future<void> fetchOpportunity(String serviceType) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await OpportunityService().fetchOpportunity(serviceType);
    _apiResponse = response;

    if (response.error != null) {
      _errorMessage = response.error;
    } else if (response.data != null) {
      _getOpportunityList = response.data!;
      _filterData();
    }

    _isLoading = false;
    notifyListeners();
  }

  void _filterData() {
    List<Opportunity> filtered = _getOpportunityList;
    final searchText = _search?.toLowerCase() ?? '';

    // Filter by search text across multiple fields
    if (searchText.isNotEmpty) {
      filtered = filtered.where((opportunity) {
        final stageMatch = opportunity.name != null &&
            opportunity.stage!.name!.toLowerCase().contains(searchText);
        final nameMatch = opportunity.name != null &&
            opportunity.name!.toLowerCase().contains(searchText);
        final contactNameMatch = opportunity.name != null &&
            opportunity.contactName!.toLowerCase().contains(searchText);

        return nameMatch || stageMatch || contactNameMatch;
      }).toList();
    }

    // Filter by selected stage
    if (selectedStage.id != 0) {
      filtered = filtered.where((opportunity) {
        return opportunity.stage != null &&
            opportunity.stage!.name == selectedStage.name;
      }).toList();
    }

    _filterOpportunity = filtered;
    notifyListeners();
  }

  onClearDataRefresh(BuildContext context) {
    FocusScope.of(context).unfocus();
    searchController.clear();
    search = "";
    selectedStage = CrmStages(name: 'All', id: 0);
    _filterData();
    notifyListeners();
  }
}
