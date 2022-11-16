import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/response.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _collection = _firestore.collection('Event');

class FirestoreCrud {
  static Future<Response> addEvent({
    required DateTime dateTime,
    required String name,
    required String description,
    required String location,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "date_time": dateTime,
      "name": name,
      "description": description,
      "location": location
    };

    var result = await documentReferencer.set(data).whenComplete(() {
      response.code = 200;
      response.message = "Successfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

  static Stream<QuerySnapshot> readEvents(String email) {
    CollectionReference notesItemCollection = _collection;

    return notesItemCollection.where('email', isEqualTo: email).snapshots();
  }

  static Future<Response> updateEvent({
    required String id,
    required DateTime dateTime,
    required String name,
    required String description,
    required String location,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _collection.doc(id);

    Map<String, dynamic> data = <String, dynamic>{
      "date_time": dateTime,
      "name": name,
      "description": description,
      "location": location
    };

    await documentReferencer.update(data).whenComplete(() {
      response.code = 200;
      response.message = "Successfully Updated Event";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }

  static Future<Response> deleteEvent({
    required String id,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = _collection.doc(id);

    await documentReferencer.delete().whenComplete(() {
      response.code = 200;
      response.message = "Successfully Deleted Event";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });

    return response;
  }
}
