import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/view_models/supporthub/marketing_team/marketing_ticket_view_model.dart';
import 'package:umgkh_mobile/views/pages/supporthub/marketing_team/request/form.dart';
import 'package:umgkh_mobile/views/pages/supporthub/marketing_team/widget/item_marketing_ticket_widget.dart';
import 'package:umgkh_mobile/widgets/custom_drop_list.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/float_bt.dart';
import 'package:umgkh_mobile/widgets/list_condition.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class RequestMarketingTicketPage extends StatefulWidget {
  static const routName = "/request-marketing-ticket";
  static const pageName = "Request Marketing Ticket";
  const RequestMarketingTicketPage({super.key});

  @override
  State<RequestMarketingTicketPage> createState() =>
      _RequestMarketingTicketPageState();
}

class _RequestMarketingTicketPageState
    extends State<RequestMarketingTicketPage> {
  @override
  void initState() {
    super.initState();
    final vm = Provider.of<MarketingTicketViewModel>(context, listen: false);
    final vm2 = Provider.of<SelectionsViewModel>(context, listen: false);
    vm.resetData();
    vm.fetchData();
    vm2.fetchProductModel();
    vm2.fetchSupportHubState();
    vm2.fetchSupportHubMarketingProductType();
  }

  @override
  Widget build(BuildContext context) => Consumer<MarketingTicketViewModel>(
      builder: (context, viewModel, _) => CustomScaffold(
          title: RequestMarketingTicketPage.pageName,
          body: Column(children: [
            Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: primaryColor.withOpacity(0.1),
                margin: EdgeInsets.symmetric(
                    horizontal: mainPadding, vertical: mainPadding / 2),
                child: Padding(
                    padding: EdgeInsets.all(mainPadding),
                    child: Row(children: [
                      Expanded(
                        flex: 3,
                        child: SearchTextfield(
                          ctrl: viewModel.searchCtrl,
                          onChanged: (v) =>
                              viewModel.onSearchChanged(context, v),
                        ),
                      ),
                      width10Space,
                      Consumer<SelectionsViewModel>(
                        builder: (context, vm, _) => Expanded(
                          flex: 2,
                          child: CustomDropList(
                            selected: viewModel.selectedState,
                            items: vm.supportHubState
                                .where((e) => ['mkt', 'all'].contains(e.team))
                                .toList(),
                            itemAsString: (i) => i.name.toString(),
                            onChanged: viewModel.onStateChanged,
                          ),
                        ),
                      )
                    ]))),
            // list
            ListCondition(
                viewModel: viewModel,
                showedData: viewModel.showedData,
                onRefresh: () => viewModel.fetchData(),
                child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(
                        mainPadding, 0, mainPadding, mainPadding * 5.5),
                    itemCount: viewModel.showedData.length,
                    itemBuilder: (context, i) => ItemMarketingTicketWidget(
                        data: viewModel.showedData[i])))
          ]),
          floatingBt: DefaultFloatButton(onTap: () async {
            if (mounted) {
              await navPush(
                  context, const RequestMarketingTicketFormAndInfoPage());
              viewModel.fetchData();
            }
          })));
}
