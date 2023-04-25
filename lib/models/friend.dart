class Friend {
  String? id;
  final String username;
  final String bio;
  final String photoURL;
  final int age;
  final List<dynamic> interests;
  final double latitude;
  final double longitude;
  final double distance;
  final double compatible;

  String get distanceText {
    if (distance < 100) {
      return "${distance.toStringAsFixed(2)} miles";
    } else if (distance < 200) {
      return "Not close";
    } else if (distance < 300) {
      return "Far away";
    }
    return "Very far away";
  }

  Friend({
    this.id,
    required this.username,
    required this.bio,
    required this.photoURL,
    required this.age,
    required this.interests,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.compatible,
  });

  @override
  String toString() {
    return 'Friend: {username: $username, age: $age, bio: $bio, photoURL: $photoURL, interests: $interests, latitude: $latitude, longitude: $longitude, distance:$distance, compatible: $compatible}';
  }

  factory Friend.fromJson(Map<String, dynamic> userData) {
    final Friend friend = Friend(
      username: userData["username"] as String,
      photoURL: userData["photoURL"] as String,
      age: int.parse(userData["age"].toString()),
      interests: userData["interests"] ?? [],
      latitude: userData["latitude"] is Map
          ? double.parse(userData["latitude"]["low"].toString())
          : double.parse(userData["latitude"].toString()),
      longitude: userData["longitude"] is Map
          ? double.parse(userData["longitude"]["low"].toString())
          : double.parse(userData["longitude"].toString()),
      compatible: userData["compatibility"] != null
          ? double.parse(userData["compatibility"].toString())
          : 0.0,
      distance: userData["distance"] != null
          ? double.parse(userData["distance"].toString())
          : 0.0,
      bio: userData["bio"] ?? "A Enthem user",
    );
    if (userData["id"] != null) {
      friend.id = userData["id"];
    }

    return friend;
  }
}
