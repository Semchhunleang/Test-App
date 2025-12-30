import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/plm/plm_supporting/plm_target/target.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class BuildPLMTargetTableWidget extends StatelessWidget {
  final List<Targets> data;
  const BuildPLMTargetTableWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) => Flexible(
      child: Material(
          color: whiteColor,
          elevation: 0,
          borderRadius: BorderRadius.circular(10),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [buildTableTitle(), buildTableItem()])));

  Widget buildTableTitle() => Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        // border: Border(
        //     top: BorderSide(color: greyColor.withOpacity(0.2), width: 1.0),
        //     left: BorderSide(color: greyColor.withOpacity(0.2), width: 1.0),
        //     right: BorderSide(color: greyColor.withOpacity(0.2), width: 1.0),
        //     bottom: BorderSide.none),
      ),
      child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: TableBorder(
              top: BorderSide.none,
              left: BorderSide.none,
              right: BorderSide.none,
              bottom: BorderSide.none,
              horizontalInside:
                  BorderSide(color: greyColor.withOpacity(0.3), width: 1.0),
              verticalInside:
                  BorderSide(color: greyColor.withOpacity(0.3), width: 1.0)),
          columnWidths: tableColumnWidth,
          children: [
            TableRow(children: [
              _buildTitle('Activity'),
              _buildTitle('Visual Board'),
              _buildTitle('Type'),
              _buildTitle('Target')
            ])
          ]));

  Widget buildTableItem() => Flexible(
      child: SingleChildScrollView(
          physics: neverScroll,
          child: Table(
              columnWidths: tableColumnWidth,
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder.all(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  color: primaryColor.withOpacity(0.2),
                  width: 1.0),
              children: [
                ...data
                    .map((e) => TableRow(children: [
                          _buildItem(e.activity?.name ?? ''),
                          _buildItem(isVB(e.isVisualBoard)),
                          _buildItem(toTitleCase(e.type)),
                          _buildItem(e.target.toString()),
                        ]))
                    .toList()
              ])));

  static Map<int, TableColumnWidth> tableColumnWidth = {
    0: const FlexColumnWidth(3), // Activity (Wider)
    1: const FlexColumnWidth(1.2), // Visual Board (Narrowest)
    2: const FlexColumnWidth(1.5), // Type
    3: const FlexColumnWidth(1.5), // Target
  };

  String isVB(bool isVb) => isVb ? 'Yes' : 'No';

  Widget _buildTitle(String text) => Padding(
      padding: EdgeInsets.all(mainPadding / 3),
      child: Text(text,
          textAlign: TextAlign.center,
          style: primary13Bold.copyWith(color: whiteColor)));

  Widget _buildItem(String text) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Text(text,
          textAlign: TextAlign.center,
          style: primary12Bold.copyWith(fontWeight: FontWeight.w600)));
}
