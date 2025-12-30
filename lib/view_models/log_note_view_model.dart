import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/log_note/log_note.dart';
import 'package:umgkh_mobile/services/api/log_note/log_note_service.dart';

class LogNoteViewModel extends ChangeNotifier {
  bool loaded = false;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  List<LogNote> _showedData = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<LogNote> get showedData => _showedData;
  ApiResponse _apiResponse = ApiResponse(statusCode: 0, data: []);
  ApiResponse get apiResponse => _apiResponse;

  resetData() {
    loaded = false;
    _errorMessage = null;
    _showedData = [];
  }

  Future<void> fetchData(int resId, String model) async {
    _isLoading = true;
    resetData();
    final response = await LogNoteAPIService().fetchData(resId, model);
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

  Future<void> insertToList(
      BuildContext context, int resId, String model) async {
    final response = await LogNoteAPIService().fetchData(resId, model);
    if (response.error != null) {
      debugPrint("_errorMessage: ${response.error}");
    } else if (response.data != null) {
      if (context.mounted) {
        LogNote data = response.data!.first;
        _showedData.insert(0, data);
        notifyListeners();
      }
    }
  }

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }
}
