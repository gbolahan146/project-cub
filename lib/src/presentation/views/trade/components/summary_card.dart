import 'package:cubex/src/data/models/fetch_cryptos.dart';
import 'package:flutter/material.dart';

import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/textstyles.dart';
import 'package:cubex/src/core/utils/dimensions.dart';
import 'package:cubex/src/core/utils/helpers.dart';
import 'package:cubex/src/core/utils/spacer.dart';

class TradeSummaryCard extends StatelessWidget {
  final CryptosData data;
  final num amount;
  final num amountExpected;
  final Rate? rate;
  final BuildContext context;
  const TradeSummaryCard({
    Key? key,
    required this.amount,
    required this.amountExpected,
    required this.data,
    required this.rate,
    required this.context,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final config = SizeConfig();
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: CbColors.cPrimaryLighten5)),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Summary.',
              style: CbTextStyle.medium.copyWith(
                  color: CbColors.cAccentLighten3, fontSize: config.sp(14))),
          YMargin(16),
          SummaryRow(title: 'Crypto', subtitle: data.name ?? ''),
          Divider(
            color: CbColors.cPrimaryLighten5,
            thickness: .5,
          ),
          SummaryRow(title: 'Amount to sell', subtitle: '\$$amount'),
          Divider(
            color: CbColors.cPrimaryLighten5,
            thickness: .5,
          ),
          SummaryRow(
            title: 'Amount expected',
            subtitle: ParserService.formatToMoney(amountExpected,
                context: context, compact: false),
          ),
          Divider(
            color: CbColors.cPrimaryLighten5,
            thickness: .5,
          ),
          SummaryRow(
            title: 'Rate:',
            subtitle:
                '@${rate?.below} below \$${rate?.mark} / @${rate?.above} above \$${rate?.mark}',
          ),
        ],
      ),
    );
  }

  calculateAmount(
      {required num value,
      required num above,
      required num mark,
      required num below}) {
    if (value <= mark) {
      return value * below;
    } else if (value > mark) {
      return value * above;
    }
    return 0;
  }
}

class GiftCardTradeSummaryCard extends StatelessWidget {
  final String name;
  final String type;
  final String country;
  final num amount;
  final num rate;
  const GiftCardTradeSummaryCard({
    Key? key,
    required this.name,
    required this.rate,
    required this.type,
    required this.country,
    required this.amount,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final config = SizeConfig();
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: CbColors.cPrimaryLighten5)),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Summary.',
              style: CbTextStyle.medium.copyWith(
                  color: CbColors.cAccentLighten3, fontSize: config.sp(14))),
          YMargin(16),
          SummaryRow(title: 'Giftcard', subtitle: name),
          Divider(
            color: CbColors.cPrimaryLighten5,
            thickness: .5,
          ),
          SummaryRow(title: 'Country', subtitle: country),
          Divider(
            color: CbColors.cPrimaryLighten5,
            thickness: .5,
          ),
          SummaryRow(title: 'Card type', subtitle: '$type'),
          Divider(
            color: CbColors.cPrimaryLighten5,
            thickness: .5,
          ),
          SummaryRow(
              title: 'Amount expected',
              subtitle:
                  ' ${ParserService.formatToMoney(amount, context: context, compact: false)} @$rate/\$'),
        ],
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String title;
  final String subtitle;
  const SummaryRow({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          Text(
            '$title',
            style: CbTextStyle.book12,
          ),
          Spacer(),
          Text(
            '$subtitle',
            style: CbTextStyle.bold12.copyWith(fontFamily: 'Roboto'),
          ),
        ],
      ),
    );
  }
}
