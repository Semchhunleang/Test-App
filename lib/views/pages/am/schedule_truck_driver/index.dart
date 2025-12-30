import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/schedule_truck_driver_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/views/pages/am/schedule_truck_driver/form_and_info.dart';
import 'package:umgkh_mobile/views/pages/am/schedule_truck_driver/widget/item_schedule_truck_driver_widget.dart';
import 'package:umgkh_mobile/widgets/custom_drop_list.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/float_bt.dart';
import 'package:umgkh_mobile/widgets/list_condition.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class ScheduleTruckDriverPage extends StatefulWidget {
  static const routeName = '/schedule-truck-driver';
  static const pageName = 'Schedule Truck Driver';
  const ScheduleTruckDriverPage({super.key});

  @override
  State<ScheduleTruckDriverPage> createState() =>
      _ScheduleTruckDriverPageState();
}

class _ScheduleTruckDriverPageState extends State<ScheduleTruckDriverPage> {
  @override
  void initState() {
    super.initState();
    final vm =
        Provider.of<ScheduleTruckDriverViewModel>(context, listen: false);
    final vm2 = Provider.of<SelectionsViewModel>(context, listen: false);
    vm.resetData();
    vm.fetchData();
    vm2.fetchScheduleTruckDriverState();
    vm2.fetchScheduleTruckDriverTag();
    vm2.fetchAllEmployee();
    vm2.fetchFleetVehicle();
  }

  @override
  Widget build(BuildContext context) => Consumer<ScheduleTruckDriverViewModel>(
        builder: (context, viewModel, _) => CustomScaffold(
          title: ScheduleTruckDriverPage.pageName,
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
                    child: Column(children: [
                      SearchTextfield(
                          ctrl: viewModel.searchCtrl,
                          onChanged: viewModel.onSearchChanged),
                      heithSpace,
                      Row(children: [
                        Consumer<SelectionsViewModel>(
                            builder: (context, vm, _) => Expanded(
                                child: CustomDropList(
                                    selected: viewModel.selectedState,
                                    items: vm.scheduleTruckDriverState.toList(),
                                    itemAsString: (i) => i.name.toString(),
                                    onChanged: viewModel.onStateChanged))),
                        width10Space,
                        Consumer<SelectionsViewModel>(
                            builder: (context, vm, _) => Expanded(
                                child: CustomDropList(
                                    selected: viewModel.selectedTag,
                                    items: vm.scheduleTruckDriverTag.toList(),
                                    itemAsString: (i) => i.name.toString(),
                                    onChanged: viewModel.onTagChanged)))
                      ])
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
                    itemBuilder: (context, i) => ItemScheduleTruckDriverWidget(
                        data: viewModel.showedData[i])))
          ]),
          floatingBt: DefaultFloatButton(onTap: () async {
            if (mounted) {
              await navPush(context,
                  const ScheduleTruckDriverFormAndInfoPage(isForm: true));
              viewModel.fetchData();
            }
          }),
        ),
      );
}
