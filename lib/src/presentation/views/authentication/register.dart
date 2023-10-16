import 'package:cubex/src/presentation/views/authentication/login.dart';
import 'package:cubex/src/presentation/widgets/app/cb_scaffold.dart';
import 'package:cubex/src/presentation/widgets/appbars/app_bar.dart';
import 'package:cubex/src/presentation/widgets/buttons/bordered_button.dart';
import 'package:cubex/src/presentation/widgets/buttons/theme_button.dart';
import 'package:cubex/src/presentation/widgets/textfields/textfield.dart';
import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/textstyles.dart';
import 'package:cubex/src/core/state_registry.dart';
import 'package:cubex/src/core/utils/navigator.dart';
import 'package:cubex/src/core/utils/spacer.dart';
import 'package:cubex/src/core/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cubex/src/core/utils/extensions.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RegisterPage extends StatefulHookWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    var emailController = useTextEditingController();
    var passwordController = useTextEditingController();
    var nameController = useTextEditingController();
    var authState = useProvider(authProvider);

    return CbScaffold(
      appBar: CbAppBar(
        title: 'Get Started! 🎉',
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                YMargin(16),
                Padding(
                  padding: const EdgeInsets.only(right: 80.0),
                  child: Text(
                    'Fill in your details to set up your account and get started on Cubex.',
                    style: CbTextStyle.book14,
                  ),
                ),
                YMargin(40),
                CbTextField(
                    label: 'Full name',
                    hint: 'Full name',
                    textCapitalization: TextCapitalization.words,
                    controller: nameController,
                    validator: Validators.validateFullName),
                YMargin(16),
                CbTextField(
                    label: 'Email address',
                    hint: 'Email address',
                    controller: emailController,
                    validator: Validators.validateEmail),
                YMargin(16),
                CbTextField(
                    label: 'Create password',
                    hint: 'Create password',
                    controller: passwordController,
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
                  text: 'Create account',
                  loadingState: authState.registerBusy,
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    Map<String, dynamic> data = {
                      'firstName': nameController.text.split(' ')[0],
                      'lastName': nameController.text.split(' ')[1],
                      'email': emailController.text,
                      'password': passwordController.text
                    };
                    authState.register(data: data, context: context);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 56),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Container(
                              margin: const EdgeInsets.only(right: 25.0),
                              child: Divider(
                                color: CbColors.cAccentLighten5,
                                height: 1,
                              ))),
                      Text("Or",
                          style: CbTextStyle.book14
                              .copyWith(color: CbColors.cAccentLighten4)),
                      Expanded(
                          child: Container(
                              margin: const EdgeInsets.only(
                                left: 25.0,
                              ),
                              child: Divider(
                                color: CbColors.cAccentLighten5,
                                height: 1,
                              ))),
                    ],
                  ),
                ),
                CbBorderedButton(
                  withIcon: true,
                  text: 'Sign up with Google',
                  icon: SvgPicture.asset(
                    'google'.svg,
                  ),
                  buttonColor: CbColors.cPrimaryBase,
                  textColor: CbColors.cPrimaryBase,
                  onPressed: () {
                    authState.googleSignUp(context: context);
                  },
                ),
                YMargin(62),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => navigate(LoginPage()),
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "Already on Cubex? ",
                          style: CbTextStyle.book16
                              .copyWith(color: CbColors.cAccentLighten4)),
                      TextSpan(
                          text: "Sign in to your account",
                          style: CbTextStyle.medium
                              .copyWith(color: CbColors.cPrimaryBase))
                    ])),
                  ),
                ),
                YMargin(40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
