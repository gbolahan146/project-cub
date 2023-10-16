import 'package:cubex/src/core/utils/helpers.dart';
import 'package:cubex/src/data/models/fetch_cards_trans.dart';
import 'package:cubex/src/data/models/fetch_crypto_trans.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/textstyles.dart';
import 'package:cubex/src/core/utils/extensions.dart';
import 'package:cubex/src/core/utils/spacer.dart';
import 'package:cubex/src/data/models/fetch_wallet_history_resp.dart';
import 'package:cubex/src/presentation/widgets/buttons/bordered_button.dart';
import 'package:cubex/src/presentation/widgets/buttons/theme_button.dart';

class FloatingBottomSheetContainer extends StatelessWidget {
  final Widget? child;
  const FloatingBottomSheetContainer({
    Key? key,
    required this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: child);
  }
}

class BottomSheetContainer extends StatelessWidget {
  final Widget? child;
  final String? title;
  const BottomSheetContainer({
    Key? key,
    required this.child,
    this.title,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0, top: 24),
                child: Row(
                  children: [
                    Text(
                      "$title",
                      style: CbTextStyle.bold24,
                    ),
                    Spacer(),
                    GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.clear, color: CbColors.cAccentBase))
                  ],
                ),
              ),
              child ?? SizedBox(),
            ],
          ),
        ));
  }
}

class WalletDetailsBottomSheet extends StatelessWidget {
  final String? amount;
  final String? status;
  final String? time;
  final HistoryMeta? meta;
  final String? type;
  final String? reason;
  final String? action;
  final String? id;
  const WalletDetailsBottomSheet({
    Key? key,
    this.amount,
    this.status,
    this.time,
    this.meta,
    this.type,
    this.reason,
    this.action,
    this.id,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0, top: 24),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Amount:",
                      style: CbTextStyle.book12,
                    ),
                    YMargin(4),
                    Text(
                      "$amount",
                      style: CbTextStyle.bold16.copyWith(
                          fontFamily: 'Roboto', color: CbColors.cAccentBase),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    reason!.toLowerCase().contains('transfer') ||
                            reason!.contains('Credit')
                        ? Text(
                            action!.contains('debit')
                                ? "Transfer to:"
                                : "Transfer from:",
                            style: CbTextStyle.book12,
                          )
                        : Text(
                            "Withdraw to:",
                            style: CbTextStyle.book12,
                          ),
                    YMargin(4),
                    if (meta != null)
                      Text("${meta?.name}",
                          style: CbTextStyle.bold16
                              .copyWith(color: CbColors.cAccentBase))
                    else
                      Text("User",
                          style: CbTextStyle.bold16
                              .copyWith(color: CbColors.cAccentBase)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: CbColors.cPrimaryLighten5,
        ),
        if (type == "Bank")
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0, top: 24),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bank:",
                        style: CbTextStyle.book12,
                      ),
                      YMargin(4),
                      Text(
                        "${meta?.bankName}",
                        style: CbTextStyle.bold16
                            .copyWith(color: CbColors.cAccentBase),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Account number:",
                        style: CbTextStyle.book12,
                      ),
                      YMargin(4),
                      Text("${meta?.account}",
                          style: CbTextStyle.bold16
                              .copyWith(color: CbColors.cAccentBase)),
                    ],
                  ),
                ),
              ],
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0, top: 24),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Channel:",
                        style: CbTextStyle.book12,
                      ),
                      YMargin(4),
                      Text(
                        "Cubex Account",
                        style: CbTextStyle.bold16
                            .copyWith(color: CbColors.cAccentBase),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Status:",
                        style: CbTextStyle.book12,
                      ),
                      YMargin(4),
                      Text(
                        "$status",
                        style: CbTextStyle.bold16.copyWith(
                            color: status!.contains('Success')
                                ? CbColors.cSuccessBase
                                : CbColors.cErrorBase),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        if (type == "Bank")
          Divider(
            color: CbColors.cPrimaryLighten5,
          ),
        if (type == "Bank")
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0, top: 24),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Status:",
                        style: CbTextStyle.book12,
                      ),
                      YMargin(4),
                      Text(
                        "$status",
                        style: CbTextStyle.bold16.copyWith(
                            color: status!.contains('Success')
                                ? CbColors.cSuccessBase
                                : CbColors.cErrorBase),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        Divider(
          color: CbColors.cPrimaryLighten5,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0, top: 24),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Transaction ID:",
                      style: CbTextStyle.book12,
                    ),
                    YMargin(4),
                    Text(
                      "$id",
                      style: CbTextStyle.bold16
                          .copyWith(color: CbColors.cAccentBase),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        YMargin(16),
        CbBorderedButton(
            text: 'Share transaction',
            bgColor: CbColors.cPrimaryLighten5,
            textColor: CbColors.cPrimaryBase,
            buttonColor: CbColors.cPrimaryBase,
            onPressed: () => Share.share(
                'Transaction ID: $id was on the $time and the status is ${status ?? ''}')),
        YMargin(24),
        Container(
          margin: EdgeInsets.only(bottom: 40),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: CbColors.cErrorLighten5,
          ),
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              SvgPicture.asset('info'.svg),
              XMargin(16),
              Column(
                children: [
                  Text("Report Transaction",
                      style: CbTextStyle.medium
                          .copyWith(color: CbColors.cErrorBase)),
                  YMargin(4),
                  Text(
                    "Report an issue with this transaction",
                    style: CbTextStyle.book12,
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              Spacer(),
              Icon(Icons.arrow_forward_ios,
                  size: 15, color: CbColors.cAccentBase)
            ],
          ),
        )
      ],
    );
  }
}

