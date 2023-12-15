import 'package:GreenSign/model/envelope_count.dart';
import 'package:flutter/material.dart';

import '../../core/utils/image_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_image_view.dart';
import '../widgets/emaillist_item_widget.dart';
import '../widgets/userprofile_item_widget.dart';
import 'envelopedetails_screen.dart';
import 'inbox.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.5, 0),
              end: Alignment(0.5, 1),
              colors: [Colors.deepPurple, Colors.blue],
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _buildUserProfile(context),
              ),
              SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Recent Activities",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: 361,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _buildEmailList(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailList(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return SizedBox(height: 1);
        },
        itemCount: 40,
        itemBuilder: (context, index) {
          // Replace the following line with your actual widget.
          return ListTile(
            title: EmaillistItemWidget(),
          );
        },
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context) {
    return Expanded(
        child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 109.v,
                crossAxisCount: 2,
                mainAxisSpacing: 8.h,
                crossAxisSpacing: 8.h),
            physics: BouncingScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) {
              return UserprofileItemWidget();
            }));
  }

  /// Section Widget
  Widget _buildWaitingForOthersButton1(BuildContext context) {
    return CustomElevatedButton(width: 120.h, text: "Waiting for others");
  }

  /// Section Widget
  Widget _buildContentRow1(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          CustomImageView(
              imagePath: ImageConstant.imgClock,
              height: 24.adaptSize,
              width: 24.adaptSize,
              margin: EdgeInsets.only(bottom: 50.v)),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.only(left: 8.h),
                  child: Column(children: [
                    _buildContentRow2(context,
                        headlineText: "Envelope Name", augCounterText: "1d"),
                    SizedBox(height: 3.v),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("From: Sandeep K",
                            style: CustomTextStyles.bodyMedium_1)),
                    SizedBox(height: 5.v),
                    SizedBox(
                        width: 268.h,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildWaitingForOthersButton1(context),
                              Spacer(),
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 11.v),
                                  child: Container(
                                      height: 4.v,
                                      width: 60.h,
                                      decoration: BoxDecoration(
                                          color: appTheme.blueGray10001,
                                          borderRadius:
                                              BorderRadius.circular(2.h)),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(2.h),
                                          child: LinearProgressIndicator(
                                              value: 0.48,
                                              backgroundColor:
                                                  appTheme.blueGray10001,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      appTheme.greenA700))))),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 8.h, top: 6.v, bottom: 4.v),
                                  child: Text("1/3",
                                      style: theme.textTheme.bodySmall))
                            ]))
                  ]))),
          CustomImageView(
              imagePath: ImageConstant.img,
              height: 17.v,
              width: 9.h,
              margin: EdgeInsets.only(left: 19.h, top: 28.v, bottom: 28.v))
        ]));
  }

  /// Section Widget
  Widget _buildNeedToSignButton1(BuildContext context) {
    return CustomElevatedButton(
        width: 91.h,
        text: "Need to Sign",
        buttonStyle: CustomButtonStyles.fillBlueGray);
  }

  /// Section Widget
  Widget _buildContentRow4(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          CustomImageView(
              imagePath: ImageConstant.imgExclamationCircle,
              height: 24.adaptSize,
              width: 24.adaptSize,
              margin: EdgeInsets.only(bottom: 50.v)),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.only(left: 8.h),
                  child: Column(children: [
                    _buildContentRow2(context,
                        headlineText: "Envelope Name", augCounterText: "Aug 9"),
                    SizedBox(height: 3.v),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("From: Sandeep K",
                            style: CustomTextStyles.bodyMedium_1)),
                    SizedBox(height: 5.v),
                    SizedBox(
                        width: 268.h,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildNeedToSignButton1(context),
                              Spacer(),
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 11.v),
                                  child: Container(
                                      height: 4.v,
                                      width: 60.h,
                                      decoration: BoxDecoration(
                                          color: appTheme.blueGray10001,
                                          borderRadius:
                                              BorderRadius.circular(2.h)),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(2.h),
                                          child: LinearProgressIndicator(
                                              value: 0.48,
                                              backgroundColor:
                                                  appTheme.blueGray10001,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      appTheme.greenA700))))),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 8.h, top: 6.v, bottom: 4.v),
                                  child: Text("1/3",
                                      style: theme.textTheme.bodySmall))
                            ]))
                  ]))),
          CustomImageView(
              imagePath: ImageConstant.img,
              height: 17.v,
              width: 9.h,
              margin: EdgeInsets.only(left: 19.h, top: 28.v, bottom: 28.v))
        ]));
  }

  /// Section Widget
  Widget _buildWaitingForOthersButton2(BuildContext context) {
    return CustomElevatedButton(width: 120.h, text: "Waiting for others");
  }

  /// Section Widget
  Widget _buildContentRow5(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          CustomImageView(
              imagePath: ImageConstant.imgClock,
              height: 24.adaptSize,
              width: 24.adaptSize,
              margin: EdgeInsets.only(bottom: 50.v)),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.only(left: 8.h),
                  child: Column(children: [
                    _buildContentRow2(context,
                        headlineText: "Envelope Name", augCounterText: "Aug 1"),
                    SizedBox(height: 3.v),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("To: Sandeep K",
                            style: CustomTextStyles.bodyMedium_1)),
                    SizedBox(height: 5.v),
                    SizedBox(
                        width: 268.h,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildWaitingForOthersButton2(context),
                              Spacer(),
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 11.v),
                                  child: Container(
                                      height: 4.v,
                                      width: 60.h,
                                      decoration: BoxDecoration(
                                          color: appTheme.blueGray10001,
                                          borderRadius:
                                              BorderRadius.circular(2.h)),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(2.h),
                                          child: LinearProgressIndicator(
                                              value: 0.48,
                                              backgroundColor:
                                                  appTheme.blueGray10001,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      appTheme.greenA700))))),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 8.h, top: 6.v, bottom: 4.v),
                                  child: Text("1/3",
                                      style: theme.textTheme.bodySmall))
                            ]))
                  ]))),
          CustomImageView(
              imagePath: ImageConstant.img,
              height: 17.v,
              width: 9.h,
              margin: EdgeInsets.only(left: 19.h, top: 28.v, bottom: 28.v))
        ]));
  }

  /// Section Widget
  Widget _buildWaitingForOthersButton3(BuildContext context) {
    return CustomElevatedButton(width: 120.h, text: "Waiting for others");
  }

  /// Section Widget
  Widget _buildContentRow6(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          CustomImageView(
              imagePath: ImageConstant.imgClock,
              height: 24.adaptSize,
              width: 24.adaptSize,
              margin: EdgeInsets.only(bottom: 50.v)),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.only(left: 8.h),
                  child: Column(children: [
                    _buildContentRow2(context,
                        headlineText: "Envelope Name",
                        augCounterText: "July 9"),
                    SizedBox(height: 3.v),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("From: Sandeep K",
                            style: CustomTextStyles.bodyMedium_1)),
                    SizedBox(height: 5.v),
                    SizedBox(
                        width: 268.h,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildWaitingForOthersButton3(context),
                              Spacer(),
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 11.v),
                                  child: Container(
                                      height: 4.v,
                                      width: 60.h,
                                      decoration: BoxDecoration(
                                          color: appTheme.blueGray10001,
                                          borderRadius:
                                              BorderRadius.circular(2.h)),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(2.h),
                                          child: LinearProgressIndicator(
                                              value: 0.48,
                                              backgroundColor:
                                                  appTheme.blueGray10001,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      appTheme.greenA700))))),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 8.h, top: 6.v, bottom: 4.v),
                                  child: Text("1/3",
                                      style: theme.textTheme.bodySmall))
                            ]))
                  ]))),
          CustomImageView(
              imagePath: ImageConstant.img,
              height: 17.v,
              width: 9.h,
              margin: EdgeInsets.only(left: 19.h, top: 28.v, bottom: 28.v))
        ]));
  }

  /// Section Widget
  Widget _buildContentRow7(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          CustomImageView(
              imagePath: ImageConstant.imgExclamationCircle,
              height: 24.adaptSize,
              width: 24.adaptSize,
              margin: EdgeInsets.only(bottom: 50.v)),
          Expanded(
              child: Padding(
                  padding: EdgeInsets.only(left: 8.h),
                  child: Column(children: [
                    _buildContentRow2(context,
                        headlineText: "Envelope Name",
                        augCounterText: "June 27"),
                    SizedBox(height: 3.v),
                    _buildContentRow2(context,
                        headlineText: "From: Sandeep K",
                        augCounterText: "Expiring soon!"),
                    SizedBox(height: 4.v),
                    SizedBox(
                        width: 268.h,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.h, vertical: 4.v),
                                  decoration: AppDecoration.fillBlueGray
                                      .copyWith(
                                          borderRadius:
                                              BorderRadiusStyle.roundedBorder4),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 1.v),
                                        Text("Need to Sign",
                                            style: theme.textTheme.labelLarge)
                                      ])),
                              Spacer(),
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 11.v),
                                  child: Container(
                                      height: 4.v,
                                      width: 60.h,
                                      decoration: BoxDecoration(
                                          color: appTheme.blueGray10001,
                                          borderRadius:
                                              BorderRadius.circular(2.h)),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(2.h),
                                          child: LinearProgressIndicator(
                                              value: 0.48,
                                              backgroundColor:
                                                  appTheme.blueGray10001,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      appTheme.greenA700))))),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 8.h, top: 6.v, bottom: 4.v),
                                  child: Text("1/3",
                                      style: theme.textTheme.bodySmall))
                            ]))
                  ]))),
          CustomImageView(
              imagePath: ImageConstant.img,
              height: 17.v,
              width: 9.h,
              margin: EdgeInsets.only(left: 19.h, top: 28.v, bottom: 28.v))
        ]));
  }

  /// Section Widget
  Widget _buildTabBars(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
            height: 50.v,
            width: double.maxFinite,
            child: Stack(alignment: Alignment.topCenter, children: [
              Align(
                  alignment: Alignment.center,
                  child: Container(
                      height: 50.v,
                      width: double.maxFinite,
                      decoration: BoxDecoration(color: appTheme.whiteA700))),
              Align(
                  alignment: Alignment.topCenter,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Divider(),
                    SizedBox(height: 2.v),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 35.h),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(children: [
                                CustomImageView(
                                    imagePath: ImageConstant.imgHome,
                                    height: 29.v,
                                    width: 25.h),
                                SizedBox(height: 2.v),
                                Text("Home",
                                    style: CustomTextStyles.labelMediumPrimary)
                              ]),
                              Spacer(flex: 35),
                              GestureDetector(
                                  onTap: () {
                                    onTapManage(context);
                                  },
                                  child: SizedBox(
                                      height: 45.v,
                                      width: 46.h,
                                      child: Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            Opacity(
                                                opacity: 0.9,
                                                child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          CustomImageView(
                                                              imagePath:
                                                                  ImageConstant
                                                                      .imgFrame217BlueGray400,
                                                              height: 29.v,
                                                              width: 22.h),
                                                          SizedBox(height: 3.v),
                                                          Text("Manage",
                                                              style: theme
                                                                  .textTheme
                                                                  .labelMedium)
                                                        ]))),
                                            Align(
                                                alignment: Alignment.topRight,
                                                child: Container(
                                                    width: 20.adaptSize,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 6.h,
                                                            vertical: 2.v),
                                                    decoration: AppDecoration
                                                        .fillRed
                                                        .copyWith(
                                                            borderRadius:
                                                                BorderRadiusStyle
                                                                    .roundedBorder10),
                                                    child: Text("3",
                                                        style: CustomTextStyles
                                                            .bodySmallSFProTextWhiteA700)))
                                          ]))),
                              Spacer(flex: 28),
                              Opacity(
                                  opacity: 0.9,
                                  child: Column(children: [
                                    CustomImageView(
                                        imagePath: ImageConstant.imgFrame217,
                                        height: 29.v,
                                        width: 17.h),
                                    SizedBox(height: 3.v),
                                    Text("Reports",
                                        style: theme.textTheme.labelMedium)
                                  ])),
                              Spacer(flex: 36),
                              Opacity(
                                  opacity: 0.9,
                                  child: Column(children: [
                                    CustomImageView(
                                        imagePath: ImageConstant.imgFrame219,
                                        height: 28.v,
                                        width: 25.h),
                                    SizedBox(height: 2.v),
                                    Text("More",
                                        style: theme.textTheme.labelMedium)
                                  ]))
                            ]))
                  ]))
            ])));
  }

  /// Common widget
  Widget _buildContentRow2(
    BuildContext context, {
    required String headlineText,
    required String augCounterText,
  }) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(headlineText,
          style:
              theme.textTheme.titleMedium!.copyWith(color: appTheme.black900)),
      Padding(
          padding: EdgeInsets.symmetric(vertical: 2.v),
          child: Text(augCounterText,
              style: CustomTextStyles.labelLargeBluegray500
                  .copyWith(color: appTheme.blueGray500)))
    ]);
  }

  /// Navigates to the manageenvelopeScreen when the action is triggered.
  onTapManage(BuildContext context) {
    // Navigator.pushNamed(context, AppRoutes.manageenvelopeScreen);
  }
}
