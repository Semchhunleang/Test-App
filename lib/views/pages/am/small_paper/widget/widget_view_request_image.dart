// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:umgkh_mobile/models/am/small_paper/small_paper.dart';
// import 'package:umgkh_mobile/utils/constants.dart';
// import 'package:umgkh_mobile/utils/navigator.dart';
// import 'package:umgkh_mobile/utils/theme.dart';
// import 'package:umgkh_mobile/utils/utlis.dart';
// import 'package:umgkh_mobile/view_models/small_paper_form_view_model.dart';
// import 'package:umgkh_mobile/views/pages/image/index.dart';
// import 'package:umgkh_mobile/views/pages/image/widget/widget_network_image.dart';
// import 'package:umgkh_mobile/widgets/button_custom.dart';

// // =================================== IMAGE FROM TAKE PHOTO - File
// class WidgetViewImageLocal extends StatelessWidget {
//   final List<File> data;

//   const WidgetViewImageLocal({super.key, required this.data});

//   @override
//   Widget build(BuildContext context) => GridView.builder(
//       shrinkWrap: true,
//       physics: neverScroll,
//       padding: EdgeInsets.fromLTRB(mainPadding, 0, mainPadding, mainPadding),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: mainPadding,
//           mainAxisSpacing: mainPadding),
//       itemCount: data.length,
//       itemBuilder: (context, i) => GestureDetector(
//           onTap: () => navPush(context, ViewFullImagePage(image: data[i]),),
//           child: Stack(alignment: Alignment.topRight, children: [
//             ClipRRect(
//                 borderRadius: BorderRadius.circular(mainRadius),
//                 child: Image.file(data[i],
//                     height: double.infinity,
//                     width: double.infinity,
//                     fit: BoxFit.cover),),
//             IconButton(
//                 icon: const Icon(Icons.delete_forever_rounded,
//                     size: 20, color: Colors.red),
//                 onPressed: () =>
//                     Provider.of<SmallPaperFormViewModel>(context, listen: false)
//                         .onRemoveImage(i),)
//           ]),),);
// }

// // =================================== PICK IMAGE
// class WidgetPickRequestImages extends StatelessWidget {
//   final Function() onGallery, onCamera;
//   final bool isPictures, isDone;
//   final List<File> localPictures;
//   final SmallPaper data;

//   const WidgetPickRequestImages(
//       {super.key,
//       required this.onGallery,
//       required this.onCamera,
//       required this.isPictures,
//       required this.isDone,
//       required this.localPictures,
//       required this.data});

//   @override
//   Widget build(BuildContext context) =>
//       Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Card(
//             elevation: 0,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(mainRadius),),
//             color: primaryColor.withOpacity(0.1),
//             child: Column(children: [
//               // button & title
//               !isDone
//                   ? Padding(
//                       padding: EdgeInsets.all(mainPadding),
//                       child: Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             CustomOutLineButton(
//                                 text: 'Gallery', onTap: onGallery),
//                             widthSpace,
//                             CustomOutLineButton(text: 'Camera', onTap: onCamera)
//                           ]),)
//                   : heithSpace,

//               // image local
//               localPictures.isNotEmpty
//                   ? WidgetViewImageLocal(data: localPictures)
//                   : sizedBoxShrink,

//               // image api
//               isDone ? buildImageApi() : sizedBoxShrink
//             ]),),
//         isPictures
//             ? Padding(
//                 padding: EdgeInsets.symmetric(horizontal: mainPadding),
//                 child: Text(
//                     'Image required! You can choose from Gallery or Camera.',
//                     style: hintStyle.copyWith(color: redColor, fontSize: 10),),)
//             : sizedBoxShrink
//       ]);

//   Widget buildImageApi() => GridView.builder(
//       shrinkWrap: true,
//       physics: neverScroll,
//       padding: EdgeInsets.fromLTRB(mainPadding, 0, mainPadding, mainPadding),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: mainPadding,
//           mainAxisSpacing: mainPadding),
//       itemCount: data.images.length,
//       itemBuilder: (context, i) => WidgetNetworkImage(
//           firstImg: Constants.smallPaperpicture(data.id, data.images[i]),
//           index: i,
//           fullImage: data.images
//               .map((e) => Constants.smallPaperpicture(data.id, e),)
//               .toList(),),);
// }
