import 'package:GreenSign/core/utils/size_utils.dart';
import 'package:GreenSign/model/envelope_count.dart';
import 'package:flutter/material.dart';

import '../../core/utils/image_constant.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/custom_image_view.dart';

// ignore: must_be_immutable
class UserprofileItemWidget extends StatelessWidget {
  EnvelopeCount? envelopeCount;

  UserprofileItemWidget(this.envelopeCount);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(
      //   horizontal: 38.h,
      //   vertical: 20.v,
      // ),
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
                  imagePath: ImageConstant.imgExclamationCircle,
                  height: 24.adaptSize,
                  width: 24.adaptSize,
                  margin: EdgeInsets.only(
                    top: 10.v,
                    bottom: 9.v,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.h),
                  child: Text(
                    '1',
                    style: CustomTextStyles.displaySmallInter,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1.v),
          Text(
            "Action Required",
            style: theme.textTheme.bodyMedium,
          ),
          SizedBox(height: 2.v),
        ],
      ),
    );
  }
}
