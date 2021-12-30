import 'package:car_call/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//Maha added
class UserProfile{
  late String _first_name ;
  late String _uid ;
  late String _token;
  late String _phoneNumber;

  UserProfile(String uid) {
    Map? info = getInfo(uid) as Map?;
    _first_name = info!['first_name'];
    _uid = uid;
    _token = info['token'];
    _phoneNumber = info['phoneNumber'];
  }

  Future<Map?> getInfo(String uid) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var snapshot =  await db.collection('Users').doc(uid).get();
    return snapshot.data();
  }

  Map toJson() => {
    'name': _first_name,
    'uid': _uid,
    'token': _token,
    'phoneNumber': _phoneNumber,
  };

}

//until here