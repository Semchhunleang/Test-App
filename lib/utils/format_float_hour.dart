String formatWorkedHours(double hours) {
  int wholeHours = hours.floor();
  int minutes = ((hours - wholeHours) * 60).round();
  if (minutes == 60) {
    wholeHours++;
    minutes = 0;
  }
  String hoursText = wholeHours == 1 ? ' hour' : ' hours';
  String minutesText = minutes == 1 ? ' minute' : ' minutes';
  if (wholeHours > 0 && minutes > 0) {
    return '$wholeHours$hoursText $minutes$minutesText';
  } else if (wholeHours > 0) {
    return '$wholeHours$hoursText';
  } else if (minutes > 0) {
    return '$minutes$minutesText';
  } else {
    return '0$hoursText';
  }
}
