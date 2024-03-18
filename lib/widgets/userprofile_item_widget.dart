import 'package:GreenSigner/core/utils/size_utils.dart';
import 'package:GreenSigner/model/envelope_count.dart';
import 'package:flutter/material.dart';

import '../../core/utils/image_constant.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/custom_image_view.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserprofileItemWidget extends StatelessWidget {
  final EnvelopeCount? envelopeCount;
  final int index;
  final Function(int) onTapManageTab;

  List<String> icons = [
    ImageConstant.imgExclamationCircle,
    ImageConstant.imgClock,
    ImageConstant.imgInfo,
    ImageConstant.imgCheck
  ];


  UserprofileItemWidget(this.envelopeCount, this.index, this.onTapManageTab);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        print("box index $index");
        onTapManageTab(index + 1);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt("dashboard_box_no", index +1);
      },

      child: Container(
        decoration: AppDecoration.outlineIndigo.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomImageView(
                    imagePath: icons[index],
                    height: 24.adaptSize,
                    width: 24.adaptSize,
                    margin: EdgeInsets.only(top: 10.v, bottom: 9.v),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25.h),
                    child: Text(
                      _getCount.toString(),
                      style: CustomTextStyles.displaySmallInter,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.v),
            Text(_getText, style: theme.textTheme.bodyMedium),
            SizedBox(height: 2.v),
          ],
        ),
      ),
    );
  }

  String get _getCount {
    return [
      envelopeCount?.data?.actionRequired.toString(),
      envelopeCount?.data?.waitingForOthers.toString(),
      envelopeCount?.data?.expiringSoon.toString(),
      envelopeCount?.data?.completed.toString(),
    ][index] ??
        '0';
  }

  String get _getText {
    return [
      'Action required',
      'Waiting for others',
      'Expiring soon',
      'Completed',
    ][index];
  }
}