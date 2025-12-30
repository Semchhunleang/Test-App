import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/service-project_task/product_category/product_image.dart';
import 'package:umgkh_mobile/services/api/e-catalog/product/product_service.dart';

class ProductImagesViewModel extends ChangeNotifier {
  // For Product Images
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  ApiResponse _apiResponse = ApiResponse(statusCode: 0, data: []);
  ApiResponse get apiResponse => _apiResponse;
  List<ProductImage> _listProductImages = [];
  List<ProductImage> get listProductImages => _listProductImages;
  int currentImageIndex = 0;
  // int fullImageUrl = 0;
  bool isSelectImage = false;
  int indexItem = 0;
  CarouselSliderController controller = CarouselSliderController();
  final ScrollController scrollController = ScrollController();

  Future<void> fetchImagesProduct(int proId) async {
    _isLoading = true;
    notifyListeners();
    final response = await ProductAPIService().fetchImagesProduct(proId);
    _apiResponse = response;
    if (response.statusCode == 200 || response.statusCode == 201) {
      final productImages = response.data!;
      _listProductImages = productImages;
      // if (_listProductImages.isEmpty || _listProductImages.length > 1) {
      //   fullImageUrl = _listProductImages[0].id;
      // }
    } else {
      _listProductImages = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  resetData() {
    currentImageIndex = 0;
    isSelectImage = false;
    indexItem = 0;
    controller = CarouselSliderController();
  }

  void onSelectImage(int index) {
    currentImageIndex = index;
    //  fullImageUrl = _listProductImages[index].id;
    notifyListeners();
  }

  void scrollToNumber(int index) {
    double targetPosition = index * 30.0;
    scrollController.animateTo(
      targetPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
