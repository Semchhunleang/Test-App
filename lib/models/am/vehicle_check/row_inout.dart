import 'question.dart';

class RowInout {
  final int? id;
  final int? sequence;
  final bool? goodCheckIn;
  final bool? badCheckIn;
  final bool? nonCheckIn;
  final String? remarkIn;
  final bool? goodCheckOut;
  final bool? badCheckOut;
  final bool? nonCheckOut;
  final String? remarkOut;
  final Question? question;

  RowInout(
      {this.id,
      this.sequence,
      this.goodCheckIn,
      this.badCheckIn,
      this.nonCheckIn,
      this.remarkIn,
      this.goodCheckOut,
      this.badCheckOut,
      this.nonCheckOut,
      this.remarkOut,
      this.question});

  RowInout.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? int,
        sequence = json['sequence'] ?? int,
        goodCheckIn = json['good_check_in'] ?? false,
        badCheckIn = json['bad_check_in'] ?? false,
        nonCheckIn = json['non_check_in'] ?? false,
        remarkIn = json['remark_in'] ?? "",
        goodCheckOut = json['good_check_out'] ?? false,
        badCheckOut = json['bad_check_out'] ?? false,
        nonCheckOut = json['non_check_out'] ?? false,
        remarkOut = json['remark_out'] ?? "",
        question = json['question'] != null
            ? Question.fromJson(json['question'])
            : null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['sequence'] = sequence;
    data['good_check_in'] = goodCheckIn;
    data['bad_check_in'] = badCheckIn;
    data['non_check_in'] = nonCheckIn;
    data['remark_in'] = remarkIn;
    data['good_check_out'] = goodCheckOut;
    data['bad_check_out'] = badCheckOut;
    data['non_check_out'] = nonCheckOut;
    data['remark_out'] = remarkOut;
    if (question != null) {
      data['question'] = question!.toJson();
    }
    return data;
  }
}
