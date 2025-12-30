import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/field_service_form_view_model.dart';
import 'package:umgkh_mobile/view_models/field_service_view_model.dart';
import 'package:umgkh_mobile/view_models/timesheet_form_view_model.dart';
import 'package:umgkh_mobile/views/pages/service/workshop/widget/build_item_info.dart';
import 'package:umgkh_mobile/views/pages/service/workshop/widget/build_lines.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';

class WorkshopInfoPage extends StatefulWidget {
  const WorkshopInfoPage({
    super.key,
  });

  @override
  State<WorkshopInfoPage> createState() => _WorkshopInfoPageState();
}

class _WorkshopInfoPageState extends State<WorkshopInfoPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final p = Provider.of<FieldServiceFormViewModel>(context, listen: false);
      final p2 = Provider.of<FieldServiceViewModel>(context, listen: false);
      p2.checkUpdateStage(p2.selectedData!);
      p.resetForm();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<FieldServiceFormViewModel, TimesheetFormViewModel,
        FieldServiceViewModel>(
      builder: (context, viewModel, timesheet, fsvm, _) {
        return CustomScaffold(
          title: 'Workshop Info',
          isLoading: viewModel.isLoading || timesheet.isLoading,
          action: [
            IconButton(
              onPressed: viewModel.onchangeDrop,
              iconSize: 15,
              tooltip: 'Hide & show field service info',
              icon: Icon(viewModel.isHideDrop
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded),
            )
          ],
          body: Column(
            children: [
              if (!viewModel.isHideDrop) ...[
                const BuildItemInfo(),
                heith10Space
              ],
              const BuildLinesFS()
            ],
          ),
        );
      },
    );
  }
}
