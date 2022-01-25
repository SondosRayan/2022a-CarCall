import 'package:car_call/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dataBase.dart';

//TODO:ADDED
enum NotificationTitle {Alert, HelpRequest, HelpOffer}

class myNotification{

  final DocumentReference<Map<String, dynamic>> db = getDB();
  final AuthRepository auth = AuthRepository.instance();
  late String _type;
  late Map<String, dynamic> _data;
  late String reciever_id;
  late String sender_id;
  late String _location;


  myNotification(NotificationTitle title, String type, String sender_uid, String reciever_uid, String location){
    _type = type;
    reciever_id = reciever_uid;
    sender_id = sender_uid;
    _location=location;

  }

  Future<void> SendAlert() async {
    String sender_name = await auth.getUserDetail(sender_id, 'first_name');
    String phone_number = await auth.getUserDetail(sender_id, 'phoneNumber');
    _data = {
      'type': _type,
      'sender': sender_id,
      'sender_name': sender_name,
      'phoneNumber' : phone_number,
      'timestamp': Timestamp.now(),
      'read' : false,
    };
    await db.collection('Users').doc(reciever_id).collection('Alerts').add(_data);
  }

  Future<void> BroadCastHelpRequest() async {
    String sender_name = await auth.getUserDetail(sender_id, 'first_name');
    //Timestamp time = Timestamp.now();

    _data = {
      'type': _type,
      'sender': sender_id,
      'sender_name': sender_name,
      'timestamp': Timestamp.now(),
      'location':_location,

    };
    DocumentReference<Map<String, dynamic>> doc = await db.collection('Requests').add(_data);
    _data = {
      'type': _type,
      'sender': sender_id,
      'sender_name': sender_name,
      'request_id' : doc.id,
      'timestamp': Timestamp.now(),
      'location':_location,

    };

    await db.collection('Users').doc(sender_id).collection('Requests').add(_data);
  }

  Future<void> SendHelpOffer() async {
    String sender_name = await auth.getUserFullName(sender_id);
    _data = {
      'type': _type,
      'sender': sender_id,
      'sender_name': sender_name,
      'timestamp': Timestamp.now(),
      'read' : false,
      'location':_location,
    };
    await db.collection('Users').doc(reciever_id).collection('Offers').add(_data);
  }

}