import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/base/custom_ui/menu_item.dart';
import 'package:umgkh_mobile/services/api/other/util_service.dart';
import 'package:umgkh_mobile/services/local_storage/models/menu_item_local_storage_service.dart';
import 'package:umgkh_mobile/utils/static_state.dart';

class HomeViewModel extends ChangeNotifier {
  final MenuItemLocalStorageService _menuHomeLocalStorageService =
      MenuItemLocalStorageService();
  final UtilAPIService _utilService = UtilAPIService();
  List<String>? _strImages = [];
  List<MenuItem> _menuItems = [];
  bool _isLoading = false, _isLoadMenu = false;
  String menuUiType = grid;
  TextEditingController searchCtrl = TextEditingController();
  List<String>? get strImages => _strImages;
  List<MenuItem> get menuItems => _menuItems;
  List<MenuItem> storeMenuItems = [];
  bool get isLoading => _isLoading;
  bool get isLoadMenu => _isLoadMenu;
  String _search = '';

  Future<void> getCarousel() async {
    try {
      _isLoading = true;
      notifyListeners();

      _strImages = await _utilService.getCarousel();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMenuItems() async {
    try {
      final items = await _menuHomeLocalStorageService.getMenuItems();
      _menuItems = items
          .map(
            (item) => MenuItem(
                id: item['id'],
                label: item['label'],
                position: item['position'],
                iconName: item['icon'],
                routeName: item['route'],
                description: item['description']),
          )
          .toList();
      notifyListeners();
      storeMenuItems = _menuItems;
    } catch (e) {
      // Handle any errors, e.g., logging or showing an error message
      debugPrint('Error loading menu items: $e');
    }
  }

  void updateMenuItemPosition(int id, int newPosition) {
    final index = menuItems.indexWhere((element) => element.id == id);
    if (index != -1) {
      final item = menuItems.removeAt(index);
      menuItems.insert(newPosition, item);
      _menuHomeLocalStorageService.updateMenuItemPosition(id, newPosition);
      notifyListeners();
    }
  }

  Future<void> getLocalMenuType() async {
    _isLoadMenu = false;
    try {
      final items = await _menuHomeLocalStorageService.getMenuUiType();
      menuUiType = items ?? grid;
      _isLoadMenu = true;
      notifyListeners();
    } catch (e) {
      _isLoadMenu = false;
    }
  }

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  onChangedMenuTypeList() {
    menuUiType = list;
    _menuHomeLocalStorageService.saveMenuUiType(menuUiType);
    notifyListeners();
  }

  onChangedMenuTypeGrid() {
    menuUiType = grid;
    _menuHomeLocalStorageService.saveMenuUiType(menuUiType);
    notifyListeners();
  }

  onSearchChanged(String text) => notify(text, (val) {
        _search = text;
        onFilter();
      });

  onRemoveSearch() => notify(null, (v) {
        searchCtrl.clear();
        _search = '';
        onFilter();
      });

  onFilter() {
    _menuItems = storeMenuItems.where((item) {
      return toSearch(item.label, _search);
    }).toList();
    notifyListeners();
  }

  bool toSearch(String? source, String text) {
    return source.toString().toLowerCase().contains(
          text.toLowerCase(),
        );
  }
}
