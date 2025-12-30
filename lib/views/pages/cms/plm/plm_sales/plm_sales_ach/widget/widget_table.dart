import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/plm/plm_sales/detail_plm_line.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

// ===========================> CARD DESIGN FOR TABLE HEAD
Widget cardHeadTabBar({required List<Widget> widget}) => Container(
    decoration: BoxDecoration(
        color: greyColor.withOpacity(0.2),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(mainRadius),
            topRight: Radius.circular(mainRadius))),
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
    child: Row(children: widget));

// ===========================> TITLE DESIGN FOR TABLE HEAD
Widget textTitleHeadTabBar(String text,
        {TextStyle? style, int flex = 1, TextAlign? textAlign}) =>
    Expanded(
        flex: flex,
        child: Text(text,
            style: style ?? titleStyle12.copyWith(fontWeight: FontWeight.bold),
            textAlign: textAlign));

// ===========================> CARD DESIGN FOR TABLE EACH ITEM
Widget cardItemTabBarView({required List<Widget> widget}) => Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
    decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: greyColor.withOpacity(0.2)))),
    child: Row(children: widget));

// ===========================> TEXT DESIGN FOR TABLE EACH ITEM
Widget textItemTabBarView(String text,
        {TextStyle? style, int flex = 1, TextAlign? textAlign}) =>
    Expanded(
        flex: flex,
        child: Text(text, style: style ?? titleStyle12, textAlign: textAlign));

// ===========================> SHOWING BOTTOMSHEET DIALOG
showInfoPLMBottomSheet(
  BuildContext context, {
  required String activity,
  required String result,
  required List<DetailPLMLine> data,
  bool isDaily = false,
  bool isWeekly = false,
  bool isMonthly = false,
}) =>
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(mainRadius))),
        builder: (_) => SizedBox(
            // 75% of screen height equal with head tab
            height: MediaQuery.of(context).size.height * 0.75,
            child: Column(children: [
              // TITLE
              Padding(
                  padding: EdgeInsets.all(mainPadding * 1.5),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // ACTIVITY
                        Expanded(
                            child: Text(activity,
                                style: titleStyle15.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    wordSpacing: 1.5))),
                        // RESULT
                        Container(
                            decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(mainRadius),
                                border: Border.all(
                                    color: primaryColor.withOpacity(0.3))),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              const SizedBox(width: 3),
                              Text.rich(TextSpan(
                                  text: 'Result: ',
                                  style: hintStyle.copyWith(
                                      color: Colors.grey[700]),
                                  children: [
                                    TextSpan(text: result, style: primary12Bold)
                                  ]))
                            ]))
                      ])),

              // ================ DAILY DETAILs LINE
              if (isDaily) ...[
                cardHeadTabBar(widget: [
                  textTitleHeadTabBar('Date'),
                  textTitleHeadTabBar('Target'),
                  textTitleHeadTabBar('Ach'),
                  textTitleHeadTabBar('State'),
                ]),
                Expanded(
                    child: ListView(
                        physics: kBounce,
                        children: data
                            .map((e) => cardItemTabBarView(widget: [
                                  textItemTabBarView(e.date != null
                                      ? formatReadableDate(e.date!)
                                      : "n/a"),
                                  textItemTabBarView('\t${e.target}'),
                                  textItemTabBarView(e.achievement.toString()),
                                  textItemTabBarView(e.state),
                                ]))
                            .toList()))
              ],

              // ================ WEEKLY DETAILs LINE
              if (isWeekly) ...[
                cardHeadTabBar(widget: [
                  textTitleHeadTabBar('Start Date'),
                  textTitleHeadTabBar('End Date'),
                  textTitleHeadTabBar('Target'),
                  textTitleHeadTabBar('Ach'),
                  textTitleHeadTabBar('State'),
                ]),
                Expanded(
                    child: ListView(
                        physics: kBounce,
                        children: data
                            .map((e) => cardItemTabBarView(widget: [
                                  textItemTabBarView(e.dateStart != null
                                      ? formatReadableDate(e.dateStart!)
                                      : "n/a"),
                                  textItemTabBarView(e.dateEnd != null
                                      ? formatReadableDate(e.dateEnd!)
                                      : "n/a"),
                                  textItemTabBarView('\t${e.target}'),
                                  textItemTabBarView(
                                      e.achievement.toStringAsFixed(2)),
                                  textItemTabBarView(e.state),
                                ]))
                            .toList()))
              ],

              // CLOSE
              Padding(
                  padding:
                      EdgeInsets.only(right: mainPadding / 2, top: mainPadding),
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                              backgroundColor: redColor.withOpacity(0.8),
                              foregroundColor: whiteColor,
                              padding: EdgeInsets.symmetric(
                                  horizontal: mainPadding * 2,
                                  vertical: mainPadding / 2),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(mainRadius))),
                          child: const Text('Close'))))
            ])));
