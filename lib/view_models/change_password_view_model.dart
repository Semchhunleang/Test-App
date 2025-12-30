import 'package:flutter/material.dart';
import 'package:umgkh_mobile/services/api/base/auth/token_service.dart';
import 'package:umgkh_mobile/utils/show_dialog.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class ChangePasswordViewModel extends ChangeNotifier {
  TextEditingController oldPasswordCtrl = TextEditingController();
  TextEditingController newPasswordCtrl = TextEditingController();
  TextEditingController confirmPasswordCtrl = TextEditingController();
  bool isOldVisible = false, isNewVisible = false, isConfirmVisible = false;
  bool isOldReq = false, isNewReq = false, isConfirmReq = false;

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  onCheckOld() => notify(null, (v) => isOldVisible = !isOldVisible);
  onCheckNew() => notify(null, (v) => isNewVisible = !isNewVisible);
  onCheckConfirm() => notify(null, (v) => isConfirmVisible = !isConfirmVisible);
  onChangeOld(String v) => notify(v, (v) => isOldReq = trimStr(v).isEmpty);
  onChangeNew(String v) => notify(v, (v) => isNewReq = trimStr(v).isEmpty);
  onChangeConf(String v) => notify(v, (v) => isConfirmReq = trimStr(v).isEmpty);
  bool checkMatch() => newPasswordCtrl.text != confirmPasswordCtrl.text;

  bool isValidated() {
    onChangeOld(oldPasswordCtrl.text);
    onChangeNew(newPasswordCtrl.text);
    onChangeConf(confirmPasswordCtrl.text);
    return isOldReq || isNewReq || isConfirmReq || checkMatch();
  }

  resetFom() {
    isOldVisible = isNewVisible = isConfirmVisible = true;
    isOldReq = isNewReq = isConfirmReq = false;
    oldPasswordCtrl.clear();
    newPasswordCtrl.clear();
    confirmPasswordCtrl.clear();
  }

  Future<void> updateData(BuildContext context) async {
    Map<String, dynamic> data = {
      'old_password': oldPasswordCtrl.text,
      'new_password': newPasswordCtrl.text
    };
    try {
      await AuthAPIService().changePassword(data).then((value) {
        if (context.mounted) {
          showResultDialog(context, '${value.message}',
              isBackToList: !value.message!.contains('error'),
              isDone: !value.message!.contains('error'),);
        }
      });
    } catch (e) {
      debugPrint('$e');
    }
  }
}
