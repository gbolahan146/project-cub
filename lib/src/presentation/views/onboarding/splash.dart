// ignore_for_file: implementation_imports

import 'dart:async';

import 'package:cubex/src/presentation/views/authentication/login.dart';
import 'package:cubex/src/presentation/views/onboarding/onboarding_page.dart';
import 'package:cubex/src/presentation/views/returning-user/login_returning.dart';
import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/core/state_registry.dart';
import 'package:cubex/src/data/datasources/local/local_storage.dart';
import 'package:cubex/src/core/utils/navigator.dart';
import 'package:flutter/material.dart';
import 'package:cubex/src/core/utils/extensions.dart';
import "package:flutter_riverpod/src/provider.dart";
import 'package:flutter_svg/svg.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SplashPage extends StatefulHookWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    context.read(accountsProvider).fetchCountries();
    context.read(accountsProvider).fetchBanks();
    // context.read(accountsProvider).fetchBanks();
    Timer(Duration(seconds: 2), () => decideNav());
    super.initState();
  }

  decideNav() async {
    bool? onboardingState = await LocalStorage.getItem("hasSeenOnboarding");
    bool loggedinState = await LocalStorage.getItem("loggedIn") ?? false;
    // print("loggedinState: $loggedinState");
    if (onboardingState != null && onboardingState) {
      if (loggedinState) {
        navigateReplaceTo(context, LoginReturningPage());
        return;
      }
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return LoginPage();
      }));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return OnboardingPage();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CbColors.cPrimaryBase,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              "logo".svg,
            ),
          ),
        ],
      ),
    );
  }
}
