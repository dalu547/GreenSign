import 'package:GreenSign/core/utils/size_utils.dart';
import 'package:GreenSign/theme/theme_helper.dart';
import 'package:flutter/material.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Body text style
  static get bodyLargeBluegray90001 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.blueGray90001,
      );
  static get bodyLargeGray80099 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.gray80099,
      );
  static get bodyLargeGray80099_1 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.gray80099.withOpacity(0.3),
      );
  static get bodyLargeInterBluegray90001 =>
      theme.textTheme.bodyLarge!.inter.copyWith(
        color: appTheme.blueGray90001,
        fontSize: 16.fSize,
      );
  static get bodyLargeInterBluegray90001_1 =>
      theme.textTheme.bodyLarge!.inter.copyWith(
        color: appTheme.blueGray90001,
      );
  static get bodyLargeLightblue600 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.lightBlue600,
      );
  static get bodyLargePrimary => theme.textTheme.bodyLarge!.copyWith(
        color: theme.colorScheme.primary,
      );
  static get bodyLargePrimary_1 => theme.textTheme.bodyLarge!.copyWith(
        color: theme.colorScheme.primary,
      );
  static get bodyLargeRoboto => theme.textTheme.bodyLarge!.roboto.copyWith(
        fontSize: 16.fSize,
      );
  static get bodyLargeRobotoBluegray90001 =>
      theme.textTheme.bodyLarge!.roboto.copyWith(
        color: appTheme.blueGray90001,
      );
  static get bodyLargeRobotoOnPrimary =>
      theme.textTheme.bodyLarge!.roboto.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 16.fSize,
      );
  static get bodyLarge_1 => theme.textTheme.bodyLarge!;
  static get bodyLarge_2 => theme.textTheme.bodyLarge!;
  static get bodyMedium15 => theme.textTheme.bodyMedium!.copyWith(
        fontSize: 15.fSize,
      );
  static get bodyMediumBlack900 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.black900,
        fontSize: 14.fSize,
      );
  static get bodyMediumBluegray400 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.blueGray400,
      );
  static get bodyMediumBluegray90001 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.blueGray90001,
      );
  static get bodyMediumInter => theme.textTheme.bodyMedium!.inter;
  static get bodyMediumInterBluegray90001 =>
      theme.textTheme.bodyMedium!.inter.copyWith(
        color: appTheme.blueGray90001,
        fontSize: 14.fSize,
      );
  static get bodyMediumInterBluegray90001_1 =>
      theme.textTheme.bodyMedium!.inter.copyWith(
        color: appTheme.blueGray90001,
      );
  static get bodyMediumInterRed500 =>
      theme.textTheme.bodyMedium!.inter.copyWith(
        color: appTheme.red500,
        fontSize: 14.fSize,
      );
  static get bodyMediumInterWhiteA700 =>
      theme.textTheme.bodyMedium!.inter.copyWith(
        color: appTheme.whiteA700,
        fontSize: 14.fSize,
      );
  static get bodyMediumPrimary => theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 15.fSize,
      );
  static get bodyMediumRoboto => theme.textTheme.bodyMedium!.roboto.copyWith(
        fontSize: 14.fSize,
      );
  static get bodyMediumRoboto14 => theme.textTheme.bodyMedium!.roboto.copyWith(
        fontSize: 14.fSize,
      );
  static get bodyMediumRobotoBluegray400 =>
      theme.textTheme.bodyMedium!.roboto.copyWith(
        color: appTheme.blueGray400,
      );
  static get bodyMediumRobotoGray800 =>
      theme.textTheme.bodyMedium!.roboto.copyWith(
        color: appTheme.gray800,
        fontSize: 14.fSize,
      );
  static get bodyMediumWhiteA700 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.whiteA700,
      );
  static get bodyMedium_1 => theme.textTheme.bodyMedium!;
  static get bodyMedium_2 => theme.textTheme.bodyMedium!;
  static get bodySmallInter => theme.textTheme.bodySmall!.inter;
  static get bodySmallInterBluegray90001 =>
      theme.textTheme.bodySmall!.inter.copyWith(
        color: appTheme.blueGray90001,
      );
  static get bodySmallInterRed500 => theme.textTheme.bodySmall!.inter.copyWith(
        color: appTheme.red500,
      );
  static get bodySmallInterWhiteA700 =>
      theme.textTheme.bodySmall!.inter.copyWith(
        color: appTheme.whiteA700.withOpacity(0.62),
      );
  static get bodySmallRed500 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.red500,
      );
  static get bodySmallRobotoWhiteA700 =>
      theme.textTheme.bodySmall!.roboto.copyWith(
        color: appTheme.whiteA700,
      );
  static get bodySmallSFProTextWhiteA700 =>
      theme.textTheme.bodySmall!.sFProText.copyWith(
        color: appTheme.whiteA700,
      );
  // Display style
  static get displaySmallInter => theme.textTheme.displaySmall!.inter;
  // Label text style
  static get labelLargeBluegray500 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.blueGray500,
        fontSize: 13.fSize,
      );
  static get labelMediumPrimary => theme.textTheme.labelMedium!.copyWith(
        color: theme.colorScheme.primary,
      );
  // Title text style
  static get titleLargeInterBluegray90001 =>
      theme.textTheme.titleLarge!.inter.copyWith(
        color: appTheme.blueGray90001,
        fontSize: 20.fSize,
        fontWeight: FontWeight.w600,
      );
  static get titleLargeRobotoWhiteA700 =>
      theme.textTheme.titleLarge!.roboto.copyWith(
        color: appTheme.whiteA700,
        fontWeight: FontWeight.w400,
      );
  static get titleLargeSemiBold => theme.textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.w600,
      );
  static get titleLargeWhiteA700 => theme.textTheme.titleLarge!.copyWith(
        color: appTheme.whiteA700,
        fontSize: 20.fSize,
        fontWeight: FontWeight.w600,
      );
  static get titleMediumInterBluegray90001 =>
      theme.textTheme.titleMedium!.inter.copyWith(
        color: appTheme.blueGray90001,
        fontSize: 16.fSize,
      );
  static get titleMediumOnPrimary => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimary,
      );
  static get titleMediumSFProTextWhiteA700 =>
      theme.textTheme.titleMedium!.sFProText.copyWith(
        color: appTheme.whiteA700,
      );
  static get titleMediumWhiteA700 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.whiteA700,
      );
  static get titleMediumWhiteA700_1 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.whiteA700,
      );
  static get titleMedium_1 => theme.textTheme.titleMedium!;
  static get titleSmallBluegray500 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.blueGray500,
        fontSize: 14.fSize,
      );
  static get titleSmallInterBluegray500 =>
      theme.textTheme.titleSmall!.inter.copyWith(
        color: appTheme.blueGray500,
        fontSize: 14.fSize,
      );
  static get titleSmallInterBluegray90001 =>
      theme.textTheme.titleSmall!.inter.copyWith(
        color: appTheme.blueGray90001,
        fontSize: 14.fSize,
        fontWeight: FontWeight.w600,
      );
  static get titleSmallRobotoBlueA200 =>
      theme.textTheme.titleSmall!.roboto.copyWith(
        color: appTheme.blueA200,
        fontSize: 14.fSize,
      );
  static get titleSmallRobotoWhiteA700 =>
      theme.textTheme.titleSmall!.roboto.copyWith(
        color: appTheme.whiteA700,
        fontSize: 14.fSize,
      );
}

extension on TextStyle {
  TextStyle get islandMoments {
    return copyWith(
      fontFamily: 'Island Moments',
    );
  }

  TextStyle get sFPro {
    return copyWith(
      fontFamily: 'SF Pro',
    );
  }

  TextStyle get roboto {
    return copyWith(
      fontFamily: 'Roboto',
    );
  }

  TextStyle get inter {
    return copyWith(
      fontFamily: 'Inter',
    );
  }

  TextStyle get sFProText {
    return copyWith(
      fontFamily: 'SF Pro Text',
    );
  }
}
