import 'package:umgkh_mobile/models/crm/activity/activity_type.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class Activity {
  int id;
  DateTime date;
  String? body;
  int resId;
  ActivityType? type;
  List<int> images;

  Activity(
      {required this.id,
      required this.date,
      this.body,
      this.resId = 0,
      this.type,
      required this.images});
  Activity.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        date = parseDateTime(json['date']),
        body = json['body'],
        resId = json['res_id'] ?? 0,
        type =
            json['type'] != null ? ActivityType.fromJson(json['type']) : null,
        images = json['images'] != null ? List<int>.from(json['images']) : [];
}
