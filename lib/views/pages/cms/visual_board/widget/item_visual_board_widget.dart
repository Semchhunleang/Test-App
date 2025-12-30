import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/visual_board/visual_board.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/views/pages/cms/visual_board/form/index.dart';

class ItemVisualBoardAsListWidget extends StatelessWidget {
  final VisualBoard data;
  const ItemVisualBoardAsListWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () => navPush(context, VisualBoardFormPage(data: data)),
      child: Card(
        elevation: 0,
        color: primaryColor.withOpacity(0.1),
        margin: EdgeInsets.only(bottom: mainPadding),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(mainPadding / 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TASK NAME
              Text(data.name,
                  style: primary15Bold,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              _buildDivided(),

              // ASSIGNEE & REQESTOR
              _buildEmployeeItem(
                  'Assignees', data.assignees.map((e) => e.name).toList()),
              heith5Space,
              _buildEmployeeItem(
                  'Requestors', data.requestors.map((e) => e.name).toList()),

              _buildDivided(),
              // DATES
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDateItem(
                    'Assigned DT',
                    data.assignedDT != null
                        ? formatDDMMYYYYHHMM(data.assignedDT!)
                        : '-',
                  ),
                  _buildDateItem(
                    'Due Date',
                    data.dueDate != null
                        ? formatDDMMYYYYHHMM(data.dueDate!)
                        : '-',
                  ),
                  _buildDateItem(
                    'Done On',
                    data.doneDT != null
                        ? formatDDMMYYYYHHMM(data.doneDT!)
                        : '-',
                  ),
                ],
              ),

              heith10Space,
              //_buildDivided(),
              // LEAD DAY & OD DAY - STAGE
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDayBadge('Lead Day', data.leadDay, primaryColor),
                  width10Space,
                  _buildDayBadge('OD Day', data.odDay, redColor),

                  // STAGE
                  Flexible(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Material(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                  padding: EdgeInsets.all(mainPadding / 3),
                                  child: Text(data.stage.name,
                                      style: primary12Bold.copyWith(
                                          fontSize: 10,
                                          color: Colors.black54))))))
                ],
              ),
            ],
          ),
        ),
      ));

  Widget _buildDivided() =>
      Divider(height: 16, color: greyColor.withOpacity(0.5), thickness: 0.3);

  Widget _buildEmployeeItem(String label, List<String> value) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('$label:',
              style: titleStyle10.copyWith(
                  fontWeight: FontWeight.bold, color: Colors.grey[600])),
          const SizedBox(width: 2),
          Flexible(
            child: value.isNotEmpty
                ? Wrap(
                    runSpacing: -5,
                    spacing: -5,
                    children: value
                        .map((name) => Card(
                            elevation: 0.1,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(mainRadius)),
                            color: Colors.grey[100],
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Text(name, style: titleStyle10))))
                        .toList())
                : Text('   -   ', style: titleStyle10),
          ),
        ],
      );

  Widget _buildDateItem(String label, String value) => Flexible(
          child: Column(
              crossAxisAlignment: value == '-'
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
            Text(label,
                style: titleStyle11.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.grey[600])),
            const SizedBox(height: 2),
            Text(value,
                style: titleStyle11.copyWith(
                    fontWeight: FontWeight.w600,
                    color: blackColor.withOpacity(0.5)),
                overflow: TextOverflow.ellipsis)
          ]));

  Widget _buildDayBadge(String label, double? count, Color color) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color, width: 0.5)),
      child: Text('$label: ${count ?? 0} day${(count ?? 0) > 1 ? 's' : ''}',
          style: primary12Bold.copyWith(color: color, fontSize: 10),
          overflow: TextOverflow.ellipsis));
}
