import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/plm/plm_supporting/plm_achievement/plm_achievement.dart';
import 'package:umgkh_mobile/services/api/plm/plm_supporting/plm_supporting_service.dart';
import 'package:umgkh_mobile/utils/show_dialog.dart';
import 'package:umgkh_mobile/view_models/plm/plm_supporting/monthly_plm_achievement_view_model.dart';

class MonthlyPlmAchievementFormViewModel extends ChangeNotifier {
  TextEditingController departmentCtrl = TextEditingController();
  TextEditingController jobPositionCtrl = TextEditingController();
  TextEditingController employeeCtrl = TextEditingController();

  void setDefaultData(PLMAchievement data) {
    departmentCtrl.clear();
    jobPositionCtrl.clear();
    employeeCtrl.clear();

    employeeCtrl.text = data.employee.name;
    departmentCtrl.text = data.department?.name ?? '';
    jobPositionCtrl.text = data.job?.name ?? '';
    notifyListeners();
  }

  Future<void> updateDailyEmployeePLM(
      BuildContext context, List<Map<String, dynamic>> data) async {
    try {
      await PLMSupportingAPIService()
          .updateDailyPLMEmployee(data)
          .then((value) {
        if (context.mounted) {
          if (!value.message!.contains('error')) {
            showResultDialog(
              context,
              '${value.message}',
              isBackToList: true,
              isDone: true,
              onTap: () {
                final vm = Provider.of<MonthlyPlmAchievementViewModel>(context,
                    listen: false);
                Navigator.pop(context, true);
                Navigator.pop(context, true);
                Navigator.pop(context, true);
                vm.fetchMonthlyPLMAchievement();
              },
            );
          } else {
            showResultDialog(context, '${value.message}', isBackToList: false);
          }
        }
        notifyListeners();
      });
    } catch (e) {
      debugPrint('Error updating daily PLM employee: $e');
    }
  }

  Future<void> updateWeeklyEmployeePLM(
      BuildContext context, int id, int achievement) async {
    Map<String, dynamic> data = {
      'id': id,
      'achievement': achievement,
    };
    try {
      await PLMSupportingAPIService()
          .updateWeeklyPLMEmployee(data)
          .then((value) {
        if (context.mounted) {
          !value.message!.contains('error')
              ? showResultDialog(context, '${value.message}',
                  isBackToList: true, isDone: true, onTap: () {
                  final vm = Provider.of<MonthlyPlmAchievementViewModel>(
                      context,
                      listen: false);
                  Navigator.pop(context, true);
                  Navigator.pop(context, true);
                  Navigator.pop(context, true);
                  vm.fetchMonthlyPLMAchievement();
                })
              : showResultDialog(context, '${value.message}',
                  isBackToList: false);
        }
        notifyListeners();
      });
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> updateMonthlyEmployeePLM(
      BuildContext context, int id, int achievement) async {
    Map<String, dynamic> data = {
      'id': id,
      'achievement': achievement,
    };
    try {
      await PLMSupportingAPIService()
          .updateMonthlyPLMEmployee(data)
          .then((value) {
        if (context.mounted) {
          !value.message!.contains('error')
              ? showResultDialog(context, '${value.message}',
                  isBackToList: true, isDone: true, onTap: () {
                  final vm = Provider.of<MonthlyPlmAchievementViewModel>(
                      context,
                      listen: false);
                  Navigator.pop(context, true);
                  Navigator.pop(context, true);
                  Navigator.pop(context, true);
                  vm.fetchMonthlyPLMAchievement();
                })
              : showResultDialog(context, '${value.message}',
                  isBackToList: false);
        }
        notifyListeners();
      });
    } catch (e) {
      debugPrint('$e');
    }
  }
}
