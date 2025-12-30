import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/main.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/static_state.dart';
import 'package:umgkh_mobile/view_models/login_view_model.dart';
import 'package:umgkh_mobile/widgets/dialog.dart';

const String nullDate = '00-00-0000';
const String nullStr = 'n/a';
const num nullNum = 0;

List<File> convertPathsToFiles(List<String> imagePaths) {
  return imagePaths.map((path) => File(path)).toList();
}

File convertPathsToFile(String imagePath) {
  return File(imagePath);
}

File convertPathsToFileSign(dynamic path) {
  if (path is String) {
    path = path.replaceAll('"', '');
    return File(path);
  }
  return File('');
}

ScrollPhysics kBounce = const BouncingScrollPhysics();
ScrollPhysics neverScroll = const NeverScrollableScrollPhysics();
void killDialog(BuildContext context) {
  if (Navigator.canPop(context)) Navigator.pop(context);
}

String formatDate(DateTime date) =>
    date == nullDt ? '' : DateFormat('dd MMMM yyyy').format(date);

String formatYear(DateTime date) => DateFormat('yyyy').format(date);

String formatMonth(DateTime date) => DateFormat('MMMM').format(date);

// String formattedDate(String date) =>
//     DateFormat('dd MMMM yyyy').format(DateTime.parse(date));

String toApiformatDTHM(DateTime date) =>
    DateFormat('yyyy-MM-dd HH:mm:ss').format(date);

String toApiformatDateTime(DateTime date) =>
    DateFormat('yyyy-MM-dd HH:mm:ss').format(date);

String toApiSubtract7Hours(String date) => toApiformatDTHM(
      parseConvertDT(date).subtract(
        const Duration(hours: 7),
      ),
    );

String toApiSubtract7HoursNoParseDt(DateTime date) => toApiformatDTHM(
      date.subtract(
        const Duration(hours: 7),
      ),
    );

String toApiAdd7HoursNoParseDt(DateTime date) => toApiformatDTHM(
      date.add(
        const Duration(hours: 7),
      ),
    );

String toApiformatDate(String? date) =>
    DateFormat('yyyy-MM-dd').format(DateTime.parse(date ?? '0000-00-00'));

String formatDecimal(num? value) {
  num v = value ?? 0;
  return v.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},");
}

DateTime nullDt = DateTime(1000, 1, 1, 0, 0, 0);

DateTime parseDateTime(String? dateStr) {
  if (dateStr == null) return nullDt;
  return DateTime.parse(dateStr).toLocal();
}

DateTime? parseDateTimeNoUtc(String? dateStr) {
  if (dateStr == null) return null;
  DateTime dateTime = DateTime.parse(dateStr).toLocal();
  dateTime.toUtc().toIso8601String();
  return dateTime;
}

DateTime parseDateTimeFormat(String dateTimeString) {
  final DateFormat format = DateFormat("dd MMM yyyy HH:mm");
  return format.parse(dateTimeString);
}

DateTime parseDateFormat(String dateTimeString) {
  final DateFormat format = DateFormat("dd MMM yyyy");
  return format.parse(dateTimeString);
}

String? rollbackParseDateTime(DateTime? dateTime) {
  if (dateTime == null) return null; // or return a default string
  return dateTime
      .toUtc()
      .toIso8601String(); // Convert to UTC and return as ISO 8601 string
}

String? rollbackParseDateTimeNoUtc(DateTime? dateTime) {
  if (dateTime == null) return null;
  return dateTime.toIso8601String();
}

String formatYYYYMMDD(DateTime date) =>
    date == nullDt ? '' : DateFormat('yyyy-MM-dd').format(date);

String formatDDMMMMYYYY(DateTime date) =>
    date == nullDt ? '' : DateFormat('dd MMMM yyyy').format(date);

String formatDMMMMYYYY(DateTime date) => DateFormat('d MMMM yyyy').format(date);

