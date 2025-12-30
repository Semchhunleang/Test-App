import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/hr/survey/feedback_line.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class BuildSurveyFormTableWidget extends StatelessWidget {
  final List<FeedbackLine> data;
  const BuildSurveyFormTableWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) => Flexible(
      child: Material(
          color: whiteColor,
          elevation: 0,
          borderRadius: BorderRadius.circular(10),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [_buildTableTitle(), _buildTableItem()])));

  Widget _buildTableTitle() => Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
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
          columnWidths: _tableColumnWidth,
          children: [
            TableRow(children: [
              _buildTitle('Question'),
              _buildTitle('Answer'),
              _buildTitle('Score'),
            ])
          ]));

  Widget _buildTableItem() => Flexible(
      child: SingleChildScrollView(
          physics: neverScroll,
          child: Table(
              columnWidths: _tableColumnWidth,
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
                          // Question
                          _buildItem(e.question?.title ?? '-',
                              textAlign: TextAlign.start),
                          // Answer
                          if (e.suggestedAnswer != null) ...[
                            _buildItem(
                              e.suggestedAnswer?.value ?? '-',
                            ),
                          ] else if (e.matrixRow != null) ...[
                            _buildItem(
                              e.matrixRow?.value ?? '-',
                            ),
                          ] else ...[
                            _buildItem('-'),
                          ],
                          // Score
                          _buildItem(e.answerScore.toString()),
                        ]))
                    .toList()
              ])));

  static final Map<int, TableColumnWidth> _tableColumnWidth = {
    0: const FlexColumnWidth(3), // Question
    1: const FlexColumnWidth(1), // Answer
    2: const FlexColumnWidth(1), // Score
  };

  Widget _buildTitle(String text) => Padding(
      padding: EdgeInsets.all(mainPadding / 2),
      child: Text(text,
          textAlign: TextAlign.center,
          style: primary13Bold.copyWith(color: whiteColor)));

  Widget _buildItem(String text, {TextAlign textAlign = TextAlign.center}) =>
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          child: Text(text,
              textAlign: textAlign,
              style: primary12Bold.copyWith(fontWeight: FontWeight.w600)));
}
