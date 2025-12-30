import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/crm/lead/lead.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/lead_view_model.dart';
import 'package:umgkh_mobile/views/pages/crm/lead/form_and_info.dart';

class ItemLeadWidget extends StatefulWidget {
  final Lead data;
  final bool isLeadUnit;
  const ItemLeadWidget({super.key, required this.data, this.isLeadUnit = true});

  @override
  State<ItemLeadWidget> createState() => _ItemLeadWidgetState();
}

class _ItemLeadWidgetState extends State<ItemLeadWidget> {
  @override
  Widget build(BuildContext context) => Consumer<LeadViewModel>(
      builder: (context, viewModel, _) => GestureDetector(
          onTap: () async {
            if (mounted) {
              final result = await navPush(
                  context,
                  LeadFormAndInfoPage(
                      isForm: false,
                      isLeadUnit: widget.isLeadUnit,
                      data: widget.data),);
              if (result == true) {
                viewModel.fetchData(widget.isLeadUnit);
              }
            }
          },
          child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(mainRadius),),
              color: primaryColor.withOpacity(0.1),
              margin: EdgeInsets.symmetric(vertical: mainPadding / 2),
              child: Padding(
                  padding: EdgeInsets.all(mainPadding * 1.2),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.data.name ?? nullStr, style: primary13Bold),
                        heith5Space,
                        rating(),
                        heith5Space,
                        Text(widget.data.contactName ?? nullStr,
                            style: titleStyle12)
                      ]),),),));

  Widget rating() => RatingBar.builder(
      initialRating: double.parse(widget.data.priority ?? '0'),
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      ignoreGestures: true,
      itemCount: 3,
      itemSize: 13,
      itemBuilder: (context, _) => Icon(Icons.star, color: primaryColor),
      onRatingUpdate: (v) {});
}