class CryptoDetailsBottomSheet extends StatelessWidget {
  final CryptoTransData transaction;
  const CryptoDetailsBottomSheet({
    Key? key,
    required this.transaction,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0, top: 24),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Amount expected:",
                      style: CbTextStyle.book12,
                    ),
                    YMargin(4),
                    Text(
                      ParserService.formatToMoney(
                          (transaction.amountExpected ??
                              transaction.amount ??
                              0),
                          context: context,
                          compact: false),
                      style: CbTextStyle.bold16.copyWith(
                          color: CbColors.cAccentBase, fontFamily: 'Roboto'),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Amount to sell:",
                      style: CbTextStyle.book12,
                    ),
                    YMargin(4),
                    Text("\$${transaction.amount!}",
                        style: CbTextStyle.bold16
                            .copyWith(color: CbColors.cAccentBase)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: CbColors.cPrimaryLighten5,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0, top: 24),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Crypto:",
                      style: CbTextStyle.book12,
                    ),
                    YMargin(4),
                    Text(
                      "${transaction.crypto?.name}",
                      style: CbTextStyle.bold16
                          .copyWith(color: CbColors.cAccentBase),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rate:",
                      style: CbTextStyle.book12,
                    ),
                    YMargin(4),
                    Text("@${transaction.rate}/\$",
                        style: CbTextStyle.bold16
                            .copyWith(color: CbColors.cAccentBase)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: CbColors.cPrimaryLighten5,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0, top: 24),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Status:",
                      style: CbTextStyle.book12,
                    ),
                    YMargin(4),
                    Text(
                      "${transaction.status!.capitalizeFirst}",
                      style: CbTextStyle.bold16.copyWith(
                          color: transaction.status!.contains('success')
                              ? CbColors.cSuccessBase
                              : transaction.status!.contains('pending')
                                  ? CbColors.cWarningBase
                                  : CbColors.cErrorBase),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: CbColors.cPrimaryLighten5,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0, top: 24),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Transaction ID:",
                      style: CbTextStyle.book12,
                    ),
                    YMargin(4),
                    Text(
                      "${transaction.id}",
                      style: CbTextStyle.bold16
                          .copyWith(color: CbColors.cAccentBase),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        YMargin(16),
        CbBorderedButton(
            text: 'Share transaction',
            bgColor: CbColors.cPrimaryLighten5,
            textColor: CbColors.cPrimaryBase,
            buttonColor: CbColors.cPrimaryBase,
            onPressed: () => Share.share(
                'Transaction ID: ${transaction.id} was on the  ${DateFormat('dd/MM/yyyy | hh:mm').format(DateTime.parse(transaction.createdAt ?? ''))} and the status is ${transaction.status}')),
        YMargin(24),
        Container(
          margin: EdgeInsets.only(bottom: 40),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: CbColors.cErrorLighten5,
          ),
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              SvgPicture.asset('info'.svg),
              XMargin(16),
              Column(
                children: [
                  Text("Report Transaction",
                      style: CbTextStyle.medium
                          .copyWith(color: CbColors.cErrorBase)),
                  YMargin(4),
                  Text(
                    "Report an issue with this transaction",
                    style: CbTextStyle.book12,
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              Spacer(),
              Icon(Icons.arrow_forward_ios,
                  size: 15, color: CbColors.cAccentBase)
            ],
          ),
        )
      ],
    );
  }
}

