import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/attendance_view_model.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart'; // Import for date formatting

class FilterAttendance extends StatefulWidget {
  // final Function(DateTime, DateTime) onFilterApplied;

  const FilterAttendance({
    Key? key,
  }) : super(key: key);

  @override
  State<FilterAttendance> createState() => _FilterAttendanceState();
}

class _FilterAttendanceState extends State<FilterAttendance> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceViewModel>(
        builder: (context, attendanceViewModel, _) {
      return Card(
        surfaceTintColor: Colors.white,
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
        elevation: 4,
        shadowColor: theme().primaryColor,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => _selectDate(context, true),
                    child: Text(
                      'Start Date: ${DateFormat('dd/MM/yyyy').format(attendanceViewModel.startDate)}',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _selectDate(context, false),
                    child: Text(
                      'End Date: ${DateFormat('dd/MM/yyyy').format(attendanceViewModel.endDate)}',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
              Consumer<ProfileViewModel>(
                  builder: (context, profileViewModel, _) {
                return Text(
                  profileViewModel.user.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                );
              }),
            ],
          ),
        ),
      );
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? Provider.of<AttendanceViewModel>(context, listen: false).startDate
          : Provider.of<AttendanceViewModel>(context, listen: false).endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        Provider.of<AttendanceViewModel>(context, listen: false)
            .setDate(picked, isStartDate);
      });
    }
  }
}
