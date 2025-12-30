import 'row.dart';

class RowData {
  final String? message;
  final List<Rows>? rows;

  const RowData({this.message, this.rows});

  RowData.fromJson(Map<String, dynamic> json)
      : message = json['id'] ?? '',
        rows = json['data']?.map((row) => Rows.fromJson(row),)?.toList();
}
