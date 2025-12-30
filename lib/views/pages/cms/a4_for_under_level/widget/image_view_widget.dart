import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/views/pages/image/index.dart';
import 'package:umgkh_mobile/widgets/widget_image.dart';
import '../../../../../utils/theme.dart';

class ImageViewWidget extends StatelessWidget {
  final Uint8List? a4Image;
  final int id;
  final String field;
  const ImageViewWidget(
      {super.key, this.a4Image, required this.id, required this.field});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navPush(
        context,
        ViewFullImagePage(
          image: Constants.getImageA4(id, field),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: mainPadding / 4, vertical: mainPadding / 2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(mainRadius / 2),
          child: SizedBox(
            width: double.infinity,
            height: 200.0,
            child: Image.network(Constants.getImageA4(id, field),
                fit: BoxFit.cover, loadingBuilder: (BuildContext context,
                    Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return const Center(
                child: WidgetLoadImage(),
              );
            }, errorBuilder: (context, error, stackTrace) {
              return Container(color: Colors.white);
            }),
          ),
        ),
      ),
    );
  }
}
