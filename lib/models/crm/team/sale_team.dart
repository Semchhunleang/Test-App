
import 'package:umgkh_mobile/utils/utlis.dart';

class SaleTeam {
  int? id;
  String? name;
  bool? active;
  int? userId;
  int? sequence;
  bool? useLeads;
  int? companyId;
  int? departmentId;
  bool? useOpportunities;
  DateTime? createDate;

  SaleTeam(
      {this.id,
      this.name,
      this.active,
      this.userId,
      this.sequence,
      this.useLeads,
      this.companyId,
      this.departmentId,
      this.useOpportunities,
      this.createDate});

  SaleTeam.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'];
    active = json['active'];
    userId = json['user_id'] ?? 0;
    sequence = json['sequence'] ?? 0;
    useLeads = json['use_leads'];
    companyId = json['company_id'] ?? 0;
    departmentId = json['department_id'] ?? 0;
    useOpportunities = json['use_opportunities'];
    createDate = parseDateTime(json['create_date']);
  }
}
