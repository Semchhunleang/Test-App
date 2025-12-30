import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/supporthub/ict/ict_ticket.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/supporthub/ict_team/ict_ticket_view_model.dart';
import 'package:umgkh_mobile/views/pages/supporthub/ict_team/request/form.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';

class ItemICTTicketWidget extends StatelessWidget {
  final ICTTicket data;
  const ItemICTTicketWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) => Consumer<ICTTicketViewModel>(
      builder: (context, viewModel, _) => GestureDetector(
          onTap: () async {
            await navPush(context, RequestICTTicketFormAndInfoPage(data: data));
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
                        item(
                            title: 'Priority',
                            data: toTitleCase(data.priority),
                            style: titleStyle12.copyWith(
                                color: colorPriority(data.priority),
                                fontWeight: FontWeight.bold)),
                        heith5Space,
                        if (data.category != null) ...[
                          item(title: 'Category', data: data.category!.name),
                          heith5Space
                        ],
                        if (data.assignee != null) ...[
                          item(title: 'Assignee', data: data.assignee!.name),
                          heith5Space
                        ],
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
