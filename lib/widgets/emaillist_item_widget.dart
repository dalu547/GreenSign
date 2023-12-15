import 'package:GreenSign/core/utils/size_utils.dart';
import 'package:flutter/material.dart';

import '../../core/utils/image_constant.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_image_view.dart';

// ignore: must_be_immutable
class EmaillistItemWidget extends StatelessWidget {
  const EmaillistItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecoration.fillWhiteA,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(height: 5.v),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgClock,
                height: 24.adaptSize,
                width: 24.adaptSize,
                margin: EdgeInsets.only(bottom: 50.v),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.h),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Envelope Name",
                            style: theme.textTheme.titleMedium,
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 3.v),
                            child: Text(
                              "1d",
                              style: CustomTextStyles.bodyMedium_2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3.v),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "From: Sandeep K",
                          style: CustomTextStyles.bodyMedium_1,
                        ),
                      ),
                      SizedBox(height: 5.v),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // CustomElevatedButton(
                          //   width: 80.h,
                          //   text: "Waiting for others",
                          // ),
                          Spacer(),
                          Container(
                            height: 4.v,
                            width: 45.h,
                            decoration: BoxDecoration(
                              color: appTheme.blueGray10001,
                              borderRadius: BorderRadius.circular(
                                2.h,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                2.h,
                              ),
                              child: LinearProgressIndicator(
                                value: 0.48,
                                backgroundColor: appTheme.blueGray10001,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  appTheme.greenA700,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 8.h,
                              top: 6.v,
                              bottom: 4.v,
                            ),
                            child: Text(
                              "1/3",
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ],
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
          SizedBox(height: 11.v),
          Align(
            alignment: Alignment.centerRight,
            child: Divider(
              indent: 48.h,
            ),
          ),
        ],
      ),
    );
  }
}
