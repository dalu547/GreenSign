import 'package:GreenSign/core/utils/size_utils.dart';
import 'package:GreenSign/model/manage_envelope_count.dart';
import 'package:flutter/material.dart';

import '../core/utils/image_constant.dart';
import '../theme/app_decoration.dart';
import '../theme/custom_text_style.dart';
import 'custom_image_view.dart';
import 'manage_envelope_item_widget.dart';

class ManageenvelopeScreen extends StatelessWidget {
  MEnvelopeCount mEnvelopeCount;

  ManageenvelopeScreen(this.mEnvelopeCount);

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.maxFinite,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.h,
              vertical: 24.v,
            ),
            decoration: AppDecoration.fillWhiteA.copyWith(
              borderRadius: BorderRadiusStyle.customBorderTL16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 8.v),
                Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.h),
                        child: Text(
                          "Manage Envelopes",
                          style: CustomTextStyles.titleSmallBluegray500,
                        ),
                      ),
                    ),
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: Padding(
                    //       padding: EdgeInsets.only(right: 16.h),
                    //       child: GestureDetector(
                    //         onTap: () {}, // Image tapped
                    //         child: Image.asset('assets/images/img_close.svg',
                    //           fit: BoxFit.cover, // Fixes border issues
                    //           width: 40.0,
                    //           height: 40.0,
                    //         ),
                    //       )
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(height: 26.v),
                _buildManageEnvelopeList(context),
                //List view
                SizedBox(height: 24.v),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 16.h),
                    child: Text(
                      "*completed in last one month",
                      style: CustomTextStyles.titleSmallBluegray500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget

  /// Section Widget

  Widget _buildManageEnvelopeList(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return SizedBox(height: 1);
        },
        itemCount: 8,
        itemBuilder: (context, index) {
          return ListTile(
            title: ManageEnvelopeItemWidget(mEnvelopeCount, index),
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (_) =>
              //             EnvelopedetailsScreen(envelopes![index])));
            },
          );
        },
      ),
    );
  }
}
