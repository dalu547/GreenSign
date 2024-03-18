import 'package:GreenSigner/core/utils/size_utils.dart';
import 'package:GreenSigner/model/document.dart';
import 'package:GreenSigner/model/envelope.dart';
import 'package:flutter/material.dart';

import '../core/utils/image_constant.dart';
import '../theme/app_decoration.dart';
import '../theme/custom_text_style.dart';
import '../theme/theme_helper.dart';
import 'custom_image_view.dart';

// ignore: must_be_immutable
class ListrowItemWidget extends StatelessWidget {
  Document document;
  Envelope? envelope;

  ListrowItemWidget(this.document, this.envelope);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecoration.fillWhiteA,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(height: 12.v),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgFilePdf,
                height: 24.adaptSize,
                width: 24.adaptSize,
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 8.h,
                    top: 2.v,
                  ),
                  child: Text(
                    document.documentName??"",
                    style: CustomTextStyles.bodyLargeBluegray90001,
                  ),
                ),
              ),
              // Expanded(
              //   flex: 2,
              //   child: Padding(
              //     padding: EdgeInsets.only(
              //       top: 5.v,
              //       bottom: 2.v,
              //     ),
              //     child: Text(
              //       envelope!.totalNumberDocuments.toString(),
              //       style: theme.textTheme.bodyMedium,
              //     ),
              //   ),
              // ),

              if(document.signature??false)
              Expanded(
                flex: 1,
                child: CustomImageView(
                  imagePath: ImageConstant.imgFrame223,
                  height: 24.adaptSize,
                  width: 24.adaptSize,
                  margin: EdgeInsets.only(left: 10.h),
                ),
              ),

              Expanded(
                flex: 1,
                child: CustomImageView(
                  imagePath: ImageConstant.img,
                  height: 17.v,
                  width: 9.h,
                  margin: EdgeInsets.only(
                    left: 25.h,
                    top: 3.v,
                    bottom: 3.v,
                  ),
                ),
              ),
            ],
          ),
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
