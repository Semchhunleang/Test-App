// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/small_paper_view_model.dart';
import 'package:umgkh_mobile/views/pages/am/small_paper/form_and_info.dart';
import 'package:umgkh_mobile/views/pages/am/small_paper/widget/item_small_paper_widget.dart';
import 'package:umgkh_mobile/views/pages/am/small_paper/widget/utils_widget.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/float_bt.dart';
import 'package:umgkh_mobile/widgets/list_condition.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class SmallPaperPage extends StatefulWidget {
  static const routeName = '/small-paper';
  static const pageName = 'Small Paper';
  const SmallPaperPage({super.key});

  @override
  State<SmallPaperPage> createState() => _SmallPaperPageState();
}

class _SmallPaperPageState extends State<SmallPaperPage> {
  @override
  void initState() {
    super.initState();
    final p = Provider.of<SmallPaperViewModel>(context, listen: false);
    p.resetData();
    p.fetchData(context);
  }

  @override
  Widget build(BuildContext context) => Consumer<SmallPaperViewModel>(
        builder: (context, viewModel, _) => CustomScaffold(
          title: SmallPaperPage.pageName,
          body: Column(
            children: [
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: primaryColor.withOpacity(0.1),
                margin: EdgeInsets.symmetric(
                    horizontal: mainPadding, vertical: mainPadding / 2),
                child: Padding(
                  padding: EdgeInsets.all(mainPadding),
                  child: Column(
                    children: [
                      SearchTextfield(
                        ctrl: viewModel.searchCtrl,
                        onChanged: (v) => viewModel.onSearchChanged(context, v),
                      ),
                      heithSpace,
                      Row(children: [
                        filterSelectStatus(
                          selected: viewModel.selectedState,
                          onValue: (v) => viewModel.onStateChanged(context, v),
                        ),
                        width10Space,
                        filterSelectPeople(
                          selected: viewModel.selectedPeople,
                          onValue: (v) => viewModel.onPeopleChanged(context, v),
                        )
                      ])
                    ],
                  ),
                ),
              ),

              // list
              ListCondition(
                viewModel: viewModel,
                showedData: viewModel.showedData,
                onRefresh: () => viewModel.fetchData(context),
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                      mainPadding, 0, mainPadding, mainPadding * 5.5),
                  itemCount: viewModel.showedData.length,
                  itemBuilder: (context, i) =>
                      ItemSmallPaperWidget(data: viewModel.showedData[i]),
                ),
              )
            ],
          ),
          floatingBt: DefaultFloatButton(onTap: () async {
            if (mounted) {
              await navPush(
                  context, const SmallPaperFormAndInfoPage(isForm: true));
              viewModel.fetchData(context);
            }
          }),
        ),
      );
}
