import 'dart:typed_data';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/hr/leave/leave.dart';
import 'package:umgkh_mobile/models/hr/leave/leave_summary.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/share_widget_view_model.dart';

Widget buildShareWidget(BuildContext context,
        {required Leave leave,
        required int year,
        required double totalLeave,
        required List<LeaveSummary> summaries,
        required Uint8List profile}) =>
    Container(
        decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(mainRadius / 2),
            image: const DecorationImage(
                // image: AssetImage('assets/icons/social/umg.jpg'),
                image: AssetImage('assets/icons/social/nenam.png'),
                opacity: 0.1,
                fit: BoxFit.none,
                scale: 1.6,
                alignment: Alignment(0, 2.5))),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.all(mainPadding / 2),
                  decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(mainRadius / 2)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        itemUser(profile,
                            '${leave.user.name} (${leave.user.department!.code})'),
                        Padding(
                            padding: EdgeInsets.only(
                                left: mainPadding, right: mainPadding),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Leave Summaries ($year)',
                                      style: titleStyle15),
                                  Text(
                                      '$totalLeave Day${totalLeave > 1 ? 's' : '\t\t'}',
                                      style: primary15Bold)
                                ])),
                        heith5Space,
                        Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: mainPadding / 2),
                            child: Divider(
                                color: primaryColor.withOpacity(0.3),
                                height: 0)),
                        Padding(
                            padding: EdgeInsets.only(
                                left: mainPadding * 1.5, right: mainPadding),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: summaries
                                    .map((item) => Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                      '• ${item.leaveType.name}',
                                                      style: titleStyle15)),
                                              Text(
                                                  '${item.numberOfDays} Day${item.numberOfDays > 1 ? 's' : '\t\t'}',
                                                  style: primary15Bold500)
                                            ]))
                                    .toList())),
                        heith10Space
                      ])),
              itemTextState(titleLeaveStatus(leave.state), leave.state),
              itemText(title: 'Leave Type: ', leave.leaveType.name),
              if (leave.requestUnitHalf) ...[
                itemText(
                    title: 'Duration: ',
                    '${leave.numberOfDays} Day • ${leave.requestDateFromPeriod != null && leave.requestDateFromPeriod == "am" ? "Morning" : "Afternoon"}'),
                itemText(
                    title: 'Leave Date: ',
                    formatReadableDate(leave.requestDateFrom)),
              ] else ...[
                itemText(
                    title: 'Duration: ',
                    '${leave.numberOfDays} Day${leave.numberOfDays > 1 ? 's' : ''}'),
                itemTextDateBetween(leave.requestDateFrom, leave.requestDateTo)
              ],
              itemText(title: 'Reason: ', leave.description),
              heithSpace
            ]));

Widget itemUser(Uint8List profile, String data) => Padding(
    padding: padding(),
    child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      if (profile.isNotEmpty) ...[
        ClipRRect(
            borderRadius: BorderRadius.circular(mainRadius),
            child: Image.memory(profile,
                width: 35, height: 35, fit: BoxFit.cover)),
        width10Space
      ],
      Expanded(child: Text(data, style: primary15Bold.copyWith(fontSize: 17)))
    ]));

Widget itemText(String data, {String? title, TextStyle? style}) => Padding(
    padding: padding(),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (title != null) ...[
        Text(title, style: titleStyle15.copyWith(color: greyColor))
      ],
      Expanded(child: Text(data, style: style ?? titleStyle15)),
    ]));

Widget itemTextDateBetween(DateTime dateFrom, DateTime dateTo) => Padding(
    padding: padding(),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Leave Date: ', style: titleStyle15.copyWith(color: greyColor)),
      Expanded(
          child: RichText(
              text: TextSpan(
                  style: titleStyle15,
                  text: formatReadableDate(dateFrom),
                  children: [
            TextSpan(text: '\t\t➝\t\t', style: primary15Bold500),
            TextSpan(text: formatReadableDate(dateTo), style: titleStyle15)
          ])))
    ]));

Widget itemTextState(String data, String state) => Padding(
    padding: padding(),
    child: Container(
        margin: EdgeInsets.symmetric(horizontal: mainPadding * 2),
        padding: EdgeInsets.symmetric(
            horizontal: mainPadding, vertical: mainPadding / 3),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(mainRadius),
            color: colorLeaveStatus(state)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(data, style: titleStyle15.copyWith(color: whiteColor)),
          width5Space,
          Icon(iconLeaveStatus(state), size: 15, color: whiteColor)
        ])));

EdgeInsets padding() => EdgeInsets.only(
    top: mainPadding / 3, left: mainPadding, right: mainPadding);

Widget buildTextShare(BuildContext context, Leave leave) =>
    Consumer<ShareWidgetViewModel>(
        builder: (context, viewModel, _) => FadeIn(
            child: InkWell(
                onTap: () async {
                  await viewModel.saveAndShare(context, leave);
                },
                splashColor: primaryColor.withOpacity(0.1),
                highlightColor: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(mainRadius),
                child: Container(
                    margin: EdgeInsets.only(right: mainPadding),
                    padding: EdgeInsets.symmetric(
                        horizontal: mainPadding * 1.5,
                        vertical: mainPadding / 3),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(mainRadius),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[200]!,
                              offset: const Offset(-4, -4),
                              blurRadius: 10,
                              spreadRadius: 1),
                          BoxShadow(
                              color: Colors.grey[200]!,
                              offset: const Offset(4, 4),
                              blurRadius: 10,
                              spreadRadius: 1)
                        ]),
                    child: Row(children: [
                      Text('Share',
                          style: primary13Bold.copyWith(letterSpacing: 2)),
                      if (viewModel.loading) ...[
                        width10Space,
                        SizedBox(
                            height: 14,
                            width: 14,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: primaryColor))
                      ]
                    ])))));
