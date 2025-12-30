import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/log_note_form_view_model.dart';
import 'package:umgkh_mobile/views/pages/image/index.dart';

const double localHeight = 80.0;

class WidgetImageLocalLogNote extends StatelessWidget {
  const WidgetImageLocalLogNote({super.key});

  @override
  Widget build(BuildContext context) => Consumer<LogNoteFormViewModel>(
      builder: (context, vm, _) => vm.isLocalImgLoading
          ? FadeIn(
              child: Padding(
                  padding: EdgeInsets.only(
                      left: mainPadding * 1.5, bottom: mainPadding),
                  child: const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))))
          : SizedBox(
              height: localHeight,
              width: double.infinity,
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: kBounce,
                      padding:
                          EdgeInsets.symmetric(horizontal: mainPadding / 5),
                      children: List.generate(
                          vm.pictures.length,
                          (index) => image(context, vm.pictures[index],
                              remove: () => vm.onRemoveImage(index)))))));

  Widget image(BuildContext context, File file, {required Function() remove}) =>
      Padding(
          padding: EdgeInsets.only(left: mainPadding / 2),
          child: GestureDetector(
              onTap: () => navPush(context, ViewFullImagePage(image: file)),
              child: Stack(children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image(
                        image: FileImage(file),
                        height: localHeight,
                        width: localHeight,
                        fit: BoxFit.cover)),
                Positioned(
                    top: -12,
                    right: -12,
                    child: IconButton(
                        highlightColor: transparent,
                        splashColor: transparent,
                        icon: const Icon(Icons.delete_forever_rounded,
                            size: 15, color: Colors.red),
                        onPressed: remove))
              ])));
}
