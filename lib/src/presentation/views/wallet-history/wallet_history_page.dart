import 'dart:io';

import 'package:cubex/src/presentation/widgets/bottomsheet/custom_bottomsheet.dart';
import 'package:cubex/src/core/state_registry.dart';
import 'package:cubex/src/core/utils/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:cubex/src/presentation/widgets/app/cb_scaffold.dart';
import 'package:cubex/src/presentation/widgets/appbars/app_bar.dart';
import 'package:cubex/src/presentation/widgets/emptystate/empty_widget.dart';
import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/textstyles.dart';
import 'package:cubex/src/core/utils/extensions.dart';
import 'package:cubex/src/core/utils/spacer.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WalletHistoryPage extends StatefulHookWidget {
  @override
  _WalletHistoryPageState createState() => _WalletHistoryPageState();
}

class _WalletHistoryPageState extends State<WalletHistoryPage> {
  bool isWalletHistoryEmpty = false;

  @override
  Widget build(BuildContext context) {
    var walletState = useProvider(walletProvider);
    return CbScaffold(
      backgroundColor: CbColors.cBase,
      appBar: CbAppBar(
        title: 'Wallet History.',
        isTransparent: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: walletState.walletHistoryData.isEmpty
            ? EmptyStateWidget(
                title: 'You haven\'t made any wallet transactions yet.',
              )
            : Container(
                margin: EdgeInsets.only(top: 40, bottom: 20),
                child: SmartRefresher(
                  controller: walletState.refreshControllerHistory,
                  enablePullDown: false,
                  enablePullUp: true,
                  onLoading: () => walletState.fetchHistory(
                    context: context,
                    refresh: false,
                  ),
                  child: ListView.separated(
                    // shrinkWrap: true,
                    separatorBuilder: (context, index) => YMargin(16),
                    itemCount: walletState.walletHistoryData.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: CbColors.transparent,
                            builder: (context) => BottomSheetContainer(
                              child: WalletDetailsBottomSheet(
                                status: walletState.walletHistoryData[index]
                                    .status!.capitalizeFirst,
                                time: DateFormat('d, MMMM yyyy').format(
                                    DateTime.parse(walletState
                                            .walletHistoryData[index]
                                            .createdAt ??
                                        '')),
                                id: walletState
                                        .walletHistoryData[index].reference ??
                                    walletState.walletHistoryData[index].id,
                                amount: ParserService.formatToMoney(
                                    walletState.walletHistoryData[index].amount
                                            ?.value ??
                                        0,
                                    compact: false,
                                    context: context),
                                meta: walletState.walletHistoryData[index].meta,
                                action:
                                    walletState.walletHistoryData[index].action,
                                reason:
                                    walletState.walletHistoryData[index].reason,
                                type: walletState
                                            .walletHistoryData[index].reason!
                                            .contains('cubex') ||
                                        walletState
                                            .walletHistoryData[index].reason!
                                            .contains('wallet')
                                    ? 'Account'
                                    : 'Bank',
                              ),
                              title: walletState
                                          .walletHistoryData[index].reason!
                                          .contains('Credit') ||
                                      walletState
                                          .walletHistoryData[index].reason!
                                          .contains('transfer')
                                  ? 'Transfer Details'
                                  : 'Withdrawal Details',
                            ),
                          );
                        },
                        child: WalletHistoryCard(
                            title: walletState.walletHistoryData[index].action!
                                .capitalizeFirst,
                            amount: ParserService.formatToMoney(
                                walletState.walletHistoryData[index].amount
                                        ?.value ??
                                    0,
                                compact: false,
                                context: context),
                            status: walletState.walletHistoryData[index].status!
                                .capitalizeFirst,
                            time: DateFormat('d, MMMM yyyy').format(
                                DateTime.parse(walletState
                                        .walletHistoryData[index].createdAt ??
                                    ''))),
                      );
                    },
                  ),
                  footer: CustomFooter(
                    builder: (BuildContext context, LoadStatus? mode) {
                      Widget? body;
                      if (mode == LoadStatus.idle) {
                        body = Text("pull up to load");
                      } else if (mode == LoadStatus.loading) {
                        body = Platform.isIOS
                            ? CupertinoActivityIndicator()
                            : SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator());
                      } else if (mode == LoadStatus.failed) {
                        body = Text("Load Failed!Click retry!");
                      } else if (mode == LoadStatus.noMore) {
                        body = Text("No more Data");
                      } else if (mode == LoadStatus.canLoading) {
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
      ),
    );
  }
}

class WalletHistoryCard extends StatelessWidget {
  final String? title;
  final String? amount;
  final String? status;
  final String? time;
  const WalletHistoryCard({
    Key? key,
    required this.title,
    this.amount,
    this.status,
    required this.time,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: CbColors.white, borderRadius: BorderRadius.circular(4)),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(title!.contains('Debit')
                  ? 'wallet-failed'.svg
                  : 'wallet-success'.svg),
              XMargin(16),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('$title', style: CbTextStyle.medium),
                        Text('$amount',
                            style: CbTextStyle.bold16.copyWith(
                              fontFamily: 'Roboto',
                                color: status!.contains('Success')
                                    ? CbColors.cSuccessBase
                                    : CbColors.cAccentBase)),
                      ],
                    ),
                    YMargin(4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('$time', style: CbTextStyle.book12),
                        Spacer(),
                        Text('$status',
                            style: CbTextStyle.book12.copyWith(
                                color: status!.contains('Success')
                                    ? CbColors.cSuccessBase
                                    : CbColors.cErrorBase)),
                        XMargin(8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 1.0),
                          child: Icon(Icons.arrow_forward_ios,
                              size: 10,
                              color: status!.contains('Success')
                                  ? CbColors.cSuccessBase
                                  : CbColors.cErrorBase),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
