import 'package:cubex/src/config/styles/colors.dart';
import 'package:cubex/src/config/styles/textstyles.dart';
import 'package:cubex/src/core/utils/dimensions.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CbDropDownDynamic<T> extends StatefulWidget {
  CbDropDownDynamic({
    this.label,
    this.onChanged,
    this.validator,
    this.selected,
    required this.options,
    this.suffix,
    required this.getDisplayName,
    this.hint,
  });

  final String? Function(Object?)? validator;
  final List<T>? options;
  final Function(T?)? onChanged;
  final T? selected;
  final String? hint;
  final Widget? suffix;
  final String? label;
  final String? Function(T)? getDisplayName;
  static SizeConfig config = SizeConfig();

  @override
  _CbDropDownDynamicState<T> createState() => _CbDropDownDynamicState<T>();
}

class _CbDropDownDynamicState<T> extends State<CbDropDownDynamic<T>> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: <Widget>[
              DropdownButtonFormField<T>(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: widget.validator,
                items: widget.options!.map<DropdownMenuItem<T>>((f) {
                  return DropdownMenuItem<T>(
                    child: Text(
                      '${widget.getDisplayName!(f)}',
                      style: CbTextStyle.book14,
                    ),
                    value: f,
                  );
                }).toList(),
                style: CbTextStyle.bold16,
                onChanged: widget.onChanged,
                value: widget.selected,
                decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: CbTextStyle.hint,
                    border: border,
                    enabledBorder: border,
                    errorStyle: CbTextStyle.error,
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: CbColors.cErrorBase),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: CbColors.cErrorBase),
                    ),
                    focusedBorder: border,
                    disabledBorder: border),
                icon: Padding(
                    padding: EdgeInsetsDirectional.only(end: 2, top: 5),
                    child: Icon(Icons.keyboard_arrow_down_rounded)),
              ),
              Positioned(
                  left: 13,
                  top: 8,
                  child: Text(
                    widget.selected == null ? '' : widget.label!,
                    style: CbTextStyle.label,
                  ))
            ],
          ),
        ],
      ),
    );
  }

  OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: CbColors.cAccentLighten5));
}
