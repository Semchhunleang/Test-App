import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/view_models/approve_request_overtime_form_view_model.dart';
import 'package:umgkh_mobile/view_models/access_levels_view_model.dart';
import 'package:umgkh_mobile/view_models/global_provider.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/views/pages/hr/approve_request_overtime/widget/confirmation_batch_ot_widget.dart';
import 'package:umgkh_mobile/views/pages/hr/approve_request_overtime/widget/select_approval_ot_list_widget.dart';
import 'package:umgkh_mobile/views/pages/hr/request_overtime/form.dart';
import 'package:umgkh_mobile/widgets/float_bt.dart';
import 'package:umgkh_mobile/widgets/list_condition.dart';
import '../../../../utils/theme.dart';
import '../../../../view_models/approve_request_overtime_view_model.dart';
import '../../../../widgets/custom_scaffold.dart';
import 'widget/search_block_widget.dart';
import 'widget/widget_item_approval_overtime.dart';

class ApproveRequestOvertimePage extends StatefulWidget {
  static const routeName = '/approve_request_overtime';
  static const namePage = 'Request Overtime';
  const ApproveRequestOvertimePage({super.key});

  @override
  State<ApproveRequestOvertimePage> createState() =>
      _ApproveRequestOvertimePageState();
}

class _ApproveRequestOvertimePageState
    extends State<ApproveRequestOvertimePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GlobalProvider>(context, listen: false);
      final vm1 =
          Provider.of<ApproveRequestOvertimeViewModel>(context, listen: false);
      final vm2 = Provider.of<SelectionsViewModel>(context, listen: false);
      final vm3 = Provider.of<AccessLevelViewModel>(context, listen: false);

      vm1.fetchApproveRequestOT();
      vm1.onClearSelect();
      vm2.fetchAllEmployee();
      vm3.fetchLocal();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: ApproveRequestOvertimePage.namePage,
      body: Consumer2<ApproveRequestOvertimeViewModel,
              ApproveRequestOvertimeFormViewModel>(
          builder: (context, viewModel, updateStateProvider, child) {
        return Column(
          children: [
            const SearchBlockWidget(),
            if (viewModel.filterApprovalOTList.isNotEmpty &&
                (viewModel.selectedState == submit ||
                    viewModel.selectedState == "all"))
              Padding(
                padding: EdgeInsets.fromLTRB(mainPadding, 0, mainPadding, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (viewModel.isSelected) ...[
                          TextButton(
                            onPressed: () {
                              popUpConfirmation(context, state: approveDH);
                            },
                            child: Text(
                              "Approve",
                              style: primary13Bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              popUpConfirmation(context, state: reject);
                            },
                            child: Text(
                              "Reject",
                              style: primary13Bold.copyWith(color: redColor),
                            ),
                          ),
                        ],
                        const Spacer(),
                        // TextButton(
                        //   onPressed: () => viewModel.onSelected(),
                        //   child: Text(
                        //     !viewModel.isSelected ? "Select" : "Cancel",
                        //     style: primary13Bold,
                        //   ),
                        // ),
                      ],
                    ),
                    if (viewModel.selectedState == submit &&
                        viewModel.isSelected &&
                        viewModel.filterApprovalOTList.isNotEmpty)
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => viewModel
                                .onSelectedAll(viewModel.filterApprovalOTList),
                            icon: Icon(viewModel.isSelectedAll
                                ? Icons.check_box_sharp
                                : Icons.check_box_outline_blank),
                          ),
                          Text(
                            "Select All (${viewModel.selectedRequests.length})",
                            style: primary13Bold.copyWith(color: primaryColor),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ListCondition(
              viewModel: viewModel,
              showedData: viewModel.filterApprovalOTList,
              onRefresh: () async {
                await viewModel.fetchApproveRequestOT();
                viewModel.year = DateTime.now().year;
                viewModel.selectedState = "all";
                viewModel.searchController.text = "";
                viewModel.search = "";
                viewModel.onClearSelect();
              },
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(
                    mainPadding, 0, mainPadding, mainPadding * 5.5),
                itemCount: viewModel.filterApprovalOTList.length,
                itemBuilder: (context, index) {
                  final request = viewModel.filterApprovalOTList[index];
                  final isSelected =
                      viewModel.selectedRequests.contains(request.id);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Stack(
                      children: [
                        WidgetItemApprovalOvertime(
                            requestOvertimeList: request),
                        if (viewModel.isSelected)
                          Positioned.fill(
                            child: SelectApprovalOTListWidget(
                                onTap: () => viewModel.toggleSelection(
                                    request.id, request.state!, context),
                                isSelected: isSelected),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
      floatingBt: DefaultFloatButton(onTap: () async {
        final result =
            await navPush(context, const CreateRequestOvertimePage());
        if (result == true) {
          // Fetch data after returning from CreateRequestOvertimePage
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Provider.of<ApproveRequestOvertimeViewModel>(context, listen: false)
                .fetchApproveRequestOT();
          });
        }
      }),
    );
  }
}
