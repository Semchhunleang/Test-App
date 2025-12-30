import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/models/cms/a4/objective_selection.dart';
import 'package:umgkh_mobile/models/cms/document_number.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class A4Data {
  final int id;
  final String? name;
  final DateTime? startPeriod;
  final DateTime? endPeriod;
  final DocumentNumber? documentNo;
  final String? improvScope;
  final String? currentCond;
  final String? improvSuggest;
  final String? improvTheme;
  final String? deliverables;
  final String? nextImprov;
  final String? createDate;
  final String? gradeBySuperior;
  final String? gradeByCb;
  final int? score;
  final String? state;
  final List<ObjectiveSelection>? isoObjective1Names;
  final List<ObjectiveSelection>? isoObjective2Names;
  final List<ObjectiveSelection>? isoObjective3Names;
  final User? creator;
  final User? manager;

  A4Data(
      {required this.id,
      this.name,
      this.startPeriod,
      this.endPeriod,
      this.documentNo,
      this.improvScope,
      this.currentCond,
      this.improvSuggest,
      this.improvTheme,
      this.deliverables,
      this.nextImprov,
      this.createDate,
      this.gradeBySuperior,
      this.gradeByCb,
      this.score,
      this.state,
      this.isoObjective1Names,
      this.isoObjective2Names,
      this.isoObjective3Names,
      this.creator,
      this.manager});

  factory A4Data.fromJson(Map<String, dynamic> json) {
    return A4Data(
        id: json['id'] as int? ?? 0,
        name: json['name'] as String? ?? '',
        startPeriod: parseDateTime(json['start_period']),
        endPeriod: parseDateTime(json['end_period']),
        documentNo: json['document_no'] != null
            ? DocumentNumber.fromJson(json['document_no'])
            : null,
        improvScope: json['improv_scope'] as String? ?? '',
        currentCond: json['current_cond'] as String? ?? '',
        improvSuggest: json['improv_suggest'] as String? ?? '',
        improvTheme: json['improv_theme'] as String? ?? '',
        nextImprov: json['next_improv'] as String? ?? '',
        deliverables: json['deliverables'] as String? ?? '',
        isoObjective1Names: (json['iso_objective1_names'] as List<dynamic>?)
            ?.map((row) =>
                ObjectiveSelection.fromJson(row as Map<String, dynamic>))
            .toList(),
        isoObjective2Names: (json['iso_objective2_names'] as List<dynamic>?)
            ?.map((row) =>
                ObjectiveSelection.fromJson(row as Map<String, dynamic>))
            .toList(),
        isoObjective3Names: (json['iso_objective3_names'] as List<dynamic>?)
            ?.map((row) =>
                ObjectiveSelection.fromJson(row as Map<String, dynamic>))
            .toList(),
        creator:
            json['creator'] != null ? User.fromJson(json['creator']) : null,
        manager:
            json['manager'] != null ? User.fromJson(json['manager']) : null,
        createDate: json['create_date'] as String? ?? '',
        gradeBySuperior: json['grade_by_superior'] as String? ?? '',
        gradeByCb: json['grade_by_cb'] as String? ?? '',
        score: json['score'] as int? ?? 0,
        state: json['state'] as String? ?? '');
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'start_period': startPeriod,
      'end_period': endPeriod,
      'create_date': createDate,
      'document_no': documentNo,
      'improv_scope': improvScope,
      'currentCond': currentCond,
      'improvSuggest': improvSuggest,
      'improvTheme': improvTheme,
      'nextImprov': nextImprov,
      'deliverables': deliverables,
      'iso_objective1_names': isoObjective1Names,
      'iso_objective2_names': isoObjective2Names,
      'iso_objective3_names': isoObjective3Names,
      'creator': creator,
      'manager': manager,
      'grade_by_superior': gradeBySuperior,
      'grade_by_cb': gradeByCb,
      'score': score,
      'state': state,
    };
  }
}
