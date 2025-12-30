import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/supporthub/marketing/marketing_ticket.dart';
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/utils/image_picker.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/supporthub/ict_team/ict_ticket_form_view_model.dart';
import 'package:umgkh_mobile/view_models/supporthub/marketing_team/marketing_ticket_form_view_model.dart';
import 'package:umgkh_mobile/views/pages/image/index.dart';
import 'package:umgkh_mobile/views/pages/image/widget/widget_network_image.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';

// =================================== PICK IMAGES - FILES
class BuildWidgetMarketingSupportHubImage extends StatelessWidget {
  final Function() onFile, onGallery, onCamera;
  final bool isPictures;
  final List<File> pictures, files;
  final MarketingTicket? data;

  const BuildWidgetMarketingSupportHubImage(
      {super.key,
      required this.onFile,
      required this.onGallery,
      required this.onCamera,
      required this.isPictures,
      required this.pictures,
      required this.files,
      this.data});

  @override
  Widget build(BuildContext context) => Consumer<MarketingTicketFormViewModel>(
      builder: (context, viewModel, _) =>
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(mainRadius)),
                color: primaryColor.withOpacity(0.1),
                child: Column(children: [
                  // button & title
                  canInsertPic()
                      ? Padding(
                          padding: EdgeInsets.all(mainPadding),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CustomOutLineButton(
                                    text: 'File', onTap: onFile),
                                widthSpace,
                                CustomOutLineButton(
                                    text: 'Gallery', onTap: onGallery),
                                widthSpace,
                                CustomOutLineButton(
                                    text: 'Camera', onTap: onCamera)
                              ]))
                      : heithSpace,

                  viewModel.isLocalImgLoading
                      ? FadeIn(
                          child: Padding(
                              padding: EdgeInsets.only(bottom: mainPadding),
                              child: const CircularProgressIndicator(
                                  strokeWidth: 2)))
                      : pictures.isNotEmpty || files.isNotEmpty
                          ? widgetViewImageLocal(
                              context: context,
                              pictures: pictures,
                              files: files)
                          : sizedBoxShrink,

                  // separate line
                  (pictures.isNotEmpty || files.isNotEmpty) && showApiPic()
                      ? divided()
                      : sizedBoxShrink,

