import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/crm/country/country.dart';
import '../models/crm/country_state/country_state.dart';
import '../models/crm/opportunity/opportunity.dart';
import '../models/crm/stage/crm_stages.dart';
import '../models/crm/customer/customer.dart';
import '../models/crm/team/sale_team.dart';
import '../services/api/crm/opportunity/opportunity_service.dart';
import '../utils/show_dialog.dart';
import '../utils/utlis.dart';
import 'selections_view_model.dart';

class OpportunityFormViewModel extends ChangeNotifier {
  bool isName = false, isContact = false, isPhone = false;
  bool isExpectRevenue = false, isSaleTeam = false, isCustomer = false;
  String selectedPriority = "0";
  Customer selectedCustomer = Customer(name: 'Select customer', id: 0);
  CountryState selectedState = CountryState.defaultValue();
  CrmStages selectedStage = CrmStages.defaultValue();
  Country selectedCountry = Country.defaultValue();
  SaleTeam selectedSale = SaleTeam(name: 'Select sale team', id: 0);
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController probabiliyCtrl = TextEditingController();
  TextEditingController companyCtrl = TextEditingController();
  TextEditingController street1Ctrl = TextEditingController();
  TextEditingController street2Ctrl = TextEditingController();
  TextEditingController zipCtrl = TextEditingController();
  TextEditingController cityCtrl = TextEditingController();
  TextEditingController websiteCtrl = TextEditingController();
  TextEditingController contactCtrl = TextEditingController();
  TextEditingController positionCtrl = TextEditingController();
  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController expectRevenueCtrl = TextEditingController();

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  onChangeName(String v) =>
      notify(v, (val) => trimStr(v).isEmpty ? isName = true : isName = false);

  onChangeContact(String v) => notify(
      v, (val) => trimStr(v).isEmpty ? isContact = true : isContact = false);

  onChangePhone(String v) =>
      notify(v, (val) => trimStr(v).isEmpty ? isPhone = true : isPhone = false);

  onChangeExpectRevenue(String v) => notify(
      v,
      (val) => trimStr(v).isEmpty
          ? isExpectRevenue = true
          : isExpectRevenue = false);

  onChangePriority(String v) => notify(v, (val) => selectedPriority = val);

  onChangeSaleTeam(dynamic v) => notify(v, (val) {
        selectedSale = val;
        selectedSale.id == 0 ? isSaleTeam = true : isSaleTeam = false;
      });

  onChangeCustomer(dynamic v, BuildContext context) => notify(v, (val) {
        selectedCustomer = v;
        selectedCustomer.id == 0 ? isCustomer = true : isCustomer = false;
        autoFillCustomer(selectedCustomer, context);
      });

  onChangeCountry(dynamic v, BuildContext context) => notify(v, (val) {
        selectedCountry = v;
        Provider.of<SelectionsViewModel>(context, listen: false)
            .fetchState(selectedCountry.id ?? 0);
        selectedState = CountryState(name: 'Select state', id: 0);
      });

  onChangeState(dynamic v) => notify(v, (val) => selectedState = val);
  onChangeStage(dynamic v) => notify(v, (val) => selectedStage = val);

  //input body of insert opportunity
  Map<String, dynamic> buildMap({int? id}) {
    return {
      if (id != null) "id": id,
      "name": nameCtrl.text,
      "description": '',
      "priority": selectedPriority,
      "stage_id": selectedStage.id,
      "expected_revenue": expectRevenueCtrl.text,
      "contact_name": contactCtrl.text,
      "partner_name": companyCtrl.text,
      "strfunction": positionCtrl.text,
      "email_from": emailCtrl.text,
      "phone": phoneCtrl.text,
      "mobile": mobileCtrl.text,
      "website": websiteCtrl.text,
      "street": street1Ctrl.text,
      "street2": street2Ctrl.text,
      "zip": zipCtrl.text,
      "city": cityCtrl.text,
      "probability": probabiliyCtrl.text,
      if (selectedSale.id != 0) "team_id": selectedSale.id,
      if (selectedCustomer.id != 0) "partner_id": selectedCustomer.id,
      if (selectedState.id != 0) "state_id": selectedState.id,
      if (selectedCountry.id != 0) "country_id": selectedCountry.id
    };
  }

