import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/textstyles.dart';
import 'package:cubex/src/core/utils/dimensions.dart';
import 'package:cubex/src/core/utils/spacer.dart';
import 'package:flutter/material.dart';

class CbBorderedButton extends StatelessWidget {
  const CbBorderedButton(
      {Key? key,
      this.onPressed,
      this.text,
      this.loadingState = false,
      this.buttonColor,
      this.bgColor,
      this.textColor,
      this.buttonTextSize,
      this.buttonRadius,
      this.icon,
      this.enabled = true,
      this.letterSpacing = 1,
      this.withIcon = false})
      : super(key: key);

  final VoidCallback? onPressed;

  final String? text;
  final double? letterSpacing;
  final bool enabled;
  final bool loadingState;
  final Color? buttonColor;
  final Color? bgColor;
  final Color? textColor;
  final Widget? icon;
  final bool? withIcon;
  final double? buttonTextSize;
  final BorderRadius? buttonRadius;

  @override
  Widget build(BuildContext context) {
    final SizeConfig config = SizeConfig();
    final textWidget = Text(
      "$text",
      textAlign: TextAlign.center,
      maxLines: 1,
      // overflow: TextOverflow.ellipsis,
      style: CbTextStyle.bold16.copyWith(
          color: enabled ? textColor ?? CbColors.cAccentBase : CbColors.cGray2,
          letterSpacing: letterSpacing),
    );
    return Container(
      width: double.infinity,
      height: config.sh(53),
      child: loadingState
          ? Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(CbColors.cPrimaryBase),
              ),
            )
          : TextButton(
              onPressed: enabled ? onPressed : null,
              child: withIcon!
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        icon!,
                        XMargin(16),
                        textWidget,
                      ],
                    )
                  : textWidget,
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      bgColor ?? CbColors.transparent),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      side: BorderSide(
                          color: enabled
                              ? buttonColor ?? CbColors.cPrimaryBase
                              : CbColors.cPrimaryLighten3),
                      borderRadius: buttonRadius ?? BorderRadius.circular(4)))),
            ),
    );
  }
}
