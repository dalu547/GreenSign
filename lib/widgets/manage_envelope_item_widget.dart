import 'package:GreenSign/core/utils/size_utils.dart';
import 'package:GreenSign/model/envelope_count.dart';
import 'package:flutter/material.dart';

import '../../core/utils/image_constant.dart';
import '../../theme/app_decoration.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/custom_image_view.dart';
import '../model/manage_envelope_count.dart';

class ManageEnvelopeItemWidget extends StatelessWidget {
  final MEnvelopeCount? mEnvelopeCount;
  final int index;

  ManageEnvelopeItemWidget(this.mEnvelopeCount, this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 16.h,
        right: 24.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomImageView(
            imagePath: _getImage,
            height: 24.adaptSize,
            width: 24.adaptSize,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 12.h,
              bottom: 3.v,
            ),
            child: Text(
              _getText,
              style: CustomTextStyles.bodyLargeRoboto,
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(
              top: 4.v,
              bottom: 3.v,
            ),
            child: Text(
              _getCount,
              style: CustomTextStyles.bodyMediumBluegray400,
            ),
          ),
        ],
      ),
    );
  }

  String get _getCount {
    return [
          mEnvelopeCount?.data.inbox.toString(),
          mEnvelopeCount?.data.completed.toString(),
          mEnvelopeCount?.data.sent.toString(),
          mEnvelopeCount?.data.draft.toString(),
          mEnvelopeCount?.data.voided.toString(),
          mEnvelopeCount?.data.expired.toString(),
          mEnvelopeCount?.data.deleted.toString(),
          mEnvelopeCount?.data.declined.toString(),
        ][index] ??
        '0';
  }

  String get _getText {
    return [
      'inbox',
      'completed',
      'sent',
      'draft',
      'voided',
      'expired',
      'deleted',
      'declined',
    ][index];
  }

  String get _getImage {
    return [
      ImageConstant.imgInbox,
      ImageConstant.imgCompleted,
      ImageConstant.imgSent,
      ImageConstant.imgDraft,
      ImageConstant.imgVoided,
      ImageConstant.imgExpired,
      ImageConstant.imgDeleted,
      ImageConstant.imgDeclined,
    ][index];
  }
}
