import 'package:flutter/foundation.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/e-catalog/product/product.dart';
import 'package:umgkh_mobile/models/e-catalog/website_category/website_category.dart';
import 'package:umgkh_mobile/services/api/e-catalog/product/product_service.dart';

class ProductPageViewModel extends ChangeNotifier {
  int _categId = 0;
  WebsiteCategory _selectedCategory = WebsiteCategory(
      id: 0,
      name: "All",
      completeName: "All",
      parentPath: "All",
      sequence: 0,
      countProduct: 1,
      totalCountProduct: 1);
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  // String _search = '';
  ApiResponse _apiResponse = ApiResponse(statusCode: 0, data: []);

  int get categId => _categId;
  WebsiteCategory get selectedCategory => _selectedCategory;
  List<Product> get products => _products;
  List<Product> get filteredProducts => _filteredProducts;
  bool get isLoading => _isLoading;
  // String get search => _search;
  ApiResponse get apiResponse => _apiResponse;
  String currentSearchText = '';

  setSelectedCategory(WebsiteCategory data) {
    _selectedCategory = data;
    _categId = data.id;
    fetchWebsiteCategories();
    notifyListeners();
  }

  void filterCategories(String searchText) {
    currentSearchText = searchText;
    final lowerQuery = searchText.toLowerCase();
    final selectedCat = selectedCategory;

    debugPrint('Filtering: query="$lowerQuery", category=${selectedCat.id}');

    _filteredProducts = _products.where((product) {
      final matchesSearch = product.name.toLowerCase().contains(lowerQuery);
      final matchesCategory =
          selectedCat.id == 0 || product.category?.id == selectedCat.id;

      debugPrint(
          'Product "${product.name}": matchesSearch=$matchesSearch, matchesCategory=$matchesCategory');

      return matchesSearch && matchesCategory;
    }).toList();

    notifyListeners();
  }

  // void filterCategories(String query) {
  //   if (query.isEmpty) {
  //     _filteredProducts = _products;
  //   } else {
  //     _filteredProducts = _products
  //         .where(
  //           (category) =>
  //               category.name.toLowerCase().contains(
  //                     query.toLowerCase(),
  //                   ) ||
  //               category.textDesc!.toLowerCase().contains(
  //                     query.toLowerCase(),
  //                   ),
  //         )
  //         .toList();
  //   }
  //   notifyListeners();
  // }

  // resetData() async {
  //   await setSearch('');
  // }

  // Future<void> setSearch(String search) async {
  //   _search = search;
  //   await fetchWebsiteCategories();
  // }

  // Future<void> setPrev() async {
  //   _isLoading = true;
  //   notifyListeners();
  //   final products = _filteredProducts;
  //   // _products = products;
  //   _prevWebsiteCategories.add(products.where((category) {
  //     return category.name.toLowerCase().contains(_search.toLowerCase(),) &&
  //         category.totalCountProduct > 0;
  //   }).toList(),);
  //   _isLoading = false;
  //   notifyListeners();
  // }

  // Future<void> setFilteredFromPrev() async {
  //   _isLoading = true;
  //   notifyListeners();
  //   if (_prevWebsiteCategories.isNotEmpty && _prevWebsiteCategories.last.isNotEmpty) {
  //     final products = _prevWebsiteCategories.last;
  //     _prevWebsiteCategories.removeLast();
  //     _filteredProducts = products.where((category) {
  //       return category.name.toLowerCase().contains(_search.toLowerCase(),) &&
  //           category.totalCountProduct > 0;
  //     }).toList();
  //   }else{
  //     fetchWebsiteCategories();
  //   }
  //   _isLoading = false;
  //   notifyListeners();
  // }

  // Future<void> setFiltered(List<Product> data) async {
  //   _isLoading = true;
  //   notifyListeners();
  //   final products = data;
  //   // _products = products;
  //   _filteredProducts = products.where((category) {
  //     return category.name.toLowerCase().contains(_search.toLowerCase(),) &&
  //         category.totalCountProduct > 0;
  //   }).toList();
  //   _isLoading = false;
  //   notifyListeners();
  // }

  setCategId(int id) {
    _categId = id;
    notifyListeners();
  }

  Future<void> fetchWebsiteCategories() async {
    _isLoading = true;
    notifyListeners();
    final response = await ProductAPIService().fetchProductByCategory(categId);
    _apiResponse = response;
    if (response.statusCode == 200 || response.statusCode == 201) {
      final products = response.data!;
      _products = products;

      _filteredProducts = products;
    } else {
      _products = [];
      _filteredProducts = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  // void filterByCategory(WebsiteCategory? category) {
  //   _selectedCategory = category!;
  //   filterCategories(currentSearchText);
  // }
  void filterByCategory(WebsiteCategory? category) {
    if (category == null) {
      _selectedCategory = WebsiteCategory(
        id: 0,
        name: "All",
        completeName: "All",
        parentPath: "All",
        sequence: 0,
        countProduct: 1,
        totalCountProduct: 1,
      );
    } else {
      _selectedCategory = category;
    }

    filterCategories(currentSearchText);
  }

  WebsiteCategory? findCategoryById(int selectedId) {
    return (_products
            .map((p) => p.category)
            .whereType<WebsiteCategory>()
            .toSet()
            .toList()
          ..add(selectedCategory))
        .firstWhere(
      (cat) => cat.id == selectedId,
      orElse: () => WebsiteCategory(
        id: 0,
        name: "All",
        completeName: "All",
        parentPath: "All",
        sequence: 0,
        countProduct: 1,
        totalCountProduct: 1,
      ),
    );
  }

  // Future<void> setWebsiteCategories(List<Product> data) async {
  //   _isLoading = true;
  //   notifyListeners();
  //   _products = data;
  //   _filteredProducts = data.where((category) {
  //     return category.name.toLowerCase().contains(_search.toLowerCase(),) &&
  //         category.totalCountProduct > 0;
  //   }).toList();
  //   _isLoading = false;
  //   notifyListeners();
  // }
}
