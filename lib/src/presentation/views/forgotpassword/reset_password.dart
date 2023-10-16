import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:cubex/src/presentation/widgets/app/cb_scaffold.dart';
import 'package:cubex/src/presentation/widgets/appbars/app_bar.dart';
import 'package:cubex/src/presentation/widgets/buttons/theme_button.dart';
import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/textstyles.dart';
import 'package:cubex/src/core/state_registry.dart';
import 'package:cubex/src/core/utils/spacer.dart';

class ResetPasswordPage extends StatefulHookWidget {
  final String? username;
  ResetPasswordPage({
    required this.username,
  });
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _pinController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var state = useProvider(forgotPassProvider);
    return CbScaffold(
      appBar: CbAppBar(
        title: 'Reset Password.',
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              YMargin(16),
              Padding(
                padding: const EdgeInsets.only(right: 40.0),
                child: Text(
                  'Enter the 6 digit code sent to ${widget.username?.replaceRange(3, 6, "*****")} reset your paassword.',
                  style: CbTextStyle.book14,
                ),
              ),
              YMargin(40),
              Form(
                key: _formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 10),
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      obscureText: false,
                      obscuringCharacter: '*',
                      animationType: AnimationType.fade,
                      validator: (v) {
                        // if (v!.length < 6) {
                        //   return "Invalid Otp Code";
                        // } else {
                        //   return null;
                        // }
                      },

                      pinTheme: PinTheme(
                        selectedColor: CbColors.cPrimaryBase,
                        inactiveFillColor: CbColors.cBase,
                        borderRadius: BorderRadius.circular(4),
                        shape: PinCodeFieldShape.box,
                        activeFillColor: CbColors.cDarken1,
                        borderWidth: .5,
                        inactiveColor: CbColors.cAccentLighten5,
                        selectedFillColor: CbColors.cDarken1,
                        fieldHeight: 56,
                        fieldWidth: 50,
                      ),
                      controller: _pinController,
                      animationDuration: Duration(milliseconds: 300),
                      textStyle: TextStyle(fontSize: 20, height: 1.6),
                      enableActiveFill: true,
                      // controller: model.otpController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        if (value.length == 6) {
                          state.validateResetCode(
                              username: widget.username,
                              code: value,
                              context: context);
                        }
                      },
                      beforeTextPaste: (text) {
                        return true;
                      },
                    )),
              ),
              YMargin(24),
              CbThemeButton(
                text: 'Reset password',
                loadingState: state.validateBusy,
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  state.validateResetCode(
                      username: widget.username,
                      code: _pinController.text,
                      context: context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
