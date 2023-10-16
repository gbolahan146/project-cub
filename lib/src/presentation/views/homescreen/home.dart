import 'package:cubex/src/presentation/views/homescreen/withdraw_bottomsheet.dart';
import 'package:cubex/src/presentation/views/trade/trade-crypto/trade_crypto1.dart';
import 'package:cubex/src/presentation/views/trade/trade-giftcard/trade_giftcard1.dart';
import 'package:cubex/src/core/state_registry.dart';
import 'package:cubex/src/core/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:cubex/src/presentation/views/notification/notification.dart';
import 'package:cubex/src/presentation/widgets/app/cb_scaffold.dart';
import 'package:cubex/src/presentation/widgets/bottomsheet/custom_bottomsheet.dart';
import 'package:cubex/src/presentation/widgets/buttons/bordered_button.dart';
import 'package:cubex/src/presentation/widgets/buttons/theme_button.dart';
import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/textstyles.dart';
import 'package:cubex/src/presentation/views/transfer/transfer-bank.dart';
import 'package:cubex/src/presentation/views/transfer/transfer-cubex.dart';
import 'package:cubex/src/core/utils/dimensions.dart';
import 'package:cubex/src/core/utils/extensions.dart';
import 'package:cubex/src/core/utils/navigator.dart';
import 'package:cubex/src/core/utils/spacer.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulHookWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool obscureText = false;
  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'morning';
    }
    if (hour < 17) {
      return 'afternoon';
    }
    return 'evening';
  }

  String greetingIcon() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return '☀️';
    }
    if (hour < 17) {
      return '⛅';
    }

    return '🌙';
  }

  @override
  void initState() {
    super.initState();
    getObscureText();
  }

  getObscureText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      obscureText = prefs.getBool('obscureWallet') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = SizeConfig();
    var authState = useProvider(authProvider);
    var tradeState = useProvider(tradeProvider);
    var user = authState.fetchUserResponse.data;
    return CbScaffold(
      backgroundColor: CbColors.cBase,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              YMargin(60),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Good ${greeting()} ${greetingIcon()}",
                        style: CbTextStyle.book14,
                      ),
                      Text(
                        "${user.firstName}.",
                        style: CbTextStyle.bold24,
                      ),
                    ],
                  ),
                  GestureDetector(
                      onTap: () => navigate(NotificationPage()),
                      child: SvgPicture.asset('notification'.svg)),
                ],
              ),
              YMargin(24),
              Container(
                decoration: BoxDecoration(
                  color: CbColors.cAccentBase,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('card-bg'.png), fit: BoxFit.cover)),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      YMargin(8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Wallet Balance',
                            style: CbTextStyle.book12
                                .copyWith(color: CbColors.cAccentLighten5),
                          ),
                          IconButton(
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              setState(() {
                                obscureText = !obscureText;
                              });
                              prefs.setBool('obscureWallet', obscureText);
                            },
                            icon: obscureText
                                ? Icon(
                                    Icons.visibility_outlined,
                                    color: CbColors.cAccentLighten5,
                                    size: 20,
                                  )
                                : Icon(
                                    Icons.visibility_off_outlined,
                                    size: 20,
                                    color: CbColors.cAccentLighten5,
                                  ),
                          )
                        ],
                      ),
                      Text(
                        obscureText
                            ? '*********'
                            : ParserService.formatToMoney(
                                user.wallet?.balance?.value ?? 0,
                                compact: false,
                                context: context,
                              ),
                        style: CbTextStyle.black.copyWith(fontFamily: 'Roboto'),
                      ),
                      YMargin(24),
                      Row(
                        children: [
                          Expanded(
                            child: CbThemeButton(
                              text: 'Transfer',
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: CbColors.transparent,
                                  builder: (context) => BottomSheetContainer(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 16.0),
                                          child: TransferCard(type: "Cubex"),
                                        ),
                                        TransferCard(type: "Bank"),
                                      ],
                                    ),
                                    title: 'Transfer.',
                                  ),
                                );
                              },
                              textColor: CbColors.cPrimaryBase,
                              buttonColor: CbColors.white,
                            ),
                          ),
                          XMargin(7),
                          Expanded(
                            child: CbBorderedButton(
                              text: 'Withdraw',
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: CbColors.transparent,
                                  builder: (context) => BottomSheetContainer(
                                    child: WithdrawBottomSheet(
                                      obscureText: obscureText,
                                    ),
                                    title: 'Withdraw.',
                                  ),
                                );
                              },
                              bgColor: CbColors.transparent,
                              buttonColor: CbColors.white,
                              textColor: CbColors.white,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              YMargin(24),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: CbColors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    YMargin(16),
                    Row(
                      children: [
                        Text(
                          'Summary.',
                          style: CbTextStyle.medium
                              .copyWith(color: CbColors.cAccentLighten3),
                        ),
                        Spacer(),
                        Text(
                          'This week.',
                          style: CbTextStyle.medium.copyWith(
                              fontSize: config.sp(14),
                              color: CbColors.cAccentLighten3),
                        ),
                        XMargin(8),
                        SvgPicture.asset('calendar'.svg),
                      ],
                    ),
                    YMargin(16),
                    Container(
                        height: config.sh(225),
                        child: GridView(
                          padding: EdgeInsets.only(top: 0),
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: .6,
                                  crossAxisSpacing: config.sh(7)),
                          children: [
                            SummaryCard(
                                callback: () => navigate(SellGiftcardPage1()),
                                img: 'sell-giftcard',
                                amount: ParserService.formatToMoney(
                                    tradeState.totalCardTraded,
                                    context: context,
                                    compact: false),
                                color: CbColors.cPrimaryBase,
                                bgColor: CbColors.cBase,
                                title: 'Giftcards traded',
                                btnText: 'Sell giftcards'),
                            SummaryCard(
                                callback: () => navigate(SellCryptoPage1()),
                                img: 'sell-crypto',
                                amount: ParserService.formatToMoney(
                                    tradeState.totalCryptoTraded,
                                    context: context,
                                    compact: false),
                                color: CbColors.cWarningDarken4,
                                bgColor: CbColors.cWarningLighten5,
                                title: 'Crypto traded',
                                btnText: 'Sell crypto'),
                          ],
                        )),
                    YMargin(16),
                  ],
                ),
              ),
              YMargin(24),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CbColors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction volume.',
                      style: CbTextStyle.medium
                          .copyWith(color: CbColors.cAccentLighten3),
                    ),
                    YMargin(16),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: CbColors.cSuccessLighten5,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${user.wallet?.balance?.currency}0 ',
                            style: CbTextStyle.black.copyWith(
                                fontSize: config.sp(24),
                                fontFamily: 'Roboto',
                                color: CbColors.cAccentBase),
                          ),
                          Text(
                            '/ ${user.wallet?.balance?.currency}0',
                            style: CbTextStyle.book14.copyWith(
                                fontFamily: 'Roboto',
                                color: CbColors.cSuccessBase),
                          ),
                          Spacer(),
                          Image.asset('money'.png, scale: 1.2)
                        ],
                      ),
                    ),
                    YMargin(8),
                    Text(
                      '*You get ₦10,000 for every \$5,000 in transactions',
                      style: CbTextStyle.book12.copyWith(
                          fontFamily: 'Roboto', fontSize: config.sp(12)),
                    ),
                    YMargin(8),
                  ],
                ),
              ),
              YMargin(24),
            ],
          ),
        ),
      ),
    );
  }
}

