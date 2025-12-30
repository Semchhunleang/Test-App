import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/overtime_view_model.dart';
import 'package:umgkh_mobile/views/pages/hr/overtime/widget/overtime_item.dart';
import 'package:umgkh_mobile/views/pages/hr/overtime/widget/top_card_overtime.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/list_condition.dart';

class EmployeeOvertimePage extends StatefulWidget {
  static const routeName = '/employee_overtime';

  const EmployeeOvertimePage({Key? key}) : super(key: key);

  @override
  State<EmployeeOvertimePage> createState() => _EmployeeOvertimePageState();
}

class _EmployeeOvertimePageState extends State<EmployeeOvertimePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<OvertimeViewModel>(context, listen: false).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OvertimeViewModel>(
      builder: (context, viewModel, _) => CustomScaffold(
        title: 'Overtime',
        body: Column(
          children: [
            const TopCardOvertime(),
            ListCondition(
              viewModel: viewModel,
              showedData: viewModel.showedData,
              onRefresh: () => viewModel.fetchData().whenComplete(() {
                viewModel.setSelectedState('all');
                viewModel.setYear(DateTime.now().year);
                viewModel.searchCtrl.clear();
              }),
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(
                    mainPadding, 0, mainPadding, mainPadding * 5.5),
                itemCount: viewModel.showedData.length,
                itemBuilder: (context, i) => OvertimeItem(
                  data: viewModel.showedData[i],
                ),
              ),
            )
          ],
        ),
        // floatingBt: DefaultFloatButton(onTap: () async {
        //   if (mounted) {
        //     await navPush(context, const CreateEmployeeOvertimePage());
        //     viewModel.fetchData();
        //   }
        // }),
      ),
    );
  }
}