class GiftcardDetailsBottomSheet extends StatelessWidget {
  final GiftTransData transaction;
  const GiftcardDetailsBottomSheet({
    Key? key,
    required this.transaction,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0, top: 24),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Amount expected:",
                      style: CbTextStyle.book12,
                    ),
                    YMargin(4),
                    Text(
                      ParserService.formatToMoney(
                          transaction.amountExpected ??transaction.amount ?? 0,
                          context: context,
                          compact: false),
                      style: CbTextStyle.bold16.copyWith(
                          fontFamily: 'Roboto', color: CbColors.cAccentBase),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Giftcard:",
                      style: CbTextStyle.book12,
                    ),
                    YMargin(4),
                    Text("${transaction.giftCard?.name ?? ''}",
                        style: CbTextStyle.bold16
                            .copyWith(color: CbColors.cAccentBase)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: CbColors.cPrimaryLighten5,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0, top: 24),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Country:",
                      style: CbTextStyle.book12,
                    ),
                    YMargin(4),
                    Text(
                      "${transaction.giftCard?.country}",
                      style: CbTextStyle.bold16
                          .copyWith(color: CbColors.cAccentBase),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rate:",
                      style: CbTextStyle.book12,
                    ),
                    YMargin(4),
                    Text("@${transaction.rate}/\$",
                        style: CbTextStyle.bold16
                            .copyWith(color: CbColors.cAccentBase)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: CbColors.cPrimaryLighten5,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0, top: 24),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Card type:",
                      style: CbTextStyle.book12,
                    ),
                    YMargin(4),
                    Text(
                      "${transaction.giftCard?.type}",
                      style: CbTextStyle.bold16
                          .copyWith(color: CbColors.cAccentBase),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: CbColors.cPrimaryLighten5,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0, top: 24),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Status:",
                      style: CbTextStyle.book12,
                    ),
                    YMargin(4),
                    Text(
                      "${transaction.status!.capitalizeFirst}",
                      style: CbTextStyle.bold16.copyWith(
                          color: transaction.status!.contains('success')
                              ? CbColors.cSuccessBase
                              : transaction.status!.contains('pending')
                                  ? CbColors.cWarningBase
                                  : CbColors.cErrorBase),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: CbColors.cPrimaryLighten5,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0, top: 24),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Transaction ID:",
                      style: CbTextStyle.book12,
                    ),
                    YMargin(4),
                    Text(
                      "${transaction.id}",
                      style: CbTextStyle.bold16
                          .copyWith(color: CbColors.cAccentBase),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        YMargin(16),
        CbBorderedButton(
            text: 'Share transaction',
            bgColor: CbColors.cPrimaryLighten5,
            textColor: CbColors.cPrimaryBase,
            buttonColor: CbColors.cPrimaryBase,
            onPressed: () => Share.share(
                'Transaction ID: ${transaction.id} was on the ${DateFormat('dd/MM/yyyy | hh:mm').format(DateTime.parse(transaction.createdAt ?? ''))} and the status is ${transaction.status}')),
        YMargin(24),
        Container(
          margin: EdgeInsets.only(bottom: 40),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: CbColors.cErrorLighten5,
          ),
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              SvgPicture.asset('info'.svg),
              XMargin(16),
              Column(
                children: [
                  Text("Report Transaction",
                      style: CbTextStyle.medium
                          .copyWith(color: CbColors.cErrorBase)),
                  YMargin(4),
                  Text(
                    "Report an issue with this transaction",
                    style: CbTextStyle.book12,
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              Spacer(),
              Icon(Icons.arrow_forward_ios,
                  size: 15, color: CbColors.cAccentBase)
            ],
          ),
        )
      ],
    );
  }
}

class SuccessBottomSheet extends StatelessWidget {
  final Function()? callback;
  final String? subtitle;
  final String? btnText;
  const SuccessBottomSheet({
    Key? key,
    this.callback,
    this.btnText,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        YMargin(24),
        Image.asset(
          'success'.png,
          scale: 1.4,
        ),
        YMargin(40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 38),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Success!',
                  style: CbTextStyle.bold24
                      .copyWith(color: CbColors.cSuccessDarken4)),
              YMargin(8),
              Text('$subtitle',
                  textAlign: TextAlign.center,
                  style: CbTextStyle.book16
                      .copyWith(color: CbColors.cSuccessBase, fontFamily:'Roboto')),
            ],
          ),
        ),
        YMargin(40),
        CbBorderedButton(
          text: btnText ?? 'Go home',
          onPressed: callback,
          bgColor: CbColors.cSuccessLighten5,
          buttonColor: CbColors.cSuccessBase,
          textColor: CbColors.cSuccessBase,
        ),
        YMargin(16),
      ],
    );
  }
}

