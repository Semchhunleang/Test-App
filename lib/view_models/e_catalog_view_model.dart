import 'package:flutter/foundation.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/e-catalog/website_category/website_category.dart';
import 'package:umgkh_mobile/services/api/e-catalog/website_category/website_category_service.dart';

class ECatalogViewModel extends ChangeNotifier {
  List<WebsiteCategory> _websiteCategories = [];
  List<List<WebsiteCategory>> _prevWebsiteCategories = [];
  List<WebsiteCategory> _filteredWebsiteCategories = [];
  bool _isLoading = false;
  String _search = '';
  ApiResponse _apiResponse = ApiResponse(statusCode: 0, data: []);

  List<WebsiteCategory> get categories => _websiteCategories;
  List<List<WebsiteCategory>> get prevWebsiteCategories =>
      _prevWebsiteCategories;
  List<WebsiteCategory> get filteredWebsiteCategories =>
      _filteredWebsiteCategories;
  bool get isLoading => _isLoading;
  String get search => _search;
  ApiResponse get apiResponse => _apiResponse;

  resetData() async {
    await setSearch('');
  }

  Future<void> setSearch(String search) async {
    _search = search;
    await fetchWebsiteCategories();
  }

  Future<void> setPrev() async {
    _isLoading = true;
    _prevWebsiteCategories = [];
    notifyListeners();
    final categories = _filteredWebsiteCategories;
    // _websiteCategories = categories;
    _prevWebsiteCategories.add(
      categories.where((category) {
        return category.name.toLowerCase().contains(
                  _search.toLowerCase(),
                )
            // &&
            //     category.totalCountProduct > 0
            ;
      }).toList(),
    );
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setFilteredFromPrev() async {
    _isLoading = true;
    notifyListeners();
    if (_prevWebsiteCategories.isNotEmpty &&
        _prevWebsiteCategories.last.isNotEmpty) {
      final categories = _prevWebsiteCategories.last;
      _prevWebsiteCategories.removeLast();
      _filteredWebsiteCategories = categories.where((category) {
        return category.name.toLowerCase().contains(
                  _search.toLowerCase(),
                )
            // &&
            //     category.totalCountProduct > 0
            ;
      }).toList();
    } else {
      _filteredWebsiteCategories = [];
      fetchWebsiteCategories();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setFiltered(List<WebsiteCategory> data) async {
    _isLoading = true;
    notifyListeners();
    final categories = data;
    // _websiteCategories = categories;
    _filteredWebsiteCategories = categories.where((category) {
      return category.name.toLowerCase().contains(
                _search.toLowerCase(),
              )
          // &&
          //     category.totalCountProduct > 0
          ;
    }).toList();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchWebsiteCategories() async {
    _isLoading = true;
    notifyListeners();
    final response = await WebsiteCategoryAPIService().fetchWebsiteCategory();
    _apiResponse = response;
    if (response.statusCode == 200 || response.statusCode == 201) {
      final categories = response.data!;
      _websiteCategories = [
        // WebsiteCategory(
        //   id: 0,
        //   name: 'All',
        //   completeName: 'All',
        //   parentPath: 'All',
        //   sequence: 0,
        //   countProduct: 1,
        //   totalCountProduct: 1,
        // ),
        ...categories // Spread operator to add the rest of the categories
      ];
      if (_filteredWebsiteCategories.isEmpty) {
        _filteredWebsiteCategories = _websiteCategories.where((category) {
          return category.name.toLowerCase().contains(
                    _search.toLowerCase(),
                  )
              // &&
              //     category.totalCountProduct > 0
              ;
        }).toList();
      }
    } else {
      _websiteCategories = [];
      _filteredWebsiteCategories = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  void filterCategories(String query) {
    if (query.isEmpty) {
      _filteredWebsiteCategories = _websiteCategories;
    } else {
      _filteredWebsiteCategories = _websiteCategories
          .where(
            (category) => category.name.toLowerCase().contains(
                  query.toLowerCase(),
                ),
          )
          .toList();
    }
    notifyListeners();
  }

  void filterSubCategories(String query) {
    if (query.isEmpty) {
      _filteredWebsiteCategories = _websiteCategories;
    } else {
      _filteredWebsiteCategories = _websiteCategories
          .where(
            (category) => category.name.toLowerCase().contains(
                  query.toLowerCase(),
                ),
          )
          .toList();
    }
    notifyListeners();
  }

  Future<void> setWebsiteCategories(List<WebsiteCategory> data) async {
    _isLoading = true;
    notifyListeners();
    _websiteCategories = data;
    _filteredWebsiteCategories = data.where((category) {
      return category.name.toLowerCase().contains(_search.toLowerCase())
          // &&
          //     category.totalCountProduct > 0
          ;
    }).toList();
    _isLoading = false;
    notifyListeners();
  }
}
