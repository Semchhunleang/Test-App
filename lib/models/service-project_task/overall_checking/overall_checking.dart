import 'dart:convert';
import 'dart:io';

import 'package:umgkh_mobile/utils/utlis.dart';


class OverallChecking {
  int id;
  int? tabOverallCheckingId;
  DateTime? checkDatetime;
  double? currentMachineHour;
  double? currentMachineKm;
  String? note;
  String? offId;
  List<int>? attachments;
  List<File>? images;

  OverallChecking({
    required this.id,
    this.tabOverallCheckingId,
    this.checkDatetime,
    this.currentMachineHour,
    this.currentMachineKm,
    this.note,
    this.offId,
    required this.attachments,
    this.images,
  });

  static OverallChecking fromJson(Map<String, dynamic> json) {
    // Initialize imagesInsert as an empty list
    // List<File> imagesInsert = [];

    // Check if 'image_paths' exists and is a List
     List<File>? imagesInsert = (json['image_paths'] != null)
      ? (jsonDecode(json['image_paths']) as List<dynamic>)
          .map((path) => convertPathsToFile(path),)
          .toList()
      : [];
    return OverallChecking(
      id: json['id'],
      tabOverallCheckingId: json['tab_overall_checking_id'],
      checkDatetime: parseDateTime(json['check_datetime']),
      currentMachineHour: double.parse(json['current_machine_hour'].toString(),),
      currentMachineKm: json['current_machine_km'] != null
          ? double.parse(json['current_machine_km'].toString(),)
          : 0.0,
      note: json['note'] ?? '',
      offId: json['off_id'] ?? '',
      attachments: json['attachments'] != null
          ? List<int>.from(json['attachments'])
          : [],
      images: imagesInsert
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tab_overall_checking_id': tabOverallCheckingId,
      'check_datetime': rollbackParseDateTime(checkDatetime),
      'current_machine_hour': currentMachineHour,
      'current_machine_km': currentMachineKm,
      'note': note,
      'off_id': offId,
      'attachments': attachments,
      'image_paths': jsonEncode(images?.map((file) => file.path).toList(),),
    };
  }
}
