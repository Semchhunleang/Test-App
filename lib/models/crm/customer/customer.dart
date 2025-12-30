import 'package:umgkh_mobile/models/crm/city/city.dart';
import 'package:umgkh_mobile/models/crm/country/country.dart';
import 'package:umgkh_mobile/models/crm/country_state/country_state.dart';

class Customer {
  int? id;
  String? name;
  String? street;
  String? street2;
  CountryState? countryState;
  Country? country;
  String? zip;
  String? website;
  String? jobPosition;
  String? phone;
  String? mobile;
  String? email;
  City? city;

  Customer({
    this.id,
    this.name,
    this.street,
    this.street2,
    this.countryState,
    this.country,
    this.zip,
    this.website,
    this.jobPosition,
    this.phone,
    this.mobile,
    this.email,
    this.city,
  });

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'];
    street = json['street'];
    street2 = json['street2'];
    countryState =
        json['state'] != null ? CountryState.fromJson(json['state']) : null;
    country =
        json['country'] != null ? Country.fromJson(json['country']) : null;
    zip = json['zip'];
    website = json['website'];
    jobPosition = json['function'];
    phone = json['phone'];
    mobile = json['mobile'];
    email = json['email'];
    city = json['city'] != null ? City.fromJson(json['city']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'street': street,
      'street2': street2,
      'country_state': countryState?.toJson(),
      'country': country?.toJson(),
      'zip': zip,
      'website': website,
      'function': jobPosition,
      'phone': phone,
      'mobile': mobile,
      'email': email,
      'city': city?.toJson(),
    };
  }
}
