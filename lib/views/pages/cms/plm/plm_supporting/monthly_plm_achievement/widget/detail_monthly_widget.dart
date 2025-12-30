import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/plm/plm_supporting/plm_achievement/monthly_line.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/plm/plm_supporting/monthly_plm_achievement_form_view_model.dart';

class DetailMonthlyWidget extends StatefulWidget {
  final MonthlyLines data;
  const DetailMonthlyWidget({super.key, required this.data});

  @override
  State<DetailMonthlyWidget> createState() => _DetailMonthlyWidgetState();

  static Map<int, TableColumnWidth> tableColumnWidth = {
    0: const FlexColumnWidth(2), // Visual Board (Narrowest)
    1: const FlexColumnWidth(1.5), // Target
    2: const FlexColumnWidth(1.5), // Achievement
    3: const FlexColumnWidth(1.5), // State
  };
}

class _DetailMonthlyWidgetState extends State<DetailMonthlyWidget> {
  int idDetail = 0;
  int achievementDetail = 0;
  late int originalAchievement;

  @override
  void initState() {
    super.initState();
    originalAchievement = widget.data.achievement;
  }

  bool get isChanged {
    return idDetail != 0 && achievementDetail != originalAchievement;
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
              onPressed: isChanged
                  ? () {
                      viewForm.updateMonthlyEmployeePLM(
                          context, idDetail, achievementDetail);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isChanged ? primaryColor : Colors.grey,
                foregroundColor: whiteColor,
              ),
              child: const Text("Save"),
            ),
          ),
        ]);
      }));

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
          columnWidths: DetailMonthlyWidget.tableColumnWidth,
          children: [
            TableRow(children: [
              _buildTitle('Visual Board'),
              _buildTitle('Target'),
              _buildTitle('Achievement'),
              _buildTitle('State'),
            ])
          ]));

  Widget buildTableItem() => Flexible(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Table(
                columnWidths: DetailMonthlyWidget.tableColumnWidth,
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: TableBorder.all(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: primaryColor.withOpacity(0.2),
                    width: 1.0),
                children: [
                  TableRow(
                      decoration: BoxDecoration(
                          color: ((widget.data.state == 'not' ||
                                          widget.data.state == 'achieved') &&
                                      !widget.data.isLocked) &&
                                  !widget.data.isVisualBoard
                              ? whiteColor
                              : Colors.grey.shade300),
                      children: [
                        _buildItem(isVB(widget.data.isVisualBoard)),
                        _buildItem(widget.data.target.toString()),
                        _textfieldInput(
                            widget.data.state,
                            widget.data.achievement.toString(),
                            widget.data.isVisualBoard,
                            widget.data.id),
                        _buildItem(capitalizeFirstLetter(widget.data.state)),
                      ])
                ])),
      );

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
          String state, String achievement, bool isVisualBoard, int id) =>
      TextFormField(
        textAlign: TextAlign.center,
        style: primary12Bold.copyWith(fontWeight: FontWeight.w600),
        keyboardType: TextInputType.number,
        enabled: ((state == 'not' || state == 'achieved') &&
                !widget.data.isLocked) &&
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
          setState(() {
            achievementDetail = value.isEmpty ? 0 : int.tryParse(value) ?? 0;
            idDetail = id;
          });
        },
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ],
      );
}
