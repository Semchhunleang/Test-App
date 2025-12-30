import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/cms/tsb/tsb_line.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/tsb_form_view_model.dart';
import 'package:umgkh_mobile/view_models/tsb_view_model.dart';
import 'package:umgkh_mobile/views/pages/cms/tsb/part_info_form_page.dart';
import 'package:umgkh_mobile/views/pages/cms/tsb/widget/item_parts_widget.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/float_bt.dart';

class PartsPage extends StatefulWidget {
  final List<TsbLine>? tsbLine;
  final String state;
  const PartsPage({super.key, this.tsbLine, this.state = ""});

  @override
  State<PartsPage> createState() => _PartsPageState();
}

class _PartsPageState extends State<PartsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<TsbFormViewModel, TsbViewModel>(
        builder: (context, viewModel, viewModel1, _) {
      return CustomScaffold(
        title: 'Parts Page',
        body: widget.tsbLine != null && widget.tsbLine!.isNotEmpty
            ? ListView.builder(
                itemCount: widget.tsbLine!.length,
                padding: EdgeInsets.fromLTRB(
                    mainPadding, 0, mainPadding, mainPadding * 5.5),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      final result = await navPush(
                        context,
                        PartsInfoFormPage(
                          isForm: false,
                          tsbLine: widget.tsbLine![index],
                        ),
                      );
                      if (result == true) {
                        viewModel1.fetchTsbLineData(widget.tsbLine![index].id!);
                      }
                    },
                    child: ItemPartsWidget(
                      tsbLine: widget.tsbLine![index],
                    ),
                  );
                })
            : const Center(
                child: Text("No data of parts"),
              ),
        floatingBt: widget.state == draft
            ? DefaultFloatButton(
                onTap: () async {
                  navPush(
                    context,
                    const PartsInfoFormPage(),
                  );
                  // viewModel.resetData();
                  // final result = await navPush(
                  //   context,
                  //   const CreateA4Page(),
                  // );
                  // if (result == true) {
                  //   WidgetsBinding.instance.addPostFrameCallback((_) {
                  //     Provider.of<A4UnderLevelViewModel>(context, listen: false)
                  //         .fetchA4Data();
                  //   });
                  // }
                },
              )
            : Container(),
      );
    });
  }
}
