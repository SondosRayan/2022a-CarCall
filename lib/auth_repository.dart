import 'dart:io';
import 'package:car_call/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dataBase.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';


enum Status { Authenticated, Unauthenticated, Authenticating, Authenticating2 }
const String defaultAvatar = 'https://cdn.onlinewebfonts.com/svg/img_258083.png';

const String femaleDefaultAvatar =
    'https://static.vecteezy.com/system/resources/thumbnails/001/993/889/small/beautiful-latin-woman-avatar-character-icon-free-vector.jpg';
const String maleDefaultAvatar =
    "https://static.vecteezy.com/system/resources/thumbnails/002/002/403/small/man-with-beard-avatar-character-isolated-icon-free-vector.jpg";




class my_message{
  late String sender_name;
  late String type;
  my_message(String senderName, String Type){
    sender_name = senderName;
    type = Type;
  }
}

class AuthRepository with ChangeNotifier {
  FirebaseAuth _auth;
  User? _user;
  Status _status = Status.Unauthenticated;
  DocumentReference<Map<String, dynamic>> _firebaseFirestore =getDB();
  FirebaseStorage _storage = FirebaseStorage.instance;

  //MAHA ADDED
  String _field_value = "";



  //until here
  String _firstName = "";
  String _lastName = "";
  String _gender = "";
  String _birthDate = "";
  String _phoneNumber = "";
  String _carPlate = "";
  String _avatarURL = defaultAvatar;
  bool _isGoogle = false;

  AuthRepository.instance()
      : _auth = FirebaseAuth.instance,
        _firebaseFirestore = getDB(),
        _storage = FirebaseStorage.instance{
    _auth.authStateChanges().listen(_onAuthStateChanged);
    _user = _auth.currentUser;
    _onAuthStateChanged(_user);
  }

  ///////////////////////////////////////
  // GET & SET FUNCTIONS
  ///////////////////////////////////////

  DocumentReference<Map<String, dynamic>> get firebaseFirestore => _firebaseFirestore;

  FirebaseStorage get storage => _storage;

  bool get isGoogle => _isGoogle;

  Status get status => _status;

  bool get isAuthenticated => status == Status.Authenticated;

  User? get user => _user;

  String? getUserEmail() {
    // print("check user $_user");
    if(_user == null) return null;
    return _user!.email;
  }

  String get firstName => _firstName;

  set firstName(String value) {
    _firstName = value;
  }

  String get lastName => _lastName;

  set lastName(String value) {
    _lastName = value;
  }

  String get fullName {
    return _firstName + " " + _lastName;
  }

  String get gender => _gender;

  set gender(String value) {
    _gender = value;
  }

  String get birthDate => _birthDate;

  set birthDate(String value) {
    _birthDate = value;
  }

  String get phoneNumber => _phoneNumber;

  set phoneNumber(String value) {
    _phoneNumber = value;
  }

  String get carPlate => _carPlate;

  set carPlate(String value) {
    _carPlate = value;
  }

  // String get avatarURL => _avatarURL;

  // COMPLETE THE REST OF THEM ***DONE***
  /////////////////////////////////////////////////////////////////////////

