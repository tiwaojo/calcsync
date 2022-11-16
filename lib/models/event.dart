class Event {
  String? id;
  DateTime? dateTime;
  String? name;
  String? description;
  String? email;

  Event(
      {required this.id,
      required this.dateTime,
      required this.name,
      required this.description,
      required this.email});
}
