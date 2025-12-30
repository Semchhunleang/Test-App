import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/e-catalog/product/product.dart';
import 'package:umgkh_mobile/models/service-project_task/product_category/product_image.dart';
import 'package:umgkh_mobile/services/api/base/auth/token_service.dart';
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'dart:io';
import 'package:http/io_client.dart';

class ProductAPIService {
  final AuthAPIService _tokenManager = AuthAPIService();
  final ioClient = IOClient(HttpClient()..findProxy = (_) => "DIRECT");

  Future<ApiResponse<List<Product>>> fetchProductByCategory(
      int categoryId) async {
    final token = await _tokenManager.getValidToken();

    try {
      var response = await ioClient.get(
        Uri.parse(Constants.getProductByCategory(categoryId),),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Adjust content type as needed
        },
      );
      if (response.statusCode == 200) {
        final List<Product> responseData = (json.decode(response.body) as List)
            .map((json) => Product.fromJson(json),)
            .toList();
        return ApiResponse(statusCode: response.statusCode, data: responseData);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }

  Future<ApiResponse<List<ProductImage>>> fetchImagesProduct(int proId) async {
    final token = await _tokenManager.getValidToken();

    try {
      var response = await ioClient.get(
        Uri.parse(Constants.getimagesPicture(proId),),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<ProductImage> responseData =
            (json.decode(response.body) as List)
                .map((json) => ProductImage.fromJson(json),)
                .toList();
        return ApiResponse(statusCode: response.statusCode, data: responseData);
      } else {
        return ApiResponse(
            error: getResponseErrorMessage(response),
            statusCode: response.statusCode);
      }
    } on TimeoutException catch (_) {
      return ApiResponse(error: 'Request timed out', statusCode: 408);
    } catch (e) {
      return ApiResponse(error: getCatchExceptionMessage(e), statusCode: 503);
    }
  }
}
