import 'package:cubex/src/presentation/views/authentication/register.dart';
import 'package:cubex/src/presentation/views/forgotpassword/forgot_password.dart';
import 'package:cubex/src/presentation/widgets/app/cb_scaffold.dart';
import 'package:cubex/src/presentation/widgets/appbars/app_bar.dart';
import 'package:cubex/src/presentation/widgets/buttons/bordered_button.dart';
import 'package:cubex/src/presentation/widgets/buttons/theme_button.dart';
import 'package:cubex/src/presentation/widgets/textfields/textfield.dart';
import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/textstyles.dart';
import 'package:cubex/src/core/state_registry.dart';
import 'package:cubex/src/data/datasources/local/local_storage.dart';
import 'package:cubex/src/core/utils/navigator.dart';
import 'package:cubex/src/core/utils/spacer.dart';
import 'package:cubex/src/core/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cubex/src/core/utils/extensions.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginPage extends StatefulHookWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    var emailController = useTextEditingController();
    var passwordController = useTextEditingController();
    var authState = useProvider(authProvider);

    return CbScaffold(
      appBar: CbAppBar(
        title: 'Welcome! 👋🏾',
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
                  padding: const EdgeInsets.only(right: 80.0),
                  child: Text(
                    'Input your email address and password to sign in to your account.',
                    style: CbTextStyle.book14,
                  ),
                ),
                YMargin(40),
                CbTextField(
                    label: 'Email address',
                    hint: 'Email address',
                    controller: emailController,
                    validator: Validators.validateEmail),
                YMargin(16),
                CbTextField(
                    label: 'Password',
                    hint: 'Password',
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
                  text: 'Sign in',
                  loadingState: authState.loginBusy,
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    Map<String, dynamic> data = <String, dynamic>{
                      "username": emailController.text,
                      "password": passwordController.text
                    };
                    await LocalStorage.setItem(
                        "username", emailController.text);
                    await LocalStorage.setItem("pass", passwordController.text);

                    authState.login(
                      context: context,
                      data: data,
                    );
                  },
                ),
                YMargin(16),
                GestureDetector(
                    onTap: () => navigate(ForgotPasswordPage()),
                    child: Text("Forgot Password?",
                        style: CbTextStyle.medium
                            .copyWith(color: CbColors.cPrimaryBase))),
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
                  text: 'Sign in with Google',
                  icon: SvgPicture.asset(
                    'google'.svg,
                  ),
                  buttonColor: CbColors.cPrimaryBase,
                  textColor: CbColors.cPrimaryBase,
                  onPressed: () {
                    authState.googleSignIn(context: context);
                    // navigate(LoginReturningPage());
                  },
                ),
                YMargin(62),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => navigate(RegisterPage()),
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "New to Cubex? ",
                          style: CbTextStyle.book16
                              .copyWith(color: CbColors.cAccentLighten4)),
                      TextSpan(
                          text: "Create your account",
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
