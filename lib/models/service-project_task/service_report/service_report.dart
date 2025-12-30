import 'dart:convert';
import 'dart:io';

import 'package:umgkh_mobile/utils/utlis.dart';

class ServiceReport {
  int id;
  int? serviceReportProjectId;
  DateTime? date;
  String? serviceReport;
  String? problem;
  String? rootCause;
  String? action;
  String? offId;
  List<int> attachments;
  List<File>? images;

  ServiceReport({
    required this.id,
    this.serviceReportProjectId,
    this.date,
    this.serviceReport,
    this.problem,
    this.rootCause,
    this.action,
    this.offId,
    required this.attachments,
    this.images,
  });

  static ServiceReport fromJson(Map<String, dynamic> json) {
    List<File>? imagesInsert = (json['image_paths'] != null)
        ? (jsonDecode(json['image_paths']) as List<dynamic>)
            .map((path) => convertPathsToFile(path),)
            .toList()
        : [];

    return ServiceReport(
        id: json['id'],
        serviceReportProjectId: json['service_report_project_id'],
        date: parseDateTime(json['date']),
        serviceReport: json['service_report'] ?? '',
        problem: json['problem'] ?? '',
        rootCause: json['root_cause'] ?? '',
        action: json['action'] ?? '',
        offId: json['off_id'] ?? '',
        attachments: json['attachments'] != null
            ? List<int>.from(json['attachments'])
            : [],
        images: imagesInsert);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'service_report_project_id': serviceReportProjectId,
      'date': rollbackParseDateTime(date),
      'service_report': serviceReport,
      'problem': problem,
      'root_cause': rootCause,
      'action': action,
      'off_id': offId,
      'attachments': attachments,
      'image_paths': jsonEncode(images?.map((file) => file.path).toList(),),
    };
  }
}
