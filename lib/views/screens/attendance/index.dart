import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/view_models/attendance_view_model.dart';
import 'package:umgkh_mobile/view_models/profile_view_model.dart';
import 'package:umgkh_mobile/views/pages/vision_detector/attendance/index.dart';
import 'package:umgkh_mobile/views/screens/attendance/widgets/dialog_attendance.dart';
import 'package:umgkh_mobile/views/screens/attendance/widgets/filter_attendance.dart';
import 'package:umgkh_mobile/views/screens/attendance/widgets/card_attendance.dart';
import 'package:umgkh_mobile/widgets/float_bt.dart';

class AttendanceScreen extends StatefulWidget {
  static const routeName = '/attendance';
  static const screenName = 'Attendance';

  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool _isLoading = false; // New loading state variable

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _openCameraView() async {
    setState(() {
      _isLoading = true; // Show loading
    });

    try {
      // Fetch the current position before opening the camera
      Position position = await _determinePosition();
      if (mounted) {
        await Provider.of<AttendanceViewModel>(context, listen: false)
            .checkLocationInPolygon(position.latitude, position.longitude);

        if (mounted) {
          if (Provider.of<AttendanceViewModel>(context, listen: false)
              .isLocationCorrect) {
            if (mounted) {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FaceDetectorView(
                    state:
                        Provider.of<AttendanceViewModel>(context, listen: false)
                            .latestState,
                  ),
                ),
              );
            }
          } else {
            await showOutsideAttendanceAreaDialog(context, _fetchData);
          }
        }
      }
    } finally {
      setState(() {
        _fetchData();
        _isLoading = false; // Hide loading when done
      });
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> _fetchData() async {
    if (!mounted) return;

    final attendanceViewModel =
        Provider.of<AttendanceViewModel>(context, listen: false);
    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);

    await attendanceViewModel.setDate(DateTime.now(), false);
    if (DateTime.now().month == 12 && DateTime.now().day > 25) {
      await attendanceViewModel.setDate(
          DateTime(DateTime.now().year, 12, 26), true);
    } else {
      await attendanceViewModel.setDate(
          DateTime(DateTime.now().year - 1, 12, 26), true);
    }
    await attendanceViewModel.setReason('');
    if (mounted) {
      await profileViewModel.fetchUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Consumer<AttendanceViewModel>(
              builder: (context, attViewModel, child) {
            return Consumer<ProfileViewModel>(
                builder: (context, profileViewModel, child) {
              return const FilterAttendance();
            });
          }),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchData,
              child: Consumer<AttendanceViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (viewModel.apiStatusCode != 200) {
                    return Center(
                      child: Text(
                        viewModel.errorMessage,
                        style: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: viewModel.attendances.length,
                      itemBuilder: (context, index) {
                        final attendance = viewModel.attendances[index];
                        return CardAttendance(attendance: attendance);
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Consumer<AttendanceViewModel>(
        builder: (context, viewModel, child) {
          final shouldDisableButton = viewModel.isLoading;
          return !shouldDisableButton
              ? DefaultFloatButton(
                  onTap: _isLoading ? null : _openCameraView,
                  icon: _isLoading ? null : Icons.camera_alt_rounded,
                  type: _isLoading ? 'loading' : 'icon',
                )
              : const SizedBox();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: _isLoading
      //     ? const DefaultFloatButton(onTap: null, type: 'loading')
      //     : DefaultFloatButton(
      //         onTap: _openCameraView, icon: Icons.camera_alt_rounded),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