  Future<UserCredential?> signUpWithEmailPass(String email,
      String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      UserCredential? userCredential = await _auth
          .createUserWithEmailAndPassword(
          email: email, password: password);
      notifyListeners();

      return userCredential;
    } catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      return null;
    }
  }

  Future<User?> completeSignUp(String firstName, String lastName, String gender,
      String birthDate,
      String phoneNumber, String carPlate) async {
    print("GENDERRRR : "+gender);
    try {
      _firstName = firstName;
      _lastName = lastName;
      _gender = gender;
      _birthDate = birthDate;
      _phoneNumber = phoneNumber;
      _carPlate = carPlate;

      updateFirebaseUserList();
      notifyListeners(); // ????
      return _user;
    } catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      return null;
    }
  }

  ////////////////////////////////////////////////////////////////////////////
  //  SIGN IN METHODS - WITH EMAIL AND PASSWORD || GOOGLE
  ////////////////////////////////////////////////////////////////////////////
  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _status = Status.Authenticated;
      //TODO: there is more to add for image
      // _avatarURL = await _storage.ref('images').child(_user!.uid).getDownloadURL();
      await updateLocalUserFields();
      notifyListeners();
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser!
        .authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    _status = Status.Authenticated;
    _user = FirebaseAuth.instance.currentUser;
    _isGoogle = true;
    await updateLocalUserFields();
  }

  Future<bool> signInFirstTime() async {
    _firebaseFirestore = getDB();
    try {
      final snapShot = await _firebaseFirestore.collection('Users').doc(
          _user!.uid).get();
      bool old_user = await oldVersionUser();
      if ((snapShot == null || !snapShot.exists) && !old_user) {
        return true;
      } else {
        await updateLocalUserFields();
        return false;
      }
    } catch (e) {
      await updateLocalUserFields();
      return false;
    }
  }

  // END OF SIGN IN FUNCTIONS
  /////////////////////////////////////////////////////////////////////////////
  Future signOut() async {
    await FirebaseMessaging.instance.getToken().then((token) async {
      await this.removeToken(token!);
    });
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _user = null;
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
    }
    await updateLocalUserFields();
    notifyListeners();
  }
  Future<String> getImageUrl() async {
    var res="";
    try{
      res = await _storage.ref('images').child(_user!.uid).getDownloadURL();
      return res;
    }
    catch(e){
      res = getNameAvatar(fullName);
    }
    return res;
  }

  Future<String> getPeerImageUrl(String peerId, String nameImage) async {
    String res = nameImage;
    try{
      res = await _storage.ref('images').child(peerId).getDownloadURL();
      return res;
    }
    catch(e){
      print(e);
    }
    return res;
  }

  Future<void> uploadNewImage(File file) async {
    print("upload image **************");
    try {
      await _storage
          .ref('images')
          .child(_user!.uid)
          .putFile(file);
    } catch(e){
      print("error in upload image **************");
    }
    notifyListeners();
  }

  ///////////////////////////////////////
  // DEALING WITH USER PROFILE
  ///////////////////////////////////////
  Future<void> updateLocalUserFields() async {
    if (_user == null) return;


    try{
      await _firebaseFirestore.collection('Users').doc(user!.uid).get().
      then((snapshot) {
        _firstName = snapshot.data()!['first_name'];
        _lastName = snapshot.get('last_name');
        _gender = snapshot.get('gender');
        _birthDate = snapshot.get('birthDate');
        _phoneNumber = snapshot.get('phoneNumber');
        _carPlate = snapshot.get('carPlate');
      });
    } catch(e){
      print(e);
    }
  }

  Future<void> updateFirebaseUserList() async {

    await _firebaseFirestore.collection('Users').doc(_user!.uid).set(
        {
          'first_name': _firstName,
          'last_name': _lastName,
          'gender' : _gender,
          'birthDate' : _birthDate,
          'phoneNumber': _phoneNumber,
          'carPlate': _carPlate,
        }
    );
    print("got here and carPlate = " + _carPlate);
    await _firebaseFirestore.collection('Cars').doc(_carPlate).set(
        {'uid': _user!.uid});

    //until here
    notifyListeners();
  }

  void deleteUser() {
    FirebaseFirestore.instance.collection('Users').doc(_user!.uid)
        .delete()
        .then((_) {
      // delete account on authentication after user data on database is deleted
    });
  }


  Future<String> getOwner(String car_plate) async {
    String user_id = "";
    try{
      await _firebaseFirestore.collection('Cars').doc(car_plate)
          .get().then((snapshot) async {
        if (!snapshot.exists) {
          user_id = "";
        }
        else {
          var list = snapshot.data();
          user_id = list!['uid'];
        }
      });
    }
    catch(e){
      return "";
    }

    return user_id;
  }


  Future<String> getUserDetail(String uidd, String field) async {
    await _firebaseFirestore.collection('Users').doc(uidd).get().
    then((snapshot){
      _field_value = snapshot.get(field);
    });
    return _field_value;
  }

  Future<String> getUserFullName(String uidd)async{

    return await getUserDetail(uidd,'first_name') + " "
        + await getUserDetail(uidd,'last_name');
  }


  Future<void> addToken(String token) async {

    if(token == null) {
      print('!!!!! Token Is Null !!!!!');
      return;
    }
    await _firebaseFirestore.collection('Tokens').doc(token).set(
        {'uid': _user!.uid});
    await _firebaseFirestore.collection('Users').doc(user!.uid).collection('tokens').doc(token).set(
        {'registerd_at': Timestamp.now()});
  }

  Future<bool> oldVersionUser() async {
    FirebaseFirestore old_database = FirebaseFirestore.instance;
    final snapShot = await old_database.collection('Users').doc(
        _user!.uid).get();
    if (snapShot == null || !snapShot.exists) {
      return false;
    }
    print("******************* OLD USERRRRRRRRRR ****************************");
    await updateLocalUserFieldsFromOldVersion();
    //await old_database.collection('Users').doc(_user!.uid).delete();
    await updateFirebaseUserList();
    notifyListeners();
    return true;
  }

  Future<void> updateLocalUserFieldsFromOldVersion() async {
    if (_user == null) return;
    var snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(_user!.uid).get();
    var list = snapshot.data();
    if (list == null) return;
    if (list['Info'] == null) return;
    _firstName = list['Info'][0];
    _lastName = list['Info'][1];
    _gender = list['Info'][2];
    _birthDate = list['Info'][3];
    _phoneNumber = list['Info'][4];
    _carPlate = list['Info'][5];
  }

  Future<void> removeToken(String token) async {

    if(token == null) {
      print('!!!!! Token Is Null !!!!!');
      return;
    }
    await _firebaseFirestore.collection('Tokens').doc(token).delete();
    await _firebaseFirestore.collection('Users').doc(user!.uid).collection('tokens').doc(token).delete();
    print("Token Removed Successfully!\n token : $token");
  }

  void updateProfile(String firstName, String lastName,
      String phoneNumber, String carPlate) async {
    String oldCarPlate = _carPlate;
    try {
      _firstName = firstName;
      _lastName = lastName;
      _phoneNumber = phoneNumber;
      _carPlate = carPlate;
      await _firebaseFirestore.collection('Cars').doc(oldCarPlate).delete();
      await updateFirebaseUserList();
      notifyListeners(); // ????
    } catch (e) {
      print(e);
    }
  }

  /*
  Future<String> onStartUp() async {
    String retVal = "error";
    try{
      var _firebaseUser = await _auth.currentUser;

    }catch(e){
      print(e);
    }
    return retVal;
  }*/

}

