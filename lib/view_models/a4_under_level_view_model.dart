import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import '../models/cms/a4/a4.dart';
import '../services/api/cms/a4/a4_under_level_service.dart';

class A4UnderLevelViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool _isImageLoading = false;
  String? _errorMessage;
  List<A4Data> _a4DataList = [];
  List<A4Data> _filteredA4DataList = [];
  Uint8List _beforeImage = Uint8List(0);
  Uint8List _afterImage = Uint8List(0);
  String? _search;
  ApiResponse _apiResponse = ApiResponse(statusCode: 0, data: []);

  final TextEditingController searchController = TextEditingController();

  bool get isLoading => _isLoading;
  bool get isImageLoading => _isImageLoading;
  String? get errorMessage => _errorMessage;
  List<A4Data> get a4DataList => _a4DataList;
  List<A4Data> get filteredA4DataList => _filteredA4DataList;
  Uint8List get beforeImage => _beforeImage;
  Uint8List get afterImage => _afterImage;
  String? get search => _search;
  ApiResponse? get apiResponse => _apiResponse;

  // Set search value and filter data
  set search(String? value) {
    _search = value;
    _filterData();
  }

  // Fetch A4 data
  Future<void> fetchA4Data() async {
    _setLoading(true);
    final response = await A4UnderLevelAPIService().fetchA4Data();
    _apiResponse = response;

    if (response.error != null) {
      _handleError(response.error!);
      _resetData();
    } else if (response.data != null) {
      _a4DataList = response.data!;
      _filterData();
    }

    _setLoading(false);
  }

  // Filter A4 data based on search text
  void _filterData() {
    if (_search == null || _search!.isEmpty) {
      _filteredA4DataList = List.from(_a4DataList);
    } else {
      final searchText = _search!.toLowerCase();
      _filteredA4DataList = _a4DataList.where((a4) {
        final nameMatch = a4.name?.toLowerCase().contains(searchText) ?? false;
        final stateMatch =
            a4.state != null && a4.state!.toLowerCase().contains(searchText);
        final startDate =
            a4.startPeriod != null ? formatDDMMMMYYYY(a4.startPeriod!) : "";
        final endDate =
            a4.endPeriod != null ? formatDDMMMMYYYY(a4.endPeriod!) : "";
        final startEndDate =
            "$startDate to $endDate".toLowerCase().contains(searchText);
        return nameMatch || stateMatch || startEndDate;
      }).toList();
    }
    notifyListeners();
  }

  // Fetch images for A4
  Future<void> fetchImageA4(int a4Id, String resField) async {
    _setImageLoading(true);
    final response = await A4UnderLevelAPIService().getImageA4(a4Id, resField);
    if (response.error != null) {
      _handleError(response.error!);
      if (resField == "before_improv") {
        _beforeImage = Uint8List(0);
      } else {
        _afterImage = Uint8List(0);
      }
    } else if (response.data != null) {
      if (resField == "before_improv") {
        _beforeImage = response.data!;
      } else {
        _afterImage = response.data!;
      }
    }

    _setImageLoading(false);
  }

  // Reset the data
  void _resetData() {
    _a4DataList = [];
    _filteredA4DataList = [];
    _beforeImage = Uint8List(0);
    _afterImage = Uint8List(0);
    _search = null;
    notifyListeners();
  }

  void reseForm() {
    searchController.clear();
    search = "";
  }

  // Handle error messages
  void _handleError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Set the loading state for fetching data
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set the loading state for fetching images
  void _setImageLoading(bool loading) {
    _isImageLoading = loading;
    notifyListeners();
  }
}
