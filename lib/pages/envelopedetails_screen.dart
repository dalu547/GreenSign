import 'package:GreenSign/model/document.dart';
import 'package:GreenSign/model/required_approvals.dart';
import 'package:GreenSign/pages/web_view.dart';
import 'package:flutter/material.dart';

import '../../core/utils/image_constant.dart';
import '../../core/utils/size_utils.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_button_style.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/listrow_item_widget.dart';
import '../model/envelope.dart';

// ignore_for_file: must_be_immutable
class EnvelopedetailsScreen extends StatelessWidget {
  Envelope? envelope;

  EnvelopedetailsScreen(this.envelope);

  TextEditingController pageTitleController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
            backgroundColor: appTheme.gray5001,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Image.asset('assets/images/digisign_title_logo_small.png'),
            ),
            body: Form(
                key: _formKey,
                child: SizedBox(
                    width: double.maxFinite,
                    child: SingleChildScrollView(
                        child: Column(children: [
                      // _buildPageTitle(context),
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.h, vertical: 15.v),
                          decoration: AppDecoration.fillGray,
                          child: Column(children: [
                            SizedBox(height: 2.v),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(envelope!.envelopeName,
                                    style:
                                        CustomTextStyles.titleLargeSemiBold)),
                            SizedBox(height: 3.v),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text("From: ${envelope?.from}",
                                    style: CustomTextStyles.bodyMedium_1)),
                            SizedBox(height: 7.v),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Row(children: [
                                  Text(envelope!.createdOn,
                                      style: theme.textTheme.bodyMedium),
                                  Padding(
                                      padding: EdgeInsets.only(left: 12.h),
                                      child: Text("Expiring soon!",
                                          style:
                                              CustomTextStyles.bodySmallRed500))
                                ])),
                            SizedBox(height: 5.v),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Row(children: [
                                  CustomImageView(
                                      imagePath: ImageConstant.imgUser,
                                      height: 16.v,
                                      width: 17.h),
                                  Padding(
                                      padding: EdgeInsets.only(left: 4.h),
                                      child: Text("Accounts",
                                          style: theme.textTheme.bodyMedium))
                                ])),
                            SizedBox(height: 5.v),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Row(children: [
                                  CustomImageView(
                                      imagePath:
                                          ImageConstant.imgExclamationCircle,
                                      height: 24.adaptSize,
                                      width: 24.adaptSize),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 8.h, top: 4.v, bottom: 2.v),
                                      child: Text(envelope!.envelopeStatusType,
                                          style: CustomTextStyles
                                              .bodyMediumBlack900))
                                ])),
                            SizedBox(height: 4.v),
                            _buildFrame(context),
                            SizedBox(height: 34.v),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Envelope Details",
                                    style: theme.textTheme.titleMedium)),
                            SizedBox(height: 8.v),
                            // _buildDescription(context),
                            // "Last changed by Full Name\nLast change on 7/3/2023 | 09:44:40 am\nSent on 6/30/2023 | 04:02:23 pm\nExpiring on\r11/21/2023 | 09:44:40 am"),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Last changed by "+envelope!.lastChangedBy)),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Last change on "+envelope!.lastChanged)),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Sent on "+envelope!.sentOn)),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Expiring on "+envelope!.expiringOn)),
                            SizedBox(height: 20.v),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Documents",
                                    style:
                                        CustomTextStyles.titleMediumOnPrimary)),
                            SizedBox(height: 11.v),
                            _buildDocsList(context, envelope!.documents),
                            SizedBox(height: 20.v),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Recipients",
                                    style:
                                        CustomTextStyles.titleMediumOnPrimary)),
                            SizedBox(height: 8.v),
                            _buildRecipients(context),
                            SizedBox(height: 8.v),
                            _buildReciepientsList(context),
                            SizedBox(height: 9.v),
                            Divider(color: appTheme.blueGray10002)
                          ]))
                    ]))))));
  }

  /// Section Widget
  Widget _buildPageTitle(BuildContext context) {
    return CustomTextFormField(
        controller: pageTitleController,
        hintText: "Back",
        hintStyle: CustomTextStyles.bodyLargePrimary_1,
        prefix: Container(
            margin: EdgeInsets.fromLTRB(16.h, 8.v, 6.h, 8.v),
            child: CustomImageView(
                imagePath: ImageConstant.img27x14, height: 27.v, width: 14.h)),
        prefixConstraints: BoxConstraints(maxHeight: 44.v),
        suffix: Container(
            margin: EdgeInsets.symmetric(horizontal: 30.h, vertical: 12.v),
            child: CustomImageView(
                imagePath: ImageConstant.imgArrowdowndoc,
                height: 19.v,
                width: 15.h)),
        suffixConstraints: BoxConstraints(maxHeight: 44.v),
        contentPadding: EdgeInsets.symmetric(vertical: 11.v));
  }

  /// Section Widget
  Widget _buildNeedToSign(BuildContext context) {
    return CustomElevatedButton(
        width: 80.h,
        text: envelope!.statusName,
        margin: EdgeInsets.only(left: 16.h),
        buttonStyle: CustomButtonStyles.fillBlueGray);
  }

  /// Section Widget
  Widget _buildSign(BuildContext context) {
    return CustomElevatedButton(
        height: 50.v,
        width: 100.h,
        text: "Sign",
        margin: EdgeInsets.only(left: 16.h),
        buttonStyle: CustomButtonStyles.fillLightBlueA,
        buttonTextStyle: CustomTextStyles.titleMediumSFProTextWhiteA700,
        onPressed: () {
          onTapSign(context);
        });
  }

  /// Section Widget
  Widget _buildFrame(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      _buildNeedToSign(context),
      Spacer(),
      Padding(
          padding: EdgeInsets.symmetric(vertical: 23.v),
          child: Container(
              height: 4.v,
              width: 60.h,
              decoration: BoxDecoration(
                  color: appTheme.blueGray10001,
                  borderRadius: BorderRadius.circular(2.h)),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(2.h),
                  child: LinearProgressIndicator(
                      value: calculatePercentage(envelope!.totalSignedDocuments,
                          envelope!.totalNumberDocuments),
                      backgroundColor: appTheme.blueGray10001,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(appTheme.greenA700))))),
      Padding(
          padding: EdgeInsets.only(left: 8.h, top: 18.v, bottom: 15.v),
          child: Text(
              '${envelope?.totalSignedDocuments}/${envelope?.totalNumberDocuments}',
              style: theme.textTheme.bodyMedium)),
      _buildSign(context)
    ]);
  }

  /// Section Widget
  Widget _buildDescription(BuildContext context) {
    return CustomTextFormField(
        controller: descriptionController,
        hintText:
            "Last changed by Full Name\nLast change on 7/3/2023 | 09:44:40 am\nSent on 6/30/2023 | 04:02:23 pm\nExpiring on\r11/21/2023 | 09:44:40 am",
        textInputAction: TextInputAction.done,
        contentPadding: EdgeInsets.all(16.h),
        borderDecoration: TextFormFieldStyleHelper.fillWhiteATL10);
  }

  /// Section Widget
  Widget _buildDocsList(BuildContext context, List<Document> documents) {
    return Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadiusStyle.roundedBorder10),
        child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return SizedBox(height: 1.v);
            },
            itemCount: documents.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: ListrowItemWidget(documents![index],envelope),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => WebView(envelope!.id)));
                },
              );
            }));
  }

  Widget _buildReciepientsList(BuildContext context) {
    return Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadiusStyle.roundedBorder10),
        child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return SizedBox(height: 1.v);
            },
            itemCount: 4,
            itemBuilder: (context, index) {
              return ListTile(
                title: _buildFrameEightySeven(context,index,envelope.requiredApprovals.elementAt(index)),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => WebView(envelope!.id)));
                },
              );
            }));
  }

  /// Section Widget
  Widget _buildRecipients(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.v),
        decoration: AppDecoration.fillGray50,
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CustomImageView(
              imagePath: ImageConstant.imgInfoCircle,
              height: 24.adaptSize,
              width: 24.adaptSize,
              margin: EdgeInsets.only(top: 3.v, bottom: 19.v)),
          Expanded(
              child: Container(
                  width: 283.h,
                  margin: EdgeInsets.only(left: 8.h, top: 2.v),
                  child: Text(
                      "Envelope is with "+ envelope!.lastChangedBy+" and he/she needs to sign.",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.bodyLargeLightblue600)))
        ]));
  }

  /// Section Widget
  Widget _buildFrameEightySeven(BuildContext context, int index, RequiredApproval reciepient) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
          padding: EdgeInsets.only(top: 53.v, bottom: 52.v),
          child: Text((index+1).toString(), style: CustomTextStyles.bodyMediumBluegray90001)),
      Expanded(
          child: Container(
              margin: EdgeInsets.only(left: 18.h),
              decoration: AppDecoration.outlineIndigo
                  .copyWith(borderRadius: BorderRadiusStyle.roundedBorder10),
              child: Row(children: [
                Container(
                    height: 80.v,
                    width: 8.h,
                    decoration: BoxDecoration(
                        color: appTheme.blueGray900,
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(8.h)))),
                Padding(
                    padding:
                        EdgeInsets.only(left: 16.h, top: 11.v, bottom: 11.v),
                    child: _buildFrameSeventyOne(context,
                        userName: reciepient.recipientName,
                        email: reciepient.recipientEmail,
                        needsToSign: reciepient.recipientPrivilegeName,
                        price: "Signed on "+reciepient.recipientLastTimestamp))
              ])))
    ]);
  }

  /// Common widget
  Widget _buildFrameSeventyOne(
    BuildContext context, {
    required String userName,
    required String email,
    required String needsToSign,
    required String price,
  }) {
    return Expanded(
        child: SizedBox(
            width: double.maxFinite,
            child: Column(children: [
              Text(userName,
                  style: CustomTextStyles.bodyLargeBluegray90001
                      .copyWith(color: appTheme.blueGray90001)),
              SizedBox(height: 4.v),
              Text(email,
                  style: theme.textTheme.bodyMedium!
                      .copyWith(color: appTheme.blueGray500)),
              SizedBox(height: 8.v),
              Divider(color: appTheme.indigo50),
              SizedBox(height: 7.v),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(needsToSign,
                      style: CustomTextStyles.bodyMediumBluegray90001
                          .copyWith(color: appTheme.blueGray90001))),
              SizedBox(height: 4.v),
              Text(price,
                  style: theme.textTheme.bodyMedium!
                      .copyWith(color: appTheme.blueGray500))
            ])));
  }

  /// Navigates to the documentviewScreen when the action is triggered.
  onTapSign(BuildContext context) {
    // Navigator.pushNamed(context, AppRoutes.documentviewScreen);

    Navigator.push(
        context, MaterialPageRoute(builder: (_) => WebView(envelope!.id)));
  }

  double calculatePercentage(
      int totalSignedDocuments, int totalNumberDocuments) {
    final value = (totalSignedDocuments / totalNumberDocuments);
    print('value: $value, $totalSignedDocuments, $totalNumberDocuments');
    return value;
  }
}
