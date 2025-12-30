import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/e-catalog/product/product.dart';
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/widgets/show_image_fullscreen.dart';

Widget singleImageWidget(BuildContext context, Product data) {
  return Container(
    color: Colors.white,
    height: MediaQuery.of(context).size.width,
    width: double.infinity,
    child: GestureDetector(
      onTap: () => showFullScreenImage(
        context,
        Constants.getProductPicture(data.id),
      ),
      child: Image.network(
        Constants.getProductPicture(data.id),
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.white,
          );
        },
        width: double.infinity,
      ),
    ),
  );
}
