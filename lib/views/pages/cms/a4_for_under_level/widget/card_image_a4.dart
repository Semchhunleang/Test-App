import 'dart:io';
import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/views/pages/image/index.dart';
import 'package:umgkh_mobile/widgets/widget_image.dart';
import '../../../../../utils/theme.dart';

class CardImageA4 extends StatelessWidget {
  final File? fillImage;
  final String? networkImage;
  final bool isValidate;
  const CardImageA4(
      {super.key, this.fillImage, this.isValidate = false, this.networkImage});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: isValidate
                ? const BorderSide(color: Colors.red, width: 1)
                : BorderSide(color: greyColor, width: 1), //BorderSide.none
            borderRadius: BorderRadius.circular(mainRadius / 2),
          ),
          color: primaryColor.withOpacity(0.1),
          margin: EdgeInsets.symmetric(vertical: mainPadding / 2),
          child: SizedBox(
            width: double.infinity,
            height: 200.0,
            child: fillImage != null
                ? GestureDetector(
                    onTap: () => navPush(
                      context,
                      ViewFullImagePage(image: fillImage),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(mainRadius / 2),
                      child: Image.file(fit: BoxFit.cover, fillImage!),
                    ),
                  )
                : networkImage != null
                    ? GestureDetector(
                        onTap: () => navPush(
                          context,
                          ViewFullImagePage(image: networkImage),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(mainRadius / 2),
                          child: networkImage != null
                              ? Image.network(
                                  networkImage!,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return const Center(
                                      child: WidgetLoadImage(),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(
                                            mainRadius / 2),
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.1),
                                    borderRadius:
                                        BorderRadius.circular(mainRadius / 2),
                                  ),
                                ),
                        ),
                      )
                    : const SizedBox(),
          ),
        ),
        if (isValidate)
          Padding(
            padding: EdgeInsets.only(left: mainPadding, right: mainPadding),
            child: Text(
              "Required, please fill image",
              style: hintStyle.copyWith(color: redColor, fontSize: 10),
            ),
          )
      ],
    );
  }
}