class ConfirmBottomSheet extends StatefulWidget {
  final Function()? callback;
  final String? name;
  final String? amount;
  final bool loading;
  final String? type;
  const ConfirmBottomSheet({
    Key? key,
    this.callback,
    this.amount,
    this.loading = false,
    this.type,
    this.name,
  }) : super(key: key);

  @override
  State<ConfirmBottomSheet> createState() => _ConfirmBottomSheetState();
}

class _ConfirmBottomSheetState extends State<ConfirmBottomSheet> {
  bool _loading = false;

  @override
  void initState() {
    _loading = widget.loading;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          YMargin(24),
          SvgPicture.asset(
            'confirm'.svg,
          ),
          YMargin(40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 38),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                    widget.type == "transfer"
                        ? 'Confirm transfer to:'
                        : 'Confirm withdrawal to:',
                    style: CbTextStyle.book14),
                YMargin(4),
                Text('${widget.name}',
                    textAlign: TextAlign.center, style: CbTextStyle.bold24),
                YMargin(16),
                Text('Confirm amount:', style: CbTextStyle.book14),
                YMargin(4),
                Text('${widget.amount}',
                    textAlign: TextAlign.center,
                    style: CbTextStyle.bold24.copyWith(fontFamily: 'Roboto')),
              ],
            ),
          ),
          YMargin(40),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: CbBorderedButton(
                  text: 'Cancel',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  bgColor: CbColors.cErrorLighten5,
                  buttonColor: CbColors.cErrorBase,
                  textColor: CbColors.cErrorBase,
                ),
              ),
              XMargin(8),
              Expanded(
                flex: 2,
                child: CbThemeButton(
                  text: 'Make transfer',
                  loadingState: _loading,
                  onPressed: () {
                    setState(() {
                      _loading = true;
                    });
                    widget.callback?.call();
                  },
                  buttonColor: CbColors.cPrimaryBase,
                ),
              ),
            ],
          ),
          YMargin(16),
        ],
      ),
    );
  }
}

class TradeTermsBottomSheet extends StatefulWidget {
  final Function() callback;
  final String title;
  final String country;
  final String price;
  final String? startCode;
  const TradeTermsBottomSheet({
    Key? key,
    required this.callback,
    required this.title,
    required this.country,
    this.startCode,
    required this.price,
  }) : super(key: key);

  @override
  _TradeTermsBottomSheetState createState() => _TradeTermsBottomSheetState();
}

class _TradeTermsBottomSheetState extends State<TradeTermsBottomSheet> {
  bool selected = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setter) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            color: CbColors.cPrimaryLighten5,
            thickness: .5,
          ),
          YMargin(24),
          Text(
            '''1. This transaction is for ${widget.country} ${widget.title} Giftcard with credit receipt trade.
2. The acceptable denomination for this trade is \$${widget.price} only.
3. Ensure to send physical clear pictures of the receipt & giftcard.
4. Ensure to send receipts before sending the giftcard.
5. ${widget.title} transactions takes about 2-20mins to process successfully, please exercise patience during this trade.''',
            style: CbTextStyle.book16,
          ),
          if (widget.startCode != null)
            Text(
              '6. The acceptable ${widget.country} ${widget.title} Giftcard must begin with ${widget.startCode}',
              style: CbTextStyle.book16.copyWith(
                  color: CbColors.cErrorBase, fontStyle: FontStyle.italic),
            ),
          YMargin(30),
          Text(
            'Payment will be sent immediately the trade is completed.',
            style: CbTextStyle.book16,
          ),
          YMargin(40),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Checkbox(
                    checkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    activeColor: CbColors.cPrimaryBase,
                    value: selected,
                    onChanged: (val) {
                      setter(() {
                        selected = val!;
                      });
                    }),
              ),
              Text(
                "Click to agree to Cubex’s trade terms",
                style:
                    CbTextStyle.book14.copyWith(color: CbColors.cPrimaryBase),
              ),
            ],
          ),
          YMargin(24),
          CbThemeButton(
              loadingState: isLoading,
              text: 'Begin trade',
              onPressed: () {
                if (selected) {
                  setter(() {
                    isLoading = true;
                  });
                  widget.callback();
                } else {
                  showErrorToast(
                      message:
                          'Please agree to Cubex’s trade terms before proceeding.');
                }
              }),
          YMargin(24),
        ],
      );
    });
  }
}
