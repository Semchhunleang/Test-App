import 'dart:io';
import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/constants.dart';
import '../../../../../utils/theme.dart';
import '../../../../../widgets/button_custom.dart';
import 'card_image_a4.dart';

class ImageFormWidget extends StatelessWidget {
  final String title;
  final GestureTapCallback? onTapGallery;
  final GestureTapCallback? onTapCamera;
  final File? fillImage;
  final bool isValidate;
  final int? id;
  final String? field;
  final bool isHideSelectImage;
  const ImageFormWidget(
      {super.key,
      required this.title,
      this.onTapGallery,
      this.onTapCamera,
      this.fillImage,
      this.isValidate = false,
      this.id,
      this.field,
      this.isHideSelectImage = false});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: mainPadding / 2),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(
            child: Text(title, style: titleStyle15),
          ),
          if (!isHideSelectImage) ...[
            SizedBox(
              height: 30,
              child: ButtonCustom(
                  onTap: onTapGallery ?? () {},
                  text: 'Gallery',
                  color: primaryColor),
            ),
            widthSpace,
            SizedBox(
              height: 30,
              child: ButtonCustom(
                  onTap: onTapCamera ?? () {},
                  text: 'Camera',
                  color: primaryColor),
            )
          ],
        ]),
      ),
      heith5Space,
      CardImageA4(
        fillImage: fillImage,
        networkImage: id == null || field == null
            ? null
            : Constants.getImageA4(id!, field!),
        isValidate: isValidate,
      )
    ]);
  }
}
