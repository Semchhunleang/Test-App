import 'package:umgkh_mobile/models/hr/survey/feedback_line.dart';
import 'package:umgkh_mobile/models/hr/survey/partner.dart';
import 'package:umgkh_mobile/models/hr/survey/survey.dart';

class SurveyUserInput {
  final Survey survey;
  final DateTime createDate;
  final String accessToken;
  final String? deadline;
  final Partner partner;
  final String emailReceiver;
  final String state;
  final String? link;
  final String? employeeName;
  final List<FeedbackLine> feedbackLines;

  SurveyUserInput({
    required this.survey,
    required this.createDate,
    required this.accessToken,
    required this.deadline,
    required this.partner,
    required this.emailReceiver,
    required this.state,
    required this.link,
    required this.feedbackLines,
     this.employeeName,
  });

  factory SurveyUserInput.fromJson(Map<String, dynamic> json) {
    return SurveyUserInput(
      survey: Survey.fromJson(json["survey"]),
      createDate: DateTime.parse(json["create_date"]),
      accessToken: json["access_token"],
      deadline: json["deadline"],
      partner: Partner.fromJson(json["partner"]),
      emailReceiver: json["email_receiver"],
      state: json["state"],
      link: json["link"],
      employeeName: json["employee_name"],
      feedbackLines: (json["feedback_lines"] as List)
          .map((e) => FeedbackLine.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "survey": survey.toJson(),
      "create_date": createDate.toIso8601String(),
      "access_token": accessToken,
      "deadline": deadline,
      "partner": partner.toJson(),
      "email_receiver": emailReceiver,
      "state": state,
      "link": link,
      "employee_name": employeeName,
      "feedback_lines": feedbackLines.map((e) => e.toJson()).toList(),
    };
  }
}
