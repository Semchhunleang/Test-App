import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/image_utils.dart';
import 'package:umgkh_mobile/utils/theme.dart';

// =============================== NO IMAGE ===============================
class WidgetNoImage extends StatelessWidget {
  final bool visible;
  const WidgetNoImage({super.key, this.visible = false});

  @override
  Widget build(BuildContext context) => Visibility(
        visible: visible,
        child: Center(
          child: Column(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(mainRadius),
              child: const Image(
                  image: NetworkImage(noImage),
                  height: 130,
                  width: 200,
                  fit: BoxFit.cover),
            ),
            heith5Space,
            Text(
              'No image',
              textAlign: TextAlign.center,
              style: primary12Bold.copyWith(color: redColor),
            )
          ]),
        ),
      );
}

// =============================== LOADING ===============================
class WidgetLoadImage extends StatelessWidget {
  const WidgetLoadImage({super.key});

  @override
  Widget build(BuildContext context) => defaultCard(
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
  //const Image(image: NetworkImage(noImage), fit: BoxFit.cover);
}

// =============================== ERROR ===============================
class WidgetImageErro extends StatelessWidget {
  const WidgetImageErro({super.key});

  @override
  Widget build(BuildContext context) => defaultCard(
        child: Icon(Icons.error_outline_rounded, color: redColor, size: 30),
      );
  //const Image(image: NetworkImage(imageError), fit: BoxFit.cover);
}

Widget defaultCard({required Widget child}) => Card(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(mainRadius),
    ),
    child: child);
