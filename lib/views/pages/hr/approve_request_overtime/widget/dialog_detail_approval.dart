import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/hr/request_overtime/request_overtime.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import '../../../../../utils/theme.dart';
import '../../../../../utils/utlis.dart';
import '../../../../../view_models/approve_request_overtime_form_view_model.dart';
import '../../../../../view_models/approve_request_overtime_view_model.dart';
import '../../../../../widgets/button_custom.dart';
import '../../request_overtime/widget/widget_text_value.dart';
import 'pop_up_confirmation.dart';

void showApprovalDetailsDialog(
    BuildContext context, RequestOvertime requestOvertimeList, String state) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mainPadding * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(
                        mainPadding, mainPadding, mainPadding, mainPadding / 2),
                    child:
                        Text('Request Overtime Details', style: primary15Bold),),
                const Divider(),

                // text
                heith5Space,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetTextValue(
                      title: 'State: ',
                      value: stateTitleOvertime(state),
                      fontWeight: FontWeight.w800,
                      valueColor: stateColor(state),
                    ),
                    heithSpace,
                    WidgetTextValue(
                      title: 'Overtime Date: ',
                      value: formatDate(requestOvertimeList.overtimeDate!),
                    ),
                    heithSpace,
                    WidgetTextValue(
                      title: 'Name: ',
                      value: requestOvertimeList.employee!.name,
                    ),
                    heithSpace,
                    WidgetTextValue(
                      title: 'Department: ',
                      value: requestOvertimeList.employee!.department!.name,
                    ),
                    heithSpace,
                    WidgetTextValue(
                      title: 'Manager: ',
                      value: requestOvertimeList.employee!.manager!.name,
                    ),
                    heithSpace,
                    WidgetTextValue(
                      title: 'Request: ',
                      value:
                          "${requestOvertimeList.overtimeHours} hours ${requestOvertimeList.overtimeMinutes} Minute",
                    ),
                    heithSpace,
                    WidgetTextValue(
                      title: 'Approved: ',
                      value:
                          "${requestOvertimeList.dhOvertimeHours} hours ${requestOvertimeList.dhOvertimeMinutes} Minute",
                    ),
                    heithSpace,
                    WidgetTextValue(
                      title: 'Approve DH Date: ',
                      value: requestOvertimeList.approveDhDatetime != null
                          ? formatDate(requestOvertimeList.approveDhDatetime!)
                          : "N/A",
                    ),
                    heithSpace,
                    WidgetTextValue(
                      title: 'Reject Date: ',
                      value: requestOvertimeList.rejectDatetime != null
                          ? formatDate(requestOvertimeList.rejectDatetime!)
                          : "N/A",
                    ),
                  ],
                ),
                heith10Space,
                const Divider(),
                heith10Space,
                Text(requestOvertimeList.reason ?? "", style: titleStyle13),
                if (state == submit) heith10Space,
                if (state == submit) heith10Space,
                if (state == submit)
                  Consumer2<ApproveRequestOvertimeFormViewModel,
                          ApproveRequestOvertimeViewModel>(
                      builder: (context, provider, providerView, child) {
                    return Row(
                      children: [
                        ButtonCustom(
                          onTap: () {
                            Navigator.pop(context);
                            provider.hourCtrl.text =
                                requestOvertimeList.overtimeHours.toString();
                            provider.minuteCtrl.text =
                                requestOvertimeList.overtimeMinutes.toString();
                            popUpConfirmation(
                              context,
                              message:
                                  "Are you sure you want to approve the request overtime?",
                              titleAction: "Approve",
                              state: "approve_dh",
                              requestOvertimeList: requestOvertimeList,
                            );
                          },
                          text: 'Approve',
                        ),
                        widthSpace,
                        ButtonCustom(
                          onTap: () {
                            Navigator.pop(context);
                            popUpConfirmation(
                              context,
                              message:
                                  "Are you sure you want to reject the request overtime?",
                              titleAction: "Reject",
                              state: "reject",
                              requestOvertimeList: requestOvertimeList,
                            );
                          },
                          text: 'Reject',
                          color: redColor,
                        )
                      ],
                    );
                  }),
                if (state == submit) heith10Space,
                // if (state != 'submit')
                Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Close',
                            style: primary12Bold.copyWith(color: redColor),),),),
              ],
            ),
          ),
        ),
      );
    },
  );
}
