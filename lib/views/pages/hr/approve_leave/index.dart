import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/approve_leave_view_model.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart';
import 'package:umgkh_mobile/views/pages/hr/approve_leave/widget/approve_leave_card.dart';
import 'package:umgkh_mobile/views/pages/hr/approve_leave/widget/top_card_approve_leave.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/list_condition.dart';

class ApproveLeavePage extends StatefulWidget {
  static const routeName = '/approval-leave';
  static const pageName = 'Leave Aproval';
  const ApproveLeavePage({Key? key}) : super(key: key);

  @override
  State<ApproveLeavePage> createState() => ApproveLeavePageState();
}

class ApproveLeavePageState extends State<ApproveLeavePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel =
          Provider.of<ApproveLeaveViewModel>(context, listen: false);
      viewModel.resetData();
      _fetchData();
      viewModel.resetStateToDefault();
    });
  }

  Future<void> _fetchData() async {
    if (mounted) {
      final viewModel =
          Provider.of<ApproveLeaveViewModel>(context, listen: false);
      await viewModel.fetchLeaves();
      viewModel.isFilterLocal = true;
    }

    if (mounted) {
      await Provider.of<ProfileViewModel>(context, listen: false)
          .fetchUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: ApproveLeavePage.pageName,
      body: Consumer<ApproveLeaveViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopCardApproveLeave(),
              Divider(
                color: theme().primaryColor,
              ),
              ListCondition(
                viewModel: viewModel,
                showedData: viewModel.filteredLeaves,
                onRefresh: _fetchData,
                child: ListView.builder(
                  itemCount: viewModel.filteredLeaves.length,
                  itemBuilder: (context, index) {
                    final leave = viewModel.filteredLeaves[index];
                    return approveLeaveCard(context: context, leave: leave);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
