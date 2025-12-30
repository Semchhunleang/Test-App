import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/models/cms/a4/selection/selection.dart';
import 'package:umgkh_mobile/models/cms/document_number.dart';
import 'package:umgkh_mobile/models/cms/tsb/tsb_line.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class TSBData {
  final int id;
  final String? transactionNo;
  final DateTime? date;
  final String? state;
  final DocumentNumber? documentNo;
  final String? createDate;
  final String? gradeBySuperior;
  final String? gradeByCb;
  final int? score;
  final Selection? manufacturer;
  final Selection? productLine;
  final Selection? engineModel;
  final Selection? componentGroup;
  final Selection? model;
  final Selection? series;
  final User? prepareBy;
  final User? manager;
  final String? subject;
  final String? problem;
  final String? symptom;
  final String? history;
  final String? causeAnalysis;
  final String? action;
  final List<TsbLine>? tsbLine;

  TSBData(
      {required this.id,
      this.transactionNo,
      this.date,
      this.state,
      this.documentNo,
      this.createDate,
      this.gradeBySuperior,
      this.gradeByCb,
      this.score,
      this.manufacturer,
      this.productLine,
      this.engineModel,
      this.componentGroup,
      this.model,
      this.series,
      this.prepareBy,
      this.manager,
      this.subject,
      this.problem,
      this.symptom,
      this.history,
      this.causeAnalysis,
      this.action,
      this.tsbLine});

  factory TSBData.fromJson(Map<String, dynamic> json) {
    return TSBData(
      id: json['id'] as int? ?? 0,
      transactionNo: json['transaction_no'] as String? ?? '',
      date: parseDateTime(json['date']),
      state: json['state'] as String? ?? '',
      documentNo: json['document_no'] != null
          ? DocumentNumber.fromJson(json['document_no'])
          : null,
      tsbLine: (json['tsb_lines'] as List<dynamic>?)
          ?.map((row) => TsbLine.fromJson(row as Map<String, dynamic>))
          .toList(),
      prepareBy: json['prepared_by'] != null
          ? User.fromJson(json['prepared_by'])
          : null,
      manager: json['manager'] != null ? User.fromJson(json['manager']) : null,
      manufacturer:
          json['manufacturer'] != null && json['manufacturer']['id'] != null
              ? Selection.fromJson(json['manufacturer'])
              : null,
      productLine:
          json['product_line'] != null && json['product_line']['id'] != null
              ? Selection.fromJson(json['product_line'])
              : null,
      engineModel:
          json['engine_model'] != null && json['engine_model']['id'] != null
              ? Selection.fromJson(json['engine_model'])
              : null,
      componentGroup: json['component_group'] != null &&
              json['component_group']['id'] != null
          ? Selection.fromJson(json['component_group'])
          : null,
      model: json['model'] != null && json['model']['id'] != null
          ? Selection.fromJson(json['model'])
          : null,
      series: json['series'] != null && json['series']['id'] != null
          ? Selection.fromJson(json['series'])
          : null,
      subject: json['subject'] as String? ?? '',
      problem: json['problem'] as String? ?? '',
      symptom: json['symptom'] as String? ?? '',
      history: json['history'] as String? ?? '',
      causeAnalysis: json['cause_analysis'] as String? ?? '',
      action: json['action'] as String? ?? '',
      createDate: json['create_date'] as String? ?? '',
      gradeBySuperior: json['grade_by_superior'] as String? ?? '',
      gradeByCb: json['grade_by_cb'] as String? ?? '',
      score: json['score'] as int? ?? 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': transactionNo,
      'date': date,
      'create_date': createDate,
      'document_no': documentNo,
      'tsb_lines': tsbLine,
      'prepared_by': prepareBy,
      'manager': manager,
      'grade_by_superior': gradeBySuperior,
      'grade_by_cb': gradeByCb,
      'score': score,
      'state': state,
      'manufacturer': manufacturer,
      'product_line': productLine,
      'engine_model': engineModel,
      'component_group': componentGroup,
      'model': model,
      'series': series,
      'subject': subject,
      'problem': problem,
      'symptom': symptom,
      'history': history,
      'cause_analysis': causeAnalysis,
      'action': action
    };
  }
}
