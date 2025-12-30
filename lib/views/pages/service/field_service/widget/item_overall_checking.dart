import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/service-project_task/overall_checking/overall_checking.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/views/pages/service/field_service/widget/utils_widget.dart';

class ItemOverallCheckingWidget extends StatelessWidget {
  final OverallChecking data;
  const ItemOverallCheckingWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(mainRadius),
      ),
      color: primaryColor.withOpacity(0.1),
      margin: EdgeInsets.symmetric(vertical: mainPadding / 2),
      child: Padding(
        padding: EdgeInsets.all(mainPadding * 1.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            item(),
            Text(ifNullStr(data.note), style: titleStyle11),
            if (data.attachments != null && data.attachments!.isNotEmpty) ...[
              heith10Space,
              imageFieldServies(context, data.attachments!)
            ],
            if (data.images != null && data.images!.isNotEmpty) ...[
              heith10Space,
              imageFieldServiesLocal(context, data.images!)
            ]
          ],
        ),
      ),
    );
  }

  item() => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              formatReadableDT(data.checkDatetime!),
              style: titleStyle12.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Column(children: [
            text(title: 'Machine Hr', data: data.currentMachineHour),
            text(title: 'Machine Km', data: data.currentMachineKm)
          ])
        ],
      );

  Widget text({required String title, required double? data}) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$title:',
            style: titleStyle11.copyWith(fontWeight: FontWeight.bold),
          ),
          width5Space,
          Text(data.toString(),
              style: titleStyle11, maxLines: 2, overflow: TextOverflow.ellipsis)
        ],
      );
}
