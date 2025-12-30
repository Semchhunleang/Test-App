import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;

class LocationService {
  // Function to check if point is inside polygon
  bool isPointInPolygon(maps.LatLng point, List<maps.LatLng> polygon) {
    int intersectCount = 0;
    for (int i = 0; i < polygon.length - 1; i++) {
      if (_rayCrossesSegment(point, polygon[i], polygon[i + 1])) {
        intersectCount++;
      }
    }
    return (intersectCount % 2) == 1;
  }

  bool _rayCrossesSegment(maps.LatLng point, maps.LatLng a, maps.LatLng b) {
    double px = point.longitude;
    double py = point.latitude;
    double ax = a.longitude;
    double ay = a.latitude;
    double bx = b.longitude;
    double by = b.latitude;

    if (ay > by) {
      ax = b.longitude;
      ay = b.latitude;
      bx = a.longitude;
      by = a.latitude;
    }

    if (py == ay || py == by) py += 0.00000001;
    if ((py > by || py < ay) || (px > max(ax, bx))) return false;
    if (px < min(ax, bx)) return true;

    double red = (ay != by) ? ((by - ay) / (bx - ax)) : double.infinity;
    double blue = (ay != py) ? ((py - ay) / (px - ax)) : double.infinity;
    return blue >= red;
  }

  // Function to calculate distance between two LatLng points
  double _distanceBetweenPoints(maps.LatLng point1, maps.LatLng point2) {
    const double R = 6371000; // Earth radius in meters
    double dLat = _degreesToRadians(point2.latitude - point1.latitude);
    double dLon = _degreesToRadians(point2.longitude - point1.longitude);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(point1.latitude)) *
            cos(_degreesToRadians(point2.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  // Function to calculate the shortest distance from point to polygon
  String distanceToPolygon(maps.LatLng point, List<maps.LatLng> polygon) {
    // If point is inside the polygon, distance is 0
    if (isPointInPolygon(point, polygon)) {
      return "0 m";
    }

    double minDistance = double.infinity;

    // Iterate through each edge of the polygon
    for (int i = 0; i < polygon.length - 1; i++) {
      double distance =
          _distanceToLineSegment(point, polygon[i], polygon[i + 1]);
      if (distance < minDistance) {
        minDistance = distance;
      }
    }

    return _formatDistance(minDistance);
  }

  // Function to calculate distance from a point to a line segment
  double _distanceToLineSegment(
      maps.LatLng point, maps.LatLng a, maps.LatLng b) {
    double A = point.latitude - a.latitude;
    double B = point.longitude - a.longitude;
    double C = b.latitude - a.latitude;
    double D = b.longitude - a.longitude;

    double dot = A * C + B * D;
    double lenSq = C * C + D * D;
    double param = (lenSq != 0) ? dot / lenSq : -1;

    double closestLat, closestLng;

    if (param < 0) {
      closestLat = a.latitude;
      closestLng = a.longitude;
    } else if (param > 1) {
      closestLat = b.latitude;
      closestLng = b.longitude;
    } else {
      closestLat = a.latitude + param * C;
      closestLng = a.longitude + param * D;
    }

    return _distanceBetweenPoints(point, maps.LatLng(closestLat, closestLng));
  }

  // Function to format the distance based on its value
  String _formatDistance(double distanceInMeters) {
    if (distanceInMeters >= 1000) {
      double distanceInKm = distanceInMeters / 1000;
      return "${distanceInKm.toStringAsFixed(2)} km";
    } else {
      return "${distanceInMeters.toStringAsFixed(2)} m";
    }
  }
}
