import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/crm/opportunity/opportunity.dart';
import 'package:umgkh_mobile/utils/navigator.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/opportunity_form_view_model.dart';
import 'package:umgkh_mobile/views/pages/crm/activity/index.dart';
import 'package:umgkh_mobile/widgets/button_custom.dart';
import 'package:umgkh_mobile/widgets/custom_scaffold.dart';
import 'package:umgkh_mobile/widgets/textfield.dart';
import 'widget/utils_opportunity_widget.dart';

class OpportunityFormInfo extends StatefulWidget {
  final bool isForm;
  final Opportunity? data;
  final String serviceType;
  const OpportunityFormInfo(
      {super.key, this.data, this.isForm = true, required this.serviceType});

  @override
  State<OpportunityFormInfo> createState() => _OpportunityFormInfoState();
}

class _OpportunityFormInfoState extends State<OpportunityFormInfo> {
  @override
  void initState() {
    final p = Provider.of<OpportunityFormViewModel>(context, listen: false);
    p.resetValidate();
    p.resetForm();
    if (!widget.isForm) p.setInfo(widget.data!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Consumer<OpportunityFormViewModel>(
        builder: (context, viewModel, _) => CustomScaffold(
          title: widget.isForm
              ? widget.serviceType == "unit"
                  ? 'Create Opportunity Unit'
                  : 'Create Opportunity Sparepart'
              : widget.serviceType == "unit"
                  ? 'Detail Opportunity Unit'
                  : 'Detail Opportunity Sparepart',
          resizeToAvoidBottomInset: true,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: mainPadding),
            child: Column(children: [
              if (!widget.isForm)
                ButtonCustom(
                  text: 'Activity',
                  icon: Icons.access_time_rounded,
                  onTap: () => navPush(
                    context,
                    ScheduleActivityPage(id: widget.data?.id ?? 0),
                  ),
                ),
              heithSpace,

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
                          maxLength: 10),
                    ),
                    widthSpace,
                    selectPriority(
                        //not DONE
                        selected: viewModel.selectedPriority,
                        onValue: viewModel.onChangePriority)
                  ]),
                  heith10Space,

                  // customer
                  selectCustomer(
                    selected: viewModel.selectedCustomer,
                    isValidate: viewModel.isCustomer,
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
                          readOnly: true,
                          keyboardType: TextInputType.streetAddress),
                    ),
                    widthSpace,
                    Expanded(
                      child: InputTextField(
                          ctrl: viewModel.street2Ctrl,
                          title: 'Street 2',
                          hint: 'Enter street',
                          readOnly: true,
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
                        hint: 'Enter street',
                        readOnly: true,
                      ),
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
                      onChanged: viewModel.onChangeState,
                    ),
                    widthSpace,
                    Expanded(
                      flex: 3,
                      child: InputTextField(
                        ctrl: viewModel.zipCtrl,
                        title: 'ZIP',
                        hint: 'Enter zip',
                        readOnly: true,
                      ),
                    )
                  ]),
                  heith10Space,

                  // website
                  InputTextField(
                      ctrl: viewModel.websiteCtrl,
                      title: 'Website',
                      readOnly: true,
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
                          readOnly: true,
                          hint: 'Enter contact name',
                          onChanged: viewModel.onChangeContact),
                    ),
                    widthSpace,
                    Expanded(
                      child: InputTextField(
                          ctrl: viewModel.positionCtrl,
                          title: 'Job position',
                          readOnly: true,
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
                          readOnly: true,
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
                          readOnly: true,
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
                          readOnly: true,
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
                  Flex(direction: Axis.horizontal, children: [
                    selectSaleTeams(
                        isValidate: viewModel.isSaleTeam,
                        selected: viewModel.selectedSale,
                        onChanged: viewModel.onChangeSaleTeam),
                    ...multiheithSpace(4),
                    widthSpace,
                    Expanded(
                      flex: 4,
                      child: selectStagesForm(
                          titleHead: "Stage",
                          selected: widget.data != null
                              ? widget.data!.stage ?? viewModel.selectedStage
                              : viewModel.selectedStage,
                          onChanged: viewModel.onChangeStage),
                    )
                  ]),
                  ...multiheithSpace(4),

                  ButtonCustom(
                      text: widget.isForm ? 'Submit' : 'Update',
                      color: greenColor,
                      onTap: () {
                        if (!viewModel.isValidated(context)) {
                          widget.isForm
                              ? viewModel.insertOpportunity(
                                  context, widget.serviceType)
                              : viewModel.updateOpportunity(
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
