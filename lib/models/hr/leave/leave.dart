import 'package:umgkh_mobile/models/hr/leave/leave_type.dart';
import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
// import 'package:umgkh_mobile/utils/utlis.dart';

class Leave {
  final int id;
  final User user;
  final LeaveType leaveType;
  final DateTime requestDateFrom;
  final DateTime requestDateTo;
  final DateTime dateFrom;
  final DateTime dateTo;
  final double numberOfDays;
  final bool requestUnitHalf;
  final String description;
  final String state;
  final String? requestDateFromPeriod;

  Leave({
    required this.id,
    required this.user,
    required this.leaveType,
    required this.requestDateFrom,
    required this.requestDateTo,
    required this.dateFrom,
    required this.dateTo,
    required this.numberOfDays,
    required this.requestUnitHalf,
    required this.description,
    required this.state,
     this.requestDateFromPeriod,
  });

  factory Leave.fromJson(Map<String, dynamic> json) {
    User user = User.fromJson(json['employee']);
    LeaveType leave = LeaveType.fromJson(json['leave_type']);
    
    return Leave(
      id: json['id'],
      user: user,
      leaveType: leave,
      requestDateFrom: parseDateTime(json['request_date_from']),
      requestDateTo: parseDateTime(json['request_date_to']),
      dateTo: parseDateTime(json['date_to']),
      dateFrom: parseDateTime(json['date_from']),
      numberOfDays: json['number_of_days'].toDouble(),
      requestUnitHalf: json['request_unit_half'],
      description: json['private_name'] ?? '',
      state: json['state'],
      requestDateFromPeriod: json['request_date_from_period'],
    );
  }
}