String formatDDMMYYYYHHMM(DateTime date) =>
    DateFormat('dd-MM-yyyy HH:mm').format(date);

String formatReadableDT(DateTime date) =>
    date == nullDt ? '' : DateFormat('dd MMM yyyy HH:mm').format(date);
String formatReadableDate(DateTime date) =>
    date == nullDt ? '' : DateFormat('dd MMM yyyy').format(date);

DateTime parseConvertDT(String date) =>
    DateFormat('dd MMM yyyy HH:mm').parse(date);

String formatDateTime(DateTime date) =>
    DateFormat('dd-MM-yyyy HH:mm:ss').format(date);

String formatMonthName(int monthNumber) {
  return DateFormat('MMMM').format(DateTime(0, monthNumber));
}

String capitalizeFirstLetter(String text) {
  if (text.isEmpty) {
    return text;
  }
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}

Color getStateColor(String value) {
  switch (value) {
    case 'open':
      return Colors.blue;
    case 'send_to_shop':
      return Colors.purple;
    case 'close':
      return Colors.green;
    case 'medium':
      return Colors.amber;
    case 'heavy':
      return Colors.red;
    default:
      return Colors.black;
  }
}

Color stateColor(String? data) {
  Color color = draftColor;
  switch (data) {
    case draft || open:
      color = draftColor;
      break;
    case approveDH || approveHR || approve || done || ictClose:
      color = approvedColor;
      break;
    case claim:
      color = claimColor;
      break;
    case reject || refuse:
      color = rejectedColor;
      break;
    case acknowledge:
      color = primaryColor;
      break;
    case onProgress || sendToShop:
      color = onProgressColor;
      break;
    case confirm:
      color = primaryColor;
      break;
    case accept:
      color = approvedColor;
      break;
    case submit || wait || waiting:
      color = submitColor;
      break;
    case prepared:
      color = submitColor;
      break;

    default:
      color = draftColor;
  }
  return color;
}

Color scheduleTruckStateColor(String? data) {
  Color color = draftColor;
  switch (data) {
    case draft:
      color = draftColor;
      break;
    case submit:
      color = submitColor;
      break;
    case approve:
      color = claimColor;
      break;
    case done:
      color = approvedColor;
      break;
    case reject:
      color = rejectedColor;
      break;

    default:
      color = draftColor;
  }
  return color;
}

String stateTitleA4(String? data) {
  String title = 'Draft';
  switch (data) {
    case draft:
      title = 'Draft';
      break;
    case submit:
      title = 'Submit';
      break;
    case acknowledge:
      title = 'Acknowledged';
      break;
    case approve:
      title = 'Approved';
      break;
    case done:
      title = 'Done';
      break;
    case reject:
      title = 'Rejected';
      break;
    case onProgress:
      title = 'On Progress';
      break;
    case confirm:
      title = 'Confirm';
      break;

    default:
      title = '$data';
  }
  return title;
}

String stateTitleOvertime(String? data) {
  String title = 'Draft';
  switch (data) {
    case draft:
      title = 'Draft';
      break;
    case submit:
      title = 'Submit';
      break;
    case approveDH:
      title = 'Approved DH';
      break;
    case approveHR:
      title = 'Approve HR';
      break;
    case approve:
      title = 'Approved';
      break;
    case claim:
      title = 'Claimed';
      break;
    case reject:
      title = 'Rejected';
      break;
    case acknowledge:
      title = 'Acknowledged';
      break;
    default:
      title = '$data';
  }
  return title;
}

String stateTitleTsb(String? data) {
  String title = 'Draft';
  switch (data) {
    case draft:
      title = 'Draft';
      break;
    case prepared:
      title = 'Prepared';
      break;
    case approve:
      title = 'Approved';
      break;
    case reject:
      title = 'Rejected';
      break;
    case acknowledge:
      title = 'Acknowledged';
      break;
    default:
      title = '$data';
  }
  return title;
}

