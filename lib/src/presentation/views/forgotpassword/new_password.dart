import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:cubex/src/presentation/widgets/app/cb_scaffold.dart';
import 'package:cubex/src/presentation/widgets/appbars/app_bar.dart';
import 'package:cubex/src/presentation/widgets/buttons/theme_button.dart';
import 'package:cubex/src/presentation/widgets/textfields/textfield.dart';
import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/textstyles.dart';
import 'package:cubex/src/core/state_registry.dart';
import 'package:cubex/src/core/utils/spacer.dart';
import 'package:cubex/src/core/utils/validators.dart';

class NewPasswordPage extends StatefulHookWidget {
  final String? id;
  NewPasswordPage({
    required this.id,
  });
  @override
  _NewPasswordPageState createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordNewController = TextEditingController();
  bool obscureText = true;
  bool obscureNewText = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var state = useProvider(forgotPassProvider);

    return CbScaffold(
      appBar: CbAppBar(
        title: 'New Password.',
        automaticallyImplyLeading: false,
      ),
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
                    'Create a new and secure password for your Cubex account below.',
                    style: CbTextStyle.book14,
                  ),
                ),
                YMargin(40),
                CbTextField(
                    label: 'New password',
                    hint: 'New password',
                    controller: _passwordNewController,
                    obscureText: obscureNewText,
                    suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          obscureNewText = !obscureNewText;
                        });
                      },
                      icon: obscureNewText
                          ? Icon(
                              Icons.visibility,
                              color: CbColors.cAccentLighten5,
                            )
                          : Icon(
                              Icons.visibility_off,
                              color: CbColors.cAccentLighten5,
                            ),
                    ),
                    validator: Validators.validatePassword),
                YMargin(16),
                CbTextField(
                    label: 'Confirm Password',
                    hint: 'Confirm Password',
                    controller: _passwordController,
                    obscureText: obscureText,
                    suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      icon: obscureText
                          ? Icon(
                              Icons.visibility,
                              color: CbColors.cAccentLighten5,
                            )
                          : Icon(
                              Icons.visibility_off,
                              color: CbColors.cAccentLighten5,
                            ),
                    ),
                    validator: Validators.validatePassword),
                YMargin(24),
                CbThemeButton(
                  text: 'Create password',
                  loadingState: state.changePasswrdBusy,
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    Map<String, dynamic> data = <String, dynamic>{
                      "id": widget.id,
                      "password": _passwordNewController.text
                    };

                    state.changePAssword(data: data, context: context);

                    // navigateReplaceTo(context, VerifyOtpPage());
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
