class RoomHistory {
  String id;
  String name;
  String time;
  String distance;
  String date;

  RoomHistory({
    required this.id,
    required this.name,
    required this.time,
    required this.distance,
    required this.date,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'time': time,
      'distance': distance,
      'date': date,
    };
  }

  @override
  String toString() {
    return 'Room{id: $id, name: $name, time: $time, distance: $distance, date: $date}';
  }
}
