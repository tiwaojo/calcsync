import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

FirebaseFirestore db;

// FirestoreSnippets(this.db);

//Initialize Cloud Firestore
db = FirebaseFirestore.instance;

// Add data
// Create a new user with a first and last name
final user = <String, dynamic>{
  "first": "Ada",
  "last": "Lovelace",
  "born": 1815
};
// Add a new document with a generated ID
db.collection("
calEvents
"
)
.
add
(
user).
then
((

DocumentReference doc
)
=>
print
('DocumentSnapshot added with ID:
${
doc.id}'
)
);

// Read Data
await
db.collection("
users
"
)
.
get
(
).then
((event) {
for (var doc in event.docs) {
print("${doc.id} => ${doc.data()}");
}
});

class CreateEvent extends StatefulWidget {
  const CreateEvent({Key? key}) : super(key: key);

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  void _addEvent() {

  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(onPressed: addEvent,);
  }
}
