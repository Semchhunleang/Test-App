import 'package:umgkh_mobile/utils/utlis.dart';

class NotificationList {
  int id;
  DateTime createDate;
  String token;
  String title;
  String message;
  String? page;
  String? url;
  bool isRead;

  NotificationList({
    required this.id,
    required this.createDate,
    required this.token,
    required this.title,
    required this.message,
    this.page,
    this.url,
    required this.isRead,
  });

  factory NotificationList.fromJson(Map<String, dynamic> json) {
    return NotificationList(
      id: json['id'],
      createDate: parseDateTime(json['create_date']),
      token: json['token'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      page: json['page'],
      url: json['url'],
      isRead: json['is_read'] ?? false,
    );
  }
}
