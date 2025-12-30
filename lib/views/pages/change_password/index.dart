import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/change_password_view_model.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class ChangePasswordPage extends StatefulWidget {
  static const routeName = '/change-password';
  static const pageName = 'Change Password';

  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  @override
  void initState() {
    final p = Provider.of<ChangePasswordViewModel>(context, listen: false);
    p.resetFom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Consumer<ChangePasswordViewModel>(
        builder: (context, viewModel, _) => CustomScaffold(
          title: ChangePasswordPage.pageName,
          resizeToAvoidBottomInset: true,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: mainPadding * 1.5),
            child: ListView(children: [
              InputTextField(
                ctrl: viewModel.oldPasswordCtrl,
                title: 'Old Password',
                hint: 'Enter old password',
                isValidate: viewModel.isOldReq,
                validatedText: viewModel.isOldReq ? 'Field required' : '',
                onChanged: viewModel.onChangeOld,
                obscureText: viewModel.isOldVisible,
                suffixIcon: IconButton(
                    iconSize: 20,
                    icon: Icon(viewModel.isOldVisible
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded),
                    onPressed: viewModel.onCheckOld),
              ),
              heithSpace,
              InputTextField(
                ctrl: viewModel.newPasswordCtrl,
                title: 'New Password',
                hint: 'Enter new password',
                isValidate: viewModel.isNewReq,
                validatedText: viewModel.isNewReq ? 'Field required' : '',
                onChanged: viewModel.onChangeNew,
                obscureText: viewModel.isNewVisible,
                suffixIcon: IconButton(
                    iconSize: 20,
                    icon: Icon(viewModel.isNewVisible
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded),
                    onPressed: viewModel.onCheckNew),
              ),
              heithSpace,
              InputTextField(
                ctrl: viewModel.confirmPasswordCtrl,
                title: 'Confirm Password',
                hint: 'Enter confirm password',
                isValidate: viewModel.isConfirmReq || viewModel.checkMatch(),
                validatedText: viewModel.isConfirmReq
                    ? 'Field required'
                    : viewModel.checkMatch()
                        ? 'Your confirm password does not match.'
                        : '',
                onChanged: viewModel.onChangeConf,
                obscureText: viewModel.isConfirmVisible,
                suffixIcon: IconButton(
                    iconSize: 20,
                    icon: Icon(viewModel.isConfirmVisible
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded),
                    onPressed: viewModel.onCheckConfirm),
              ),
              ...multiheithSpace(5),
              ButtonCustom(
                text: 'Update',
                color: primaryColor,
                onTap: () => viewModel.isValidated()
                    ? null
                    : viewModel.updateData(context),
              )
            ]),
          ),
        ),
      );
}
