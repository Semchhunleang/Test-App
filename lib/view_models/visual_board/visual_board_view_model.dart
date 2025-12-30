import 'package:flutter/material.dart';
import 'package:flutter_boardview/boardview_controller.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/models/visual_board/stage.dart';
import 'package:umgkh_mobile/models/visual_board/visual_board.dart';
import 'package:umgkh_mobile/services/api/visual_board/visual_board_service.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart';

class VisualBoardViewModel extends ChangeNotifier {
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  List<VisualBoard> _listData = [];
  List<VisualBoard> _showedData = [];
  List<VisualBoardStage> _listStage = [];
  bool _isLoading = false, _isShowSearch = true, _isKanban = true;
  bool get isLoading => _isLoading;
  bool get isShowSearch => _isShowSearch;
  bool get isKanban => _isKanban;
  List<VisualBoard> get listData => _listData;
  List<VisualBoard> get showedData => _showedData;
  List<VisualBoardStage> get listStage => _listStage;
  ApiResponse _apiResponse = ApiResponse(statusCode: 0, data: []);
  ApiResponse get apiResponse => _apiResponse;
  TextEditingController searchCtrl = TextEditingController();
  BoardViewController boardCtrl = BoardViewController();
  String _search = '';
  List<User> selectUser = [];

  resetData() {
    searchCtrl.clear();
    boardCtrl = BoardViewController();
    _errorMessage = null;
    _listData = [];
    _showedData = [];
    selectUser = [];
  }

  resetFilter() {
    searchCtrl.clear();
    _search = '';
    selectUser = [];
  }

  void updateShowedData(List<VisualBoard> newData) {
    _showedData = newData;
    notifyListeners();
  }

  Future<void> fetchData({bool isRefresh = true}) async {
    resetFilter();
    _isLoading = true;
    if (isRefresh) notifyListeners();
    final response = await VisualBoardAPIService().fetchVisualBoardByDept();
    _apiResponse = response;
    if (response.error != null) {
      _errorMessage = response.error;
      debugPrint("_errorMessage: $_errorMessage");
    } else if (response.data != null) {
      _listData = response.data!;
      _showedData = response.data!;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> reFetchDataAfterChanged() async {
    final response = await VisualBoardAPIService().fetchVisualBoardByDept();
    _apiResponse = response;
    if (response.error != null) {
      _errorMessage = response.error;
      debugPrint("_errorMessage: $_errorMessage");
    } else if (response.data != null) {
      _listData = response.data!;
      _showedData = response.data!;
    }
    _applyFilters();
    notifyListeners();
  }

  Future<void> fetchStage() async {
    final response = await VisualBoardAPIService().fetchVisualBoardStage();
    _apiResponse = response;
    if (response.error != null) {
      debugPrint("_errorMessage: $_errorMessage");
    } else if (response.data != null) {
      _listStage = response.data!;
    }
    notifyListeners();
  }

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  onSearchChanged(String text) => notify(text, (val) {
        _search = text;
        _applyFilters();
      });

  onChangedUser(dynamic v) => notify(v, (val) {
        selectUser = val;
        _applyFilters();
      });

  onRemovedUser(User v) => notify(v, (val) {
        selectUser = List.from(selectUser)..remove(v);
        _applyFilters();
      });

  _applyFilters() {
    _showedData = _listData.where((item) {
      // search filter
      final matchesSearch = _search.isEmpty ||
          toSearch(item.name, _search) ||
          toSearch(item.stage.name, _search) ||
          item.assignees.any((a) => toSearch(a.name, _search)) ||
          item.requestors.any((r) => toSearch(r.name, _search));

      // user filter
      final matchesUser = selectUser.isEmpty ||
          item.assignees.any((a) => selectUser.any((s) => s.id == a.id));

      // both must match
      return matchesSearch && matchesUser;
    }).toList();
    notifyListeners();
  }

  defaultFilter(BuildContext context) {
    final vm = Provider.of<ProfileViewModel>(context, listen: false);
    onChangedUser([vm.user]);
  }

  onKanbanView() => notify(null, (_) => _isKanban = !_isKanban);
  onHidingSearch() => notify(null, (_) => _isShowSearch = !_isShowSearch);
  resetBool() => _isShowSearch = _isKanban = true;
  bool toSearch(String? source, String text) {
    return source.toString().toLowerCase().contains(text.toLowerCase());
  }
}
