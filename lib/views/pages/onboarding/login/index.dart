import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/launch_utils.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/login_view_model.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';
import 'package:umgkh_mobile/widgets/custom_text_field.dart';

class LoginPage extends StatelessWidget {
  static const routeName = '/login';
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
          // title: Text('Login', style: Theme.of(context).textTheme.titleLarge),
          ),
      body: GestureDetector(
        onTap: () {
          // Dismiss the keyboard when tapping outside the input fields
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Image logo section
                SizedBox(
                  height: screenHeight * 0.3, // 30% of screen height for image
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/text-logo-blue.png',
                      width:
                          screenWidth * 0.75, // 75% of screen width for image
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),

                // Username and Password input fields
                CustomTextField(
                  controller: _usernameController,
                  labelText: 'Username',
                  prefixIcon: Icons.person,
                  prefixText: 'EUMG-',
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  prefixIcon: Icons.lock,
                  obscureText: true,
                ),
                heith5Space,
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: mainPadding / 2),
                    child: Row(children: [
                      Expanded(
                          child: RichText(
                              text: TextSpan(children: [
                        TextSpan(
                            text:
                                "Nenam suggests you to read and understand our ",
                            style: titleStyle11.copyWith(height: 1.5)),
                        TextSpan(
                            text: "Privacy Policy",
                            style: primary12Bold.copyWith(
                                height: 1.5, fontSize: 11),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => openPrivacy()),
                        TextSpan(
                            text: ".",
                            style: titleStyle11.copyWith(height: 1.5))
                      ])))
                    ])),

                const SizedBox(height: 24.0),

                // Login button
                // Consumer<LoginViewModel>(
                //   builder: (context, viewModel, _) => viewModel.isLoading
                //       ? const CircularProgressIndicator()
                //       : ButtonCustom(
                //           text: 'Login',
                //           onTap: () {
                //             viewModel.login(
                //               context,
                //               "EUMG-${_usernameController.text.trim()}",
                //               _passwordController.text.trim(),
                //             );
                //           },
                //         ),
                // ),
                SizedBox(
                  width: screenWidth * 0.5, // 50% of screen width
                  child: Consumer<LoginViewModel>(
                    builder: (context, viewModel, _) => viewModel.isLoading
                        ? const CircularProgressIndicator()
                        : ButtonCustom(
                            text: 'Login',
                            onTap: () {
                              viewModel.login(
                                context,
                                "EUMG-${_usernameController.text.trim()}",
                                _passwordController.text.trim(),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
