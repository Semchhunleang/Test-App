import 'package:umgkh_mobile/models/log_note/log_note_employee.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class LogNote {
  int id;
  DateTime date;
  String model;
  int resId;
  int authorId;
  String authorName;
  String body;
  LogNoteEmployee employee;
  List<int> images;

  LogNote({
    required this.id,
    required this.date,
    required this.model,
    required this.resId,
    required this.authorId,
    required this.authorName,
    required this.body,
    required this.employee,
    required this.images,
  });

  factory LogNote.fromJson(Map<String, dynamic> json) {
    return LogNote(
      id: json['id'],
      date: parseDateTime(json['date']),
      model: json['model'],
      resId: json['res_id'],
      authorId: json['author_id'],
      authorName: json['author_name'],
      body: json['body'],
      employee: LogNoteEmployee.fromJson(json['employee']),
      images: json['images'] != null ? List<int>.from(json['images']) : [],
    );
  }
}
