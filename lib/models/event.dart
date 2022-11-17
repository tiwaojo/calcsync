class Event {
  String? id;
  DateTime? from;
  DateTime? to;
  bool? isAllDay;
  String? name;
  String? description;
  String? email;

  Event(
      {required this.id,
      required this.from,
      required this.to,
      required this.isAllDay,
      required this.name,
      required this.description,
      required this.email});
}
