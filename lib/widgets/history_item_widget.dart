import 'package:DigiSign/core/utils/size_utils.dart';
import 'package:DigiSign/model/EnvelopeHistory.dart';
import 'package:DigiSign/model/envelope.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/utils/image_constant.dart';
import '../../theme/custom_text_style.dart';
import '../../theme/theme_helper.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_image_view.dart';

class HistorylistItemWidget extends StatelessWidget {
  final Activites activites;

  const HistorylistItemWidget(this.activites);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Text('${activites.timestamp}',
                style: theme.textTheme.bodyLarge)),
        Align(
            alignment: Alignment.centerLeft,
            child: Text('By ${activites.userName}',
                style: theme.textTheme.bodySmall)),
        SizedBox(height: 11.v),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Action: ${activites.action}',
              style: theme.textTheme.bodyMedium),
        ),
        SizedBox(height: 4.v),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Status: ${activites.status}',
              style: theme.textTheme.bodyMedium),
        ),
        SizedBox(height: 4.v),
        Align(
            alignment: Alignment.centerLeft,
            child: Text('Comments: ', style: theme.textTheme.bodyMedium)),
        SizedBox(height: 4.v),
        Align(alignment: Alignment.center, child: Divider()),
      ],
    );
  }
}
