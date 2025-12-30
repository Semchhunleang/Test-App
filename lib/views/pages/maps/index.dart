import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/view_models/map_view_model.dart';

class AttendanceAreaPage extends StatefulWidget {
  static const routeName = '/attendance-area';
  static const pageName = 'Attendance Area';

  const AttendanceAreaPage({super.key});

  @override
  State<AttendanceAreaPage> createState() => _AttendanceAreaPageState();
}

class _AttendanceAreaPageState extends State<AttendanceAreaPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AttendanceAreaViewModel>(context, listen: false).setPoints();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AttendanceAreaPage.pageName,
            style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Consumer<AttendanceAreaViewModel>(
        builder: (context, model, child) {
          if (model.isLoading) {
            return const Center(child: CircularProgressIndicator(),);
          } else if (model.latLngPoints.isEmpty) {
            return const Center(child: Text('No data available'),);
          } else {
            return GoogleMap(
              mapType: MapType.satellite,
              initialCameraPosition: CameraPosition(
                target: model
                    .getPolygonCentroid(), // Default location if no points are available
                zoom: 19,
              ),
              polygons: {
                Polygon(
                  polygonId: const PolygonId('shape'),
                  points: model.latLngPoints,
                  fillColor: Colors.blue.withOpacity(0.5),
                  strokeColor: Colors.blue,
                  strokeWidth: 3,
                ),
              },
              zoomGesturesEnabled: false,
              scrollGesturesEnabled: false,
              rotateGesturesEnabled: false,
              tiltGesturesEnabled: false,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
            );
          }
        },
      ),
    );
  }
}
