import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/e-catalog/product/product.dart';
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/view_models/product_images_view_model.dart';
import 'package:umgkh_mobile/views/pages/e-catalog/widget/image_widget.dart';
import 'package:umgkh_mobile/widgets/show_image_fullscreen.dart';

Widget slideImageDetail(
    BuildContext context, ProductImagesViewModel viewModel, Product data) {
  return CarouselSlider(
    carouselController: viewModel.controller,
    options: CarouselOptions(
      aspectRatio: 1.0,
      autoPlay: false,
      viewportFraction: 1,
      onPageChanged: (index, reason) async {
        viewModel.currentImageIndex = index;
        viewModel.onSelectImage(index);

        if (viewModel.isSelectImage) {
          if (viewModel.listProductImages.length - 1 == viewModel.indexItem) {
            viewModel.controller.jumpToPage(0);
            if (viewModel.listProductImages.length > 5) {
              viewModel.scrollToNumber(0);
            }
            viewModel.isSelectImage = false;
          } else if (viewModel.listProductImages.length - 1 >
              viewModel.indexItem) {
            viewModel.controller.jumpToPage(viewModel.indexItem + 1);

            if (viewModel.listProductImages.length > 5) {
              viewModel.scrollToNumber(viewModel.indexItem);
            }
            viewModel.isSelectImage = false;
          }
        } else {
          if (viewModel.listProductImages.length > 5) {
            viewModel.scrollToNumber(index);
          }
        }
      },
    ),
    items: viewModel.listProductImages
        .asMap()
        .entries
        .map(
          (item) => Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.width,
            width: double.infinity,
            child: GestureDetector(
              onTap: () => showFullScreenImage(
                  context,
                  Constants.getPictureProduct(viewModel
                      .listProductImages[viewModel.currentImageIndex].id),),
              child: imageWidget(context, viewModel, data,
                  viewModel.listProductImages[viewModel.currentImageIndex]),
            ),
          ),
        )
        .toList(),
  );
}
