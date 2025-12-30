import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/access_levels_view_model.dart';
import 'package:umgkh_mobile/view_models/small_paper_form_view_model.dart';
import 'package:umgkh_mobile/views/pages/image/index.dart';
import 'package:umgkh_mobile/views/pages/image/widget/widget_network_image.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';

// =================================== IMAGE FROM TAKE PHOTO - File
class WidgetViewImageLocal extends StatelessWidget {
  final List<File> data;

  const WidgetViewImageLocal({super.key, required this.data});

  @override
  Widget build(BuildContext context) => GridView.builder(
      shrinkWrap: true,
      physics: neverScroll,
      padding: EdgeInsets.fromLTRB(mainPadding, 0, mainPadding, mainPadding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: mainPadding,
          mainAxisSpacing: mainPadding),
      itemCount: data.length,
      itemBuilder: (context, i) => GestureDetector(
          onTap: () => navPush(context, ViewFullImagePage(image: data[i])),
          child: Stack(alignment: Alignment.topRight, children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(mainRadius),
                child: Image.file(data[i],
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover)),
            IconButton(
                icon: const Icon(Icons.delete_forever_rounded,
                    size: 20, color: Colors.red),
                onPressed: () =>
                    Provider.of<SmallPaperFormViewModel>(context, listen: false)
                        .onRemoveImage(i))
          ])));
}

// =================================== PICK IMAGE
class WidgetPickImages extends StatelessWidget {
  final Function() onGallery, onCamera;
  final bool isPictures, isDone, isApproved, isSubmitted;
  final List<File> localPictures;
  final int smallPaperId;
  final List<int> checkingImages;
  final List<int> requestImages;

  const WidgetPickImages(
      {super.key,
      required this.onGallery,
      required this.onCamera,
      required this.isPictures,
      required this.isDone,
      required this.isApproved,
      required this.isSubmitted,
      required this.localPictures,
      required this.smallPaperId,
      required this.checkingImages,
      required this.requestImages});

  @override
  Widget build(BuildContext context) => Consumer<AccessLevelViewModel>(
      builder: (context, accessVM, _) =>
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(mainRadius)),
                color: primaryColor.withOpacity(0.1),
                child: Column(children: [
                  // button & title
                  (!isSubmitted &&
                              !isApproved &&
                              !isDone &&
                              !accessVM.hasScanSamllPaper()) ||
                          (isApproved && accessVM.hasScanSamllPaper())
                      ? Padding(
                          padding: EdgeInsets.all(mainPadding),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CustomOutLineButton(
                                    text: 'Gallery', onTap: onGallery),
                                widthSpace,
                                CustomOutLineButton(
                                    text: 'Camera', onTap: onCamera)
                              ]))
                      : heithSpace,

                  // image local
                  localPictures.isNotEmpty
                      ? WidgetViewImageLocal(data: localPictures)
                      : sizedBoxShrink,

                  // request image
                  if (requestImages.isNotEmpty) ...[
                    buildTitleImage('Requested Images'),
                    heith10Space,
                    buildRequestImageApi()
                  ],

                  // image api
                  if (isDone && checkingImages.isNotEmpty) ...[
                    buildTitleImage('Checked Images'),
                    heith10Space,
                    buildCheckingImageApi()
                  ]
                ])),
            isPictures
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: mainPadding),
                    child: Text(
                        'Image required! You can choose from Gallery or Camera.',
                        style:
                            hintStyle.copyWith(color: redColor, fontSize: 10)))
                : sizedBoxShrink
          ]));

  Widget buildTitleImage(String title) => Row(children: [
        Expanded(
            child: Container(
                height: 1,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Colors.transparent,
                  blackColor.withOpacity(.4)
                ])))),
        Container(
            margin: EdgeInsets.symmetric(horizontal: mainPadding / 2),
            padding: EdgeInsets.symmetric(
                horizontal: mainPadding / 2, vertical: mainPadding / 3),
            decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                      color: greenColor.withOpacity(0.1))
                ]),
            child: Text(title, style: primary12Bold)),
        Expanded(
            child: Container(
                height: 1,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  blackColor.withOpacity(.4),
                  Colors.transparent
                ]))))
      ]);

  Widget buildRequestImageApi() => GridView.builder(
      shrinkWrap: true,
      physics: neverScroll,
      padding: EdgeInsets.fromLTRB(mainPadding, 0, mainPadding, mainPadding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: mainPadding,
          mainAxisSpacing: mainPadding),
      itemCount: requestImages.length,
      itemBuilder: (context, i) => WidgetNetworkImage(
          firstImg: Constants.smallPaperpicture(smallPaperId, requestImages[i]),
          index: i,
          fullImage: requestImages
              .map((e) => Constants.smallPaperpicture(smallPaperId, e))
              .toList()));

  Widget buildCheckingImageApi() => GridView.builder(
      shrinkWrap: true,
      physics: neverScroll,
      padding: EdgeInsets.fromLTRB(mainPadding, 0, mainPadding, mainPadding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: mainPadding,
          mainAxisSpacing: mainPadding),
      itemCount: checkingImages.length,
      itemBuilder: (context, i) => WidgetNetworkImage(
          firstImg:
              Constants.smallPaperpicture(smallPaperId, checkingImages[i]),
          index: i,
          fullImage: checkingImages
              .map((e) => Constants.smallPaperpicture(smallPaperId, e))
              .toList()));
}
