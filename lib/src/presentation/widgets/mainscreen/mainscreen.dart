import 'package:cubex/src/presentation/views/homescreen/home.dart';
import 'package:cubex/src/presentation/views/settings/settings.dart';
import 'package:cubex/src/presentation/views/wallet-history/wallet_history_page.dart';
import 'package:cubex/src/presentation/widgets/app/cb_scaffold.dart';
import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/textstyles.dart';
import 'package:cubex/src/presentation/views/trade/trade.dart';
import 'package:cubex/src/core/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cubex/src/core/utils/extensions.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController? _pageController;
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    TradePage(),
    WalletHistoryPage(),
    SettingsPage(),
  ];

  @override
  void initState() {
    _pageController = PageController(
      keepPage: true,
      initialPage: 0,
    );
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController!.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final config = SizeConfig();
    return WillPopScope(
      onWillPop: () => Future<bool>.value(false),
      child: CbScaffold(
        body: PageView(
          onPageChanged: onPageChanged,
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: _pages,
        ),
        bottomNavigationBar: Container(
          color: Colors.red,
          child: BottomNavigationBar(
            iconSize: 10,
            onTap: onPageChanged,
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: CbColors.white,
            selectedFontSize: 1,
            unselectedFontSize: 1,
            selectedLabelStyle: CbTextStyle.bold14.copyWith(
                color: CbColors.cPrimaryBase, fontSize: config.sp(12)),
            unselectedLabelStyle:
                CbTextStyle.book12.copyWith(color: CbColors.cDarken4),
            items: [
              BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset("active-home".svg),
                  icon: SvgPicture.asset("home".svg),
                  label: "",
                  tooltip: 'Home'),
              BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset("active-trade".svg),
                  icon: SvgPicture.asset("trade".svg),
                  label: "",
                  tooltip: 'Trade'),
              BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset("active-history".svg),
                  icon: SvgPicture.asset("history".svg),
                  label: "",
                  tooltip: 'History'),
              BottomNavigationBarItem(
                  activeIcon: SvgPicture.asset("active-settings".svg),
                  icon: SvgPicture.asset("settings".svg),
                  label: "",
                  tooltip: 'Settings'),
            ],
          ),
        ),
      ),
    );
  }
}
