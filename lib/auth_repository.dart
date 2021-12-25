import 'dart:io';
import 'package:car_call/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

enum Status { Authenticated, Unauthenticated, Authenticating }

class AuthRepository with ChangeNotifier {
  final FirebaseAuth _auth;
  User? _user;
  Status _status = Status.Unauthenticated;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  //Set<WordPair> userData = <WordPair>{};
  // UserProfile userProfile;

  AuthRepository.instance() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onAuthStateChanged);
    _user = _auth.currentUser;
    _onAuthStateChanged(_user);
  }

  Status get status => _status;

  User? get user => _user;

  FirebaseFirestore get firebaseFirestore => _firebaseFirestore;

  bool get isAuthenticated => status == Status.Authenticated;

  Future<UserCredential?> signUp(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      UserCredential? userCredential= await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      //print(userCredential.)
      // userProfile.addInfoToUserData(pair, first, second);
      // _user = userCredential.user;
      return userCredential;
    } catch (e) {
      print(e);
      _status = Status.Unauthenticated;
      notifyListeners();
      return null;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // to get chat and notifications
      //userData = await getAllSavedSuggestions();
      notifyListeners();
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

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
    notifyListeners();
  }

  /*
  my help functions for storing the data
  addPairToUserData
  removePairFromUserData
  getAllSavedSuggestions
  getAllSavedSuggestionsaddpai
  getData
   */
  /*
  Future<void> addPairToUserData(WordPair pair, String first, String second)async {
    if(_status == Status.Authenticated){
      await _firebaseFirestore.collection('Users').doc(_user!.uid)
          .collection('Saved Suggestions')
          .doc(pair.toString())
          .set({'first': first, 'second': second});
    }
    userData = await getAllSavedSuggestions();
    notifyListeners();
  }
*/
  /*
  Future<void> removePairFromUserData(WordPair pair) async {
    if (_status == Status.Authenticated) {
      await _firebaseFirestore.collection('Users')
          .doc(_user!.uid)
          .collection('Saved Suggestions')
          .doc(pair.toString()).delete();
      userData = await getAllSavedSuggestions();
    }
    notifyListeners();
  }
*/
  /*
  Future<Set<WordPair>> getAllSavedSuggestions() async {
    Set<WordPair> savedSuggestions = <WordPair>{};
    String first, second;
    await _firebaseFirestore.collection('Users')
        .doc(_user!.uid)
        .collection('Saved Suggestions')
        .get()
        .then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        first = result.data().entries.first.value.toString();
        second = result.data().entries.last.value.toString();
        savedSuggestions.add(WordPair(first, second));
      }
    });
    return Future<Set<WordPair>>.value(savedSuggestions);
  }
*/
  /*
  Set<WordPair> getData() {
    return userData;
  }
*/
  String? getUserEmail(){
    return _user!.email;
  }

  Future<String> getImageUrl() async {
    return await _storage.ref('images').child(_user!.uid).getDownloadURL();
  }

  Future<void> uploadNewImage(File file)async {
    await _storage
        .ref('images')
        .child(_user!.uid)
        .putFile(file);
    notifyListeners();
  }

  ////////////////////////////
  Future<void> addInfoToUserData(String first, String last, String gender, String birthDate,
      String phoneNumber, String carPlate)async {
    var name = '$first $last';
    // await _user.updateProfile()
    //updateDisplayName(name).
    await _user!.updateDisplayName(name)
        .catchError((error) => print(error));

    await _user!.reload();
    _user = _auth.currentUser;
    // userData = await getAllInfo();
    notifyListeners();
  }
}

/*
    await _firebaseFirestore.collection('Users').doc(_user!.uid)
        .set({'carPlate': carPlate});
 */
