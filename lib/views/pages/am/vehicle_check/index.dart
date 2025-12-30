import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart';
import 'package:umgkh_mobile/view_models/vehicle_check_view_model.dart';
import 'package:umgkh_mobile/views/pages/am/vehicle_check/form_and_info.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/float_bt.dart';

import '../../../../utils/navigator.dart';
import '../../../../utils/theme.dart';
import '../../../../view_models/selections_view_model.dart';
import '../../../../widgets/list_condition.dart';
import '../../../../widgets/textfield.dart';
import 'widget/item_vehicle_check_widget.dart';
import 'widget/utils_widget.dart';

class VehicleCheckPage extends StatefulWidget {
  static const routeName = '/vehicle-check';
  static const pageName = 'Vehicle Check';
  const VehicleCheckPage({super.key});

  @override
  State<VehicleCheckPage> createState() => _VehicleCheckPageState();
}

class _VehicleCheckPageState extends State<VehicleCheckPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final selectionsProvider =
          Provider.of<SelectionsViewModel>(context, listen: false);
      final provider =
          Provider.of<VehicleCheckViewModel>(context, listen: false);
      final profile = Provider.of<ProfileViewModel>(context, listen: false);

      Future.microtask(() {
        selectionsProvider.fetchAllEmployee();
        selectionsProvider.fetchState(116);
        selectionsProvider.fetchFleetVehicle();
        provider.resetData();
        provider.fetchAllVehicleCheck(profile);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<VehicleCheckViewModel, ProfileViewModel>(
        builder: (context, viewModel, profile, _) {
      return CustomScaffold(
          title: VehicleCheckPage.pageName,
          body: Column(
            children: [
              Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),),
                  color: primaryColor.withOpacity(0.1),
                  margin: EdgeInsets.symmetric(
                      horizontal: mainPadding, vertical: mainPadding / 2),
                  child: Padding(
                      padding: EdgeInsets.all(mainPadding),
                      child: Column(
                        children: [
                          SearchTextfield(
                              ctrl: viewModel.searchController,
                              onChanged: (value) {
                                viewModel.updateSearch(value, profile);
                              }),
                          heith10Space,
                          Row(children: [
                            filterSelectStatus(
                                selected: viewModel.selectedState,
                                onValue: (v) {
                                  viewModel.onStateChanged(v, profile);
                                }),
                            width10Space,
                            filterSelectPeople(
                                selected: viewModel.selectedPeople,
                                onValue: (v) =>
                                    viewModel.onPeopleChanged(v, profile),)
                          ]),
                        ],
                      ),),),
              ListCondition(
                  viewModel: viewModel,
                  showedData: viewModel.showedVehicleData,
                  onRefresh: () async {
                    await viewModel.fetchAllVehicleCheck(profile);
                    if (context.mounted) {
                      viewModel.clearFilterVehicleCheck(profile);
                    }
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(
                        mainPadding, 0, mainPadding, mainPadding * 5.5),
                    itemCount: viewModel.showedVehicleData.length,
                    itemBuilder: (context, i) => ItemVehicleCheckWidget(
                      data: viewModel.showedVehicleData[i],
                    ),
                  ),)
            ],
          ),
          floatingBt: DefaultFloatButton(onTap: () async {
            if (mounted) {
              final result = await navPush(
                  context,
                  const VehicleCheckFormInfoPage(
                    isForm: true,
                  ));
              if (result == true) {
                viewModel.fetchAllVehicleCheck(profile);
              }
            }
          }));
    });
  }
}
