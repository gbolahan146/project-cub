import 'dart:math';

import 'package:cubex/src/core/state_registry.dart';
import 'package:cubex/src/presentation/widgets/dummydata.dart';
import 'package:cubex/src/presentation/widgets/emptystate/empty_widget.dart';
import 'package:cubex/src/presentation/widgets/textfields/textfield.dart';
import 'package:cubex/src/presentation/views/trade/trade-crypto/trade_crypto1.dart';
import 'package:cubex/src/presentation/views/trade/trade-giftcard/trade_giftcard2.dart';
import 'package:cubex/src/core/utils/navigator.dart';
import 'package:flutter/material.dart';

import 'package:cubex/src/presentation/widgets/app/cb_scaffold.dart';
import 'package:cubex/src/presentation/widgets/appbars/app_bar.dart';
import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/textstyles.dart';
import 'package:cubex/src/core/utils/dimensions.dart';
import 'package:cubex/src/core/utils/spacer.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SellGiftcardPage1 extends StatefulHookWidget {
  @override
  _SellGiftcardPage1State createState() => _SellGiftcardPage1State();
}

class _SellGiftcardPage1State extends State<SellGiftcardPage1> {
  ValueNotifier _searchNotifier = ValueNotifier<String>("");
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig config = SizeConfig();
    var tradeState = useProvider(tradeProvider);
    return CbScaffold(
      appBar: CbAppBar(
        title: 'Sell Giftcards.',
        automaticallyImplyLeading: true,
      ),
      isLoading: tradeState.getGiftCardBusy,
      body: Scrollbar(
        child: RefreshIndicator(
          onRefresh: () async {
            return await tradeState.getGiftcards(
              context: context,
              refresh: true,
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: tradeState.giftCardData.isEmpty
                ? EmptyStateWidget(
                    title: 'No giftcards available',
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      YMargin(16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select card',
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
                          valueColor: AlwaysStoppedAnimation<Color>(
                              CbColors.cPrimaryBase),
                        ),
                      ),
                      YMargin(40),
                      CbTextField(
                        label: 'Search giftcards',
                        hint: 'Search giftcards',
                        suffix:
                            Icon(Icons.search, color: CbColors.cAccentLighten5),
                        onChanged: (String? value) {
                          _searchNotifier.value = value;
                        },
                        controller: _searchController,
                      ),
                      YMargin(40),
                      Expanded(
                        child: ValueListenableBuilder(
                          valueListenable: _searchNotifier,
                          builder: (context, value, child) {
                            if (value == "") {
                              return
                                  //  pullToRefresh.SmartRefresher(
                                  //   controller: tradeState.cardRefreshController,
                                  //   enablePullDown: false,
                                  //   enablePullUp: true,
                                  //   onLoading: () => tradeState.getGiftcards(
                                  //     context: context,
                                  //     refresh: false,
                                  //   ),
                                  //   child:
                                  GridView.builder(
                                      itemCount: tradeState.giftCardData.length,
                                      physics: BouncingScrollPhysics(),
                                      // shrinkWrap: true,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 1.3,
                                              crossAxisSpacing: config.sh(1)),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            tradeState.selectedGiftCard =
                                                tradeState.giftCardData[index];
                                            navigate(SellGiftcardPage2());
                                          },
                                          child: SellCard(
                                            color: randomColor(),
                                            image: tradeState
                                                .giftCardData[index].icon,
                                            title: tradeState
                                                .giftCardData[index].name,
                                          ),
                                        );
                                      });
                            } else {
                              var items = tradeState.giftCardData
                                  .where((element) => element.name
                                      .toString()
                                      .toLowerCase()
                                      .contains(value.toString().toLowerCase()))
                                  .toList();
                              if (items.isEmpty) {
                                return Center(child: Text('No results found'));
                              }
                              return GridView.builder(
                                  itemCount: items.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 1.3,
                                          crossAxisSpacing: config.sh(1)),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        tradeState.selectedGiftCard =
                                            items[index];

                                        navigate(SellGiftcardPage2());
                                      },
                                      child: SellCard(
                                        color: randomColor(),
                                        image: items[index].icon,
                                        title: items[index].name,
                                      ),
                                    );
                                  });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
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
