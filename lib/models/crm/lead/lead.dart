import 'package:umgkh_mobile/models/crm/country/country.dart';
import 'package:umgkh_mobile/models/crm/country_state/country_state.dart';
import 'package:umgkh_mobile/models/crm/customer/customer.dart';
import 'package:umgkh_mobile/models/crm/team/sale_team.dart';
import 'package:umgkh_mobile/models/base/user/user.dart';

class Lead {
  int? id;
  String? name;
  String? expectedRevenue;
  String? probability;
  String? emailFrom;
  String? function;
  String? phone;
  String? mobile;
  String? contactName;
  String? partnerName;
  String? priority;
  String? website;
  String? street;
  String? street2;
  String? city;
  String? zip;
  Country? country;
  CountryState? state;
  User? employee;
  Customer? customer;
  SaleTeam? saleTeam;

  Lead(
      {this.id,
      this.name,
      this.expectedRevenue,
      this.probability,
      this.emailFrom,
      this.function,
      this.phone,
      this.mobile,
      this.contactName,
      this.partnerName,
      this.priority,
      this.website,
      this.street,
      this.street2,
      this.city,
      this.zip,
      this.country,
      this.state,
      this.employee,
      this.customer,
      this.saleTeam});

  Lead.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'];
    expectedRevenue = json['expected_revenue'];
    probability = json['probability'].toString();
    emailFrom = json['email_from'];
    function = json['function'];
    phone = json['phone'];
    mobile = json['mobile'];
    contactName = json['contact_name'];
    partnerName = json['partner_name'];
    priority = json['priority'];
    website = json['website'];
    street = json['street'];
    street2 = json['street2'];
    city = json['city'];
    zip = json['zip'];
    country =
        json['country'] != null ? Country.fromJson(json['country']) : null;
    state = json['state'] != null ? CountryState.fromJson(json['state']) : null;
    employee =
        json['employee'] != null ? User.fromJson(json['employee']) : null;
    customer =
        json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    saleTeam =
        json['sale_team'] != null ? SaleTeam.fromJson(json['sale_team']) : null;
  }
}
