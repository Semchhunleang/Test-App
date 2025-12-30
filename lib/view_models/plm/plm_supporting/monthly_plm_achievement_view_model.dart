import 'package:flutter/material.dart';
import 'package:umgkh_mobile/models/base/custom_ui/api_response.dart';
import 'package:umgkh_mobile/models/base/user/user.dart';
import 'package:umgkh_mobile/models/plm/plm_supporting/plm_achievement/detail.dart';
import 'package:umgkh_mobile/models/plm/plm_supporting/plm_achievement/plm_achievement.dart';
import 'package:umgkh_mobile/services/api/plm/plm_supporting/plm_supporting_service.dart';

class MonthlyPlmAchievementViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  User selectEmployee = User.defaultUser(id: 0, name: 'Select employee');
  String selectedMonth = "01";
  String selectedYear = "2022";

  //PLM Achievement
  List<PLMAchievement> _listAchievementData = [];
  List<PLMAchievement> _showedAchievementData = [];
  List<PLMAchievement> get listAchievementData => _listAchievementData;
  List<PLMAchievement> get showedAchievementData => _showedAchievementData;
  ApiResponse _apiResponse = ApiResponse(statusCode: 0, data: []);
  ApiResponse get apiResponse => _apiResponse;
  int departmentId = 0;

  MonthlyPlmAchievementViewModel() {
    final now = DateTime.now();
    selectedMonth = now.month.toString().padLeft(2, "0");
    selectedYear = now.year.toString();
  }

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  void onChangeEmployee(dynamic v) => notify(v, (val) {
        selectEmployee = val;
        _applyFilters();
      });

  void setDefaultEmployee(User user, {bool isDh = false}) {
    if (isDh) {
      selectEmployee = User.defaultUser(id: 0, name: "All Employees");
      departmentId = user.department?.id ?? 0;
    } else {
      selectEmployee = user;
    }

    notifyListeners();
  }

  void onChangedMonth(BuildContext context, String v) => notify(v, (val) {
        selectedMonth = val;
        fetchMonthlyPLMAchievement();
      });
  void onChangedYear(BuildContext context, String v) => notify(v, (val) {
        selectedYear = val;
        fetchMonthlyPLMAchievement();
      });

  bool shouldLockDetail(Detail detail, {List<Detail>? allDetails}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (detail.date == null || detail.date!.isEmpty) return true;

    final parsedDate = DateTime.tryParse(detail.date!);
    if (parsedDate == null) return true;

    final dateOnly =
        DateTime(parsedDate.year, parsedDate.month, parsedDate.day);

    if (dateOnly.isAfter(today)) return true;

    if (detail.isVisualBoard) return true;

    final state = detail.state.toLowerCase();

    if (state == "holiday" || state == "sunday" || state == "leave")
      return true;

    // Unlock if today is the same date and state is 'not' or 'achieved'
    if (dateOnly.isAtSameMomentAs(today) &&
        (state == "not" || state == "achieved")) {
      return false;
    }

    // --- Handle unlocking the day before a holiday/Sunday chain ---
    if (allDetails != null && allDetails.isNotEmpty) {
      // Filter only holidays or Sundays before today (ignore leave)
      List<Detail> pastHolidaysOrSundays = allDetails.where((d) {
        if (d.date == null || d.date!.isEmpty) return false;
        final dDate = DateTime.tryParse(d.date!)!;
        final dState = d.state.toLowerCase();
        return (dState == "holiday" || dState == "sunday") &&
            dDate.isBefore(today);
      }).toList();

      if (pastHolidaysOrSundays.isNotEmpty) {
        pastHolidaysOrSundays.sort((a, b) {
          final aDate = DateTime.parse(a.date!);
          final bDate = DateTime.parse(b.date!);
          return bDate.compareTo(aDate);
        });

        final lastChainEnd = DateTime.parse(pastHolidaysOrSundays.first.date!);
        DateTime lastChainStart = lastChainEnd;
        for (var d in pastHolidaysOrSundays.skip(1)) {
          final dDate = DateTime.parse(d.date!);
          if (lastChainStart.difference(dDate).inDays == 1) {
            lastChainStart = dDate;
          } else {
            break;
          }
        }

        final dayBeforeChain = lastChainStart.subtract(const Duration(days: 1));
        final nextWorkingDayAfterChain =
            lastChainEnd.add(const Duration(days: 1));

        // Unlock only if today is immediately after the chain
        if (dateOnly.isAtSameMomentAs(dayBeforeChain) &&
            today.isAtSameMomentAs(nextWorkingDayAfterChain)) {
          return false;
        }
      }
    }

    return true;
  }

  Future<void> fetchMonthlyPLMAchievement() async {
    _isLoading = true;
    final response = await PLMSupportingAPIService()
        .fetchMonthlyPLMAchievement(selectedMonth, selectedYear);
    _apiResponse = response;
    if (response.error != null) {
      _errorMessage = response.error;
      debugPrint("_errorMessage: $_errorMessage");
    } else if (response.data != null) {
      _listAchievementData = response.data!;

      // Apply locking logic
      // --- DAILY LINES ---
      for (final plmAchievement in _listAchievementData) {
        if (plmAchievement.dailyLines != null) {
          for (final daily in plmAchievement.dailyLines!) {
            if (daily.detail != null) {
              for (final detail in daily.detail!) {
                detail.isLocked =
                    shouldLockDetail(detail, allDetails: daily.detail);
              }
            }
          }
        }

        // // --- WEEKLY LINES ---
        // if (plmAchievement.weeklyLines != null) {
        //   final now = DateTime.now();
        //   final today = DateTime(now.year, now.month, now.day);

        //   for (final weekly in plmAchievement.weeklyLines!) {
        //     if (weekly.detail != null) {
        //       for (final detail in weekly.detail!) {
        //         if (detail.isVisualBoard) {
        //           detail.isLocked = true;
        //         } else if (detail.date != null && detail.date!.isNotEmpty) {
        //           final parsedDate = DateTime.tryParse(detail.date!);
        //           if (parsedDate != null) {
        //             final dateOnly = DateTime(
        //                 parsedDate.year, parsedDate.month, parsedDate.day);

        //             // Lock past dates, unlock today/future
        //             detail.isLocked = dateOnly.isBefore(today);
        //           } else {
        //             detail.isLocked = true;
        //           }
        //         } else {
        //           detail.isLocked = true;
        //         }
        //       }
        //     }
        //   }
        // }
        // --- WEEKLY LINES ---
        if (plmAchievement.weeklyLines != null) {
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);

          // Start of week = Monday, End of week = Sunday
          final weekStart = today.subtract(Duration(days: today.weekday - 1));
          final weekEnd = weekStart.add(const Duration(days: 6));

          for (final weekly in plmAchievement.weeklyLines!) {
            if (weekly.detail != null) {
              for (final detail in weekly.detail!) {
                // Visual board always locked
                if (detail.isVisualBoard) {
                  detail.isLocked = true;
                  continue;
                }

                // If date missing or unparsable, lock
                if (detail.date == null || detail.date!.isEmpty) {
                  detail.isLocked = true;
                  continue;
                }

                final parsedDate = DateTime.tryParse(detail.date!);
                if (parsedDate == null) {
                  detail.isLocked = true;
                  continue;
                }

                final dateOnly =
                    DateTime(parsedDate.year, parsedDate.month, parsedDate.day);

                // Optional: lock if state is holiday/leave/sunday (uncomment if desired)
                final state = detail.state.toLowerCase();
                if (state == 'holiday' ||
                    state == 'leave' ||
                    state == 'sunday') {
                  detail.isLocked = true;
                  continue;
                }

                // Unlock only if date falls inside THIS week (Monday..Sunday)
                if (dateOnly.isBefore(weekStart) || dateOnly.isAfter(weekEnd)) {
                  detail.isLocked = true; // outside this week -> lock
                } else {
                  detail.isLocked = false; // inside this week -> unlock
                }
              }
            }
          }
        }

        // --- MONTHLY LINES ---
        if (plmAchievement.monthlyLines != null) {
          final now = DateTime.now();
          final currentMonth = now.month.toString().padLeft(2, "0");
          final currentYear = now.year.toString();

          final isCurrentMonth = plmAchievement.month == currentMonth &&
              plmAchievement.year == currentYear;

          for (final line in plmAchievement.monthlyLines!) {
            if (line.isVisualBoard) {
              line.isLocked = true;
            } else if (!isCurrentMonth) {
              line.isLocked = true;
            } else {
              line.isLocked = false;
            }
          }
        }
      }

      _applyFilters();
    }

    _isLoading = false;
    notifyListeners();
  }

  void _applyFilters() {
    _showedAchievementData = List.from(_listAchievementData);

    // Filter by employee
    if (selectEmployee.id != 0) {
      _showedAchievementData = _showedAchievementData
          .where((e) => e.employee.id == selectEmployee.id)
          .toList();
    }

    // Filter by year
    if (selectedYear.isNotEmpty) {
      _showedAchievementData = _showedAchievementData
          .where((e) => e.year.trim() == selectedYear.trim())
          .toList();
    }

    // Filter by month
    if (selectedMonth.isNotEmpty) {
      _showedAchievementData = _showedAchievementData.where((e) {
        final month = e.month;
        final monthSelect = selectedMonth;
        return month == monthSelect;
      }).toList();
    }

    notifyListeners();
  }

  void onClearFilter(User user, {bool isDh = false}) {
    if (isDh) {
      selectEmployee = User.defaultUser(id: 0, name: "All Employees");
      departmentId = user.department?.id ?? 0;
    } else {
      selectEmployee = user;
    }
    final now = DateTime.now();
    selectedMonth = now.month.toString().padLeft(2, "0");
    selectedYear = now.year.toString();
  }
}
