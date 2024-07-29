import 'dart:math';

double computeDistance(
  List<dynamic> point1,
  List<dynamic> point2,
) {
  double lat1 = double.parse(point1[1].toString());
  double lon1 = double.parse(point1[0].toString());
  double lat2 = double.parse(point2[1].toString());
  double lon2 = double.parse(point2[0].toString());

  const R = 3958.8; // Radius of the earth in miles
  var dLat = _toRadians(lat2 - lat1);
  var dLon = _toRadians(lon2 - lon1);
  var a = pow(sin(dLat / 2), 2) +
      cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * pow(sin(dLon / 2), 2);
  var c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return R * c;
}

double _toRadians(double degree) {
  return degree * pi / 180;
}

double deg2rad(double deg) {
  return deg * (pi / 180);
}
