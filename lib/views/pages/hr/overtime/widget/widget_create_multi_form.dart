import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/hr/overtime/local_multi_submit_ot.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/approve_request_overtime_view_model.dart';
import 'package:umgkh_mobile/view_models/overtime_form_view_model.dart';
import 'package:umgkh_mobile/widgets/custom_drop_list.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class WidgetSumbitOTCreateMultiForm extends StatelessWidget {
  const WidgetSumbitOTCreateMultiForm({super.key});

  @override
  Widget build(BuildContext context) =>
      Consumer2<OvertimeFormViewModel, ApproveRequestOvertimeViewModel>(
          builder: (context, formVM, apprvoeReqOTVM, _) => Column(
                children: formVM.localMultiSubmitOT
                    .toList()
                    .asMap()
                    .entries
                    .map((entry) {
                  int index = entry.key;
                  var multi = entry.value;
                  return itemMutli(
                      context, multi, index, formVM, apprvoeReqOTVM);
                }).toList(),
              ));

  Widget itemMutli(
      BuildContext context,
      LocalMultiSubmitOT multi,
      int index,
      OvertimeFormViewModel formVM,
      ApproveRequestOvertimeViewModel apprvoeReqOTVM) {
    return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: primaryColor.withOpacity(0.1),
        margin: EdgeInsets.only(
            top: mainPadding / 1.5, left: mainPadding, right: mainPadding),
        child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: mainPadding / 1.5, horizontal: mainPadding),
            child: Column(
                //physics: const BouncingScrollPhysics(),
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Overtime: #${index + 1}', style: primary15Bold),
                        InkWell(
                            onTap: () => formVM.onRemoveMulti(index),
                            borderRadius: BorderRadius.circular(mainRadius),
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: mainPadding / 3,
                                    horizontal: mainPadding / 1.5),
                                child: Text('Remove',
                                    style: primary15Bold.copyWith(
                                        color: redColor))))
                      ]),
                  heith10Space,

                  // employee
                  CustomDropList(
                    selected: multi.request,
                    // isValidate: formVM.validate,
                    items: apprvoeReqOTVM.filterRequestOvertimeList
                        .where((e) =>
                            (e.overtimeId == null || e.overtimeId == 0) &&
                            e.state == approveDH)
                        .toList(),
                    itemAsString: (i) => i.name.toString(),
                    onChanged: (v) {
                      formVM.updateSelectedRequest(index, v);
                      // formVM.onValidateReason(formVM.reasonCtrl.text);
                      // formVM.validate = formVM.selectedRequest.id == 0;
                    },
                  ),
                  heithSpace,

                  // distance
                  InputTextField(
                      ctrl: multi.distance,
                      title: 'Distance',
                      hint: 'Distance',
                      suffixText: "KM",
                      keyboardType: TextInputType.number,
                      // focusNode: formVM.focusNode,
                      // onChanged: (v) => formVM.fetchAttendance()
                      onChanged: (v) => formVM.updateMultiDistance(index, v)),
                  heithSpace,

                  _rowText(
                      title: 'Actual Check In',
                      data: multi.otAttendance.checkIn != null
                          ? formatDateTime(multi.otAttendance.checkIn!)
                          : ''),
                  _rowText(
                      title: 'Actual Check Out',
                      data: multi.otAttendance.checkOut != null
                          ? formatDateTime(multi.otAttendance.checkOut!)
                          : ''),
                  _rowText(
                      title: 'Worked duration',
                      data:
                          '${multi.otAttendance.workedDurationHour ?? nullNum} hours ${multi.otAttendance.workedDurationMinute ?? nullNum} mins'),
                  _rowText(
                      title: 'Approved duration',
                      data:
                          '${multi.otAttendance.durationHour ?? nullNum} hours ${multi.otAttendance.durationMinute ?? nullNum} mins'),
                  // Row(children: [
                  //   Expanded(
                  //       child: InputTextField(
                  //           ctrl: multi.approveHr,
                  //           title: 'Approved duration',
                  //           hint: 'Hour',
                  //           suffixText: "hr",
                  //           keyboardType: TextInputType.number,
                  //           onChanged: (v) =>
                  //               formVM.updateMultiApproveHr(index, v))),
                  //   widthSpace,
                  //   Expanded(
                  //       child: InputTextField(
                  //           ctrl: multi.approveMin,
                  //           title: '',
                  //           hint: 'Minute',
                  //           suffixText: "min",
                  //           keyboardType: TextInputType.number,
                  //           onChanged: (v) =>
                  //               formVM.updateMultiApproveMin(index, v))),
                  // ]),
                  heith10Space,

                  /// reason
                  MutliLineTextField(
                      ctrl: multi.reason,
                      title: 'Reason',
                      maxLine: null,
                      // isValidate: formVM.validateReason,
                      // validatedText: formVM.validateText,
                      onChanged: (v) => formVM.updateMultiReason(index, v)),
                  heithSpace,
                  // amount
                  Material(
                      color: greenColor,
                      borderRadius: BorderRadius.circular(mainRadius),
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: mainPadding,
                              vertical: mainPadding / 3),
                          child: Text(
                              '\$ ${multi.otAttendance.amount?.toStringAsFixed(2) ?? '0'}',
                              textAlign: TextAlign.center,
                              style:
                                  primary15Bold.copyWith(color: whiteColor))))
                ])));
  }

  Widget _rowText({required String title, required String data}) => Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
      child: Row(children: [
        Expanded(child: Text('$title:', style: titleStyle13)),
        Expanded(child: Text(data, style: primary13Bold))
      ]));
}
