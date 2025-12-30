import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/service-project_task/project_task/project_task.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/timesheet_form_view_model.dart';
import 'package:umgkh_mobile/views/pages/service/field_service/widget/utils_widget.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class ArriveOfficeFormPage extends StatefulWidget {
  final ProjectTask data;
  final int odometerStart;
  const ArriveOfficeFormPage(
      {super.key, required this.data, this.odometerStart = 0});

  @override
  State<ArriveOfficeFormPage> createState() => _ArriveOfficeFormPageState();
}

class _ArriveOfficeFormPageState extends State<ArriveOfficeFormPage> {
  @override
  void initState() {
    final p = Provider.of<TimesheetFormViewModel>(context, listen: false);
    p.resetValidate();
    p.resetForm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimesheetFormViewModel>(
        builder: (context, provider, child) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.35,
        width: double.infinity,
        child: Column(
          children: [
            InputTextField(
              ctrl: TextEditingController(text: "${widget.odometerStart}"),
              title: 'Odometer Start',
              hint: 'Enter the Odometer Start',
              readOnly: true,
              readOnlyAndFilled: true,
            ),
            heith10Space,
            InputTextField(
              ctrl: provider.odometerEndCtrl,
              title: 'Odometer End',
              hint: 'Enter the Odometer End',
              isValidate: provider.isOdometerEnd,
              validatedText: provider.isOdometerEnd
                  ? "Odometer End is required and must be greater than Odometer Start"
                  : "",
              onChanged: (value) {
                provider.onChangeOdometerEnd(value, widget.odometerStart);
              },
            ),
            heith10Space,
            selectArriveAt(
                validate: provider.isArriveAt,
                selected: provider.arriveAt,
                onChanged: provider.onChangeArriveAt),
          ],
        ),
      );
    });
  }
}
