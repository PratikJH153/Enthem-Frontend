import 'package:enthem2frontend/interfaces/user.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String? id;
  final String? username;
  final String? email;
  final String? photoURL;
  final String? gender;
  final int? age;
  final List<dynamic>? interests;
  final double? latitude;
  final double? longitude;

  bool get isLocationGiven {
    return !(latitude == -90.0 && longitude == 0);
  }

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.photoURL,
    required this.gender,
    required this.age,
    required this.interests,
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() {
    return 'User: {id: $id, username: $username, age: $age, email: $email, photoURL: $photoURL, gender: $gender, interests: $interests, latitude: $latitude, longitude: $longitude}';
  }

  factory UserModel.fromInterface(UserInterface userData) {
    final UserModel user = UserModel(
      id: userData.id,
      username: userData.username?.toString().trim(),
      email: userData.email?.toString(),
      photoURL: userData.photoURL?.toString(),
      gender: userData.gender,
      age: int.parse(userData.age.toString()),
      interests: userData.interests,
      latitude: userData.latitude ?? -90.0,
      longitude: userData.longitude ?? 0.0,
    );

    return user;
  }

  factory UserModel.fromJson(Map<String, dynamic> userData) {
    final UserModel user = UserModel(
      id: userData["id"].toString(),
      username: userData["username"].toString().trim(),
      email: userData["email"].toString(),
      photoURL: userData["photoURL"].toString(),
      gender: userData["gender"],
      age: int.parse(userData["age"].toString()),
      interests: userData["interests"],
      latitude: userData["latitude"] is Map
          ? double.parse(userData["latitude"]["low"].toString())
          : userData["latitude"] == null
              ? -90.0
              : double.parse(userData["latitude"].toString()),
      longitude: userData["longitude"] is Map
          ? double.parse(userData["longitude"]["low"].toString())
          : userData["longitude"] == null
              ? 0.0
              : double.parse(userData["longitude"].toString()),
    );
    return user;
  }

  Map<String, dynamic> toJson() {
    final userMap = {
      "id": id,
      "username": username,
      "email": email,
      "photoURL": photoURL,
      "gender": gender,
      "age": age!.toInt(),
      "interests": interests,
      "latitude": latitude ?? -90.toDouble(),
      "longitude": longitude ?? 0.toDouble(),
    };
    return userMap;
  }

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        photoURL,
        gender,
        age,
        latitude,
        longitude,
        interests,
      ];
}
