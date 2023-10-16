import 'package:cubex/src/presentation/views/authentication/login.dart';
import 'package:cubex/src/presentation/widgets/bottomsheet/custom_bottomsheet.dart';
import 'package:cubex/src/core/state_registry.dart';
import 'package:cubex/src/data/datasources/local/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_svg/svg.dart';

import 'package:cubex/src/presentation/views/forgotpassword/forgot_password.dart';
import 'package:cubex/src/presentation/widgets/app/cb_scaffold.dart';
import 'package:cubex/src/presentation/widgets/appbars/app_bar.dart';
import 'package:cubex/src/presentation/widgets/buttons/theme_button.dart';
import 'package:cubex/src/presentation/widgets/textfields/textfield.dart';
import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/textstyles.dart';
import 'package:cubex/src/core/utils/extensions.dart';
import 'package:cubex/src/core/utils/navigator.dart';
import 'package:cubex/src/core/utils/spacer.dart';
import 'package:cubex/src/core/utils/validators.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginReturningPage extends StatefulHookWidget {
  @override
  _LoginReturningPageState createState() => _LoginReturningPageState();
}

class _LoginReturningPageState extends State<LoginReturningPage> {
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  String? firstname;
  String? username;
  String? password;
  LocalAuthentication localAuth = LocalAuthentication();

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  fetchData() async {
    firstname = await LocalStorage.getItem('firstname');
    username = await LocalStorage.getItem('username');
    password = await LocalStorage.getItem('pass');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var authState = useProvider(authProvider);

    return CbScaffold(
      appBar: CbAppBar(
        title: 'Welcome back,',
        subtitle: '${firstname ?? ''}! 👋🏾',
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
                    'Kindly input your password to get back into your account.',
                    style: CbTextStyle.book14,
                  ),
                ),
                YMargin(40),
                CbTextField(
                    label: 'Password',
                    hint: 'Password',
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
                  text: 'Sign in',
                  loadingState: authState.loginBusy,
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    Map<String, dynamic> data = <String, dynamic>{
                      "username": username,
                      "password": _passwordController.text
                    };
                    authState.login(
                      context: context,
                      data: data,
                    );
                    // navigateReplaceTo(context, VerifyOtpPage());
                  },
                ),
                YMargin(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () => navigate(ForgotPasswordPage()),
                        child: Text("Forgot Password?",
                            style: CbTextStyle.medium
                                .copyWith(color: CbColors.cPrimaryBase))),
                    GestureDetector(
                        onTap: () async {
                          await LocalStorage.setItem("loggedIn", false);

                          navigateReplaceTo(context, LoginPage());
                        },
                        child: Text("Switch accounts",
                            style: CbTextStyle.medium
                                .copyWith(color: CbColors.cPrimaryBase))),
                  ],
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
                Center(
                  child: GestureDetector(
                    onTap: () => showModalBottomSheet(
                      context: context,
                      backgroundColor: CbColors.transparent,
                      builder: (context) => FloatingBottomSheetContainer(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 32,
                            ),
                            Text('Sign In', style: CbTextStyle.bold24),
                            YMargin(40),
                            GestureDetector(
                              onTap: () {
                                biometricAuth();
                              },
                              child: Center(
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      'fingerprint'.svg,
                                    ),
                                    YMargin(14),
                                    Text('Touch fingerprint sensor',
                                        style: CbTextStyle.book12.copyWith(
                                            color: CbColors.cAccentLighten3)),
                                  ],
                                ),
                              ),
                            ),
                            YMargin(58),
                            Divider(
                              color: CbColors.cAccentLighten5,
                            ),
                            YMargin(16),
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Cancel',
                                  style: CbTextStyle.medium
                                      .copyWith(color: CbColors.cErrorBase),
                                ),
                              ),
                            ),
                            YMargin(16),
                          ],
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        SvgPicture.asset('fingerprint'.svg),
                        YMargin(14),
                        Text("Use touch ID",
                            style: CbTextStyle.book12
                                .copyWith(color: CbColors.cAccentLighten3)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  biometricAuth() async {
    try {
      bool authenticated = await localAuth.authenticateWithBiometrics(
          localizedReason: "Scan fingerprint login",
          useErrorDialogs: true,
          stickyAuth: true);

      if (authenticated) {
        Navigator.pop(context);
        Map<String, dynamic> data = <String, dynamic>{
          "username": username,
          "password": password
        };
        context.read(authProvider).login(context: context, data: data);
      }
    } on PlatformException {
    } catch (e) {

    }
  }
}