String trimStr(String v) => v.replaceAll(RegExp(r'\s+'), '');

bool isNum(String input) => double.tryParse(trimStr(input)) != null;

//DispatchFrom
String titleDispatchFrom(String? data) {
  var title = "";
  if (data == office) {
    title = 'Office';
  } else if (data == guestHouse) {
    title = 'Guest House';
  } else if (data == jobSite) {
    title = 'Job Site';
  } else {
    title = '';
  }
  return title;
}

String stateTitleLeave(String? data) {
  var title = "";
  if (data == draft) {
    title = 'To Submit';
  } else if (data == confirm) {
    title = 'To Approve';
  } else if (data == refuse) {
    title = 'Refused';
  } else {
    title = data == 'validate1' ? 'Second Approval' : 'Approved';
  }
  return title;
}

String stateTitle(String? data) {
  switch (data) {
    case wait || waiting:
      return 'Waiting';
    case accept:
      return 'Accepted';
    case reject:
      return 'Rejected';
    case open:
      return 'Open';
    case close || ictClose:
      return 'Closed';
    case done:
      return 'Done';
    case sendToShop:
      return 'Send To Shop';
    default:
      return 'draft';
  }
}

String stageFSTitle(String? data) {
  switch (data) {
    case draft:
      return 'Draft';
    case unscheduled:
      return 'Unscheduled';
    case schedule:
      return 'Schedule';
    case inProgress:
      return 'In Progress';
    case reschedule:
      return 'Reschedule';
    case waitingCusMec:
      return 'Waiting Customer/Mechanic';
    case waitingPart:
      return 'Waiting Part';
    case cancel:
      return 'Cancel';
    case jobFinish:
      return 'Job Finish';
    case evaluate:
      return 'Evaluate';
    case close:
      return 'Close';
    default:
      return 'draft';
  }
}

String titleServiceType(String? data) {
  switch (data) {
    case fieldService:
      return 'Field Service';
    case workshop:
      return 'Workshop';
    default:
      return 'Field Service';
  }
}

String ifNullStr(String? str) =>
    str == null || str == 'null' || str == "" ? 'n/a' : str;

String ifNullModel<T>(T? model, String Function(T) getProperty) =>
    model != null ? getProperty(model) : 'n/a';

// perfome log out *API: middleware/auth.js/verifyToken
void checkAndLogoutOnAuthError(String msg) {
  final context = MyApp.navigatorKey.currentContext;
  if (context != null) {
    // force log out employee resign
    if (msg.contains('User is not active')) {
      () async {
        final loginViewModel =
            Provider.of<LoginViewModel>(context, listen: false);

        await loginViewModel.logout(context);

        if (!context.mounted) return; // ✅ guard against disposed context

        showCustomConfirmDialog(
          context,
          hasActionCancel: false,
          title: 'Access Terminated!',
          message:
              'Sorry, your Nenam is no longer active anymore due to employment termination!',
          confirmTitle: 'Understood',
        );
      }();
    } else if (msg.contains('Token has expired')
        // ||
        // msg.contains('Invalid token') ||
        // msg.contains('No token provided')
        ) {
      debugPrint(msg);
      showCustomConfirmDialog(context,
          barrierDismissible: false,
          hasActionCancel: false,
          title: 'Log Out Required!',
          message: '$msg \nYou need to log out to restart Nenam immediately!',
          confirmTitle: 'Log Out', onConfirm: () async {
        showLoadingDialog(context);
        await Provider.of<LoginViewModel>(context, listen: false)
            .logout(context);
      });
    }
  }
}

String getResponseErrorMessage(Response response) {
  String errorMessage = 'An error occurred';
  try {
    final responseBody = json.decode(response.body);
    if (responseBody is Map<String, dynamic> &&
        responseBody.containsKey('error')) {
      errorMessage = responseBody['error'];
    }
    checkAndLogoutOnAuthError(errorMessage); // check user & token
  } catch (e) {
    errorMessage = 'Failed to parse error message';
  }
  return errorMessage;
}

