import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/views/pages/image/index.dart';
import 'package:umgkh_mobile/widgets/widget_image.dart';

class WidgetNetworkImage extends StatelessWidget {
  final String firstImg;
  final dynamic fullImage;
  final int index;
  final Function()? onDelete;
  const WidgetNetworkImage(
      {super.key,
      required this.firstImg,
      this.fullImage,
      this.index = 0,
      this.onDelete});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: fullImage != null
            ? () => navPush(
                  context,
                  ViewFullImagePage(index: index, image: fullImage),
                )
            : null,
        child: onDelete != null
            ? Stack(alignment: Alignment.topRight, children: [
                buildImage(),
                IconButton(
                    icon: const Icon(Icons.delete_forever_rounded,
                        size: 20, color: Colors.red),
                    onPressed: onDelete)
              ])
            : buildImage(),
      );

  Widget buildImage() => ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        child: Image.network(firstImg,
            height: onDelete != null ? double.infinity : null,
            width: onDelete != null ? double.infinity : null,
            fit: BoxFit.cover, loadingBuilder: (BuildContext context,
                Widget child, ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return const Center(
            child: WidgetLoadImage(),
          );
        }, errorBuilder: (context, error, stackTrace) {
          return const WidgetImageErro();
        }),
      );
}
