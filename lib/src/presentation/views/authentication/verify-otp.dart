import 'package:cubex/src/presentation/widgets/app/cb_scaffold.dart';
import 'package:cubex/src/presentation/widgets/appbars/app_bar.dart';
import 'package:cubex/src/presentation/widgets/buttons/theme_button.dart';
import 'package:cubex/src/presentation/widgets/textfields/textfield.dart';
import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/textstyles.dart';
import 'package:cubex/src/core/state_registry.dart';

import 'package:cubex/src/core/utils/spacer.dart';
import 'package:cubex/src/core/utils/validators.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class VerifyOtpPage extends StatefulHookWidget {
  @override
  _VerifyOtpPageState createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _pinCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var authState = useProvider(authProvider);

    return CbScaffold(
      appBar: CbAppBar(
        title: 'Confirm Account.',
        automaticallyImplyLeading: false,
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
                padding: const EdgeInsets.only(right: 80.0),
                child: Text(
                  'Input the OTP sent to your email address to confirm your account.',
                  style: CbTextStyle.book14,
                ),
              ),
              YMargin(40),
              Form(
                key: _formKey,
                child:
                    //    Padding(
                    //       padding: const EdgeInsets.symmetric(
                    //           vertical: 8.0, horizontal: 10),
                    //       child: PinCodeTextField(
                    //         appContext: context,
                    //         pastedTextStyle: TextStyle(
                    //           color: Colors.green.shade600,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //         length: 6,
                    //         obscureText: false,
                    //         obscuringCharacter: '*',
                    //         autovalidateMode: AutovalidateMode.disabled,
                    //         animationType: AnimationType.fade,
                    //         validator: (v) {
                    //           if (v!.length < 6) {
                    //             return "Otp Code must be 8 digit";
                    //           } else {
                    //             return null;
                    //           }
                    //         },

                    //         pinTheme: PinTheme(
                    //           selectedColor: CbColors.cPrimaryBase,
                    //           inactiveFillColor: CbColors.cBase,
                    //           borderRadius: BorderRadius.circular(4),
                    //           shape: PinCodeFieldShape.box,
                    //           activeFillColor: CbColors.cDarken1,
                    //           borderWidth: .5,
                    //           inactiveColor: CbColors.cAccentLighten5,
                    //           selectedFillColor: CbColors.cDarken1,
                    //           fieldHeight: 56,
                    //           fieldWidth: 50,
                    //         ),
                    //         controller: _pinCodeController,
                    //         animationDuration: Duration(milliseconds: 300),
                    //         textStyle: TextStyle(fontSize: 20, height: 1.6),
                    //         enableActiveFill: true,
                    //         // controller: model.otpController,
                    //         keyboardType: TextInputType.number,
                    //         onChanged: (value) {
                    //           // print(value);
                    //           // print(_pinCodeController!.value);
                    //         },
                    //         beforeTextPaste: (text) {
                    //           return true;
                    //         },
                    //       )),
                    CbTextField(
                        label: 'Code',
                        hint: 'Enter Code',
                        keyboardType: TextInputType.number,
                        controller: _pinCodeController,
                        validator: Validators.validateField),
              ),
              YMargin(23),
              CbThemeButton(
                text: 'Submit',
                loadingState: authState.resendBusy || authState.verifyBusy,
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  // if (_pinCodeController.text == '') {
                  //   showErrorToast(message: 'Please enter the OTP code');
                  //   return;
                  // }
                  authState.verifyEmail(
                      code: _pinCodeController.text, context: context);
                },
              ),
              YMargin(10),
              GestureDetector(
                // onTap: () => navigate(RegisterScreen()),
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: "Didn’t receive code?",
                      style: CbTextStyle.book16
                          .copyWith(color: CbColors.cAccentLighten4)),
                  TextSpan(
                      text: " Resend",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          authState.resendOtp();
                        },
                      style: CbTextStyle.medium
                          .copyWith(color: CbColors.cPrimaryBase))
                ])),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
