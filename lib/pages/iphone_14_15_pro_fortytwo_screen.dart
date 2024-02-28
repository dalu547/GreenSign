// import 'package:DigiSign/core/utils/size_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:signartures/core/app_export.dart';
// import 'package:signartures/widgets/app_bar/appbar_subtitle.dart';
// import 'package:signartures/widgets/app_bar/appbar_subtitle_one.dart';
// import 'package:signartures/widgets/app_bar/appbar_title.dart';
// import 'package:signartures/widgets/app_bar/custom_app_bar.dart';
// import 'package:signartures/widgets/custom_elevated_button.dart';
// import 'package:signartures/widgets/custom_text_form_field.dart';
//
// import '../core/utils/image_constant.dart';
// import '../theme/app_decoration.dart';
// import '../theme/custom_text_style.dart';
// import '../theme/theme_helper.dart';
// import '../widgets/app_bar/custom_app_bar.dart';
// import '../widgets/custom_elevated_button.dart';
// import '../widgets/custom_image_view.dart';
// import '../widgets/custom_text_form_field.dart';
//
// class Iphone1415ProFortytwoScreen extends StatelessWidget {
//   Iphone1415ProFortytwoScreen({Key? key})
//       : super(
//           key: key,
//         );
//
//   TextEditingController swathiController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         appBar: _buildAppBar(context),
//         body: Container(
//           width: 361.h,
//           margin: EdgeInsets.only(
//             left: 16.h,
//             top: 16.v,
//             right: 16.h,
//           ),
//           decoration: AppDecoration.fillWhiteA.copyWith(
//             borderRadius: BorderRadiusStyle.roundedBorder10,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _buildFrameOne(context),
//               _buildFrameThree(context),
//               _buildFrameFour(context),
//               SizedBox(height: 16.v),
//               _buildFrameSix(context),
//               SizedBox(height: 5.v),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// Section Widget
//   PreferredSizeWidget _buildAppBar(BuildContext context) {
//     return CustomAppBar(
//       centerTitle: true,
//       title: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.h),
//             child: Row(
//               children: [
//                 AppbarSubtitleOne(
//                   text: "Cancel",
//                   margin: EdgeInsets.only(bottom: 1.v),
//                 ),
//                 AppbarSubtitle(
//                   text: "Long Signature",
//                   margin: EdgeInsets.only(
//                     left: 67.h,
//                     top: 1.v,
//                   ),
//                 ),
//                 AppbarTitle(
//                   text: "Save",
//                   margin: EdgeInsets.only(
//                     left: 81.h,
//                     bottom: 1.v,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 10.v),
//           SizedBox(
//             width: double.maxFinite,
//             child: Divider(),
//           ),
//         ],
//       ),
//       styleType: Style.bgFill,
//     );
//   }
//
//   /// Section Widget
//   Widget _buildFrameOne(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.fromLTRB(16.h, 16.v, 16.h, 15.v),
//       decoration: AppDecoration.outlineIndigo,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CustomImageView(
//             imagePath: ImageConstant.imgUserWhiteA700,
//             height: 20.v,
//             width: 16.h,
//             margin: EdgeInsets.only(bottom: 146.v),
//           ),
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.only(
//                 left: 16.h,
//                 bottom: 8.v,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Long Signature 1",
//                     style: theme.textTheme.bodyLarge,
//                   ),
//                   SizedBox(height: 1.v),
//                   SizedBox(
//                     height: 82.v,
//                     width: 297.h,
//                     child: Stack(
//                       alignment: Alignment.centerLeft,
//                       children: [
//                         Align(
//                           alignment: Alignment.center,
//                           child: Container(
//                             height: 72.v,
//                             width: 297.h,
//                             decoration: BoxDecoration(
//                               color: appTheme.whiteA700,
//                               borderRadius: BorderRadius.circular(
//                                 4.h,
//                               ),
//                               border: Border.all(
//                                 color: appTheme.indigo50,
//                                 width: 1.h,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Padding(
//                             padding: EdgeInsets.only(left: 13.h),
//                             child: Text(
//                               "Swathi",
//                               style: CustomTextStyles.displayLargeInspiration,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 20.v),
//                   _buildFrameTwo(
//                     context,
//                     text: "Draw",
//                     text1: "Upload",
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Section Widget
//   Widget _buildFrameThree(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.fromLTRB(16.h, 16.v, 16.h, 15.v),
//       decoration: AppDecoration.outlineIndigo50,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CustomImageView(
//             imagePath: ImageConstant.imgUserWhiteA700,
//             height: 20.v,
//             width: 16.h,
//             margin: EdgeInsets.only(bottom: 146.v),
//           ),
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.only(
//                 left: 16.h,
//                 bottom: 8.v,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Long Signature 2",
//                     style: theme.textTheme.bodyLarge,
//                   ),
//                   SizedBox(height: 1.v),
//                   CustomTextFormField(
//                     controller: swathiController,
//                     hintText: "Swathi",
//                     textInputAction: TextInputAction.done,
//                     contentPadding: EdgeInsets.symmetric(horizontal: 16.h),
//                   ),
//                   SizedBox(height: 24.v),
//                   _buildFrameTwo(
//                     context,
//                     text: "Draw",
//                     text1: "Upload",
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Section Widget
//   Widget _buildFrameFour(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.fromLTRB(16.h, 16.v, 16.h, 15.v),
//       decoration: AppDecoration.outlineIndigo,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CustomImageView(
//             imagePath: ImageConstant.imgUserWhiteA700,
//             height: 20.v,
//             width: 16.h,
//             margin: EdgeInsets.only(bottom: 146.v),
//           ),
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.only(
//                 left: 16.h,
//                 bottom: 8.v,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Long Signature 3",
//                     style: theme.textTheme.bodyLarge,
//                   ),
//                   SizedBox(
//                     height: 81.v,
//                     width: 297.h,
//                     child: Stack(
//                       alignment: Alignment.centerLeft,
//                       children: [
//                         Align(
//                           alignment: Alignment.bottomCenter,
//                           child: Container(
//                             height: 72.v,
//                             width: 297.h,
//                             decoration: BoxDecoration(
//                               color: appTheme.whiteA700,
//                               borderRadius: BorderRadius.circular(
//                                 4.h,
//                               ),
//                               border: Border.all(
//                                 color: appTheme.indigo50,
//                                 width: 1.h,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Padding(
//                             padding: EdgeInsets.only(left: 16.h),
//                             child: Text(
//                               "Swathi",
//                               style: CustomTextStyles.displayLargeLicorice,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 24.v),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.only(right: 4.h),
//                         child: _buildFrameFive(
//                           context,
//                           icon: ImageConstant.imgFrame136,
//                           upload: "Draw",
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(left: 4.h),
//                         child: _buildFrameFive(
//                           context,
//                           icon: ImageConstant.imgIcon,
//                           upload: "Upload",
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Section Widget
//   Widget _buildFrameSix(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16.h),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CustomImageView(
//             imagePath: ImageConstant.imgUserWhiteA700,
//             height: 20.v,
//             width: 16.h,
//             margin: EdgeInsets.only(bottom: 138.v),
//           ),
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.only(left: 16.h),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Long Signature 4",
//                     style: theme.textTheme.bodyLarge,
//                   ),
//                   SizedBox(height: 6.v),
//                   SizedBox(
//                     height: 72.v,
//                     width: 297.h,
//                     child: Stack(
//                       alignment: Alignment.centerLeft,
//                       children: [
//                         Align(
//                           alignment: Alignment.center,
//                           child: Container(
//                             height: 72.v,
//                             width: 297.h,
//                             decoration: BoxDecoration(
//                               color: appTheme.whiteA700,
//                               borderRadius: BorderRadius.circular(
//                                 4.h,
//                               ),
//                               border: Border.all(
//                                 color: appTheme.indigo50,
//                                 width: 1.h,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Padding(
//                             padding: EdgeInsets.only(left: 16.h),
//                             child: Text(
//                               "Swathi",
//                               style:
//                                   CustomTextStyles.displayLargePassionsConflict,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 24.v),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Expanded(
//                         child: CustomElevatedButton(
//                           text: "Draw",
//                           margin: EdgeInsets.only(right: 4.h),
//                           leftIcon: Container(
//                             margin: EdgeInsets.only(right: 4.h),
//                             child: CustomImageView(
//                               imagePath: ImageConstant.imgFrame136,
//                               height: 18.adaptSize,
//                               width: 18.adaptSize,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: CustomElevatedButton(
//                           text: "Upload",
//                           margin: EdgeInsets.only(left: 4.h),
//                           leftIcon: Container(
//                             margin: EdgeInsets.only(right: 4.h),
//                             child: CustomImageView(
//                               imagePath: ImageConstant.imgIcon,
//                               height: 18.adaptSize,
//                               width: 18.adaptSize,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Common widget
//   Widget _buildFrameTwo(
//     BuildContext context, {
//     required String text,
//     required String text1,
//   }) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           margin: EdgeInsets.only(right: 4.h),
//           padding: EdgeInsets.symmetric(
//             horizontal: 39.h,
//             vertical: 7.v,
//           ),
//           decoration: AppDecoration.fillGray200.copyWith(
//             borderRadius: BorderRadiusStyle.circleBorder16,
//           ),
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadiusStyle.roundedBorder10,
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 CustomImageView(
//                   imagePath: ImageConstant.imgFrame136,
//                   height: 18.adaptSize,
//                   width: 18.adaptSize,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(left: 4.h),
//                   child: Text(
//                     text,
//                     style: theme.textTheme.titleSmall!.copyWith(
//                       color: appTheme.lightBlueA700,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Container(
//           margin: EdgeInsets.only(left: 4.h),
//           padding: EdgeInsets.symmetric(
//             horizontal: 32.h,
//             vertical: 6.v,
//           ),
//           decoration: AppDecoration.fillGray200.copyWith(
//             borderRadius: BorderRadiusStyle.circleBorder16,
//           ),
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadiusStyle.roundedBorder10,
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 CustomImageView(
//                   imagePath: ImageConstant.imgIcon,
//                   height: 18.adaptSize,
//                   width: 18.adaptSize,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(left: 4.h),
//                   child: Text(
//                     text1,
//                     style: theme.textTheme.titleSmall!.copyWith(
//                       color: appTheme.lightBlueA700,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   /// Common widget
//   Widget _buildFrameFive(
//     BuildContext context, {
//     required String icon,
//     required String upload,
//   }) {
//     return Expanded(
//       child: Container(
//         padding: EdgeInsets.symmetric(
//           horizontal: 32.h,
//           vertical: 6.v,
//         ),
//         decoration: AppDecoration.fillGray200.copyWith(
//           borderRadius: BorderRadiusStyle.circleBorder16,
//         ),
//         child: Row(
//           children: [
//             CustomImageView(
//               imagePath: icon,
//               height: 18.adaptSize,
//               width: 18.adaptSize,
//             ),
//             Padding(
//               padding: EdgeInsets.only(
//                 left: 4.h,
//                 top: 2.v,
//               ),
//               child: Text(
//                 upload,
//                 style: theme.textTheme.titleSmall!.copyWith(
//                   color: appTheme.lightBlueA700,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
