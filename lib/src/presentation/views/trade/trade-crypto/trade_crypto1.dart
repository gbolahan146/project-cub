import 'dart:io';
import 'dart:math';

import 'package:cubex/src/core/state_registry.dart';
import 'package:cubex/src/presentation/widgets/dummydata.dart';
import 'package:cubex/src/presentation/views/trade/trade-crypto/trade_crypto2.dart';
import 'package:cubex/src/core/utils/navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cubex/src/presentation/widgets/app/cb_scaffold.dart';
import 'package:cubex/src/presentation/widgets/appbars/app_bar.dart';
import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/textstyles.dart';
import 'package:cubex/src/core/utils/dimensions.dart';
import 'package:cubex/src/core/utils/spacer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' as pullToRefresh;

class SellCryptoPage1 extends StatefulHookWidget {
  @override
  _SellCryptoPage1State createState() => _SellCryptoPage1State();
}

class _SellCryptoPage1State extends State<SellCryptoPage1> {
  @override
  Widget build(BuildContext context) {
    SizeConfig config = SizeConfig();
    var tradeState = useProvider(tradeProvider);
    return CbScaffold(
      appBar: CbAppBar(
        title: 'Sell Crypto',
        automaticallyImplyLeading: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return await tradeState.getCryptos(
            context: context,
            refresh: true,
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              YMargin(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select crypto',
                    style: CbTextStyle.book14,
                  ),
                  Text(
                    'Step 1 / 3',
                    style: CbTextStyle.medium.copyWith(
                      color: CbColors.cAccentLighten3,
                      fontSize: config.sp(14),
                    ),
                  ),
                ],
              ),
              YMargin(8),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: LinearProgressIndicator(
                  value: 3 / 10,
                  backgroundColor: CbColors.cPrimaryLighten5,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(CbColors.cPrimaryBase),
                ),
              ),
              YMargin(40),
              Expanded(
                child: pullToRefresh.SmartRefresher(
                  controller: tradeState.cryptoRefreshController,
                  enablePullDown: false,
                  enablePullUp: true,
                  onLoading: () => tradeState.getCryptos(
                    context: context,
                    refresh: false,
                  ),
                  child: GridView.builder(
                      itemCount: tradeState.cryptoData.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.3,
                          crossAxisSpacing: config.sh(1)),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            tradeState.selectedCrypto =
                                tradeState.cryptoData[index];
                            navigate(SellCryptoPage2());
                          },
                          child: SellCard(
                            color: randomColor(),
                            image: tradeState.cryptoData[index].icon,
                            title: tradeState.cryptoData[index].name,
                          ),
                        );
                      }),
                  footer: pullToRefresh.CustomFooter(
                    builder:
                        (BuildContext context, pullToRefresh.LoadStatus? mode) {
                      Widget? body;
                      if (mode == pullToRefresh.LoadStatus.idle) {
                        body = Text("pull up to load");
                      } else if (mode == pullToRefresh.LoadStatus.loading) {
                        body = Platform.isIOS
                            ? CupertinoActivityIndicator()
                            : SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator());
                      } else if (mode == pullToRefresh.LoadStatus.failed) {
                        body = Text("Load Failed!Click retry!");
                      } else if (mode == pullToRefresh.LoadStatus.noMore) {
                        body = Text("");
                      } else if (mode == pullToRefresh.LoadStatus.canLoading) {
                        body = Text("Release to Load More");
                      }
                      return Container(
                        height: 55.0,
                        child: Center(child: body),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  randomColor() {
    var random = Random();
    giftcolors.shuffle(random);
    return giftcolors[0];
  }
}

class SellCard extends StatelessWidget {
  final String? image;
  final String? title;
  final Color? color;
  const SellCard({
    Key? key,
    this.image,
    this.title,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 0,
        color: color ?? CbColors.cPrimaryLighten5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 24.0, bottom: 16),
          child: Column(
            children: [
              Expanded(
                  child: SvgPicture.network(
                      image ?? 'https://via.placeholder.com/150')),
              YMargin(22),
              Expanded(
                child: Text(
                  '$title',
                  style: CbTextStyle.book14,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
