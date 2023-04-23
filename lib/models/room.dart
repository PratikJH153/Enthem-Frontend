import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Room extends Equatable {
  final String? id;
  final String title;
  final String? des;
  final String ownerID;
  final DateTime createdAt;
  final List<double> coordinates;
  final int? votes;
  List<dynamic>? participants;

  Room({
    this.id,
    required this.title,
    this.des,
    required this.ownerID,
    required this.createdAt,
    required this.coordinates,
    this.votes,
    this.participants,
  });

  @override
  String toString() {
    return 'Room: {id: $id, title: $title, des: $des, createdAt: $createdAt, ownerID: $ownerID, coordinates: $coordinates, votes: $votes, participants: $participants}';
  }

  factory Room.fromJson(Map<String, dynamic> json) {
    final List<double> coordinates = [];
    json["location"]["coordinates"]
        .forEach((c) => coordinates.add(double.parse(c.toString())));

    final Room room = Room(
      id: json["_id"],
      title: json["title"] ?? "Default",
      des: json["des"],
      ownerID: json["ownerID"],
      createdAt: DateTime.parse(json["createdAt"]),
      coordinates: coordinates,
      votes: json["votes"] ?? 0,
      participants: json["memberlist"],
    );
    return room;
  }

  Map<String, dynamic> toJson() {
    final userMap = {
      "title": title,
      "des": des,
      "ownerID": ownerID,
      "createdAt": createdAt.toString(),
      "coordinates": coordinates
    };
    return userMap;
  }

  @override
  List<Object?> get props => [
        id,
        title,
        des,
        ownerID,
        createdAt,
        coordinates,
        votes,
      ];
}
