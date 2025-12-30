import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/crm/lead/lead.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/lead_form_view_model.dart';
import 'package:umgkh_mobile/views/pages/crm/activity/index.dart';
import 'package:umgkh_mobile/views/pages/crm/lead/widget/utils_widget.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';

class LeadFormAndInfoPage extends StatefulWidget {
  final bool isForm;
  final bool isLeadUnit;

  final Lead? data;
  const LeadFormAndInfoPage(
      {super.key, this.isForm = true, this.isLeadUnit = true, this.data});

  @override
  State<LeadFormAndInfoPage> createState() => _LeadFormAndInfoPageState();
}

class _LeadFormAndInfoPageState extends State<LeadFormAndInfoPage> {
  late String title;
  @override
  void initState() {
    final p = Provider.of<LeadFormViewModel>(context, listen: false);
    p.resetValidate();
    p.resetForm();
    if (!widget.isForm) p.setInfo(widget.data!);
    title = widget.isForm
        ? (widget.isLeadUnit ? 'Create Lead Unit' : 'Create Lead Spare Part')
        : (widget.isLeadUnit ? 'Lead Unit Info' : 'Lead Spare Part Info');
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Consumer<LeadFormViewModel>(
        builder: (context, viewModel, _) => CustomScaffold(
          title: title,
          resizeToAvoidBottomInset: true,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: mainPadding),
            child: Column(children: [
              if (!widget.isForm) ...[
                ButtonCustom(
                    text: 'Convert To Opportunity',
                    icon: Icons.crop_rounded,
                    onTap: () {
                      convertToOpportunity(
                        context,
                        selected: viewModel.selectedCustomer,
                        onChanged: (v) =>
                            viewModel.onChangeConvertToOpportunity(
                                v, context, widget.data?.id ?? 0),
                      );
                    }),
                heith5Space,
                ButtonCustom(
                  text: 'Activity',
                  icon: Icons.access_time_rounded,
                  onTap: () => navPush(
                    context,
                    ScheduleActivityPage(id: widget.data?.id ?? 0),
                  ),
                ),
                heithSpace
              ],

              // info as form
              Expanded(
                child: ListView(physics: kBounce, children: [
                  // name
                  InputTextField(
                      ctrl: viewModel.nameCtrl,
                      isValidate: viewModel.isName,
                      validatedText: viewModel.isName ? 'Required field' : '',
                      title: 'Name',
                      hint: 'Enter name',
                      onChanged: viewModel.onChangeName),
                  heith10Space,

                  // probability x priority
                  Flex(direction: Axis.horizontal, children: [
                    Expanded(
                      child: InputTextField(
                          ctrl: viewModel.probabiliyCtrl,
                          title: 'Probability',
                          hint: 'Enter probability',
                          suffixText: '%',
                          keyboardType: TextInputType.number,
                          maxLength: 7),
                    ),
                    widthSpace,
                    selectPriority(
                        selected: viewModel.selectedPriority,
                        onValue: viewModel.onChangePriority)
                  ]),
                  heith10Space,

                  // customer
                  selectCustomer(
                    selected: viewModel.selectedCustomer,
                    onChanged: (v) => viewModel.onChangeCustomer(v, context),
                    isRemove: true,
                    onRemove: () => viewModel.resetCustomer(context),
                  ),
                  heith10Space,

                  // company name
                  InputTextField(
                      ctrl: viewModel.companyCtrl,
                      title: 'Company name',
                      hint: 'Enter company name'),
                  heith10Space,

                  // street 1 x street 2
                  Flex(direction: Axis.horizontal, children: [
                    Expanded(
                      child: InputTextField(
                          ctrl: viewModel.street1Ctrl,
                          title: 'Street 1',
                          hint: 'Enter street',
                          keyboardType: TextInputType.streetAddress),
                    ),
                    widthSpace,
                    Expanded(
                      child: InputTextField(
                          ctrl: viewModel.street2Ctrl,
                          title: 'Street 2',
                          hint: 'Enter street',
                          keyboardType: TextInputType.streetAddress),
                    )
                  ]),
                  heith10Space,

                  // city x country
                  Flex(direction: Axis.horizontal, children: [
                    Expanded(
                      child: InputTextField(
                          ctrl: viewModel.cityCtrl,
                          title: 'City',
                          hint: 'Enter street'),
                    ),
                    widthSpace,
                    selectCountry(
                      selected: viewModel.selectedCountry,
                      onChanged: (v) => viewModel.onChangeCountry(v, context),
                    )
                  ]),
                  heith10Space,

                  // state x zip
                  Flex(direction: Axis.horizontal, children: [
                    selectState(
                        selected: viewModel.selectedState,
                        onChanged: viewModel.onChangeState),
                    widthSpace,
                    Expanded(
                      flex: 3,
                      child: InputTextField(
                          ctrl: viewModel.zipCtrl,
                          title: 'ZIP',
                          hint: 'Enter zip'),
                    )
                  ]),
                  heith10Space,

                  // website
                  InputTextField(
                      ctrl: viewModel.websiteCtrl,
                      title: 'Website',
                      hint: 'Enter website',
                      keyboardType: TextInputType.url),
                  heith10Space,

                  // contact name x job position
                  Flex(direction: Axis.horizontal, children: [
                    Expanded(
                      child: InputTextField(
                          ctrl: viewModel.contactCtrl,
                          isValidate: viewModel.isContact,
                          validatedText:
                              viewModel.isContact ? 'Required field' : '',
                          title: 'Contact name',
                          hint: 'Enter contact name',
                          onChanged: viewModel.onChangeContact),
                    ),
                    widthSpace,
                    Expanded(
                      child: InputTextField(
                          ctrl: viewModel.positionCtrl,
                          title: 'Job position',
                          hint: 'Enter position'),
                    )
                  ]),
                  heith10Space,

                  // mobile x phone
                  Flex(direction: Axis.horizontal, children: [
                    Expanded(
                      child: InputTextField(
                          ctrl: viewModel.mobileCtrl,
                          title: 'Mobile',
                          hint: 'Enter mobile',
                          keyboardType: TextInputType.phone),
                    ),
                    widthSpace,
                    Expanded(
                      child: InputTextField(
                          ctrl: viewModel.phoneCtrl,
                          isValidate: viewModel.isPhone,
                          validatedText:
                              viewModel.isPhone ? 'Required field' : '',
                          title: 'Phone',
                          hint: 'Enter phone',
                          keyboardType: TextInputType.phone,
                          onChanged: viewModel.onChangePhone),
                    )
                  ]),
                  heith10Space,

                  // email x expected revenue
                  Flex(direction: Axis.horizontal, children: [
                    Expanded(
                      flex: 5,
                      child: InputTextField(
                          ctrl: viewModel.emailCtrl,
                          title: 'Email',
                          hint: 'Enter email',
                          keyboardType: TextInputType.emailAddress),
                    ),
                    widthSpace,
                    Expanded(
                      flex: 3,
                      child: InputTextField(
                          ctrl: viewModel.expectRevenueCtrl,
                          isValidate: viewModel.isExpectRevenue,
                          validatedText:
                              viewModel.isExpectRevenue ? 'Required field' : '',
                          title: 'Expected revenue',
                          hint: 'Expected \$',
                          keyboardType: TextInputType.number,
                          onChanged: viewModel.onChangeExpectRevenue),
                    )
                  ]),
                  heith10Space,

                  // sale team
                  selectSaleTeam(
                      isValidate: viewModel.isSaleTeam,
                      selected: viewModel.selectedSale,
                      onChanged: viewModel.onChangeSaleTeam),
                  ...multiheithSpace(4),

                  ButtonCustom(
                      text: widget.isForm ? 'Submit' : 'Update',
                      color: greenColor,
                      onTap: () {
                        if (!viewModel.isValidated()) {
                          widget.isForm
                              ? viewModel.insertData(context, widget.isLeadUnit)
                              : viewModel.updateData(
                                  context, widget.data?.id ?? 0);
                        }
                      }),
                  heithSpace
                ]),
              )
            ]),
          ),
        ),
      );
}
