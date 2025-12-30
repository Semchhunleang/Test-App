import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/plm/plm_supporting/plm_target/target.dart';
import 'package:umgkh_mobile/utils/theme.dart';

class BuildPLMTargetTableWidget extends StatelessWidget {
  final List<Targets> data;
  const BuildPLMTargetTableWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Material(
          color: whiteColor,
          borderRadius: BorderRadius.circular(10),
          child: Column(children: [
            buildTableTitle(),
            // heithSpace,
            buildTableItem(context),
          ]),
        ),
      );

  Widget buildTableTitle() => Container(
      decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          border: Border(
              top: BorderSide(color: primaryColor.withOpacity(0.2), width: 1.0),
              left:
                  BorderSide(color: primaryColor.withOpacity(0.2), width: 1.0),
              right:
                  BorderSide(color: primaryColor.withOpacity(0.2), width: 1.0),
              bottom: BorderSide.none)),
      child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: TableBorder(
              top: BorderSide.none,
              left: BorderSide.none,
              right: BorderSide.none,
              bottom: BorderSide.none,
              horizontalInside:
                  BorderSide(color: primaryColor.withOpacity(0.2), width: 1.0),
              verticalInside:
                  BorderSide(color: primaryColor.withOpacity(0.2), width: 1.0)),
          columnWidths: tableColumnWidth,
          children: [
            TableRow(children: [
              buildTableCellTitle('Activity'),
              buildTableCellTitle('Visual Board'),
              buildTableCellTitle('Type'),
              buildTableCellTitle('Target')
            ])
          ]));

  Widget buildTableItem(BuildContext context) {
    return Table(
      columnWidths: tableColumnWidth,
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          color: primaryColor.withOpacity(0.2),
          width: 1.0),
      children: [
        ...[
          1212121212,
          1313131313,
          1414141414,
          1515151515,
          1616161616,
          1717171717,
          1818181818,
          1919191919,
          2020202020,
          2121212121,
          2222222222,
          2323232323,
          2424242424,
          2525252525,
          1515151515,
          1616161616,
          1717171717,
          1818181818,
          1919191919,
          2020202020,
          2121212121,
          2222222222,
          2323232323,
          2424242424,
          2525252525
        ].map((e) {
          // ...widget.data.targets.map((e) {
          return TableRow(
            // decoration:
            //     BoxDecoration(borderRadius: BorderRadius.circular(50)),
            children: [
              buildTableCellItem(e.toString()),
              buildTableCellItem(e.toString()),
              buildTableCellItem(e.toString()),
              buildTableCellItem(e.toString()),
              // buildTableCellItem(e.activity?.name ?? ''),
              // buildTableCellItem(isVB(e.isVisualBoard)),
              // buildTableCellItem(toTitleCase(e.type)),
              // buildTableCellItem(e.target.toString()),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget buildTableItems() => Expanded(
        child: SingleChildScrollView(
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
              ...[
                111111,
                222222,
                333333,
                444444,
                555555,
                666666,
                777777,
                888888,
                999999,
                1010101010,
                1111111111,
                1212121212,
                1313131313,
                1414141414,
                1515151515,
                1616161616,
                1717171717,
                1818181818,
                1919191919,
                2020202020,
                2121212121,
                2222222222,
                2323232323,
                2424242424,
                2525252525
              ].map((e) {
                // ...widget.data.targets.map((e) {
                return TableRow(
                  // decoration:
                  //     BoxDecoration(borderRadius: BorderRadius.circular(50)),
                  children: [
                    buildTableCellItem(e.toString()),
                    buildTableCellItem(e.toString()),
                    buildTableCellItem(e.toString()),
                    buildTableCellItem(e.toString()),
                    // buildTableCellItem(e.activity?.name ?? ''),
                    // buildTableCellItem(isVB(e.isVisualBoard)),
                    // buildTableCellItem(toTitleCase(e.type)),
                    // buildTableCellItem(e.target.toString()),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      );

  static Map<int, TableColumnWidth> tableColumnWidth = {
    0: const FlexColumnWidth(3), // Activity (Wider)
    1: const FlexColumnWidth(1.2), // Visual Board (Narrowest)
    2: const FlexColumnWidth(1.5), // Type
    3: const FlexColumnWidth(1.5), // Target
  };

  String isVB(bool isVb) => isVb ? 'Yes' : 'No';

  Widget buildTableCellTitle(String text) => Padding(
      padding: EdgeInsets.all(mainPadding / 3),
      child: Text(text,
          textAlign:
              TextAlign.center, //isHeader ? TextAlign.center : TextAlign.start,
          style: primary13Bold));

  Widget buildTableCellItem(String text, {bool isCenter = true}) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Text(text,
          textAlign: isCenter ? TextAlign.center : TextAlign.start,
          style: primary12Bold.copyWith(fontWeight: FontWeight.w600)));
}

//

Map<int, TableColumnWidth> tableColumnWidth = {
  0: const FlexColumnWidth(3), // Activity (Wider)
  1: const FlexColumnWidth(1.2), // Visual Board (Narrowest)
  2: const FlexColumnWidth(1.5), // Type
  3: const FlexColumnWidth(1.5), // Target
};

String isVB(bool isVb) => isVb ? 'Yes' : 'No';

Widget buildTableCellTitle(String text) => Padding(
    padding: EdgeInsets.all(mainPadding / 3),
    child: Text(text,
        textAlign:
            TextAlign.center, //isHeader ? TextAlign.center : TextAlign.start,
        style: primary13Bold));

Widget buildTableCellItem(String text, {bool isCenter = true}) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
    child: Text(text,
        textAlign: isCenter ? TextAlign.center : TextAlign.start,
        style: primary12Bold.copyWith(fontWeight: FontWeight.w600)));
