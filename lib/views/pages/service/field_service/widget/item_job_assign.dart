import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/service-project_task/job_assign_line/job_assign_line.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/field_service_view_model.dart';
import 'package:umgkh_mobile/views/pages/service/field_service/widget/job_assign/pop_up_reason.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';

class ItemJobAssignWidget extends StatelessWidget {
  final JobAssignLine data;
  const ItemJobAssignWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) => Consumer<FieldServiceViewModel>(
        builder: (context, viewModel, _) => Card(
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
                item(),
                if (data.state != wait) heith5Space,
                if (data.state != wait)
                  Text(
                      data.state == accept
                          ? data.acceptedDt != null
                              ? formatReadableDT(data.acceptedDt!)
                              : ''
                          : data.rejectedDt != null
                              ? formatReadableDT(data.rejectedDt!)
                              : '',
                      style: titleStyle11),
                if (data.state == wait &&
                    viewModel.isUser(context, data.mechanic.id)) ...[
                  heithSpace,
                  button(context, viewModel)
                ]
              ],
            ),
          ),
        ),
      );

  item() => Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(
            child: Text(ifNullModel(data.mechanic, (p) => p.name),
                style: titleStyle12.copyWith(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis)),
        Text(stateTitle(data.state),
            style: titleStyle12.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: stateColor(data.state)))
      ]);

  button(BuildContext context, FieldServiceViewModel viewModelFS) => Padding(
        padding: EdgeInsets.symmetric(horizontal: mainPadding * 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonCustom(
                isExpan: true,
                text: 'Accept',
                color: approvedColor,
                onTap: () async {
                  await popUpReason(context,
                      jobAssignLine: data,
                      state: accept,
                      message:
                          "Are you sure you want to accept the job assign?");
                }),
            widthSpace,
            ButtonCustom(
                isExpan: true,
                text: 'Reject',
                color: redColor,
                onTap: () async {
                  await popUpReason(context,
                      jobAssignLine: data, state: reject);
                })
          ],
        ),
      );
}
