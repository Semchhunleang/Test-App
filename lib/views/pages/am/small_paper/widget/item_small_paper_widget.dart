// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/am/small_paper/small_paper.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/small_paper_view_model.dart';
import 'package:umgkh_mobile/views/pages/am/small_paper/form_and_info.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';

class ItemSmallPaperWidget extends StatelessWidget {
  final SmallPaper data;
  const ItemSmallPaperWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) => Consumer<SmallPaperViewModel>(
      builder: (context, viewModel, _) => GestureDetector(
          onTap: () async {
            await navPush(
                context, SmallPaperFormAndInfoPage(isForm: false, data: data),);
            viewModel.fetchData(context);
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
                        SizedBox(
                            width: double.infinity,
                            height: 25,
                            child: StatusCustom(
                                textsize: 11,
                                text: data.state.toUpperCase(),
                                color: stateColor(data.state),),),
                        heith10Space,
                        Text(data.transportationType.toUpperCase(),
                            style: primary15Bold),
                        heith5Space,
                        item(title: 'Requestor', data: data.requestor.name),
                        heith5Space,
                        item(
                            title: 'Department',
                            data: data.requestor.department!.name),
                        heith5Space,
                        item(title: 'Approver', data: data.approver.name),
                        heith5Space,
                        item(
                            title: 'Planned DT',
                            data: formatReadableDT(data.plannedDatetime),),
                        heith5Space,
                        if (data.actualDatetime != null) ...[
                          item(
                              title: 'Actual DT',
                              data: formatReadableDT(data.actualDatetime!),),
                          heith5Space
                        ],
                        Divider(
                            color: Colors.black12.withOpacity(0.1), height: 20),
                        Text(data.description.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: titleStyle12.copyWith(color: Colors.black54),)
                      ]),),),));

  Widget item({required String title, required String data}) =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('$title:', style: titleStyle12.copyWith(color: Colors.black54),),
        width5Space,
        Expanded(child: Text(data, style: titleStyle12),)
      ]);
}
