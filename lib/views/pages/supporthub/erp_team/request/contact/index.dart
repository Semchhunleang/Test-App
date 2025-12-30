import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/supporthub/erp_team/request_contact_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/views/pages/supporthub/erp_team/request/contact/form.dart';
import 'package:umgkh_mobile/views/pages/supporthub/erp_team/widget/item_contact_widget.dart';
import 'package:umgkh_mobile/widgets/custom_drop_list.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/float_bt.dart';
import 'package:umgkh_mobile/widgets/list_condition.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class RequestContactPage extends StatefulWidget {
  static const routeName = '/request-contact';
  static const pageName = 'ERP Request Contact';
  const RequestContactPage({super.key});

  @override
  State<RequestContactPage> createState() => _RequestContactPageState();
}

class _RequestContactPageState extends State<RequestContactPage> {
  @override
  void initState() {
    super.initState();
    final vm1 = Provider.of<RequestContactViewModel>(context, listen: false);
    final vm2 = Provider.of<SelectionsViewModel>(context, listen: false);
    vm1.resetData();
    vm1.fetchData();
    vm1.checkOutsideWorkingHours();
    vm2.fetchSupportHubState();
    vm2.fetchContactType();
    vm2.fetchAllEmployee();
  }

  @override
  Widget build(BuildContext context) => Consumer<RequestContactViewModel>(
      builder: (context, viewModel, _) => CustomScaffold(
          title: RequestContactPage.pageName,
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
                      Expanded(
                          flex: 2,
                          child: Consumer<SelectionsViewModel>(
                              builder: (context, vm, _) => CustomDropList(
                                  selected: viewModel.selectedState,
                                  items: vm.supportHubState
                                      .where((e) =>
                                          ['erp', 'all'].contains(e.team))
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
                        ItemContactWidget(data: viewModel.showedData[i])))
          ]),
          floatingBt: DefaultFloatButton(onTap: () async {
            if (mounted) {
              await navPush(context, const ERPRequestContactFormAndInfoPage());
              viewModel.fetchData();
            }
          })));
}
