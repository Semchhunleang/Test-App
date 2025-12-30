import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/models/hr/attendance/attendance.dart';
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/utils/format_float_hour.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/attendance_view_model.dart';
import 'package:umgkh_mobile/views/pages/image/widget/widget_network_image.dart';
import 'package:umgkh_mobile/views/pages/vision_detector/attendance/index.dart'; // Adjust path based on your file structure

void showAttendanceDetailsDialog(BuildContext context, Attendance attendance) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Attendance Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(),
              ListTile(
                title: Text(
                  DateFormat('dd MMMM yyyy').format(attendance.checkIn),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              // ============= CHECK IN =============
              ListTile(
                leading: AspectRatio(
                  aspectRatio: 1,
                  child: attendance.imageCheckIn != null
                      ? WidgetNetworkImage(
                          firstImg: Constants.attachmentById(
                              attendance.imageCheckIn ?? 0),
                          fullImage: Constants.attachmentById(
                              attendance.imageCheckIn ?? 0),
                        )
                      : Icon(
                          Icons.image_not_supported_outlined,
                          color: greyColor,
                          size: 30,
                        ),
                ),
                titleTextStyle:
                    titleStyle15.copyWith(fontWeight: FontWeight.bold),
                subtitleTextStyle: titleStyle14,
                title: Text(
                  'Morning Check-in: ${DateFormat('HH:mm').format(attendance.checkIn)}',
                ),
                subtitle: attendance.reasonCheckIn != null &&
                        !attendance.reasonCheckIn!.contains('(0, 0)')
                    ? Text(attendance.reasonCheckIn!)
                    : null,
              ),

              // ============= CHECK OUT MORNING =============
              if (attendance.checkOutMorning != null)
                ListTile(
                  leading: AspectRatio(
                    aspectRatio: 1,
                    child: attendance.imageCheckOutMorning != null
                        ? WidgetNetworkImage(
                            firstImg: Constants.attachmentById(
                                attendance.imageCheckOutMorning ?? 0),
                            fullImage: Constants.attachmentById(
                                attendance.imageCheckOutMorning ?? 0),
                          )
                        : Icon(
                            Icons.image_not_supported_outlined,
                            color: greyColor,
                            size: 30,
                          ),
                  ),
                  titleTextStyle:
                      titleStyle15.copyWith(fontWeight: FontWeight.bold),
                  subtitleTextStyle: titleStyle14,
                  title: Text(
                      'Morning Check-out: ${DateFormat('HH:mm').format(attendance.checkOutMorning!)}'),
                  subtitle: attendance.reasonCheckOutMorning != null &&
                          !attendance.reasonCheckOutMorning!.contains('(0, 0)')
                      ? Text(attendance.reasonCheckOutMorning!)
                      : null,
                ),

              // ============= CHECK IN AFTERNOON =============
              if (attendance.checkInAfternoon != null)
                ListTile(
                  leading: AspectRatio(
                    aspectRatio: 1,
                    child: attendance.imageCheckInAfternoon != null
                        ? WidgetNetworkImage(
                            firstImg: Constants.attachmentById(
                                attendance.imageCheckInAfternoon ?? 0),
                            fullImage: Constants.attachmentById(
                                attendance.imageCheckInAfternoon ?? 0),
                          )
                        : Icon(
                            Icons.image_not_supported_outlined,
                            color: greyColor,
                            size: 30,
                          ),
                  ),
                  titleTextStyle:
                      titleStyle15.copyWith(fontWeight: FontWeight.bold),
                  subtitleTextStyle: titleStyle14,
                  title: Text(
                      'Afternoon Check-in: ${DateFormat('HH:mm').format(attendance.checkInAfternoon!)}'),
                  subtitle: attendance.reasonCheckInAfternoon != null &&
                          !attendance.reasonCheckInAfternoon!.contains('(0, 0)')
                      ? Text(attendance.reasonCheckInAfternoon!)
                      : null,
                ),

              // ============= CHECK OUT =============
              if (attendance.checkOut != null)
                ListTile(
                  leading: AspectRatio(
                    aspectRatio: 1,
                    child: attendance.imageCheckOut != null
                        ? WidgetNetworkImage(
                            firstImg: Constants.attachmentById(
                                attendance.imageCheckOut ?? 0),
                            fullImage: Constants.attachmentById(
                                attendance.imageCheckOut ?? 0),
                          )
                        : Icon(
                            Icons.image_not_supported_outlined,
                            color: greyColor,
                            size: 30,
                          ),
                  ),
                  titleTextStyle:
                      titleStyle15.copyWith(fontWeight: FontWeight.bold),
                  subtitleTextStyle: titleStyle14,
                  title: Text(
                      'Work End: ${DateFormat('HH:mm').format(attendance.checkOut!)}'),
                  subtitle: attendance.reasonCheckOut != null &&
                          !attendance.reasonCheckOut!.contains('(0, 0)')
                      ? Text(attendance.reasonCheckOut!)
                      : null,
                ),

              // ============= LATE TYPE =============
              if (attendance.lateType != null)
                ListTile(
                  title: Text(
                      'Late Type: ${capitalizeFirstLetter(attendance.lateType!)}'),
                ),

              // ============= TOTAL HOURs =============
              if (attendance.workedHours > 0)
                ListTile(
                  title: Text(
                      'Working: ${formatWorkedHours(attendance.workedHours)}'
                      //'Worked Hours: ${attendance.workedHours.toStringAsFixed(2)} hours',
                      ),
                ),
              const SizedBox(height: 16),
              // Add more fields as needed
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(color: redColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> showOutsideAttendanceAreaDialog(
    BuildContext context, Future<void> Function() fetchData) async {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  await showDialog(
    context: context,
    builder: (context) {
      return Consumer<AttendanceViewModel>(
        builder: (context, viewModel, child) {
          return AlertDialog(
            title: const Text('Why are you not in your work area?'),
            content: Form(
              key: formKey,
              child: TextFormField(
                key: const Key("reason"),
                initialValue: viewModel.reason,
                decoration: const InputDecoration(labelText: "Reason"),
                keyboardType: TextInputType.text,
                onChanged: (String value) {
                  viewModel.setReason(value);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Reason is required';
                  }
                  if (value.replaceAll(RegExp(r"\s+"), "").isEmpty) {
                    return 'Reason is required';
                  }
                  if (value.replaceAll(RegExp(r"\s+"), "").length < 6) {
                    return 'Reason must be contain at least 6 characters.';
                  }
                  return null;
                },
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  final FormState? form = formKey.currentState;

                  if (!form!.validate()) {
                    // Show some error message if needed
                  } else {
                    // await Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => FaceDetectorView(
                    //       state: viewModel.latestState,
                    //     ),
                    //   ),
                    // );
                    // fetchData;
                    switch (viewModel.latestState) {
                      case 'ci':
                        await viewModel.checkIn(context, null);
                        break;
                      case 'com':
                        // if (isSaturday) {
                        // await attendanceViewModel.checkOutSaturday(context, imageFile);
                        // } else {
                        await viewModel.checkOutMorning(context, null);
                        // }
                        break;
                      case 'cia':
                        await viewModel.checkInAfternoon(context, null);
                        break;
                      case 'co':
                        await viewModel.checkOut(context, null);
                        break;
                      default:
                        return;
                    }
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    },
  );
}
