import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/plm/plm_supporting/monthly_plm_achievement_form_view_model.dart';

class DetailTableWidget extends StatefulWidget {
  final List<dynamic> data;
  final bool isWeekly;
  const DetailTableWidget(
      {super.key, required this.data, this.isWeekly = false});

  @override
  State<DetailTableWidget> createState() => _DetailTableWidgetState();

  static Map<int, TableColumnWidth> tableColumnWidth = {
    0: const FlexColumnWidth(2), // Date
    1: const FlexColumnWidth(2), // Visual Board (Narrowest)
    2: const FlexColumnWidth(1.2), // Target
    3: const FlexColumnWidth(2), // Achievement
    4: const FlexColumnWidth(1.5), // State
  };
}

class _DetailTableWidgetState extends State<DetailTableWidget> {
  int idDetail = 0;
  int achievementDetail = 0;
  final Map<int, int> originalValues = {};

  final Map<int, int> changedValues = {};

  @override
  void initState() {
    super.initState();
    for (var e in widget.data) {
      originalValues[e.id] = e.achievement;
    }
  }

  bool get isChangedDaily => changedValues.isNotEmpty;

  bool get isChangedWeekly {
    if (idDetail == 0) return false;
    return originalValues[idDetail] != achievementDetail;
  }

  @override
  Widget build(BuildContext context) => Material(
        color: whiteColor,
        elevation: 0,
        borderRadius: BorderRadius.circular(10),
        child: Consumer<MonthlyPlmAchievementFormViewModel>(
            builder: (context, viewForm, _) {
          return Column(mainAxisSize: MainAxisSize.min, children: [
            buildTableTitle(),
            buildTableItem(),
            const SizedBox(
              height: 10.0,
            ),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: widget.isWeekly
                    ? (isChangedWeekly
                        ? () {
                            viewForm.updateWeeklyEmployeePLM(
                                context, idDetail, achievementDetail);
                          }
                        : null)
                    : (isChangedDaily
                        ? () {
                            final List<Map<String, dynamic>> data =
                                changedValues.entries
                                    .map((e) =>
                                        {"id": e.key, "achievement": e.value})
                                    .toList();

                            viewForm.updateDailyEmployeePLM(context, data);
                          }
                        : null),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      (widget.isWeekly ? isChangedWeekly : isChangedDaily)
                          ? primaryColor
                          : Colors.grey,
                  foregroundColor: whiteColor,
                ),
                child: const Text("Save"),
              ),
            ),
          ]);
        }),
      );

  Widget buildTableTitle() => Container(
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
          columnWidths: DetailTableWidget.tableColumnWidth,
          children: [
            TableRow(children: [
              _buildTitle('Date'),
              _buildTitle('Visual Board'),
              _buildTitle('Target'),
              _buildTitle('Achievement'),
              _buildTitle('State'),
            ])
          ]));

  Widget buildTableItem() {
    List<dynamic> sortedData = [...widget.data];
    sortedData.sort((a, b) {
      if (a.date == null) return 1;
      if (b.date == null) return -1;

      DateTime dateA = DateTime.tryParse(a.date!) ?? DateTime(1900);
      DateTime dateB = DateTime.tryParse(b.date!) ?? DateTime(1900);

      return dateA.compareTo(dateB); // ascending
    });
    return Flexible(
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Table(
              columnWidths: DetailTableWidget.tableColumnWidth,
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder.all(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  color: primaryColor.withOpacity(0.2),
                  width: 1.0),
              children: [
                ...sortedData
                    .map((e) => TableRow(
                            decoration: BoxDecoration(
                                color: ((e.state == 'not' ||
                                                e.state == 'achieved') &&
                                            !e.isLocked) &&
                                        !e.isVisualBoard
                                    ? whiteColor
                                    : Colors.grey.shade300),
                            children: [
                              _buildItem(e.date ?? ''),
                              _buildItem(isVB(e.isVisualBoard)),
                              _buildItem(e.target.toString()),
                              // _buildItem(e.achievement.toString()),
                              _textfieldInput(e.state, e.achievement.toString(),
                                  e.isVisualBoard, e.id,
                                  isLocked: e.isLocked),
                              // isLocked:
                              //     widget.isWeekly ? false : e.isLocked),
                              _buildItem(capitalizeFirstLetter(e.state)),
                            ]))
                    .toList()
              ])),
    );
  }

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

  Widget _textfieldInput(
    String state,
    String achievement,
    bool isVisualBoard,
    int id, {
    bool isLocked = false,
  }) =>
      TextFormField(
        key: ValueKey(id),
        textAlign: TextAlign.center,
        style: primary12Bold.copyWith(fontWeight: FontWeight.w600),
        keyboardType: TextInputType.number,
        enabled: ((state == 'not' || state == 'achieved') && !isLocked) &&
            !isVisualBoard,
        initialValue: achievement,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          fillColor: Colors.transparent,
          filled: true,
          hintText: "0",
          hintStyle: primary12Bold.copyWith(fontWeight: FontWeight.w600),
        ),
        onChanged: (value) {
          final int parsedValue = int.tryParse(value) ?? 0;

          setState(() {
            idDetail = id;
            achievementDetail = parsedValue;

            final original = originalValues[id] ?? 0;
            if (parsedValue != original) {
              changedValues[id] = parsedValue;
            } else {
              changedValues.remove(id);
            }
          });

          debugPrint("changedValues: $changedValues");
        },
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ],
      );
}
