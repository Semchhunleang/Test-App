import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/notification/notification.dart';
import 'package:umgkh_mobile/services/api/notification/notification_service.dart';
import '../models/base/custom_ui/api_response.dart';

class NotificationViewModel extends ChangeNotifier {
  bool loaded = false;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  List<NotificationList> _showedData = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<NotificationList> get showedData => _showedData;
  ApiResponse _apiResponse = ApiResponse(statusCode: 0, data: []);
  ApiResponse get apiResponse => _apiResponse;

  resetData() {
    loaded = false;
    _errorMessage = null;
    _showedData.clear();
  }

  Future<void> fetchData() async {
    _isLoading = true;
    final response = await NotificationAPIService().fetchData();
    _apiResponse = response;
    if (response.error != null) {
      _errorMessage = response.error;
      debugPrint("_errorMessage: $_errorMessage");
    } else if (response.data != null) {
      _showedData = response.data!;
      loaded = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateIsRead(BuildContext context, int id) async {
    Map<String, dynamic> data = {'id': id};
    try {
      await NotificationAPIService().updateIsRead(data).then((value) {
        if (context.mounted) fetchData();
      });
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> updateAllIsRead(BuildContext context) async {
    try {
      await NotificationAPIService().updateAllIsRead().then((value) {
        if (context.mounted) fetchData();
        debugPrint('update read all=========== ${value.message}');
      });
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> updateArchiveById(BuildContext context, int id) async {
    Map<String, dynamic> data = {'id': id};
    try {
      await NotificationAPIService().updateArchiveById(data).then((value) {
        if (context.mounted) fetchData();
        debugPrint('update ACTIVI BY $id=========== ${value.message}');
      });
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> updateArchiveAll(BuildContext context) async {
    try {
      await NotificationAPIService().updateArchiveAll().then((value) {
        if (context.mounted) fetchData();
        debugPrint('update ACTIVE=========== ${value.message}');
      });
    } catch (e) {
      debugPrint('$e');
    }
  }

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  int badgeCount() => _showedData.where((item) => !item.isRead).length;
}
