import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/am/small_paper/small_paper.dart';
import 'package:umgkh_mobile/services/api/am/small_paper/small_paper_service.dart';
import 'package:umgkh_mobile/view_models/access_levels_view_model.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart';
import '../models/base/custom_ui/api_response.dart';

class SmallPaperViewModel extends ChangeNotifier {
  bool loaded = false;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  List<SmallPaper> _listData = [];
  List<SmallPaper> _showedData = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<SmallPaper> get listData => _listData;
  List<SmallPaper> get showedData => _showedData;
  String selectedState = "all", selectedPeople = "all";
  ApiResponse _apiResponse = ApiResponse(statusCode: 0, data: []);
  ApiResponse get apiResponse => _apiResponse;
  TextEditingController searchCtrl = TextEditingController();
  String _search = '', _status = 'all', _people = 'all';

  resetData() {
    searchCtrl.clear();
    loaded = false;
    _errorMessage = null;
    _listData = [];
    _showedData = [];
    selectedState = "all";
    selectedPeople = "all";
  }

  Future<void> fetchData(BuildContext context) async {
    resetFilter();
    _isLoading = true;
    final p = Provider.of<AccessLevelViewModel>(context, listen: false);
    final response = await SmallPaperAPIService().fetchData(
      p.hasAmDh(),
    );
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

  Future<SmallPaper?> fetchInfo(int id) async {
    final response = await SmallPaperAPIService().fetchInfo(id);
    _apiResponse = response;

    notifyListeners();
    return response.error == null ? response.data : null;
  }

  Future<Uint8List> fetchImages(
      {required int spId, required int attId, bool isRefresh = false}) async {
    if (isRefresh) notifyListeners();
    final ApiResponse<Uint8List> response =
        await SmallPaperAPIService().fetchImage(spId: spId, attId: attId);
    if (response.error == null) {
      return response.data!;
    } else {
      return Uint8List(0);
    }
  }

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  void onStateChanged(BuildContext context, String v) => notify(v, (val) {
        selectedState = val;
        _status = val;
        onFilter(context);
      });

  void onPeopleChanged(BuildContext context, String v) => notify(v, (val) {
        selectedPeople = val;
        _people = val;
        onFilter(context);
      });

  onSearchChanged(BuildContext context, String text) => notify(text, (val) {
        _search = text;
        onFilter(context);
      });

  void onFilter(BuildContext context) {
    final p = Provider.of<ProfileViewModel>(context, listen: false);
    int id = p.user.id;
    _showedData = _listData.where((item) {
      final matchSearch = toSearch(item.description, _search);
      final matchStatus = _status == 'all' || item.state == _status;
      final matchPeople = _people == 'all'
          ? true
          : _people == 'requestor'
              ? item.requestor.id == id
              : item.approver.id == id;
      return matchSearch && matchStatus && matchPeople;
    }).toList();

    notifyListeners();
  }

  bool toSearch(String? source, String text) {
    return source.toString().toLowerCase().contains(
          text.toLowerCase(),
        );
  }

  resetFilter() {
    searchCtrl.clear();
    selectedState = "all";
    selectedPeople = "all";
    _search = '';
    _status = 'all';
    _people = 'all';
  }
}
