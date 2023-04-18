import 'dart:math';

double computeDistance(
  List<dynamic> point1,
  List<dynamic> point2,
) {
  double lat1 = double.parse(point1[0].toString());
  double lon1 = double.parse(point1[1].toString());
  double lat2 = double.parse(point2[0].toString());
  double lon2 = double.parse(point2[1].toString());
  double R = 6371;

  var dLat = deg2rad(lat2 - lat1);
  var dLon = deg2rad(lon2 - lon1);
  var a = sin(dLat / 2) * sin(dLat / 2) +
      cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
  var c = 2 * atan2(sqrt(a), sqrt(1 - a));
  var d = R * c;
  return d * 0.00062137;
}

double deg2rad(double deg) {
  return deg * (pi / 180);
}
