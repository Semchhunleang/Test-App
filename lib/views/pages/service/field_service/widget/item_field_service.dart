import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/service-project_task/project_task/project_task.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/field_service_view_model.dart';
import 'package:umgkh_mobile/views/pages/service/field_service/info.dart';

class ItemFieldServiceWidget extends StatelessWidget {
  final ProjectTask data;
  const ItemFieldServiceWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) => Consumer<FieldServiceViewModel>(
        builder: (context, viewModel, _) => GestureDetector(
          onTap: () async {
            await viewModel.setSelectData(data);
            if (context.mounted) {
              if (viewModel.titleState(context, data.jobAssignLines ?? []) !=
                  reject) {
                final result = await navPush(context, const FieldServiceInfoPage(),);

                if (result == true) {
                  viewModel.fetchData('field_service');
                }
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
                  Text(data.name, style: primary15Bold),
                  heith10Space,
                  item(context, viewModel),
                  // if (data.operatorName != null ||
                  //     data.operatorPhone != null) ...[
                  //   Divider(color: Colors.black12.withOpacity(0.1), height: 35),
                  //   call(context)
                  // ]
                ],
              ),
            ),
          ),
        ),
      );

  Widget item(BuildContext context, FieldServiceViewModel p) =>
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(ifNullStr(data.jobOrderNo),
              style: titleStyle12,
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          heith5Space,
          Text(ifNullModel(data.customer, (e) => ifNullStr(e.name),),
              style: titleStyle12, maxLines: 2, overflow: TextOverflow.ellipsis)
        ]),),
        widthSpace,
        Column(
          children: [
            buttonStage(context, p),
            const Divider(),
            button(context, p),
          ],
        )
      ]);

  Widget buttonStage(BuildContext context, FieldServiceViewModel p) => Material(
        borderRadius: BorderRadius.circular(mainRadius / 2),
        color: whiteColor.withOpacity(0.7),
        child: InkWell(
          //onTap: () {},
          borderRadius: BorderRadius.circular(mainRadius / 2),
          splashColor: primaryColor.withOpacity(0.1),
          highlightColor: primaryColor.withOpacity(0.1),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                mainPadding, mainPadding / 2, mainPadding, mainPadding / 2),
            child: Text(
              stageFSTitle(data.stage?.name ?? ''),
              style: titleStyle12.copyWith(
                  color: stateColor(data.stage?.name ?? ''),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );

  Widget button(BuildContext context, FieldServiceViewModel p) => Padding(
        padding: EdgeInsets.fromLTRB(
            mainPadding, mainPadding / 2, mainPadding, mainPadding / 2),
        child: Text(
          stateTitle(
            p.titleState(
              context,
              data.jobAssignLines ?? [],
            ),
          ),
          style: titleStyle12.copyWith(
              color: stateColor(
                p.titleState(
                  context,
                  data.jobAssignLines ?? [],
                ),
              ),
              fontWeight: FontWeight.bold),
        ),
      );

  // Widget call(BuildContext context) => GestureDetector(
  //         onTap: () {

  //         },
  //         child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
  //       Icon(Icons.phone_rounded, color: primaryColor),
  //       width5Space,
  //       Text(
  //           data.operatorName != null
  //               ? ifNullStr(data.operatorName)
  //               : ifNullStr(data.operatorPhone),
  //           style: titleStyle12)
  //     ]),);
}
