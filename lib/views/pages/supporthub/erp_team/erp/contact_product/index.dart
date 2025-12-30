import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/supporthub/erp_team/request_contact_product_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/views/pages/supporthub/erp_team/widget/item_contact_product_widget.dart';
import 'package:umgkh_mobile/widgets/custom_drop_list.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/list_condition.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class RequestContactAndProductForERPPage extends StatefulWidget {
  final String type;
  static const routeName = '/erp-request-contact-product';
  static const pageNameContact = 'Request Contacts';
  static const pageNameProduct = 'Request Products';
  const RequestContactAndProductForERPPage({super.key, required this.type});

  @override
  State<RequestContactAndProductForERPPage> createState() =>
      _RequestContactAndProductForERPPageState();
}

class _RequestContactAndProductForERPPageState
    extends State<RequestContactAndProductForERPPage> {
  @override
  void initState() {
    super.initState();
    final vm1 =
        Provider.of<RequestContactProductViewModel>(context, listen: false);
    final vm2 = Provider.of<SelectionsViewModel>(context, listen: false);
    vm1.resetData();
    vm1.fetchData(widget.type);
    vm2.fetchSupportHubState();
  }

  @override
  Widget build(BuildContext context) =>
      Consumer<RequestContactProductViewModel>(
          builder: (context, viewModel, _) => CustomScaffold(
              title: widget.type == contact
                  ? RequestContactAndProductForERPPage.pageNameContact
                  : RequestContactAndProductForERPPage.pageNameProduct,
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
                    onRefresh: () => viewModel.fetchData(widget.type),
                    child: ListView.builder(
                        padding: EdgeInsets.fromLTRB(
                            mainPadding, 0, mainPadding, mainPadding * 5.5),
                        itemCount: viewModel.showedData.length,
                        itemBuilder: (context, i) => ItemContactProductWidget(
                            type: widget.type, data: viewModel.showedData[i])))
              ])));
}
