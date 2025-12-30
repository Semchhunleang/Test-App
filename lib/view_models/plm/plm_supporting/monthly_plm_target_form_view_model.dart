import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/plm/plm_supporting/plm_target/plm_supporting.dart';

class MonthlyPlmTargetFormViewModel extends ChangeNotifier {
  TextEditingController employeeCtrl = TextEditingController();
  TextEditingController deptCtrl = TextEditingController();
  TextEditingController jobCtrl = TextEditingController();

  void setInfo(PLMTarget data) {
    employeeCtrl.text = data.employee.name;
    deptCtrl.text = data.employee.department?.name ?? '';
    jobCtrl.text = data.employee.jobTitle;
  }

  void resetForm() {
    employeeCtrl.clear();
    deptCtrl.clear();
    jobCtrl.clear();
  }
}
