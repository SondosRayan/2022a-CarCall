import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum Status { Authenticated, Unauthenticated, Authenticating, Authenticating2 }
const String defaultAvatar = 'https://cdn.onlinewebfonts.com/svg/img_258083.png';

class AuthRepository with ChangeNotifier {
  FirebaseAuth _auth;
  User? _user;
  Status _status = Status.Unauthenticated;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  String _firstName = "";
  String _lastName = "";
  String _gender = "";
  String _birthDate = "";
  String _phoneNumber= "";
  String _carPlate = "";
  String _avatarURL = defaultAvatar;
  bool _isGoogle = false;

  AuthRepository.instance() : _auth = FirebaseAuth.instance,
                              _firebaseFirestore = FirebaseFirestore.instance,
                              _storage = FirebaseStorage.instance{
    _auth.authStateChanges().listen(_onAuthStateChanged);
    _user = _auth.currentUser;
    _onAuthStateChanged(_user);
  }

  ///////////////////////////////////////
  // GET & SET FUNCTIONS
  ///////////////////////////////////////
  FirebaseFirestore get firebaseFirestore => _firebaseFirestore;

  FirebaseStorage get storage => _storage;

  bool get isGoogle => _isGoogle;

  Status get status => _status;
  bool get isAuthenticated => status == Status.Authenticated;

  User? get user => _user;

  String? getUserEmail(){
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

  Future<UserCredential?> signUpWithEmailPass(String email, String password) async {
    try{
      _status = Status.Authenticating;
      notifyListeners();
      UserCredential? userCredential= await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      notifyListeners();
      return userCredential;
    }catch(e){
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      return null;
    }
  }

  Future<User?> completeSignUp(
      String firstName,String lastName, String gender,String birthDate,
      String phoneNumber,String carPlate) async {
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
      updateLocalUserFields();
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
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    _status = Status.Authenticated;
    _user = FirebaseAuth.instance.currentUser;
    _isGoogle = true;
    updateLocalUserFields();
  }

  Future<bool> signInFirstTime() async {
    _firebaseFirestore = FirebaseFirestore.instance;
    try {
      final snapShot = await _firebaseFirestore.collection('Users').doc(_user!.uid).get();
      if (snapShot == null || !snapShot.exists) {
        return true;
      } else {
        updateLocalUserFields();
        return false;
      }
    } catch(e) {
      updateLocalUserFields();
      return false;
    }
  }

  // END OF SIGN IN FUNCTIONS
  /////////////////////////////////////////////////////////////////////////////
  Future signOut() async {
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
    updateLocalUserFields();
    notifyListeners();
  }

  Future<String> getImageUrl() async {
    return _avatarURL;
    // return await _storage.ref('images').child(_user!.uid).getDownloadURL();
  }

  Future<void> uploadNewImage(File file)async {
    await _storage
        .ref('images')
        .child(_user!.uid)
        .putFile(file);
    notifyListeners();
  }

  ///////////////////////////////////////
  // DEALING WITH USER PROFILE
  ///////////////////////////////////////
  void updateLocalUserFields() async {
    if(_user == null) return;
    var snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(_user!.uid).get();
    var list = snapshot.data();
    if(list == null) return;
    if(list['Info']==null) return;
    _firstName = list['Info'][0];
    _lastName = list['Info'][1];
    _gender = list['Info'][2];
    _birthDate = list['Info'][3];
    _phoneNumber = list['Info'][4];
    _carPlate = list['Info'][5];

    // try {
    //   _avatarURL = await FirebaseStorage.instance.ref("images")
    //       .child(_user!.uid)
    //       .getDownloadURL() ?? defaultAvatar;
    // } catch (_){
    //   _avatarURL = defaultAvatar;
    // }

  }

  Future<void> updateFirebaseUserList() async {
    var list=[_firstName,_lastName,_gender,_birthDate,_phoneNumber,_carPlate];
    await _firebaseFirestore.collection('Users').doc(_user!.uid).set({'Info':list});
    notifyListeners();
  }

  void deleteUser(){
    FirebaseFirestore.instance.collection('Users').doc(_user!.uid).delete().then((_){
      // delete account on authentication after user data on database is deleted
    });
  }
}

