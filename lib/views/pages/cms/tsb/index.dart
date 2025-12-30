import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/view_models/tsb_view_model.dart';
import 'package:umgkh_mobile/views/pages/cms/tsb/tsb_detail_form_page.dart';
import 'package:umgkh_mobile/views/pages/cms/tsb/widget/item_tsb_widget.dart';
import 'package:umgkh_mobile/views/pages/cms/tsb/widget/search_widget.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/float_bt.dart';
import 'package:umgkh_mobile/widgets/list_condition.dart';

class TSBPage extends StatefulWidget {
  static const routeName = '/tsb-cms';
  static const pageName = 'TSB';
  const TSBPage({super.key});

  @override
  State<TSBPage> createState() => _TSBPageState();
}

class _TSBPageState extends State<TSBPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tsbView = Provider.of<TsbViewModel>(context, listen: false);
      final selectView =
          Provider.of<SelectionsViewModel>(context, listen: false);
      tsbView.fetchTsbData();
      selectView.fetchProductBrand();
      selectView.fetchTsbProductCateg();
      selectView.fetchEngineModel();
      selectView.fetchComponentGroup();
      selectView.fetchProductModel();
      selectView.fetchStockProductionLot();
      selectView.fetchTypePartTsb();
      selectView.fetchProduct();
      selectView.fetchDocumentNumber("tsb");
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: TSBPage.pageName,
      body: Consumer2<TsbViewModel, ProfileViewModel>(
          builder: (context, viewModel, providerProfile, child) {
        return Column(
          children: [
            const SearchWidget(),
            ListCondition(
              viewModel: viewModel,
              showedData: viewModel.filteredTsbDataList,
              onRefresh: () async {
                FocusScope.of(context).unfocus();
                await viewModel.fetchTsbData();
                viewModel.clearSearch();
              },
              child: ListView.builder(
                  itemCount: viewModel.filteredTsbDataList.length,
                  padding: EdgeInsets.fromLTRB(
                      mainPadding, 0, mainPadding, mainPadding * 5.5),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        final result = await navPush(
                          context,
                          TsbDetailFormPages(
                            isForm: false,
                            tsbData: viewModel.filteredTsbDataList[index],
                          ),
                        );
                        if (result == true) {
                          viewModel.fetchTsbData();
                        }
                      },
                      child: ItemTsbWidget(
                        tsbdata: viewModel.filteredTsbDataList[index],
                      ),
                    );
                  }),
            )
          ],
        );
      }),
      floatingBt: DefaultFloatButton(
        onTap: () async {
          navPush(
            context,
            const TsbDetailFormPages(),
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
      ),
    );
  }
}
