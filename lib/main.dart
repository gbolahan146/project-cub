import 'dart:io';

import 'package:cubex/src/config/envconfig.dart';
import 'package:cubex/src/core/utils/dimensions.dart';
import 'package:cubex/src/presentation/views/onboarding/splash.dart';
import 'package:cubex/src/config/themes/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();
var logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory? dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  await Hive.openBox("app_data");
  await EnvConfig.initialize();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cubex',
        navigatorKey: navigatorKey,
        theme: ThemeConfig.defaultTheme,
        home: Builder(builder: (context) {
          SizeConfig.init(context);
          return SplashPage();
        }),
      ),
    );
  }
}