String getResponseMessage(Response response) {
  String message = 'Success';
  try {
    final responseBody = json.decode(response.body);
    if (responseBody is Map<String, dynamic> &&
        responseBody.containsKey('message')) {
      message = responseBody['message'];
    }
  } catch (e) {
    message = 'Success';
  }
  return message;
}

String getCatchExceptionMessage(Object e) {
  String message = "";
  if (e is SocketException) {
    message = 'Network connection failed: ${e.message}';
  } else if (e is HttpException) {
    message = 'HTTP error occurred: ${e.message}';
  } else {
    message = 'An error occurred: Something went wrong.';
  }
  return message;
}

bool toFilter(String source, String text) {
  return source.toLowerCase().contains(text.toLowerCase());
}

String convertTextToHtml(String text) =>
    "<p>${text.replaceAll('\n', '<br>')}</p>";

String convertHtmlToText(String text) => text
    .replaceAll(RegExp(r'<br\s*/?>|</p>', caseSensitive: false), '\n')
    .replaceAll(RegExp(r'<[^>]+>'), '')
    .trim();

String toTitleCase(String str) {
  return str
      .split(' ')
      .map((word) => word.isNotEmpty
          ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
          : '')
      .join(' ');
}

String timeAgo(DateTime date) {
  DateTime now = DateTime.now();
  Duration difference = now.difference(date);

  if (difference.inSeconds < 60) {
    return '${difference.inSeconds}sec ago';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}min ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}hr ago';
  } else if (difference.inDays < 30) {
    return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
  } else {
    int years = now.year - date.year;
    int months = now.month - date.month;
    if (months < 0) {
      years--;
      months += 12;
    }
    if (years > 0) {
      return '$years year${years == 1 ? '' : 's'} ago';
    } else {
      return '$months month${months == 1 ? '' : 's'} ago';
    }
  }
}

String titleLeaveStatus(String state) {
  switch (state) {
    case draft:
      return 'To Submit';
    case confirm:
      return 'To Approve';
    case refuse:
      return 'Refused';
    case validate1:
      return 'Second Approval';
    default:
      return 'Approved';
  }
}

IconData iconLeaveStatus(String state) {
  switch (state) {
    case draft:
      return Icons.error_rounded;
    case confirm:
      return Icons.error_rounded;
    case refuse:
      return Icons.cancel_rounded;
    case validate1:
      return Icons.check_circle_rounded;
    default:
      return Icons.check_circle_rounded;
  }
}

Color colorLeaveStatus(String state) {
  switch (state) {
    case draft:
      return const Color.fromARGB(255, 127, 135, 139);
    case confirm:
      return const Color.fromARGB(255, 236, 220, 70);
    case refuse:
      return const Color.fromARGB(255, 236, 20, 20);
    case validate1:
      return const Color.fromARGB(255, 5, 180, 8);
    default:
      return const Color.fromARGB(255, 5, 180, 8);
  }
}

Color colorPriority(String priority) {
  switch (priority.toLowerCase()) {
    case 'low':
      return Colors.yellow;
    case 'medium':
      return Colors.orange;
    case 'high':
      return Colors.red;
    default:
      return Colors.yellow;
  }
}

Color colorType(String str) {
  switch (str.toLowerCase()) {
    case 'new':
      return Colors.red;
    case 'update':
      return Colors.orange;
    default:
      return Colors.yellow;
  }
}

String monthNumberToName(String monthNumber) {
  Map<String, String> monthMap = {
    "01": "January",
    "02": "February",
    "03": "March",
    "04": "April",
    "05": "May",
    "06": "June",
    "07": "July",
    "08": "August",
    "09": "September",
    "10": "October",
    "11": "November",
    "12": "December",
  };

  return monthMap[monthNumber] ?? monthNumber;
}
