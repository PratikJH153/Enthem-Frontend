class UserInterface {
  String? id;
  String? timezone;
  String? username;
  String? email;
  String? photoURL;
  String? gender;
  int? age;
  List<String>? interests;
  double? latitude;
  double? longitude;

  UserInterface({
    this.id,
    this.timezone,
    this.username,
    this.email,
    this.photoURL,
    this.gender,
    this.age,
    this.interests,
    this.latitude,
    this.longitude,
  });

  @override
  String toString() {
    return 'UserModel{id: $id, timezone: $timezone, username: $username, email: $email, photoURL: $photoURL, gender: $gender, age: $age, interests: $interests, latitude: $latitude, longitude: $longitude}';
  }
}