  //Create a opportunity
  Future<void> insertOpportunity(
      BuildContext context, String serviceType) async {
    try {
      Map<String, dynamic> data = buildMap()
        ..addAll({'service_type': serviceType});
      await OpportunityService().insertOpportunity(data).then((value) {
        if (context.mounted) {
          !value.message!.contains('error')
              ? showResultDialog(context, '${value.message}',
                  isBackToList: true, isDone: true)
              : showResultDialog(context, '${value.message}',
                  isBackToList: false);
        }
        notifyListeners();
      });
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> updateOpportunity(BuildContext context, int id) async {
    try {
      await OpportunityService()
          .updateOpportunity(buildMap(id: id),)
          .then((value) {
        if (context.mounted) {
          !value.message!.contains('error')
              ? showResultDialog(context, '${value.message}',
                  isBackToList: true, isDone: true)
              : showResultDialog(context, '${value.message}',
                  isBackToList: false);
        }
        notifyListeners();
      });
    } catch (e) {
      debugPrint('$e');
    }
  }

  resetCustomer(BuildContext context) {
    selectedCustomer = Customer(
        name: 'Select customer',
        id: 0,
        country: Country.defaultValue(),
        countryState: CountryState.defaultValue(),);
    autoFillCustomer(selectedCustomer, context);
    notifyListeners();
  }

  resetValidate() {
    isName =
        isContact = isPhone = isExpectRevenue = isSaleTeam = isCustomer = false;
    selectedPriority = "0";
    selectedSale = SaleTeam(name: 'Select sale team', id: 0);
  }

  bool isValidated(BuildContext context) {
    onChangeName(nameCtrl.text);
    //onChangeContact(contactCtrl.text);
    //onChangePhone(phoneCtrl.text);
    onChangeExpectRevenue(expectRevenueCtrl.text);
    onChangeSaleTeam(selectedSale);
    if (selectedCustomer.id == 0) onChangeCustomer(selectedCustomer, context);
    return isName ||
        isContact ||
        isPhone ||
        isExpectRevenue ||
        isSaleTeam ||
        isCustomer;
  }

  resetForm() {
    selectedCustomer = Customer(name: 'Select customer', id: 0);
    selectedState = CountryState.defaultValue();
    selectedCountry = Country.defaultValue();
    selectedSale = SaleTeam(name: 'Select sale team', id: 0);
    selectedStage = CrmStages(name: 'COOL', id: 1);
    selectedPriority = '0';
    nameCtrl.clear();
    expectRevenueCtrl.clear();
    contactCtrl.clear();
    companyCtrl.clear();
    positionCtrl.clear();
    emailCtrl.clear();
    phoneCtrl.clear();
    mobileCtrl.clear();
    websiteCtrl.clear();
    street1Ctrl.clear();
    street2Ctrl.clear();
    zipCtrl.clear();
    cityCtrl.clear();
    probabiliyCtrl.text = '0.0';
  }

  setInfo(Opportunity data) {
    selectedCustomer = Customer(
        name: data.customer?.name ?? 'Select customer', id: data.customer?.id);
    selectedCountry = Country(
        name: data.country?.name ?? 'Select country', id: data.country?.id);
    selectedState = CountryState(
        name: data.state?.name ?? 'Phnom Penh', id: data.state?.id);
    selectedSale = SaleTeam(
        name: data.saleTeam?.name ?? 'Select sale team', id: data.saleTeam?.id);
    selectedStage = CrmStages.defaultValue();
    selectedPriority = data.priority.toString();
    nameCtrl.text = data.name ?? '';
    expectRevenueCtrl.text = data.expectedRevenue ?? '';
    contactCtrl.text = data.contactName ?? '';
    companyCtrl.text = data.partnerName ?? '';
    positionCtrl.text = data.function ?? '';
    emailCtrl.text = data.emailFrom ?? '';
    phoneCtrl.text = data.phone ?? '';
    mobileCtrl.text = data.mobile ?? '';
    websiteCtrl.text = data.website ?? '';
    street1Ctrl.text = data.street ?? '';
    street2Ctrl.text = data.street2 ?? '';
    zipCtrl.text = data.zip ?? '';
    cityCtrl.text = data.city ?? '';
    probabiliyCtrl.text = '${data.probability == 0 ? 0.0 : data.probability}';
  }

  autoFillCustomer(Customer data, BuildContext context) {
    companyCtrl.text = contactCtrl.text = data.id != 0 ? data.name ?? '' : '';
    street1Ctrl.text = data.street ?? '';
    street2Ctrl.text = data.street2 ?? '';
    cityCtrl.text = data.city?.name.toString() ?? '';
    onChangeCountry(data.country, context);
    onChangeState(data.countryState);
    zipCtrl.text = data.zip ?? '';
    websiteCtrl.text = data.website ?? '';
    positionCtrl.text = data.jobPosition ?? '';
    phoneCtrl.text = data.phone ?? '';
    mobileCtrl.text = data.mobile ?? '';
    emailCtrl.text = data.email ?? '';
    // onChangeContact(contactCtrl.text);
    // onChangePhone(phoneCtrl.text);
  }
}
