// ignore: must_be_immutable
import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/textstyles.dart';
import 'package:cubex/src/core/utils/spacer.dart';
import 'package:flutter/material.dart';

class TradeCards extends StatelessWidget {
  final String? amount;
  final String? time;
  final String? status;
  final String? rate;
  final String? price;
  final String? title;
  const TradeCards({
    Key? key,
    required this.amount,
    required this.time,
    required this.status,
    required this.rate,
    required this.price,
    required this.title,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: CbColors.white,
      ),
      // height: 230,
      // width: 300,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '$title',
                style: CbTextStyle.medium,
              ),
              Spacer(),
              Text(
                '$price',
                style: CbTextStyle.bold16.copyWith(
                    fontFamily: 'Roboto',
                    color:status!.contains('Success')
                          ? CbColors.cSuccessBase
                          : status!.contains('Pending')
                              ? CbColors.cWarningBase
                              : CbColors.cErrorBase),
              )
            ],
          ),
          YMargin(8),
          Divider(
            color: CbColors.cPrimaryLighten5,
            thickness: .5,
          ),
          YMargin(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Amount: $amount',
                style: CbTextStyle.book12,
              ),
              Text(
                '$time',
                style: CbTextStyle.book12,
              )
            ],
          ),
          YMargin(4),
          Row(
            children: [
              Text(
                'Rate: $rate',
                style: CbTextStyle.book12,
              ),
              Spacer(),
              Text('$status',
                  style: CbTextStyle.book12.copyWith(
                      color: status!.contains('Success')
                          ? CbColors.cSuccessBase
                          : status!.contains('Pending')
                              ? CbColors.cWarningBase
                              : CbColors.cErrorBase)),
              XMargin(8),
              Padding(
                  padding: const EdgeInsets.only(bottom: 1.0),
                  child: Icon(Icons.arrow_forward_ios,
                      size: 10,
                      color: status!.contains('Success')
                          ? CbColors.cSuccessBase
                          : status!.contains('Pending')
                              ? CbColors.cWarningBase
                              : CbColors.cErrorBase)),
            ],
          ),
          YMargin(4),
        ],
      ),
    );
  }
}
