import 'package:flutter/material.dart';

import '../../core/utils/image_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_text_form_field.dart';

class ProfilescreenScreen extends StatelessWidget {
  ProfilescreenScreen({Key? key})
      : super(
          key: key,
        );

  TextEditingController profileNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.gray5001,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Profile"),
        ),
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              SizedBox(height: 16.v),
              CustomImageView(
                imagePath: ImageConstant.imgProfilepic21,
                height: 88.adaptSize,
                width: 88.adaptSize,
                radius: BorderRadius.circular(
                  44.h,
                ),
              ),
              SizedBox(height: 8.v),
              Text(
                "Edit",
                style: CustomTextStyles.bodyMediumPrimary,
              ),
              SizedBox(height: 25.v),
              _buildCardWithBorder1(context),
              SizedBox(height: 16.v),
              _buildCardWithBorder(
                context,
                mobileNo: "Sandeep",
                value: "K",
                company: "sandeep.k@greenkogroup.com",
                deskNumber: "**********",
                address: "**********",
              ),
              SizedBox(height: 24.v),
              _buildCardWithBorder(
                context,
                mobileNo: "8642934411",
                value: "General Manager",
                company: "Company",
                deskNumber: "Desk Number",
                address: "Address",
              ),
              SizedBox(height: 5.v),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildCardWithBorder1(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      padding: EdgeInsets.all(16.h),
      decoration: AppDecoration.fillWhiteA.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 2.v),
          Text(
            "Sandeep",
            style: theme.textTheme.displayLarge,
          ),
          SizedBox(height: 5.v),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(right: 4.h),
                padding: EdgeInsets.symmetric(
                  horizontal: 9.h,
                  vertical: 6.v,
                ),
                decoration: AppDecoration.fillGray200.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder16,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusStyle.roundedBorder10,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgInfoPrimary,
                        height: 18.adaptSize,
                        width: 18.adaptSize,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 4.h),
                        child: Text(
                          "Choose",
                          style: theme.textTheme.titleSmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.h),
                padding: EdgeInsets.symmetric(
                  horizontal: 18.h,
                  vertical: 6.v,
                ),
                decoration: AppDecoration.fillGray200.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder16,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusStyle.roundedBorder10,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgClosePrimary,
                        height: 18.adaptSize,
                        width: 18.adaptSize,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 4.h),
                        child: Text(
                          "Draw",
                          style: theme.textTheme.titleSmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 4.h),
                padding: EdgeInsets.symmetric(
                  horizontal: 10.h,
                  vertical: 6.v,
                ),
                decoration: AppDecoration.fillGray200.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder16,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusStyle.roundedBorder10,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgIconPrimary,
                        height: 18.adaptSize,
                        width: 18.adaptSize,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 4.h),
                        child: Text(
                          "Upload",
                          style: theme.textTheme.titleSmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Common widget
  Widget _buildCardWithBorder(
    BuildContext context, {
    required String mobileNo,
    required String value,
    required String company,
    required String deskNumber,
    required String address,
  }) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 11.v),
      decoration: AppDecoration.outlineGray400,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mobileNo,
                  style: CustomTextStyles.bodyLarge_1.copyWith(
                    color: appTheme.black900,
                  ),
                ),
                SizedBox(height: 11.v),
                Divider(),
              ],
            ),
          ),
          SizedBox(height: 12.v),
          Padding(
            padding: EdgeInsets.only(left: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: CustomTextStyles.bodyLarge_1.copyWith(
                    color: appTheme.black900,
                  ),
                ),
                SizedBox(height: 9.v),
                Divider(),
              ],
            ),
          ),
          SizedBox(height: 12.v),
          Padding(
            padding: EdgeInsets.only(left: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  company,
                  style: CustomTextStyles.bodyLargeGray80099_1.copyWith(
                    color: appTheme.gray80099.withOpacity(0.3),
                  ),
                ),
                SizedBox(height: 9.v),
                Divider(),
              ],
            ),
          ),
          SizedBox(height: 11.v),
          Padding(
            padding: EdgeInsets.only(left: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deskNumber,
                  style: CustomTextStyles.bodyLargeGray80099_1.copyWith(
                    color: appTheme.gray80099.withOpacity(0.3),
                  ),
                ),
                SizedBox(height: 11.v),
                Divider(),
              ],
            ),
          ),
          SizedBox(height: 11.v),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20.h),
              child: Text(
                address,
                style: CustomTextStyles.bodyLargeGray80099_1.copyWith(
                  color: appTheme.gray80099.withOpacity(0.3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
