import 'dart:io';

import 'package:umgkh_mobile/utils/utlis.dart';

class JobFinish {
  final int id;
  final int? jobFinishProjectId;
  final DateTime? finishDatetime;
  final String? customerSatisfied;
  final String? customerComment;
  final String? serviceRecommendation;
  final String? customerName;
  final String? phone;
  final String? offId;
  final int sign;
  final File? signImage;
  final int mechanicSign;
  final File? signImageMechanic;

  JobFinish(
      {required this.id,
      this.jobFinishProjectId,
      this.finishDatetime,
      this.customerSatisfied,
      this.customerComment,
      this.serviceRecommendation,
      this.customerName,
      this.phone,
      this.offId,
      required this.sign,
      required this.mechanicSign,
      this.signImage,
      this.signImageMechanic});

  static JobFinish fromJson(Map<String, dynamic> json) {
    File? imagesInsert = json['image_path'] != null
        ? convertPathsToFileSign(json['image_path'])
        : null;
    File? imagesInsertMechanic = json['mechanic_signature_path'] != null
        ? convertPathsToFileSign(json['mechanic_signature_path'])
        : null;

    return JobFinish(
      id: json['id'],
      jobFinishProjectId: json['job_finish_project_id'],
      // finishDatetime: json['finish_datetime'] ?? '',
      finishDatetime: parseDateTime(json['finish_datetime']),
      customerSatisfied: json['customer_satisfied'] ?? '',
      customerComment: json['customer_comment'] ?? '',
      serviceRecommendation: json['service_recommendation'] ?? '',
      customerName: json['customer_name'] ?? '',
      phone: json['phone'] ?? '',
      offId: json['off_id'] ?? '',
      sign: json['sign'] ?? 0,
      signImage: imagesInsert,
      mechanicSign: json['mechanic_sign'] ?? 0,
      signImageMechanic: imagesInsertMechanic,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_finish_project_id': jobFinishProjectId,
      'finish_datetime': rollbackParseDateTime(finishDatetime),
      'customer_satisfied': customerSatisfied,
      'customer_comment': customerComment,
      'service_recommendation': serviceRecommendation,
      'customer_name': customerName,
      'phone': phone,
      'off_id': offId,
      'sign': sign,
      'image_path': signImage?.path,
      'mechanic_sign': mechanicSign,
      'mechanic_signature_path': signImageMechanic?.path,
    };
  }
}
