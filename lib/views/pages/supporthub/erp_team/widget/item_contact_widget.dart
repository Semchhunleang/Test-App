import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/supporthub/erp/erp_ticket.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/supporthub/erp_team/request_contact_view_model.dart';
import 'package:umgkh_mobile/views/pages/supporthub/erp_team/request/contact/form.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';

class ItemContactWidget extends StatelessWidget {
  final ERPTicket data;
  const ItemContactWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) => Consumer<RequestContactViewModel>(
      builder: (context, viewModel, _) => GestureDetector(
          onTap: () async {
            await navPush(
                context, ERPRequestContactFormAndInfoPage(data: data));
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
                                text: data.state.toUpperCase(),
                                color: stateColor(data.state))),
                        heith10Space,
                        Text(formatReadableDT(data.createDate),
                            style: primary13Bold),
                        heith5Space,
                        item(title: 'Name', data: data.name),
                        heith5Space,
                        item(title: 'Contact', data: data.contact),
                        heith5Space,
                        if (hasType()) ...[
                          item(
                              title: 'Type',
                              data: toTitleCase(data.contactType!),
                              style: titleStyle12.copyWith(
                                  color: colorType(data.contactType!),
                                  fontWeight: FontWeight.bold)),
                          heith5Space
                        ],
                        if (hasAssignee()) ...[
                          item(title: 'Assignee', data: data.assignee!.name),
                          heith5Space
                        ],
                        if (hasRejectReason()) ...[
                          item(
                              title: 'Reject Reason', data: data.rejectReason!),
                          heith5Space,
                        ],
                        Divider(
                            color: Colors.black12.withOpacity(0.1), height: 20),
                        Text(data.description.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: titleStyle12.copyWith(color: Colors.black54))
                      ])))));

  bool hasType() => data.contactType != null;
  bool hasAssignee() => data.assignee != null;
  bool hasRejectReason() => data.rejectReason != null && data.state == reject;
  Widget item(
          {required String title, required String data, TextStyle? style}) =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('$title:', style: titleStyle12.copyWith(color: Colors.black54)),
        width5Space,
        Expanded(child: Text(data, style: style ?? titleStyle12))
      ]);
}
