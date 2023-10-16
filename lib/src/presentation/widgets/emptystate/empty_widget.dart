import 'package:flutter/material.dart';

import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/textstyles.dart';
import 'package:cubex/src/core/utils/extensions.dart';
import 'package:cubex/src/core/utils/spacer.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final double? topPadding;
  const EmptyStateWidget({
    Key? key,
    this.title = '',
    this.topPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 70, right: 70, top: topPadding ?? 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'empty'.png,
            scale: 1.8,
          ),
          YMargin(24),
          Text(
            title,
            style: CbTextStyle.book16.copyWith(color: CbColors.cAccentLighten4),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
