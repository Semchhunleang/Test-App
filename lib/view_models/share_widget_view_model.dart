import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:umgkh_mobile/models/hr/leave/leave.dart';
import 'package:umgkh_mobile/models/hr/leave/leave_summary.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart';
import 'package:umgkh_mobile/view_models/take_leave_view_model.dart';
import 'package:umgkh_mobile/views/pages/hr/take_leave/widget/widget_button_share.dart';

class ShareWidgetViewModel extends ChangeNotifier {
  // init
  bool loading = false;
  ScreenshotController ctrl = ScreenshotController();
  Uint8List _byteScreenshot = Uint8List(0), _profile = Uint8List(0);
  int _year = DateTime.now().year;
  double _totalLeave = 0.0, _numberOfDay = 0.0;
  List<LeaveSummary> _leaveSummaries = [];
  String _message = "";

  // get
  Uint8List get byteScreenshot => _byteScreenshot;
  Uint8List get profile => _profile;
  int get year => _year;
  double get totalLeave => _totalLeave;
  double get numberOfDay => _numberOfDay;
  List<LeaveSummary> get leaveSummaries => _leaveSummaries;
  String get message => _message;

  resetForm() {
    ctrl = ScreenshotController();
    _byteScreenshot = Uint8List(0);
    _profile = Uint8List(0);
    _year = DateTime.now().year;
    _totalLeave = 0.0;
    _numberOfDay = 0.0;
    _leaveSummaries = [];
    _message = "";
  }

  Future captureWidget(BuildContext context, Leave leave) async {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
    setData(context, leave);
    _byteScreenshot = await ctrl.captureFromWidget(
        buildShareWidget(context,
            leave: leave,
            year: year,
            totalLeave: totalLeave,
            summaries: leaveSummaries,
            profile: profile),
        context: context);
    debugPrint('================Bytes: $byteScreenshot');
    notifyListeners();
  }

  Future setData(BuildContext context, Leave leave) async {
    resetForm();
    final vmLeave = Provider.of<TakeLeaveViewModel>(context, listen: false);
    final vmProfile = Provider.of<ProfileViewModel>(context, listen: false);

    _profile = vmProfile.profilePicture;
    _year = vmLeave.year;
    _totalLeave = vmLeave.totalLeave;
    _numberOfDay = leave.numberOfDays;
    _leaveSummaries = vmLeave.leaveSummaries;
    _message = leave.description;
    notifyListeners();
  }

  Future saveAndShare(BuildContext context, Leave leave) async {
    if (_byteScreenshot.isEmpty) {
      loading = true;
      await captureWidget(context, leave);
    }

    if (byteScreenshot.isNotEmpty) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/leave-evidenc.png';
      final image = File(imagePath);

      // check if file exists before writing
      if (await image.exists()) await image.delete();
      await image.writeAsBytes(byteScreenshot);
      final xFile = XFile(image.path);
      String day = 'day${leave.numberOfDays > 1 ? 's' : ''}';
      final customMessage =
          "Dear @ and HR,\n\nI would like to request take leave $numberOfDay $day by the reason: $message\n\nThanks.";
      final result =
          await Share.shareXFiles([xFile], text: '\n\t$customMessage\n');

      if (result.status == ShareResultStatus.dismissed) {
        debugPrint('User dismissed share');
      }
      if (result.status == ShareResultStatus.success) {
        debugPrint('Shared successfully');
      }
      loading = false;
      notifyListeners();
    }
  }
}
