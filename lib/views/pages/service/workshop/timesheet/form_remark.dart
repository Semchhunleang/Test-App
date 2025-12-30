import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/view_models/timesheet_form_view_model.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class RemarkFormPage extends StatefulWidget {
  const RemarkFormPage({super.key});

  @override
  State<RemarkFormPage> createState() => _RemarkFormPageState();
}

class _RemarkFormPageState extends State<RemarkFormPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TimesheetFormViewModel>(
        builder: (context, provider, child) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.20,
        width: double.infinity,
        child: Column(
          children: [
            MutliLineTextField(
              ctrl: provider.remarkCtrl,
              title: 'Remark',
              hint: 'Enter the Remark',
            ),
          ],
        ),
      );
    });
  }
}
