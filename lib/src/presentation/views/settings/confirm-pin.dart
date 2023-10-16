import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/textstyles.dart';
import 'package:cubex/src/core/state_registry.dart';
import 'package:cubex/src/core/utils/spacer.dart';
import 'package:cubex/src/presentation/widgets/app/cb_scaffold.dart';
import 'package:cubex/src/presentation/widgets/appbars/app_bar.dart';
import 'package:cubex/src/presentation/widgets/buttons/theme_button.dart';

class ConfirmPinPage extends StatefulHookWidget {
  final VoidCallback callback;
  final bool loadingState;
  ConfirmPinPage({
    required this.callback,
    this.loadingState = false,
  });
  @override
  _ConfirmPinPageState createState() => _ConfirmPinPageState();
}

class _ConfirmPinPageState extends State<ConfirmPinPage> {
  final TextEditingController _pinController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var authState = useProvider(authProvider);
    return CbScaffold(
      appBar: CbAppBar(
        title: 'Transaction PIN.',
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              YMargin(40),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 40.0),
                child: Text(
                  'Confirm Transaction Pin',
                  style: CbTextStyle.book14,
                ),
              ),
              YMargin(24),
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
                      obscureText: true,
                      obscuringCharacter: '*',
                      animationType: AnimationType.fade,
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
                          Map<String, dynamic> data = <String, dynamic>{
                            "pin": _pinController.text,
                          };
                          authState.validatePin(
                              context: context,
                              data: data,
                              callback: widget.callback);
                        }
                      },
                      beforeTextPaste: (text) {
                        return true;
                      },
                    )),
              ),
              YMargin(24),
              CbThemeButton(
                text: 'Continue',
                loadingState: widget.loadingState || authState.pinBusy,
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  Map<String, dynamic> data = <String, dynamic>{
                    "pin": _pinController.text,
                  };
                  authState.validatePin(
                      context: context, data: data, callback: () {});
                },
              ),
              YMargin(24),
            ],
          ),
        ),
      ),
    );
  }
}
