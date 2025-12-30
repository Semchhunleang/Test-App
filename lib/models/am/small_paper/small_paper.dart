import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class SmallPaper {
  int id;
  String name;
  String description;
  DateTime plannedDatetime;
  DateTime? actualDatetime;
  String transportationType;
  String state;
  DateTime createDate;
  User requestor;
  User approver;
  List<int> images; // as checking images
  List<int> requestImages;

  SmallPaper(
      {required this.id,
      required this.name,
      required this.description,
      required this.plannedDatetime,
      this.actualDatetime,
      required this.transportationType,
      required this.state,
      required this.createDate,
      required this.requestor,
      required this.approver,
      required this.images,
      required this.requestImages});

  factory SmallPaper.fromJson(Map<String, dynamic> json) {
    return SmallPaper(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        plannedDatetime: parseDateTime(json['planned_datetime']),
        actualDatetime: json['actual_datetime'] != null
            ? parseDateTime(json['actual_datetime'])
                .subtract(const Duration(hours: 7))
            : null,
        createDate: parseDateTime(json['create_date']),
        transportationType: json['transportation_type'],
        state: json['state'],
        requestor: User.fromJson(json['requestor']),
        approver: User.fromJson(json['approver']),
        images: json['images'] != null ? List<int>.from(json['images']) : [],
        requestImages: json['request_images'] != null
            ? List<int>.from(json['request_images'])
            : []);
  }
}