class TransferCard extends StatelessWidget {
  final String type;
  const TransferCard({
    Key? key,
    required this.type,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: type == 'Bank'
          ? () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => TransferBankPage()))
          : () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => TransferCubexPage())),
      child: Container(
        margin: EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
            color: CbColors.cBase, borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            SvgPicture.asset(
                type == 'Bank' ? 'bank-account'.svg : 'cubex-account'.svg),
            XMargin(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$type account', style: CbTextStyle.medium),
                  YMargin(4),
                  Text('Transfer to another $type account',
                      style: CbTextStyle.book12),
                  // Spacer(),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: CbColors.cPrimaryBase,
              size: 15,
            )
          ],
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String? btnText;
  final String? title;
  final String? img;
  final String? amount;
  final Color? bgColor;
  final Color? color;
  final Function()? callback;
  const SummaryCard({
    Key? key,
    this.btnText,
    this.title,
    this.img,
    this.amount,
    this.bgColor,
    this.color,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = SizeConfig();

    return Container(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
      decoration:
          BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(4)),
      child: Column(
        children: [
          SvgPicture.asset('$img'.svg),
          YMargin(20),
          Text('$title', style: CbTextStyle.book12),
          YMargin(4),
          Text(
            '$amount',
            textAlign: TextAlign.center,
            style: CbTextStyle.black.copyWith(
                fontSize: config.sp(18),
                fontFamily: 'Roboto',
                color: CbColors.cAccentBase),
          ),
          YMargin(24),
          CbBorderedButton(
            text: '$btnText',
            onPressed: callback,
            letterSpacing: .6,
            bgColor: CbColors.transparent,
            buttonColor: color,
            textColor: color,
          )
        ],
      ),
    );
  }
}
