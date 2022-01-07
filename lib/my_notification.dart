import 'package:car_call/auth_repository.dart';
import 'package:car_call/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

//TODO:ADDED
enum NotificationTitle {Alert, HelpRequest, HelpOffer}

class myNotification{

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final AuthRepository auth = AuthRepository.instance();
  late String _type;
  late Map<String, dynamic> _data;
  late String reciever_id;
  late String sender_id;

  myNotification(NotificationTitle title, String type, String sender_uid, String reciever_uid){
    _type = type;
    reciever_id = reciever_uid;
    sender_id = sender_uid;
  }

  Future<void> SendAlert() async {
    String sender_name = await auth.getUserName(sender_id);
    _data = {
      'type': _type,
      'sender': sender_id,
      'sender_name': sender_name,
    };
    await db.collection('Users').doc(reciever_id).collection('Alerts').add(_data);
    //await db.collection('Alerts').add(_data);
  }

  Future<void> BroadCastHelpRequest() async {
    String sender_name = await auth.getUserName(sender_id);
    _data = {
      'type': _type,
      'sender': sender_id,
      'sender_name': sender_name,
    };
    await db.collection('Users').doc(sender_id).collection('Requests').add(_data);
    await db.collection('Requests').add(_data);
  }

  Future<void> SendHelpOffer() async {
    String sender_name = await auth.getUserName(sender_id);
    _data = {
      'type': _type,
      'sender': sender_id,
      'sender_name': sender_name,
    };
    await db.collection('Users').doc(reciever_id).collection('Offers').add(_data);
    //await db.collection('Offers').add(_data);
  }

}
