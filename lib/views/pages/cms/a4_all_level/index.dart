import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/a4_under_level_form_view_model.dart';
import 'package:umgkh_mobile/view_models/a4_under_level_view_model.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/views/pages/cms/a4_all_level/a4_all_level_form_and_info.dart';
import 'package:umgkh_mobile/views/pages/cms/a4_for_under_level/widget/item_a4_underlevel.dart';
import 'package:umgkh_mobile/views/pages/cms/a4_for_under_level/widget/search_widget.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/float_bt.dart';
import 'package:umgkh_mobile/widgets/list_condition.dart';

class A4AllLevelPage extends StatefulWidget {
  static const routeName = '/a4-all';
  static const pageName = 'A4';
  const A4AllLevelPage({super.key});

  @override
  State<A4AllLevelPage> createState() => _A4AllLevelPageState();
}

class _A4AllLevelPageState extends State<A4AllLevelPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final a4UnderLevelViewModel =
          Provider.of<A4UnderLevelViewModel>(context, listen: false);
      final selectionView =
          Provider.of<SelectionsViewModel>(context, listen: false);
      a4UnderLevelViewModel.reseForm();
      a4UnderLevelViewModel.fetchA4Data();
      selectionView.fetchIsoOjective1();
      selectionView.fetchIsoOjective2();
      selectionView.fetchSheetProblem();
      selectionView.fetchImprovScope();
      selectionView.fetchAllEmployee();
      selectionView.fetchDocumentNumber("a4");
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: A4AllLevelPage.pageName,
      body: Consumer2<A4UnderLevelViewModel, ProfileViewModel>(
          builder: (context, viewModel, providerProfile, child) {
        return Column(
          children: [
            const SearchWidget(),
            ListCondition(
              viewModel: viewModel,
              showedData: viewModel.filteredA4DataList,
              onRefresh: () async {
                FocusScope.of(context).unfocus();
                await viewModel.fetchA4Data();
                viewModel.searchController.clear();
                viewModel.search = "";
              },
              child: ListView.builder(
                  itemCount: viewModel.filteredA4DataList.length,
                  padding: EdgeInsets.fromLTRB(
                      mainPadding, 0, mainPadding, mainPadding * 5.5),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        final result = await navPush(
                          context,
                          A4AllLevelFormAndInfo(
                            isForm: false,
                            a4Data: viewModel.filteredA4DataList[index],
                          ),
                        );
                        if (result == true) {
                          viewModel.fetchA4Data();
                        }
                      },
                      child: ItemA4Underlevel(
                        a4data: viewModel.filteredA4DataList[index],
                      ),
                    );
                  }),
            )
          ],
        );
      }),
      floatingBt: Consumer<A4UnderLevelFormViewModel>(
          builder: (context, viewModel, child) {
        return DefaultFloatButton(
          onTap: () async {
            navPush(
              context,
              const A4AllLevelFormAndInfo(),
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
        );
      }),
    );
  }
}
