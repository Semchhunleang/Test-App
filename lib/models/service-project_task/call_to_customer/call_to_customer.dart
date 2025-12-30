import 'package:umgkh_mobile/utils/utlis.dart';

class CallToCustomer {
  final int id;
  final int? callToCustomerId;
  final DateTime? callDatetime;
  final num? callDuration;
  final String? status;
  final String? note;
  final int evidenceImage;

  CallToCustomer(
      {required this.id,
      this.callToCustomerId,
      this.callDatetime,
      this.callDuration,
      this.status,
      this.note,
      required this.evidenceImage});

  static CallToCustomer fromJson(Map<String, dynamic> json) {
    return CallToCustomer(
      id: json['id'],
      callToCustomerId: json['call_to_customer_id'],
      callDatetime: parseDateTime(json['call_datetime']),
      callDuration: json['call_duration'] ?? 0,
      status: json['status'] ?? '',
      note: json['note'] ?? '',
      evidenceImage: json['evidence_image'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'call_to_customer_id': callToCustomerId,
      'call_datetime': rollbackParseDateTime(callDatetime),
      'call_duration': callDuration,
      'status': status,
      'note': note,
      'evidence_image': evidenceImage
    };
  }
}
