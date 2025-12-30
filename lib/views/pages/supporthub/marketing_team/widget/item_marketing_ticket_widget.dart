import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/supporthub/marketing/marketing_ticket.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/supporthub/marketing_team/marketing_ticket_view_model.dart';
import 'package:umgkh_mobile/views/pages/supporthub/marketing_team/request/form.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';

class ItemMarketingTicketWidget extends StatelessWidget {
  final MarketingTicket data;
  const ItemMarketingTicketWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) => Consumer<MarketingTicketViewModel>(
      builder: (context, viewModel, _) => GestureDetector(
          onTap: () async {
            await navPush(
                context, RequestMarketingTicketFormAndInfoPage(data: data));
            viewModel.fetchData();
          },
          child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(mainRadius)),
              color: primaryColor.withOpacity(0.1),
              margin: EdgeInsets.symmetric(vertical: mainPadding / 2),
              child: Padding(
                  padding: EdgeInsets.all(mainPadding * 1.2),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: double.infinity,
                            height: 25,
                            child: StatusCustom(
                                textsize: 11,
                                text: stateTitle(data.state.toLowerCase())
                                    .toUpperCase(),
                                color: stateColor(data.state))),
                        heith10Space,
                        Text(formatReadableDT(data.createDate),
                            style: primary13Bold),
                        heith5Space,
                        item(title: 'Problem', data: data.name),
                        heith5Space,
                        if (data.assignee != null) ...[
                          item(title: 'Assignee', data: data.assignee!.name),
                          heith5Space
                        ],
                        if (data.productModel.name != null) ...[
                          item(title: 'Model', data: data.productModel.name!),
                          heith5Space
                        ],
                        if (data.productModelStr != "") ...[
                          item(title: 'Model', data: data.productModelStr),
                          heith5Space
                        ],
                        item(title: 'Type', data: data.type.name),
                        heith5Space,
                        Divider(
                            color: Colors.black12.withOpacity(0.1), height: 20),
                        Text(data.description.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: titleStyle12.copyWith(color: Colors.black54))
                      ])))));

  Widget item(
          {required String title, required String data, TextStyle? style}) =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('$title:', style: titleStyle12.copyWith(color: Colors.black54)),
        width5Space,
        Expanded(child: Text(data, style: style ?? titleStyle12))
      ]);
}
