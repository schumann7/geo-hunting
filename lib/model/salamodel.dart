class Room {
  String name;
  String id;
  String time;
  String distance;

  Room({
    required this.name,
    required this.id,
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
