import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/supporthub/ict_team/ict_ticket_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/views/pages/supporthub/ict_team/request/form.dart';
import 'package:umgkh_mobile/views/pages/supporthub/ict_team/widget/item_ict_ticket_widget.dart';
import 'package:umgkh_mobile/widgets/custom_drop_list.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/float_bt.dart';
import 'package:umgkh_mobile/widgets/list_condition.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class RequestICTTicketPage extends StatefulWidget {
  static const routeName = '/request-ict-ticket';
  static const pageName = 'Request ICT Ticket';
  const RequestICTTicketPage({super.key});

  @override
  State<RequestICTTicketPage> createState() => _RequestICTTicketPageState();
}

class _RequestICTTicketPageState extends State<RequestICTTicketPage> {
  @override
  void initState() {
    super.initState();
    final vm = Provider.of<ICTTicketViewModel>(context, listen: false);
    final vm2 = Provider.of<SelectionsViewModel>(context, listen: false);
    vm.resetData();
    vm.fetchData();
    vm2.fetchSupportHubState();
    vm2.fetchSupportHubPriority();
    vm2.fetchSupportHubICTDevices();
    vm2.fetchSupportHubICTRequestCategory();
  }

  @override
  Widget build(BuildContext context) => Consumer<ICTTicketViewModel>(
      builder: (context, viewModel, _) => CustomScaffold(
          title: RequestICTTicketPage.pageName,
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
                                  viewModel.onSearchChanged(context, v))),
                      width10Space,
                      Consumer<SelectionsViewModel>(
                          builder: (context, vm, _) => Expanded(
                              flex: 2,
                              child: CustomDropList(
                                  selected: viewModel.selectedState,
                                  items: vm.supportHubState
                                      .where((e) =>
                                          ['ict', 'all'].contains(e.team))
                                      .toList(),
                                  itemAsString: (i) => i.name.toString(),
                                  onChanged: viewModel.onStateChanged)))
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
                    itemBuilder: (context, i) =>
                        ItemICTTicketWidget(data: viewModel.showedData[i])))
          ]),
          floatingBt: DefaultFloatButton(onTap: () async {
            if (mounted) {
              await navPush(context, const RequestICTTicketFormAndInfoPage());
              viewModel.fetchData();
            }
          })));
}
