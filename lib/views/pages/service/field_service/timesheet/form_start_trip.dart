import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/service-project_task/project_task/project_task.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/timesheet_form_view_model.dart';
import 'package:umgkh_mobile/views/pages/service/field_service/widget/utils_widget.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class StartTripFormPage extends StatefulWidget {
  final ProjectTask data;
  const StartTripFormPage({super.key, required this.data});

  @override
  State<StartTripFormPage> createState() => _StartTripFormPageState();
}

class _StartTripFormPageState extends State<StartTripFormPage> {
  @override
  void initState() {
    final p = Provider.of<TimesheetFormViewModel>(context, listen: false);
    p.resetValidate();
    p.resetForm();
    p.setInfoForm(widget.data);
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
            selectFleetVehicle(
                validate: provider.isSelectVehicle,
                selected: provider.selectFleetVehicle,
                onChanged: (value) {
                  provider.onChangeVehicle(value);
                  provider.odometerStartCtrl =
                      TextEditingController(text: "${value.odometer}");
                  if (provider.odometerStartCtrl.text != "") {
                    provider.isOdometerStart = false;
                  }
                }),
            heith10Space,
            InputTextField(
              ctrl: provider.odometerStartCtrl,
              title: 'Odometer Start',
              hint: 'Enter the Odometer Start',
              isValidate: provider.isOdometerStart,
              validatedText:
                  provider.isOdometerStart ? "Odometer start is required" : "",
              onChanged: provider.onChangeOdometerStart,
            ),
            heith10Space,
            selectDispatchFrom(
                validate: provider.isDispatchFrom,
                selected: provider.dispatchFrom,
                onChanged: provider.onChangeDispatchFrom),
          ],
        ),
      );
    });
  }
}
