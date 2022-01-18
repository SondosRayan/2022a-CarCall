import 'package:cloud_firestore/cloud_firestore.dart';

DocumentReference<Map<String, dynamic>> getDB(){
  FirebaseFirestore db = FirebaseFirestore.instance;
  return db.collection("versions").doc("v2");
}