import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/global_provider.dart';
import 'package:umgkh_mobile/view_models/request_overtime_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/views/pages/hr/request_overtime/widget/top_card_request_overtime.dart';
import 'package:umgkh_mobile/widgets/list_condition.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'widget/widget_item_request_overtime.dart';

class RequestOvertimePage extends StatefulWidget {
  static const routeName = '/request_overtime';
  static const namePage = 'Request Overtime';

  const RequestOvertimePage({Key? key}) : super(key: key);

  @override
  State<RequestOvertimePage> createState() => _RequestOvertimePageState();
}

class _RequestOvertimePageState extends State<RequestOvertimePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GlobalProvider>(context, listen: false);
      final vm1 = Provider.of<RequestOvertimeViewModel>(context, listen: false);
      final vm2 = Provider.of<SelectionsViewModel>(context, listen: false);

      vm1.fetchRequestOvertimes();
      vm2.fetchAllEmployee();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: RequestOvertimePage.namePage,
      body:
          Consumer<RequestOvertimeViewModel>(builder: (context, requestVM, _) {
        return Column(children: [
          // Search and filter section
          const TopCardRequestOvertime(),
          ListCondition(
              viewModel: requestVM,
              showedData: requestVM.filterRequestOvertimeList,
              onRefresh: () async {
                await requestVM.fetchRequestOvertimes();
                requestVM.year = DateTime.now().year;
                requestVM.selectedState = "all";
                requestVM.searchController.text = "";
                requestVM.search = "";
              },
              child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(
                      mainPadding, 0, mainPadding, mainPadding * 5.5),
                  itemCount: requestVM.filterRequestOvertimeList.length,
                  itemBuilder: (context, index) {
                    final request = requestVM.filterRequestOvertimeList[index];
                    return WidgetItemRequestOvertime(
                        requestOvertimeList: request);
                  }))
        ]);
      }),
      // floatingBt: DefaultFloatButton(onTap: () async {
      //   final result = await Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) => const CreateRequestOvertimePage()));
      //   if (result == true) {
      //     // Fetch data after returning from CreateRequestOvertimePage
      //     WidgetsBinding.instance.addPostFrameCallback((_) {
      //       Provider.of<RequestOvertimeViewModel>(context, listen: false)
      //           .fetchRequestOvertimes();
      //     });
      //   }
      // }),
    );
  }
}
