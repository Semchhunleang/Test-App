import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:umgkh_mobile/widgets/show_image_fullscreen.dart';

Widget carouselCustom(BuildContext context, List<String> strImages) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.23,
    width: MediaQuery.of(context).size.width,
    child: CarouselSlider(
      options: CarouselOptions(autoPlay: true, viewportFraction: 1),
      items: strImages
          .map(
            (item) => _carouselCustomItem(item, context),
          )
          .toList(),
    ),
  );
}

Widget _carouselCustomItem(String item, BuildContext context) {
  return GestureDetector(
    onTap: () => showFullScreenImage(context, item),
    child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(item), fit: BoxFit.fitWidth),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: 20, sigmaY: 20, tileMode: TileMode.mirror),
          child: Center(
            child: Image.network(
              item,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    ),
  );
}
