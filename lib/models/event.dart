class Event {
  String? id;
  DateTime? from;
  DateTime? to;
  String? name;
  String? description;
  String? email;

  Event(
      {required this.id,
      required this.from,
      required this.to,
      required this.name,
      required this.description,
      required this.email});

  Event.fromMap(Map<String, dynamic> item)
      : id = item["id"],
        description = item["description"],
        name = item["name"],
        email = item["email"],
        from = item["start"],
        to = item["end"];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'name': name,
      'email': email,
      'start': from,
      'end': to
    };
  }
}
