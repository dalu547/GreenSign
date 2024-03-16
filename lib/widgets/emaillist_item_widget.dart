import 'package:DigiSign/core/utils/size_utils.dart';
import 'package:DigiSign/model/envelope.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/utils/image_constant.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_image_view.dart';

class EmaillistItemWidget extends StatelessWidget {
  final Envelope envelope;
  final String envelope_type;
  final String envelope_icon ;


  const EmaillistItemWidget(this.envelope, this.envelope_type,this.envelope_icon);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(height: 5.v),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageView(
              imagePath: envelope_icon,
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
                        Expanded(
                          child: Text(envelope.envelopeName ?? "",
                              style: theme.textTheme.titleMedium,
                              overflow: TextOverflow.ellipsis),
                        ),
                        // if(envelope.statusName != 'Completed')
                        // Padding(
                        //   padding: EdgeInsets.only(bottom: 3.v),
                        //   child: Text(
                        //       calculateDaysGap(envelope.lastChanged ?? ""),
                        //       style: CustomTextStyles.bodyMedium_2),
                        // ),
                      ],
                    ),
                    SizedBox(height: 3.v),
                    if (envelope_type == 'Sent')
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("To: ${envelope.requiredApprovals?.first.recipientName}",
                            style: CustomTextStyles.bodyMedium_1))
                    else
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text("From: ${envelope.from}",
                              style: CustomTextStyles.bodyMedium_1)),
                    SizedBox(height: 5.v),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if(envelope.envelopeStatusType == 'action_required')
                        CustomElevatedButton(
                            width: 80.h,
                            text: 'Action Required')
                        else if(envelope.envelopeStatusType == 'waiting_for_others')
                          CustomElevatedButton(
                              width: 80.h,
                              text: 'Waiting For Others')
                        else if(envelope.envelopeStatusType == 'expiring_soon')
                          CustomElevatedButton(
                              width: 80.h,
                              text: 'Expiring Soon')
                        else
                            CustomElevatedButton(
                                width: 80.h,
                                text: envelope.envelopeStatusType ?? ""),

                        Spacer(),
                        if (envelope.totalSignedDocuments != null &&
                            envelope.totalNumberRecipients != null)
                          Container(
                            height: 4.v,
                            width: 45.h,
                            decoration: BoxDecoration(
                              color: appTheme.blueGray10001,
                              borderRadius: BorderRadius.circular(2.h),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2.h),
                              child: LinearProgressIndicator(
                                value: calculatePercentage(
                                    envelope.totalSignedDocuments ?? 0,
                                    envelope.totalNumberRecipients ?? 0),
                                backgroundColor: appTheme.blueGray10001,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    appTheme.greenA700),
                              ),
                            ),
                          ),
                        if (envelope.totalSignedDocuments != null &&
                            envelope.totalNumberRecipients != null)
                          Padding(
                            padding: EdgeInsets.only(
                                left: 8.h, top: 6.v, bottom: 4.v),
                            child: Text(
                                '${envelope.totalSignedDocuments}/${envelope.totalNumberRecipients}',
                                style: theme.textTheme.bodySmall),
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
              margin: EdgeInsets.only(left: 25.h, top: 28.v, bottom: 28.v),
            ),
          ],
        ),
        SizedBox(height: 11.v),
        Align(alignment: Alignment.centerRight, child: Divider(indent: 48.h)),
      ],
    );
  }

  String calculateDaysGap(String dateString) {
    try {
      print('dateString $dateString');
      DateTime lastChangedDateTime =
          DateFormat("dd-MMM-yyyy HH:mm:ss").parse(dateString);
      DateTime currentDate = DateTime.now();
      Duration difference = currentDate.difference(lastChangedDateTime);
      int daysGap = difference.inDays;
      return '$daysGap d';
    } catch (e) {
      // Catch the exception and handle it
      print('Error: $e');
      return "0d";
    }
  }

  double calculatePercentage(
      int totalSignedDocuments, int totalNumberDocuments) {
    print('totalSignedDocuments: $totalSignedDocuments totalNoOfDocuments: $totalNumberDocuments');
    if (totalSignedDocuments > 0 && totalNumberDocuments > 0) {
      final value = (totalSignedDocuments / totalNumberDocuments);
      return value;
    }
    return 0;
  }
}
