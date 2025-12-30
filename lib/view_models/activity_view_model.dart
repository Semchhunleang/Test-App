import 'package:flutter/foundation.dart';
import 'package:umgkh_mobile/models/crm/activity/activity.dart';
import 'package:umgkh_mobile/services/api/base/activity/activity_service.dart';
import '../models/base/custom_ui/api_response.dart';

class ActivityViewModel extends ChangeNotifier {
  bool loaded = false;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  List<Activity> _showedSchedule = [];
  List<Activity> get showSchedule => _showedSchedule;
  List<Activity> _showActivity = [];
  List<Activity> get showActivity => _showActivity;
  ApiResponse _apiResponse = ApiResponse(statusCode: 0, data: []);
  ApiResponse get apiResponse => _apiResponse;

  Future<void> fetchSchedule(int id) async {
    _showedSchedule = [];
    _isLoading = true;
    _errorMessage = null;
    final response = await ActivityAPIService().fetchSchedule(id);
    _apiResponse = response;
    if (response.error != null) {
      _errorMessage = response.error;
      debugPrint("_errorMessage: $_errorMessage");
    } else if (response.data != null) {
      _showedSchedule = response.data!;
      loaded = true;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchActivity(int id) async {
    _showActivity = [];
    _isLoading = true;
    _errorMessage = null;
    final response = await ActivityAPIService().fetchActivity(id);
    _apiResponse = response;
    if (response.error != null) {
      _errorMessage = response.error;
      debugPrint("_errorMessage: $_errorMessage");
    } else if (response.data != null) {
      _showActivity = response.data!;
      loaded = true;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchActivityOrSchedule(bool isSchedule) async {
    _showActivity = [];
    _isLoading = true;
    _errorMessage = null;
    final response =
        await ActivityAPIService().fetchActivityOrSchedule(isSchedule);
    _apiResponse = response;
    if (response.error != null) {
      _errorMessage = response.error;
      debugPrint("_errorMessage: $_errorMessage");
    } else if (response.data != null) {
      _showActivity = response.data!;
      loaded = true;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<Uint8List> fetchImage(
      {required int leadId, required int attId, bool isRefresh = false}) async {
    if (isRefresh) notifyListeners();
    final ApiResponse<Uint8List> response =
        await ActivityAPIService().fetchImage(leadId: leadId, attId: attId);
    if (response.error == null) {
      return response.data!;
    } else {
      return Uint8List(0);
    }
  }
}
