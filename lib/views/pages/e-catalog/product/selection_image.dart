import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/view_models/product_images_view_model.dart';

class SelectionImage extends StatefulWidget {
  const SelectionImage({super.key});

  @override
  State<SelectionImage> createState() => _SelectionImageState();
}

class _SelectionImageState extends State<SelectionImage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductImagesViewModel>(
        builder: (context, viewModel, child) {
      return SingleChildScrollView(
        controller: viewModel.scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: viewModel.listProductImages.asMap().entries.map((e) {
            return Padding(
              padding:
                  EdgeInsets.only(right: 15.0, left: e.key == 0 ? 15.0 : 0.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(30),
                  child: GestureDetector(
                    onTap: () {
                      viewModel.onSelectImage(e.key);
                      viewModel.isSelectImage = true;
                      viewModel.indexItem = e.key;
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          Constants.getPictureProduct(e.value.id),
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 30,
                              width: 30,
                              color: Colors.grey,
                            );
                          },
                          headers: const {'timeout': '60000'},
                        ),
                        if (viewModel.currentImageIndex == e.key)
                          Container(
                            color: Colors.black.withOpacity(0.6),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }
}
