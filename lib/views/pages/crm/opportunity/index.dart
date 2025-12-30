import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/views/pages/crm/opportunity/form_and_info.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/float_bt.dart';
import 'package:umgkh_mobile/widgets/list_condition.dart';

import '../../../../utils/navigator.dart';
import '../../../../utils/theme.dart';
import '../../../../view_models/opportunity_view_model.dart';
import '../../../../view_models/selections_view_model.dart';
import '../../../../widgets/textfield.dart';
import 'widget/item_opportunity.dart';
import 'widget/utils_opportunity_widget.dart';

class OpportunityPage extends StatefulWidget {
  static const routeName = '/opportunity-unit';
  static const pageName = 'Opportunity Unit';
  final String serviceType;
  const OpportunityPage({super.key, required this.serviceType});

  @override
  State<OpportunityPage> createState() => _OpportunityPageState();
}

class _OpportunityPageState extends State<OpportunityPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selectionsProvider =
          Provider.of<SelectionsViewModel>(context, listen: false);
      final opportunityProvider =
          Provider.of<OpportunityViewModel>(context, listen: false);
      selectionsProvider.fetchStages();
      opportunityProvider.fetchOpportunity(widget.serviceType);
      selectionsProvider.fetchCustomer();
      selectionsProvider.fetchState(116);
      selectionsProvider.fetchCountry();
      selectionsProvider.fetchSaleTeam();
      selectionsProvider.fetchActType();
      opportunityProvider.onClearDataRefresh(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OpportunityViewModel>(
      builder: (context, viewModel, child) {
        return CustomScaffold(
            title: widget.serviceType == "unit"
                ? OpportunityPage.pageName
                : "Opportunity Sparepart",
            body: Column(
              children: [
                Card(
                  margin: EdgeInsets.symmetric(
                      horizontal: mainPadding, vertical: mainPadding / 2),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),),
                  color: primaryColor.withOpacity(0.1),
                  child: Padding(
                    padding: EdgeInsets.all(mainPadding),
                    child: Column(
                      children: [
                        /// search
                        SearchTextfield(
                            ctrl: viewModel.searchController,
                            onChanged: (value) {
                              viewModel.search = value;
                            }),
                        heith10Space,
                        selectStages(
                            selected: viewModel.selectedStage,
                            onChanged: viewModel.onChangeStage),
                      ],
                    ),
                  ),
                ),
                ListCondition(
                  viewModel: viewModel,
                  showedData: viewModel.filterOpportunity,
                  onRefresh: () async {
                    viewModel.onClearDataRefresh(context);
                    viewModel.fetchOpportunity(widget.serviceType);
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(
                        mainPadding, 0, mainPadding, mainPadding * 5.5),
                    itemCount: viewModel.filterOpportunity.length,
                    itemBuilder: (context, index) {
                      return ItemOpportunityWidget(
                        opportunity: viewModel.filterOpportunity[index],
                        serviceType: widget.serviceType,
                      );
                    },
                  ),
                ),
              ],
            ),
            floatingBt: DefaultFloatButton(onTap: () async {
              if (mounted) {
                final result = await navPush(
                    context,
                    OpportunityFormInfo(
                      serviceType: widget.serviceType,
                    ));
                if (result == true) {
                  viewModel.fetchOpportunity(widget.serviceType);
                }
              }
            }));
      },
    );
  }
}
