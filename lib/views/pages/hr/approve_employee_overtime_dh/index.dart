import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/access_levels_view_model.dart';
import 'package:umgkh_mobile/view_models/approve_employee_overtime_dh_view_model.dart';
import 'package:umgkh_mobile/view_models/global_provider.dart';
import 'package:umgkh_mobile/views/pages/hr/overtime/form.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/float_bt.dart';
import 'package:umgkh_mobile/widgets/list_condition.dart';
import 'widget/search_block_widget.dart';
import 'widget/widget_item_approval_overtime.dart';

class ApproveEmployeeOvertimeDhPage extends StatefulWidget {
  static const routeName = '/approve_employee_overtime_dh';
  static const namePage = 'Overtime';
  const ApproveEmployeeOvertimeDhPage({super.key});

  @override
  State<ApproveEmployeeOvertimeDhPage> createState() =>
      _ApproveEmployeeOvertimeDhPageState();
}

class _ApproveEmployeeOvertimeDhPageState
    extends State<ApproveEmployeeOvertimeDhPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GlobalProvider>(context, listen: false);
      final vm1 = Provider.of<ApproveEmployeeOvertimeDHViewModel>(context,
          listen: false);
      final vm2 = Provider.of<AccessLevelViewModel>(context, listen: false);
      vm1.fetchApproveEmployeeOT();
      vm2.fetchLocal();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApproveEmployeeOvertimeDHViewModel>(
        builder: (context, listVM, _) {
      return CustomScaffold(
          title: ApproveEmployeeOvertimeDhPage.namePage,
          body: Column(children: [
            const SearchBlockWidget(),
            ListCondition(
              viewModel: listVM,
              showedData: listVM.filterApprovalOTList,
              onRefresh: () async {
                await listVM.fetchApproveEmployeeOT();
                listVM.year = DateTime.now().year;
                listVM.selectedState = "all";
                listVM.searchController.text = "";
                listVM.search = "";
              },
              child: FadeIn(
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                      mainPadding, 0, mainPadding, mainPadding * 5.5),
                  itemCount: listVM.filterApprovalOTList.length,
                  itemBuilder: (context, index) {
                    final request = listVM.filterApprovalOTList[index];
                    return WidgetItemApprovalOvertime(data: request);
                  },
                ),
              ),
            ),
          ]),
          floatingBt: DefaultFloatButton(onTap: () async {
            if (mounted) {
              await navPush(context, const CreateEmployeeOvertimePage());
              listVM.fetchApproveEmployeeOT();
            }
          }));
    });
  }
}
