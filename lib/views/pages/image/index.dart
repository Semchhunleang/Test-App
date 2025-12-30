import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/widgets/widget_image.dart';

class ViewFullImagePage extends StatefulWidget {
  final dynamic image;
  final int index;

  const ViewFullImagePage({super.key, required this.image, this.index = 0});

  @override
  State<ViewFullImagePage> createState() => _ViewFullImagePageState();
}

class _ViewFullImagePageState extends State<ViewFullImagePage> {
  final TransformationController controller = TransformationController();
  double scale = 1.0;
  late PageController pageCtrl;
  int pageChange = 0;

  @override
  void initState() {
    pageChange = widget.index;
    pageCtrl = PageController(initialPage: pageChange);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop()),
          title: widget.image is List
              ? widget.image is Uint8List
                  ? sizedBoxShrink
                  : Text('${pageChange + 1}/${widget.image.length}',
                      style: titleStyle15.copyWith(color: whiteColor))
              : sizedBoxShrink),
      body: Center(
          child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: GestureDetector(
                  onDoubleTap: onDoubleTap,
                  child: InteractiveViewer(
                      transformationController: controller,
                      panEnabled: true,
                      boundaryMargin: const EdgeInsets.all(20),
                      minScale: 0.2,
                      maxScale: 4.0,
                      child: buildImage())))));

  Widget buildImage() {
    if (widget.image is File) {
      return Image.file(widget.image as File, fit: BoxFit.contain);
    } else if (widget.image is Uint8List) {
      return Image.memory(widget.image as Uint8List, fit: BoxFit.contain);
    } else if (widget.image is String) {
      final String imgString = widget.image as String;
      return imgString.startsWith('http')
          ? Image.network(imgString, fit: BoxFit.contain)
          : Image.asset(imgString, fit: BoxFit.contain);
    } else if (widget.image is List) {
      return buildListImage();
    } else {
      return const WidgetLoadImage();
    }
  }

  Widget buildListImage() => PageView.builder(
      controller: pageCtrl,
      onPageChanged: (v) => setState(() => pageChange = v),
      physics: kBounce,
      itemCount: (widget.image as List).length,
      itemBuilder: (context, index) =>
          Image.network(widget.image[index], fit: BoxFit.contain));

  void onDoubleTap() {
    scale == 1.0 ? scale = 1.3 : scale = 1.0;
    controller.value = Matrix4.identity()..scale(scale);
    setState(() {});
  }
}
