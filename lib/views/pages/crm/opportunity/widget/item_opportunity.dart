import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/crm/opportunity/opportunity.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/opportunity_view_model.dart';

import '../../../../../utils/navigator.dart';
import '../form_and_info.dart';

class ItemOpportunityWidget extends StatefulWidget {
  final Opportunity opportunity;
  final String serviceType;
  const ItemOpportunityWidget(
      {super.key, required this.opportunity, required this.serviceType});

  @override
  State<ItemOpportunityWidget> createState() => _ItemOpportunityWidgetState();
}

class _ItemOpportunityWidgetState extends State<ItemOpportunityWidget> {
  @override
  Widget build(BuildContext context) => Consumer<OpportunityViewModel>(
      builder: (context, viewModel, _) => GestureDetector(
          onTap: () async {
            if (mounted) {
              final result = await navPush(
                  context,
                  OpportunityFormInfo(
                    isForm: false,
                    data: widget.opportunity,
                    serviceType: widget.serviceType,
                  ),);
              if (result == true) {
                viewModel.fetchOpportunity(widget.serviceType);
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
                        Text(widget.opportunity.stage!.name ?? nullStr,
                            style: primary13Bold),
                        Text(widget.opportunity.name ?? nullStr,
                            style: primary13Bold),
                        heith5Space,
                        rating(),
                        heith5Space,
                        Text(widget.opportunity.contactName ?? nullStr,
                            style: titleStyle12)
                      ]),),),));

  Widget rating() => RatingBar.builder(
      initialRating: double.parse(widget.opportunity.priority ?? '0'),
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      ignoreGestures: true,
      itemCount: 3,
      itemSize: 13,
      itemBuilder: (context, _) => Icon(Icons.star, color: primaryColor),
      onRatingUpdate: (v) {});
}
