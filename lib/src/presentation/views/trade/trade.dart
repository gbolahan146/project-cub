import 'dart:io';
import 'package:cubex/src/core/state_registry.dart';
import 'package:cubex/src/core/utils/helpers.dart';
import 'package:cubex/src/core/utils/spacer.dart';
import 'package:cubex/src/presentation/views/trade/components/trade_cards.dart';
import 'package:cubex/src/presentation/views/trade/trade-crypto/trade_crypto1.dart';
import 'package:cubex/src/presentation/views/trade/trade-giftcard/trade_giftcard1.dart';
import 'package:cubex/src/presentation/widgets/bottomsheet/custom_bottomsheet.dart';
import 'package:cubex/src/presentation/widgets/emptystate/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cubex/src/presentation/widgets/app/cb_scaffold.dart';
import 'package:cubex/src/presentation/widgets/appbars/app_bar.dart';
import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/textstyles.dart';
import 'package:cubex/src/core/utils/navigator.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart' as pullToRefresh;

class TradePage extends StatefulHookWidget {
  const TradePage({Key? key}) : super(key: key);

  @override
  _TradePageState createState() => _TradePageState();
}

class _TradePageState extends State<TradePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  bool isCryptoEmpty = false;

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 2, initialIndex: 0);
    super.initState();
    // context.read(tradeProvider).getGiftcards(
    //     context: context,
    //     refresh: true,
    //    );
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tradeState = useProvider(tradeProvider);

    return CbScaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: _tabController!.index == 1
              ? () {
                  navigate(SellCryptoPage1());
                }
              : () {
                  navigate(SellGiftcardPage1());
                },
          child: Icon(Icons.add, color: Colors.white),
          backgroundColor: CbColors.cPrimaryBase),
      backgroundColor: CbColors.cBase,
      appBar: CbAppBar(
        isTransparent: true,
        title: 'Trade.',
      ),
      isLoading: tradeState.getGiftCardBusy,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: new BoxDecoration(
                  color: CbColors.white,
                  borderRadius: BorderRadius.circular(4)),
              child: new TabBar(
                onTap: (val) {
                  setState(() {});
                },
                controller: _tabController,
                unselectedLabelColor: Colors.redAccent,
                labelPadding: EdgeInsets.symmetric(horizontal: 10),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: CbColors.cDarken1,
                ),
                tabs: [
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 9),
                      child: Text(
                        "Giftcard",
                        style: CbTextStyle.bold14
                            .copyWith(color: CbColors.cPrimaryBase),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 9),
                      child: Text(
                        "Crypto",
                        style: CbTextStyle.bold14
                            .copyWith(color: CbColors.cPrimaryBase),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              // flex: 8,
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: <Widget>[
                  pullToRefresh.SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    onRefresh: () {
                      tradeState.fetchGiftCardTransactions(
                        refresh: true,
                      );
                    },
                    controller: tradeState.cardRefreshTransController,

                    // },
                    onLoading: () =>
                        tradeState.fetchGiftCardTransactions(refresh: false),
                    child: ListView(
                      children: [
                        tradeState.giftCardTransData.isEmpty
                            ? Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.07),
                                child: EmptyStateWidget(
                                  topPadding: 0,
                                  title:
                                      'You haven’t made any giftcard trade yet. Click the “+” to begin..',
                                ),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor: CbColors.transparent,
                                          builder: (context) =>
                                              BottomSheetContainer(
                                            child: GiftcardDetailsBottomSheet(
                                                transaction: tradeState
                                                    .giftCardTransData[index]),
                                            title: 'Transaction Details',
                                          ),
                                        );
                                      },
                                      child: TradeCards(
                                          amount:
                                              '${tradeState.giftCardTransData[index].amount} card(s)',
                                          time: DateFormat('dd/MM/yyyy | hh:mm')
                                              .format(DateTime.parse(tradeState
                                                      .giftCardTransData[index]
                                                      .createdAt ??
                                                  '')),
                                          status: tradeState
                                              .giftCardTransData[index]
                                              .status!
                                              .capitalize,
                                          rate:
                                              ' @${tradeState.giftCardTransData[index].rate}/\$',
                                          price: ParserService.formatToMoney(
                                              tradeState
                                                      .giftCardTransData[index]
                                                      .amountExpected ??
                                                  tradeState
                                                      .giftCardTransData[index]
                                                      .amount ??
                                                  0,
                                              context: context,
                                              compact: false),
                                          title:
                                              'Sell ${tradeState.giftCardTransData[index].giftCard?.name}'),
                                    ),
                                separatorBuilder: (c, i) => YMargin(16),
                                itemCount: tradeState.giftCardTransData.length),
                      ],
                    ),
                    footer: pullToRefresh.CustomFooter(
                      builder: (BuildContext context,
                          pullToRefresh.LoadStatus? mode) {
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
                        } else if (mode ==
                            pullToRefresh.LoadStatus.canLoading) {
                          body = Text("Release to Load More");
                        }
                        return Container(
                          height: 55.0,
                          child: Center(child: body),
                        );
                      },
                    ),
                  ),
                  pullToRefresh.SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    onRefresh: () {
                      tradeState.fetchCryptoTransactions(
                        refresh: true,
                      );
                    },
                    controller: tradeState.cryptoRefreshTransController,
                    onLoading: () =>
                        tradeState.fetchCryptoTransactions(refresh: false),
                    child: ListView(
                      children: [
                        tradeState.cryptoTransData.isEmpty
                            ? Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.07),
                                child: EmptyStateWidget(
                                  topPadding: 0,
                                  title:
                                      'You haven’t made any crypto trade yet. Click the “+” to begin..',
                                ),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor: CbColors.transparent,
                                          builder: (context) =>
                                              BottomSheetContainer(
                                            child: CryptoDetailsBottomSheet(
                                                transaction: tradeState
                                                    .cryptoTransData[index]),
                                            title: 'Transaction Details',
                                          ),
                                        );
                                      },
                                      child: TradeCards(
                                          amount:
                                              '${tradeState.cryptoTransData[index].amount} ',
                                          time: DateFormat('dd/MM/yyyy | hh:mm')
                                              .format(DateTime.parse(tradeState
                                                      .cryptoTransData[index]
                                                      .createdAt ??
                                                  '')),
                                          status: tradeState
                                              .cryptoTransData[index]
                                              .status!
                                              .capitalizeFirst,
                                          rate:
                                              ' @${tradeState.cryptoTransData[index].rate}/\$',
                                          price: ParserService.formatToMoney(
                                              tradeState.cryptoTransData[index]
                                                      .amountExpected ??
                                                  tradeState
                                                      .cryptoTransData[index]
                                                      .amount ??
                                                  0,
                                              context: context,
                                              compact: false),
                                          title:
                                              'Sell ${tradeState.cryptoTransData[index].crypto?.name}'),
                                    ),
                                separatorBuilder: (c, i) => YMargin(16),
                                itemCount: tradeState.cryptoTransData.length),
                      ],
                    ),
                    footer: pullToRefresh.CustomFooter(
                      builder: (BuildContext context,
                          pullToRefresh.LoadStatus? mode) {
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
                        } else if (mode ==
                            pullToRefresh.LoadStatus.canLoading) {
                          body = Text("Release to Load More");
                        }
                        return Container(
                          height: 55.0,
                          child: Center(child: body),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
