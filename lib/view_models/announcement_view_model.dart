// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/announcement/announcement.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/services/api/annoucmenet/announcement_service.dart';

class AnnouncementViewModel extends ChangeNotifier {
  bool _isLoading = false;
  List<Announcement> _listData = [];
  List<Announcement> _showedData = [];
  TextEditingController searchCtrl = TextEditingController();
  ApiResponse _apiResponse = ApiResponse(statusCode: 0, data: []);

  bool get isLoading => _isLoading;
  List<Announcement> get listData => _listData;
  List<Announcement> get showedData => _showedData;
  ApiResponse get apiResponse => _apiResponse;

  resetData()async {
    _listData = [];
    _showedData = [];
    searchCtrl = TextEditingController();
    notifyListeners();
  }

  Future<void> fetchData() async {
    _isLoading = true;
    resetData();
    final response = await AnnouncementAPIService().fetchData();
    _apiResponse = response;
    if (response.data != null) {
      _listData = response.data!;
      _showedData = response.data!;
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
