import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/hr/leave/leave.dart';
import 'package:umgkh_mobile/models/hr/leave/leave_type.dart';
import 'package:umgkh_mobile/models/hr/leave/public_holiday.dart';
import 'package:umgkh_mobile/services/api/hr/leave/holiday_service.dart';
import 'package:umgkh_mobile/services/api/hr/leave/leave_service.dart';
import 'package:umgkh_mobile/services/api/hr/leave/leave_type_service.dart';
import 'package:umgkh_mobile/utils/show_dialog.dart';
import 'package:umgkh_mobile/utils/utlis.dart';

class TakeLeaveFormViewModel extends ChangeNotifier {
  String? _requestDateFromPeriod = 'Morning';
  Leave? _leave;
  List<LeaveType>? _listLeaveType;
  List<PublicHoliday> _listHoliday = [];
  LeaveType? _selectedLeaveType;
  bool _isLoading = false;
  bool _isHalfDay = false;
  bool _isSaturday = false;
  bool _isReadOnly = false;
  double _duration = 1;
  ApiResponse _apiResponse = ApiResponse(statusCode: 0, data: []);

  final TextEditingController _startDateInput;
  final TextEditingController _endDateInput;
  final TextEditingController _descriptionCtrl = TextEditingController();
  TakeLeaveFormViewModel()
      : _startDateInput = TextEditingController(
            text: DateFormat('yyyy-MM-dd').format(DateTime.now())),
        _endDateInput = TextEditingController(
            text: DateFormat('yyyy-MM-dd').format(DateTime.now()));

  // Getters
  String? get requestDateFromPeriod => _requestDateFromPeriod;
  Leave? get leave => _leave;
  LeaveType? get selectedLeaveType => _selectedLeaveType;
  List<LeaveType>? get listLeaveType => _listLeaveType;
  List<PublicHoliday> get listHoliday => _listHoliday;
  bool get isLoading => _isLoading;
  bool get isHalfDay => _isHalfDay;
  bool get isSaturday => _isSaturday;
  bool get isReadOnly => _isReadOnly;
  double get duration => _duration;
  TextEditingController get startDateInput => _startDateInput;
  TextEditingController get endDateInput => _endDateInput;
  TextEditingController get descriptionCtrl => _descriptionCtrl;
  ApiResponse get apiResponse => _apiResponse;
  String get apiRequestDateFromPeriod =>
      _requestDateFromPeriod == "Morning" ? "am" : "pm";

  // Set default value
  Future<void> resetVariable() async {
    _requestDateFromPeriod = DateTime.now().hour < 11 ? 'Morning' : 'Afternoon';
    _leave = null;
    _listLeaveType = null;
    _selectedLeaveType = null;
    _isLoading = false;
    _isHalfDay = false;
    _isSaturday = false;
    _isReadOnly = false;
    _duration = 1;
    _startDateInput.text = TextEditingController(
            text: DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .text;
    _endDateInput.text = TextEditingController(
            text: DateFormat('yyyy-MM-dd').format(DateTime.now()))
        .text;
    _descriptionCtrl.text = '';
    await fetchLeaveTypes();
    _checkIfSaturday();
    notifyListeners();
  }

  // Set date and update duration
  Future<void> setRequestDateFromPeriod(String? value) async {
    _requestDateFromPeriod = value;
    notifyListeners();
  }

  // Set date and update duration
  Future<void> setDate(String formattedDate, bool isStart) async {
    _isLoading = true;
    setSelectedLeaveType(null);
    if (_isHalfDay) {
      _setSameDate(formattedDate);
      _updateDurationForHalfDay();
      _checkIfSaturday();
    } else {
      _updateDate(isStart, formattedDate);
      _updateDurationForFullDay();
      _checkIfSaturday();
    }

    await fetchLeaveTypes();
    _isLoading = false;
    notifyListeners();
  }

  // Set reason
  Future<void> setSelectedLeaveType(LeaveType? selected) async {
    _selectedLeaveType = selected;
    notifyListeners();
  }

  // Set reason
  Future<void> setReason(String reason) async {
    _descriptionCtrl.text = reason;
    notifyListeners();
  }

  // Toggle half-day status and update duration
  Future<void> toggleIsHalfDay() async {
    _isHalfDay = !_isHalfDay;
    fetchLeaveTypes();
    _updateDate(false, startDateInput.text);
    _updateDuration();
    notifyListeners();
  }

  // Update duration based on half-day/full-day status
  void _updateDuration() {
    if (_isHalfDay) {
      _updateDurationForHalfDay();
    } else {
      _updateDurationForFullDay();
    }
  }

  // Update duration for half-day leave
  void _updateDurationForHalfDay() async {
    _duration = _isSaturdayLeave() ? 1 : 0.5;
    _isSaturday = _isSaturdayLeave();

    // await fetchLeaveTypes();
    notifyListeners();
  }

  // Update duration for full-day leave
  void _updateDurationForFullDay() async {
    _duration = _calculateDaysBetween(
      DateTime.parse(_startDateInput.text),
      DateTime.parse(_endDateInput.text),
    );
    // await fetchLeaveTypes();
    notifyListeners();
  }

  // Calculate number of days between two dates
  // double _calculateDaysBetween(DateTime from, DateTime to) {
  //   from = DateTime(from.year, from.month, from.day);
  //   to = DateTime(to.year, to.month, to.day);
  //   return (to.difference(from).inDays + 1).toDouble();
  // }

  double _calculateDaysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    double totalDays = (to.difference(from).inDays + 1);
    int sundays = ((totalDays + from.weekday - 1) ~/ 7); // on Sunday -> skip
    return (totalDays - sundays - checkHolidays(from, to));
  }

