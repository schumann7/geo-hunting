class RoomHistory {
  String id;
  String name;
  String time;
  String distance;

  RoomHistory({
    required this.id,
    required this.name,
    required this.time,
    required this.distance,
  });

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'time': time, 'distance': distance};
  }

  @override
  String toString() {
    return 'Room{id: $id, name: $name, time: $time, distance: $distance}';
  }
}
