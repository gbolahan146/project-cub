import 'package:cubex/src/presentation/views/authentication/register.dart';
import 'package:cubex/src/presentation/widgets/buttons/theme_button.dart';
import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/textstyles.dart';
import 'package:cubex/src/data/datasources/local/local_storage.dart';
import 'package:cubex/src/core/utils/dimensions.dart';
import 'package:cubex/src/core/utils/indicator.dart';
import 'package:cubex/src/core/utils/spacer.dart';
import 'package:flutter/material.dart';
import 'package:cubex/src/core/utils/extensions.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _currentIndex = 0;

  void _saveUserOnboardingState() async {
    bool? onboardingState = await LocalStorage.getItem("hasSeenOnboarding");
    if (onboardingState == null) {
      await LocalStorage.setItem("hasSeenOnboarding", true);
    }
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    pageController!.jumpToPage(index);
  }

  PageController? pageController;

  List<String> titles = <String>[
    "Trade your Giftcards",
    "Trade your Crypto",
    "Secure your Money",
  ];
  List<String> subtitles = <String>[
    "Get instant access to funds and choose from a varieties loan options at the click of a button.",
    "Get instant access to funds and choose from a varieties loan options at the click of a button.",
    "Get instant access to funds and choose from a varieties loan options at the click of a button.",
  ];

  List<String> images = <String>[
    "onboarding-1",
    "onboarding-2",
    "onboarding-3",
  ];

  @override
  void initState() {
    pageController = PageController(keepPage: true, initialPage: 0);
    super.initState();
    _saveUserOnboardingState();
  }

  @override
  Widget build(BuildContext context) {
    final SizeConfig config = SizeConfig();
    return Scaffold(
      backgroundColor: CbColors.cBase,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                PageView(
                  controller: pageController,
                  children: images.map(
                    (e) {
                      final index = images.indexOf(e);
                      return Stack(
                        children: [
                          Positioned(
                            bottom: config.sh(50),
                            left: config.sw(43),
                            right: config.sw(43),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "$e".png,
                                ),
                                FutureBuilder(
                                  future: Future(() async {
                                    await Future.delayed(
                                      Duration(milliseconds: 1),
                                    );
                                    return index;
                                  }),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 56),
                                        child: Indicator(
                                          controller: pageController,
                                          itemCount: 3,
                                        ),
                                      );
                                    }
                                    return SizedBox();
                                  },
                                ),
                                Text(
                                  titles[index],
                                  textAlign: TextAlign.center,
                                  style: CbTextStyle.bold24,
                                ),
                                YMargin(16),
                                Text(
                                  subtitles[index],
                                  textAlign: TextAlign.center,
                                  style: CbTextStyle.book16,
                                ),
                                YMargin(70),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ).toList(),
                  onPageChanged: onPageChanged,
                ),
              ],
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CbThemeButton(
            text: 'Get started',
            onPressed: _currentIndex < 2
                ? () {
                    onPageChanged(_currentIndex + 1);
                  }
                : () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return RegisterPage();
                    }));
                  },
          ),
        )
      ],
    );
  }
}
