import 'package:DigiSign/model/document.dart';
import 'package:DigiSign/model/required_approvals.dart';
import 'package:DigiSign/pages/sfpdf_viewer.dart';
import 'package:DigiSign/pages/web_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
import 'envelopes_history_screen.dart';

// ignore_for_file: must_be_immutable
class EnvelopedetailsScreen extends StatelessWidget {
  Envelope? envelope;
  String user_id = "";

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
              actions: [
                IconButton(
                  icon: Image.asset('assets/images/history.png'),
                  // Replace with your image asset
                  onPressed: () {
                    // Handle the button press
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                EnvelopesHistoryScreen(envelope?.id)));
                  },
                ),
              ],
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
                              horizontal: 5.h, vertical: 5.v),
                          decoration: AppDecoration.fillGray,
                          child: Column(children: [
                            SizedBox(height: 2.v),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(envelope?.envelopeName ?? "",
                                    style:
                                        CustomTextStyles.titleLargeSemiBold)),
                            SizedBox(height: 3.v),
                            if (envelope?.statusName == 'Sent')
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("To: ${envelope?.from}",
                                      style: CustomTextStyles.bodyMedium_1))
                            else
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("From: ${envelope?.from}",
                                      style: CustomTextStyles.bodyMedium_1)),
                            SizedBox(height: 7.v),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Row(children: [
                                  Text(envelope!.createdOn ?? "",
                                      style: theme.textTheme.bodyMedium),
                                  if (envelope!.expiringSoon ?? false)
                                    Padding(
                                        padding: EdgeInsets.only(left: 12.h),
                                        child: Text("Expiring soon!",
                                            style: CustomTextStyles
                                                .bodySmallRed500))
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
                                      child: Text(envelope!.groupName ?? "",
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
                                  if (envelope?.envelopeStatusType ==
                                      'action_required')
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.h, top: 4.v, bottom: 2.v),
                                        child: Text('Action Required',
                                            style: CustomTextStyles
                                                .bodyMediumBlack900))
                                  else if (envelope?.envelopeStatusType ==
                                      'waiting_for_others')
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.h, top: 4.v, bottom: 2.v),
                                        child: Text('Waiting For Others',
                                            style: CustomTextStyles
                                                .bodyMediumBlack900))
                                  else if (envelope?.envelopeStatusType ==
                                      'expiring_soon')
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.h, top: 4.v, bottom: 2.v),
                                        child: Text('Expiring Soon',
                                            style: CustomTextStyles
                                                .bodyMediumBlack900))
                                  else
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.h, top: 4.v, bottom: 2.v),
                                        child: Text(
                                            envelope!.envelopeStatusType ?? "",
                                            style: CustomTextStyles
                                                .bodyMediumBlack900)),
                                ])),
                            SizedBox(height: 4.v),
                            if (envelope?.totalSignedDocuments != null &&
                                envelope?.totalNumberRecipients != null)
                              _buildProgressAndSign(context, envelope),
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
                                child: Text("Last changed by " +
                                    (envelope!.lastChangedBy ?? ""))),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Last change on " +
                                    (envelope!.lastChanged ?? ""))),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    "Sent on " + (envelope!.sentOn ?? ""))),
                            if (envelope?.envelopeStatusType != 'Completed')
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Expiring on " +
                                    (envelope!.expiringOn ?? ""))),

                            SizedBox(height: 20.v),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Documents",
                                    style:
                                        CustomTextStyles.titleMediumOnPrimary)),
                            SizedBox(height: 11.v),
                            _buildDocsList(context, envelope!.documents),
                            SizedBox(height: 20.v),
                            if (envelope?.envelopeStatusType != 'Completed')
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Recipients",
                                      style: CustomTextStyles
                                          .titleMediumOnPrimary)),
                            SizedBox(height: 8.v),
                            if (envelope?.envelopeStatusType != 'Completed')
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
        alignment: Alignment.centerLeft,
        text: envelope!.statusName ?? "",
        buttonTextStyle: TextStyle(color: Colors.white),
        margin: EdgeInsets.only(left: 16.h),
        buttonStyle: CustomButtonStyles.fillBlueGray);
  }

  /// Section Widget
  Widget _buildSign(
      BuildContext context, Envelope envelope, String buttonType) {
    return CustomElevatedButton(
        height: 50.v,
        text: buttonType,
        margin: EdgeInsets.only(left: 16.h),
        buttonStyle: CustomButtonStyles.fillLightBlueA,
        buttonTextStyle: CustomTextStyles.titleMediumSFProTextWhiteA700,
        onPressed: () {
          onTapSign(context, buttonType);
        });
  }

  /// Section Widget
  Widget _buildProgressAndSign(BuildContext context, Envelope? envelope) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: _buildNeedToSign(context),
        ),
        SizedBox(width: 10.v),
        if (envelope?.envelopeStatusType != 'Completed')
          Container(
            height: 4.v,
            width: 60.h,
            decoration: BoxDecoration(
              color: appTheme.blueGray10001,
              borderRadius: BorderRadius.circular(2.h),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2.h),
              child: LinearProgressIndicator(
                value: calculatePercentage(envelope!.totalSignedDocuments ?? 0,
                    envelope!.totalNumberRecipients ?? 0),
                backgroundColor: appTheme.blueGray10001,
                valueColor: AlwaysStoppedAnimation<Color>(appTheme.greenA700),
              ),
            ),
          ),
        if (envelope?.envelopeStatusType != 'Completed')
          Padding(
            padding: EdgeInsets.only(left: 8.h, top: 18.v, bottom: 15.v),
            child: Text(
                '${envelope?.totalSignedDocuments}/${envelope?.totalNumberRecipients}',
                style: theme.textTheme.bodyMedium),
          ),
        SizedBox(width: 10.v),
        if ((envelope?.envelopePrivilegeName == 'Needs to Sign' ||
                envelope?.envelopePrivilegeName == 'Specify Recipient' ||
                envelope?.envelopePrivilegeName == 'Update Recipients') &&
            envelope?.envelopeStatusType == "action_required" &&
            envelope?.statusName != 'Locked')
          Expanded(
            child: _buildSign(context, envelope!, 'Sign'),
          ),
        if ((envelope?.envelopePrivilegeName == 'Needs to View') &&
            envelope?.envelopeStatusType == "action_required" &&
            envelope?.statusName != 'Locked')
          Expanded(
            child: _buildSign(context, envelope!, 'View'),
          )
      ],
    );
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
  Widget _buildDocsList(BuildContext context, List<Document>? documents) {
    return Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadiusStyle.roundedBorder10),
        child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return SizedBox(height: 1.v);
            },
            itemCount: documents!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: ListrowItemWidget(documents![index], envelope),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => SFPDFScreen(
                              documents![index].document ?? "",
                              documents![index].documentName ?? "")));
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
            itemCount: envelope!.totalNumberRecipients ?? 0,
            itemBuilder: (context, index) {
              return ListTile(
                title: _buildFrameEightySeven(context, index,
                    envelope!.requiredApprovals!.elementAt(index)),
                onTap: () {
                  // Navigator.push(context,MaterialPageRoute(builder: (_) => WebView(envelope!.id)));
                  print(envelope?.requiredApprovals
                      ?.elementAt(index)
                      .recipientPrivilegeName);
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
                      "Envelope is with " +
                          (envelope!.lastChangedBy ?? "") +
                          " and he/she needs to sign.",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.bodyLargeLightblue600)))
        ]));
  }

  /// Section Widget
  Widget _buildFrameEightySeven(
      BuildContext context, int index, RequiredApproval reciepient) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
          padding: EdgeInsets.only(top: 53.v, bottom: 52.v),
          child: Text((index + 1).toString(),
              style: CustomTextStyles.bodyMediumBluegray90001)),
      Expanded(
          child: Container(
              margin: EdgeInsets.only(left: 18.h),
              decoration: AppDecoration.outlineIndigo
                  .copyWith(borderRadius: BorderRadiusStyle.roundedBorder10),
              child: Row(children: [
                Container(
                    height: 120.v,
                    width: 8.h,
                    decoration: BoxDecoration(
                        color: appTheme.blueGray900,
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(8.h)))),
                Expanded(
                    child: _buildFrameSeventyOne(context,
                        userName: reciepient.recipientName ?? "",
                        email: reciepient.recipientEmail ?? "",
                        recAction: reciepient.recipientAction ?? false,
                        needsToSign: reciepient.recipientPrivilegeName ?? "",
                        price: reciepient.recipientLastTimestamp ?? ""))
              ])))
    ]);
  }

  /// Common widget
  Widget _buildFrameSeventyOne(
    BuildContext context, {
    required String userName,
    required String email,
    required bool recAction,
    required String needsToSign,
    required String price,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: CustomTextStyles.bodyLargeBluegray90001
                    .copyWith(color: appTheme.blueGray90001),
              ),
              Text(
                email,
                style: theme.textTheme.bodyMedium!
                    .copyWith(color: appTheme.blueGray500),
              ),
            ],
          ),
          Divider(color: appTheme.indigo50),
          Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                needsToSign,
                style: CustomTextStyles.bodyMediumBluegray90001
                    .copyWith(color: appTheme.blueGray90001),
              ),
              if (recAction &&
                  (needsToSign == 'Needs to Sign' ||
                      needsToSign == 'Update Recipients' ||
                      needsToSign == 'Specify Recipient'))
                Text(
                  'Signed On: $price',
                  style: theme.textTheme.bodyMedium!
                      .copyWith(color: appTheme.blueGray500),
                ),
              if (recAction && needsToSign == 'Receives a Copy')
                Text(
                  'Received On: $price',
                  style: theme.textTheme.bodyMedium!
                      .copyWith(color: appTheme.blueGray500),
                ),
              if (recAction && needsToSign == 'Needs to View')
                Text(
                  'Viewed On: $price',
                  style: theme.textTheme.bodyMedium!
                      .copyWith(color: appTheme.blueGray500),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Navigates to the documentviewScreen when the action is triggered.
  onTapSign(BuildContext context, String buttonType) {
    // Navigator.pushNamed(context, AppRoutes.documentviewScreen);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => WebViewScreen(envelope!.id, envelope!.senderId)));
  }

  double calculatePercentage(
      int totalSignedDocuments, int totalNumberDocuments) {
    final value = (totalSignedDocuments / totalNumberDocuments);
    print('value: $value, $totalSignedDocuments, $totalNumberDocuments');
    return value;
  }
}
