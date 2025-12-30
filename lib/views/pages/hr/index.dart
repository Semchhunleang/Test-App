import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/access_levels_view_model.dart';
import 'package:umgkh_mobile/views/pages/hr/approve_employee_overtime_dh/index.dart';
import 'package:umgkh_mobile/views/pages/hr/approve_employee_overtime_hr/index.dart';
import 'package:umgkh_mobile/views/pages/hr/approve_leave/index.dart';
import 'package:umgkh_mobile/views/pages/hr/approve_request_overtime/index.dart';
import 'package:umgkh_mobile/views/pages/hr/overtime/index.dart';
import 'package:umgkh_mobile/views/pages/hr/request_overtime/index.dart';
import 'package:umgkh_mobile/views/pages/hr/survey/index.dart';
import 'package:umgkh_mobile/views/pages/hr/take_leave/index.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';

class HRPage extends StatefulWidget {
  static const routeName = '/hr';
  static const pageName = 'HR ';
  const HRPage({super.key});

  @override
  State<HRPage> createState() => _HRPageState();
}

class _HRPageState extends State<HRPage> {
  @override
  Widget build(BuildContext context) => Consumer<AccessLevelViewModel>(
        builder: (context, viewModel, _) => CustomScaffold(
          title: HRPage.pageName,
          body: ListView(
            physics: kBounce,
            padding: EdgeInsets.symmetric(horizontal: mainPadding),
            children: [
              item(
                  name: 'Take Leave',
                  page: const TakeLeavePage(),
                  image: 'assets/icons/hr/leave_hr_icon.png'),
              if (viewModel.accessLevel.isDh == 1) ...[
                item(
                    name: 'Approve Leave',
                    page: const ApproveLeavePage(),
                    image: 'assets/icons/hr/approve_leave_hr_icon.png')
              ],
              if (viewModel.hasReadReqOT()) ...[
                item(
                    name: 'Request Overtime',
                    page: const RequestOvertimePage(),
                    image: 'assets/icons/hr/request_overtime_icon.png')
              ],
              if (viewModel.hasSubmitReqOT()) ...[
                item(
                    name: 'Request Overtime',
                    page: const ApproveRequestOvertimePage(),
                    image: 'assets/icons/hr/approve_request_overtime_icon.png')
              ],
              if (viewModel.hasReadOT()) ...[
                item(
                    name: 'Overtime',
                    page: const EmployeeOvertimePage(),
                    image: 'assets/icons/hr/overtime_icon.png')
              ],
              if (viewModel.hasSubmitOT() || viewModel.hasApproveOT()) ...[
                item(
                    name: 'Overtime',
                    page: const ApproveEmployeeOvertimeDhPage(),
                    image: 'assets/icons/hr/approve_overtime_icon.png')
              ],
              if (viewModel.accessLevel.isHc == 1 ||
                  viewModel.accessLevel.isHrd == 1 ||
                  viewModel.accessLevel.isHrc == 1) ...[
                item(
                    name: 'HR Approve Overtime',
                    page: const ApproveEmployeeOvertimeHrPage(),
                    image: 'assets/icons/hr/approve_overtime_icon.png')
              ],
              item(
                  name: 'Survey',
                  page: const SurveyPage(),
                  image: 'assets/icons/hr/survey_icon.png'),
            ],
          ),
        ),
      );

  Widget item(
          {required String name,
          required Widget page,
          required String image}) =>
      GestureDetector(
          onTap: () => navPush(context, page),
          child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(mainRadius)),
              color: primaryColor,
              margin: EdgeInsets.symmetric(vertical: mainPadding / 2),
              child: Padding(
                  padding: EdgeInsets.all(mainPadding * 1.2),
                  child: Row(children: [
                    Image.asset(image, height: 25, color: whiteColor),
                    widthSpace,
                    Text(name, style: white13Bold)
                  ]))));
}