                  // image api
                  showApiPic() ? buildImageApi() : sizedBoxShrink
                ])),

            // required image text
            isPictures
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: mainPadding),
                    child: Text(
                        'Image required! You can choose from Gallery or Camera.',
                        style:
                            hintStyle.copyWith(color: redColor, fontSize: 10)))
                : sizedBoxShrink
          ]));

  bool canInsertPic() => (data == null || data?.state == open);
  bool showApiPic() =>
      (data != null && (data!.images.isNotEmpty || data!.files.isNotEmpty));

  Widget buildImageApi() => Consumer<MarketingTicketFormViewModel>(
      builder: (context, viewModel, _) => Column(children: [
            // files as list
            ListView.builder(
                shrinkWrap: true,
                physics: neverScroll,
                itemCount: data?.files.length,
                padding: EdgeInsets.symmetric(horizontal: mainPadding),
                itemBuilder: (context, i) => Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(mainRadius / 2)),
                    child: InkWell(
                        onTap: () {
                          final file = viewModel.downloadedFiles
                              .firstWhere((d) => d.id == data!.files[i].id);
                          openFiles(file.downloadedFile);
                        },
                        borderRadius: BorderRadius.circular(mainRadius / 2),
                        highlightColor: primaryColor.withOpacity(0.1),
                        splashColor: primaryColor.withOpacity(0.1),
                        child: Row(children: [
                          width5Space,
                          Icon(getIconExt(data!.files[i].extension),
                              color: primaryColor, size: 20),
                          width5Space,
                          Expanded(
                              child: Text(data!.files[i].name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: titleStyle13)),
                          IconButton(
                              icon: Icon(
                                  canInsertPic()
                                      ? Icons.delete_forever_rounded
                                      : null,
                                  size: 20,
                                  color: Colors.red),
                              onPressed: canInsertPic()
                                  ? () => viewModel
                                          .deleteImage(
                                              context, data!.files[i].id)
                                          .then((v) {
                                        if (v) {
                                          viewModel.removeApiFileInLocal(
                                              data!, data!.files[i].id);
                                        }
                                      })
                                  : null)
                        ])))),

            data!.files.isNotEmpty && data!.images.isNotEmpty
                ? heith10Space
                : sizedBoxShrink,

            // image as grid
            GridView.builder(
                shrinkWrap: true,
                physics: neverScroll,
                padding: EdgeInsets.fromLTRB(
                    mainPadding, 0, mainPadding, mainPadding),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: mainPadding,
                    mainAxisSpacing: mainPadding),
                itemCount: data?.images.length,
                itemBuilder: (context, i) => viewModel
                        .loadImageApi(data!.images[i])
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [CircularProgressIndicator(strokeWidth: 2)])
                    : WidgetNetworkImage(
                        firstImg: Constants.attachmentById(data!.images[i]),
                        index: i,
                        fullImage: data?.images
                            .map((e) => Constants.attachmentById(e))
                            .toList(),
                        onDelete: canInsertPic()
                            ? () => viewModel
                                    .deleteImage(context, data!.images[i])
                                    .then((v) {
                                  if (v) {
                                    viewModel.removeApiImageInLocal(
                                        data!, data!.images[i]);
                                  }
                                })
                            : null))
          ]));

  // =================================== IMAGE FROM TAKE PHOTO - File
  Widget widgetViewImageLocal(
          {required BuildContext context,
          required List<File> pictures,
          required List<File> files}) =>
      Column(children: [
        // list as files
        ListView.builder(
            shrinkWrap: true,
            physics: neverScroll,
            itemCount: files.length,
            padding: EdgeInsets.symmetric(horizontal: mainPadding),
            itemBuilder: (context, i) => Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(mainRadius / 2)),
                child: InkWell(
                    onTap: () => openFiles(files[i].path),
                    borderRadius: BorderRadius.circular(mainRadius / 2),
                    highlightColor: primaryColor.withOpacity(0.1),
                    splashColor: primaryColor.withOpacity(0.1),
                    child: Row(children: [
                      width5Space,
                      Icon(getIconExt(getFileExt(files[i])),
                          color: primaryColor, size: 20),
                      width5Space,
                      Expanded(
                          child: Text(files[i].path.split('/').last,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: titleStyle13)),
                      IconButton(
                          icon: const Icon(Icons.delete_forever_rounded,
                              size: 20, color: Colors.red),
                          onPressed: () => Provider.of<ICTTicketFormViewModel>(
                                  context,
                                  listen: false)
                              .onRemoveFile(i))
                    ])))),

        files.isNotEmpty && pictures.isNotEmpty ? heith10Space : sizedBoxShrink,

        // grid as images
        GridView.builder(
            shrinkWrap: true,
            physics: neverScroll,
            padding:
                EdgeInsets.fromLTRB(mainPadding, 0, mainPadding, mainPadding),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: mainPadding,
                mainAxisSpacing: mainPadding),
            itemCount: pictures.length,
            itemBuilder: (context, i) => GestureDetector(
                onTap: () =>
                    navPush(context, ViewFullImagePage(image: pictures[i])),
                child: Stack(alignment: Alignment.topRight, children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(mainRadius),
                      child: Image.file(pictures[i],
                          height: double.infinity,
                          width: double.infinity,
                          fit: BoxFit.cover)),
                  IconButton(
                      icon: const Icon(Icons.delete_forever_rounded,
                          size: 20, color: Colors.red),
                      onPressed: () => Provider.of<ICTTicketFormViewModel>(
                              context,
                              listen: false)
                          .onRemoveImage(i))
                ])))
      ]);
}

Widget divided() => Padding(
    padding: EdgeInsets.symmetric(horizontal: mainPadding * 3),
    child: Column(children: [
      Divider(color: primaryColor.withOpacity(0.2)),
      Text('Your Uploaded Files & Images',
          style: titleStyle13.copyWith(color: draftColor)),
      heithSpace
    ]));
