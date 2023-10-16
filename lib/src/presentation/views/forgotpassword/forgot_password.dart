import 'package:cubex/src/presentation/views/authentication/login.dart';
import 'package:cubex/src/presentation/widgets/app/cb_scaffold.dart';
import 'package:cubex/src/presentation/widgets/appbars/app_bar.dart';
import 'package:cubex/src/presentation/widgets/buttons/theme_button.dart';
import 'package:cubex/src/presentation/widgets/textfields/textfield.dart';
import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/textstyles.dart';
import 'package:cubex/src/core/state_registry.dart';
import 'package:cubex/src/core/utils/navigator.dart';
import 'package:cubex/src/core/utils/spacer.dart';
import 'package:cubex/src/core/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ForgotPasswordPage extends StatefulHookWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var state = useProvider(forgotPassProvider);
    return CbScaffold(
      appBar: CbAppBar(
        title: 'Forgot Password?',
        automaticallyImplyLeading: true,
      ),
      persistentFooterButtons: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: GestureDetector(
                  onTap: () => navigate(LoginPage()),
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "Remember password?",
                        style: CbTextStyle.book16
                            .copyWith(color: CbColors.cAccentLighten4)),
                    TextSpan(
                        text: " Sign in",
                        style: CbTextStyle.medium
                            .copyWith(color: CbColors.cPrimaryBase))
                  ])))),
        )
      ],
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                YMargin(16),
                Padding(
                  padding: const EdgeInsets.only(right: 40.0),
                  child: Text(
                    'Kindly enter your registered email address or phone number to reset your password...',
                    style: CbTextStyle.book14,
                  ),
                ),
                YMargin(40),
                CbTextField(
                    label: 'Email address/phone number',
                    hint: 'Email address/phone number',
                    controller: _emailController,
                    validator: Validators.validateField),
                YMargin(24),
                CbThemeButton(
                  text: 'Proceed',
                  loadingState: state.forgotPassBusy,
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    Map<String, dynamic> data = <String, dynamic>{
                      "phoneNumber": _emailController.text,
                      "email": _emailController.text
                    };
                    state.forgotPAssword(
                        data: data,
                        username: _emailController.text,
                        context: context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
