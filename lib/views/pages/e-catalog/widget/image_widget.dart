import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/e-catalog/product/product.dart';
import 'package:umgkh_mobile/models/service-project_task/product_category/product_image.dart';
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/product_images_view_model.dart';

Widget imageWidget(BuildContext context, ProductImagesViewModel viewModel,
    Product data, ProductImage proImage) {
  return Stack(
    fit: StackFit.expand,
    children: [
      Image.network(
        // viewModel.listProductImages.isEmpty || viewModel.listProductImages.length == 1
        viewModel.listProductImages.isEmpty
            ? Constants.getProductPicture(data.id)
            : Constants.getPictureProduct(proImage.id),
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.white,
          );
        },
        width: double.infinity,
      ),
      if (viewModel.listProductImages.isNotEmpty
          // && viewModel.listProductImages.length > 1
          )
        Positioned(
          bottom: 10.0,
          right: MediaQuery.of(context).size.width * 0.05,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Text(
              "${viewModel.currentImageIndex + 1} / ${viewModel.listProductImages.length}",
              style: titleStyle13.copyWith(
                  color: const Color.fromARGB(255, 109, 117, 126),
                  letterSpacing: 1.5),
            ),
          ),
        ),
    ],
  );
}
