import 'package:DigiSign/core/utils/size_utils.dart';
import 'package:flutter/material.dart';

import '../../core/utils/image_constant.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_image_view.dart';

// ignore: must_be_immutable
class MoreItemWidget extends StatelessWidget {

  int index;

   // MoreItemWidget(int index, {Key? key})
   //    : super(
   //        key: key,
   //      );

   MoreItemWidget({required this.index});

   List<String> icons = [ImageConstant.imgMoreProfile, ImageConstant.imgMoreSettings, ImageConstant.imgMoreLogout];
   List<String> titles = ['My Signatures', 'Settings', 'Logout'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecoration.fillWhiteA,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: icons[index],
            height: 24.adaptSize,
            width: 24.adaptSize,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 8.h),
              child: Text(
                titles[index],
                style: theme.textTheme.titleMedium,
              ),
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.img,
            height: 17.v,
            width: 9.h,
            margin: EdgeInsets.only(
              left: 25.h,
              top: 28.v,
              bottom: 28.v,
            ),
          ),
        ],
      ),
    );
  }
}
