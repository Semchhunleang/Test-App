import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/view_models/lead_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/views/pages/crm/lead/form_and_info.dart';
import 'package:umgkh_mobile/views/pages/crm/lead/widget/item_lead_widget.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/widgets/float_bt.dart';
import 'package:umgkh_mobile/widgets/list_condition.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class LeadPage extends StatefulWidget {
  static const routeName = '/lead';
  static const pageName = 'Lead';
  final bool isLeadUnit;

  const LeadPage({super.key, this.isLeadUnit = true});

  @override
  State<LeadPage> createState() => _LeadPageState();
}

class _LeadPageState extends State<LeadPage> {
  @override
  void initState() {
    super.initState();
    final p1 = Provider.of<LeadViewModel>(context, listen: false);
    final p2 = Provider.of<SelectionsViewModel>(context, listen: false);
    p1.resetData();
    p1.fetchData(widget.isLeadUnit);
    p2.fetchCustomer();
    p2.fetchState(116);
    p2.fetchCountry();
    p2.fetchSaleTeam();
    p2.fetchActType();
  }

  @override
  Widget build(BuildContext context) => Consumer<LeadViewModel>(
        builder: (context, viewModel, _) => CustomScaffold(
          title: widget.isLeadUnit ? 'Lead Unit' : 'Lead Spare Part',
          body: Column(children: [
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
                child: Column(children: [
                  /// search
                  SearchTextfield(
                      ctrl: viewModel.searchCtrl,
                      onChanged: viewModel.onSearchChanged)
                ]),
              ),
            ),

            // list
            ListCondition(
              viewModel: viewModel,
              showedData: viewModel.showedData,
              onRefresh: () =>
                  viewModel.fetchData(widget.isLeadUnit).whenComplete(() {
                viewModel.searchCtrl.clear();
              }),
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(
                    mainPadding, 0, mainPadding, mainPadding * 5.5),
                itemCount: viewModel.showedData.length,
                itemBuilder: (context, i) => ItemLeadWidget(
                    isLeadUnit: widget.isLeadUnit,
                    data: viewModel.showedData[i]),
              ),
            ),
          ]),
          floatingBt: DefaultFloatButton(onTap: () async {
            if (mounted) {
              final result = await navPush(
                  context, LeadFormAndInfoPage(isLeadUnit: widget.isLeadUnit));
              if (result == true) {
                viewModel.fetchData(widget.isLeadUnit);
              }
            }
          })));
}
