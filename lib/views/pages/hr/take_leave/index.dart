import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/take_leave_view_model.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart';
import 'package:umgkh_mobile/views/pages/hr/take_leave/form.dart';
import 'package:umgkh_mobile/views/pages/hr/take_leave/widget/leave_card.dart';
import 'package:umgkh_mobile/views/pages/hr/take_leave/widget/top_card_take_leave.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/float_bt.dart';
import 'package:umgkh_mobile/widgets/list_condition.dart';

class TakeLeavePage extends StatefulWidget {
  static const routeName = '/take-leave';
  static const pageName = 'Leave';
  const TakeLeavePage({Key? key}) : super(key: key);

  @override
  State<TakeLeavePage> createState() => TakeLeavePageState();
}

class TakeLeavePageState extends State<TakeLeavePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _resetDate();
      _fetchData();
    });
  }

  Future<void> _resetDate() async {
    await Provider.of<TakeLeaveViewModel>(context, listen: false).resetData();
  }

  Future<void> _fetchData() async {
    if (mounted) {
      await Provider.of<TakeLeaveViewModel>(context, listen: false)
          .fetchLeaves();
    }

    if (mounted) {
      await Provider.of<ProfileViewModel>(context, listen: false)
          .fetchUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        title: TakeLeavePage.pageName,
        body: Consumer<TakeLeaveViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TopCardTakeLeave(),
                Divider(
                  color: theme().primaryColor,
                ),
                ListCondition(
                  viewModel: viewModel,
                  showedData: viewModel.filteredLeaves,
                  onRefresh: _fetchData,
                  child: ListView.builder(
                    physics: kBounce,
                    padding: EdgeInsets.only(
                        left: mainPadding / 3,
                        right: mainPadding / 3,
                        bottom: mainPadding * 6),
                    itemCount: viewModel.filteredLeaves.length,
                    itemBuilder: (context, index) {
                      final leave = viewModel.filteredLeaves[index];
                      return leaveCard(context: context, leave: leave);
                    },
                  ),
                ),
              ],
            );
          },
        ),
        floatingBt: DefaultFloatButton(onTap: () async {
          if (mounted) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TakeLeaveFormPage(),
              ),
            );
            _fetchData();
          }
        }));
  }
}