  double checkHolidays(DateTime from, DateTime to) {
    double holidayCounts = 0;
    for (var e in listHoliday) {
      for (DateTime holiday = e.dateFrom;
          !holiday.isAfter(e.dateTo);
          holiday = holiday.add(const Duration(days: 1))) {
        if (!holiday.isBefore(from) && !holiday.isAfter(to)) {
          holidayCounts++;
          if (holiday.weekday == 7) holidayCounts--; // if holiday on Sunday
        }
      }
    }
    return holidayCounts;
  }

  // Set start and end dates to the same date
  void _setSameDate(String formattedDate) {
    _startDateInput.text = formattedDate;
    _endDateInput.text = formattedDate;
  }

  // Update the date values
  void _updateDate(bool isStart, String formattedDate) {
    if (isStart) {
      _startDateInput.text = formattedDate;
    } else {
      _endDateInput.text = formattedDate;
    }
    _adjustEndDateIfNecessary();
  }

  // Fetch leave types from API
  Future<void> fetchLeaveTypes() async {
    _selectedLeaveType = null;
    _isLoading = true;
    final response = await LeaveTypeAPIService().fetchLeaveType(
      _startDateInput.text,
      _endDateInput.text,
      _isHalfDay,
    );
    _apiResponse = response;
    if (response.error == null) {
      _listLeaveType = response.data!;
    } else {
      _listLeaveType = null;
    }
    _isLoading = false;
    notifyListeners();
  }

  // Ensure end date is after or equal to start date
  void _adjustEndDateIfNecessary() {
    DateTime startDate = DateTime.parse(_startDateInput.text);
    DateTime endDate = DateTime.parse(_endDateInput.text);

    if (endDate.isBefore(startDate)) {
      _endDateInput.text = _startDateInput.text;
    }
  }

  // Check if the leave is on a Saturday
  bool _isSaturdayLeave() {
    return DateFormat('EEEE').format(DateTime.parse(_startDateInput.text)) ==
        "Saturday";
  }

  // Update isSaturday flag and adjust duration if needed
  void _checkIfSaturday() {
    _isSaturday = _isSaturdayLeave();
    // && _startDateInput.text == _endDateInput.text;
    if (_isSaturday) {
      if (_isHalfDay == true) {
        toggleIsHalfDay();
      }
      if (_startDateInput.text == _endDateInput.text) {
        _duration = 1;
      }
    }
  }

  Future<void> insert(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    final response = await LeaveAPIService().insert(
        _descriptionCtrl.text,
        _selectedLeaveType!.id,
        _startDateInput.text,
        _endDateInput.text,
        apiRequestDateFromPeriod,
        _isHalfDay);
    if (context.mounted) {
      await showResultDialog(context, response.error ?? response.message!,
          isDone: true, isBackToList: true);
    }
    _isLoading = false;
    notifyListeners();
  }

  // Fetch publich holiday from API
  Future<void> fetchPublicHoliday() async {
    _listHoliday = [];
    final response = await HolidayAPIService().fetchPuclicHoliday(
        DateTime.parse(_startDateInput.text).year.toString(),
        DateTime.parse(_endDateInput.text).year.toString());
    _apiResponse = response;
    (response.error == null)
        ? _listHoliday = response.data!
        : _listHoliday = [];
    notifyListeners();
  }

  void setInfo(Leave data) {
    _isReadOnly = true;
    startDateInput.text = formatYYYYMMDD(data.requestDateFrom);
    endDateInput.text = formatYYYYMMDD(data.requestDateTo);
    _requestDateFromPeriod =
        data.requestDateFromPeriod == "am" ? "Morning" : "Afternoon";
    _isHalfDay = data.requestUnitHalf;
    _duration = data.numberOfDays;
    descriptionCtrl.text = data.description;
  }
}
