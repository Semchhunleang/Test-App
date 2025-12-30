import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import '../../../../view_models/a4_under_level_form_view_model.dart';
import '../../../../widgets/button_custom.dart';
import 'widget/image_form_widget.dart';

class CreateA4Page extends StatefulWidget {
  const CreateA4Page({super.key});

  @override
  State<CreateA4Page> createState() => _CreateA4PageState();
}

class _CreateA4PageState extends State<CreateA4Page> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Create A4",
      body: Consumer<A4UnderLevelFormViewModel>(
          builder: (context, viewModel, child) {
        return viewModel.isLoading == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Stack(children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        mainPadding, 0, mainPadding, mainPadding * 5.5),
                    child: Column(children: [
                      ImageFormWidget(
                          title: "Before",
                          onTapCamera: () => viewModel.pickOrCaptureImage(
                              isBefore: true, fromGallery: false),
                          onTapGallery: () => viewModel.pickOrCaptureImage(
                              isBefore: true, fromGallery: true),
                          fillImage: viewModel.selectedImageBefore),
                      heithSpace,
                      Divider(
                        color: primaryColor.withOpacity(0.1),
                      ),
                      heithSpace,
                      ImageFormWidget(
                          title: "After",
                          onTapCamera: () => viewModel.pickOrCaptureImage(
                              isBefore: false, fromGallery: false),
                          onTapGallery: () => viewModel.pickOrCaptureImage(
                              isBefore: false, fromGallery: true),
                          fillImage: viewModel.selectedImageAfter),
                      ...multiheithSpace(4),
                      SizedBox(
                        width: double.infinity,
                        child: ButtonCustom(
                            text: 'Submit',
                            isDiable: viewModel.selectedImageBefore != null &&
                                    viewModel.selectedImageAfter != null
                                ? false
                                : true,
                            onTap: () {
                              if (viewModel.selectedImageBefore != null &&
                                  viewModel.selectedImageAfter != null) {
                                viewModel.createA4UnderLevel(context);
                              }
                            }),
                      )
                    ]),
                  ),
                  if (viewModel.isLoading)
                    Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                ]),
              );
      }),
    );
  }
}
