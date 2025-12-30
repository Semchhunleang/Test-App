import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/hr/request_overtime/local_multi_req_ot.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart';
import 'package:umgkh_mobile/view_models/request_overtime_form_view_model.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/widgets/custom_drop_list.dart';
import 'package:umgkh_mobile/widgets/custom_selected_date.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class WidgetRequestOTCreateMultiForm extends StatelessWidget {
  const WidgetRequestOTCreateMultiForm({super.key});

  @override
  Widget build(BuildContext context) =>
      Consumer2<RequestOvertimeFormViewModel, ProfileViewModel>(
          builder: (context, formVM, userVM, _) => Column(
                children: formVM.localMultiReqOT
                    .toList()
                    .asMap()
                    .entries
                    .map((entry) {
                  int index = entry.key;
                  var multi = entry.value;
                  return itemMutli(context, multi, index, formVM, userVM);
                }).toList(),
              ));

  Widget itemMutli(BuildContext context, LocalMultiReqOT multi, int index,
      RequestOvertimeFormViewModel formVM, ProfileViewModel userVM) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: greyColor.withOpacity(0.1),
      margin: EdgeInsets.only(
          top: mainPadding / 1.5, left: mainPadding, right: mainPadding),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: mainPadding / 1.5, horizontal: mainPadding),
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Request Overtime: #${index + 1}', style: primary15Bold),
              InkWell(
                  onTap: () => formVM.onRemoveMulti(index),
                  borderRadius: BorderRadius.circular(mainRadius),
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: mainPadding / 3,
                          horizontal: mainPadding / 1.5),
                      child: Text('Remove',
                          style: primary15Bold.copyWith(color: redColor))))
            ]),
            heith10Space,
            // employee
            Consumer<SelectionsViewModel>(
                builder: (context, vm, _) => CustomDropList(
                      titleHead: 'Employee',
                      selected: multi.employee,
                      isSearch: true,
                      items: vm.employees
                          .where((e) => e.manager?.id == userVM.user.id)
                          .toList(),
                      itemAsString: (i) => i.name.toString(),
                      onChanged: (v) => formVM.updateMultiEmplyee(index, v),
                    )),
            heithSpace,

            // overtime date
            CustomSelectDate(
                ctrl: multi.overtimeDate,
                title: 'Overtime Date',
                onTap: () => formVM.updateMultiDate(index, context)),
            heithSpace,

            /// duration
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // hour
              Expanded(
                  flex: 3,
                  child: InputTextField(
                    ctrl: multi.overtimeHours,
                    title: 'Duration',
                    hint: 'Hour',
                    suffixText: "Hour",
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    // isValidate: formVM.validateHour,
                    // validatedText: formVM.validateHourText,
                    // readOnly: formVM.isReadOnly,
                    // readOnlyAndFilled: formVM.isReadOnly,
                    // enableSelectText: !formVM.isReadOnly,
                    // onChanged: (hour) => formVM.onValidateHour(hour)
                    onChanged: (v) => formVM.updateMultiHr(index, v),
                  )),
              widthSpace,

              // minutes
              Expanded(
                  flex: 3,
                  child: InputTextField(
                    ctrl: multi.overtimeMinutes,
                    //focusNode: formVM.minuteFocusNode,
                    title: '',
                    maxLength: 2,
                    hint: 'Minute',
                    suffixText: 'Minute',
                    keyboardType: TextInputType.number,
                    // readOnly: formVM.isReadOnly,
                    // readOnlyAndFilled: formVM.isReadOnly,
                    // enableSelectText: !formVM.isReadOnly
                    onChanged: (v) => formVM.updateMultiMin(index, v),
                  ))
            ]),
            heithSpace,

            /// reason
            MutliLineTextField(
                ctrl: multi.reason,
                title: 'Reason',
                maxLine: null,
                // isValidate: formVM.validateReason,
                // validatedText: formVM.validateText,
                // readOnly: formVM.isReadOnly,
                // readOnlyAndFilled: formVM.isReadOnly,
                // enableSelectText: !formVM.isReadOnly,
                // onChanged: (reason) => formVM.onValidateReason(reason)
                onChanged: (v) => formVM.updateMultiReason(index, v)),
            heith5Space
          ],
        ),
      ),
    );
  }
}
