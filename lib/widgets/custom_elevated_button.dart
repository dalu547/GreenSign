import 'package:flutter/material.dart';

import '../theme/theme_helper.dart';
import 'base_button.dart';

class CustomElevatedButton extends BaseButton {
  CustomElevatedButton({
    Key? key,
    this.decoration,
    this.leftIcon,
    this.rightIcon,
    EdgeInsets? margin,
    VoidCallback? onPressed,
    ButtonStyle? buttonStyle,
    Alignment? alignment,
    TextStyle? buttonTextStyle,
    bool? isDisabled,
    double? height,
    double? width,
    required String text,
  }) : super(
          text: text,
          onPressed: onPressed,
          buttonStyle: buttonStyle,
          isDisabled: isDisabled,
          buttonTextStyle: buttonTextStyle,
          height: height,
          width: width,
          alignment: alignment,
          margin: margin,
        );

  final BoxDecoration? decoration;
  final Widget? leftIcon;
  final Widget? rightIcon;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment ?? Alignment.center,
      child: buildElevatedButtonWidget,
    );
  }

  Widget get buildElevatedButtonWidget => Container(
        width: 130,
        height: 35,
        margin: margin,
        decoration: decoration,
        child: ElevatedButton(
          style: buttonStyle,
          onPressed: isDisabled ?? false ? null : onPressed ?? () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              leftIcon ?? Padding(padding: EdgeInsets.zero),
              Expanded(
                child: Center(
                  child: Text(
                    text,
                    style: buttonTextStyle ?? theme.textTheme.labelLarge?.copyWith(color: Colors.black),
                  ),
                ),
              ),
              rightIcon ?? Padding(padding: EdgeInsets.zero),
            ],
          ),
        ),
      );
}
