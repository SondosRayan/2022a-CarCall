import 'package:car_call/auth_repository.dart';
import 'package:car_call/dataBase.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'globals.dart';

class BlockAuth{
  late AuthRepository auth;
  final db = getDB();
  var context;

  BlockAuth(context){
    auth = Provider.of<AuthRepository>(context, listen: false);
    this.context = context;
  }

  Future<void> showBlockDialog(String to_Block, String reason) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody( children: <Widget>[
              Text('Are you sure you want to block this user?')
            ],
            ),
          ),
          actions: <Widget>[Row(
            children: [
              TextButton(
                child: Text('Yes', style: TextStyle(color: green11,),),
                onPressed: () async{
                  blockUser(to_Block, reason);
                  Navigator.of(context).pop();
                },
              ),
              const Spacer(),
              TextButton(
                child: Text('No', style: TextStyle(color: green11),),
                onPressed: () {Navigator.of(context).pop();},
              ),
            ],
          ),
          ],
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
        );
      },
    );
  }

  Future<void> showUnBlockDialog(String to_unBlock) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody( children: <Widget>[
              Text('Are you sure you want to unblock this user?')
            ],
            ),
          ),
          actions: <Widget>[Row(
            children: [
              TextButton(
                child: Text('Yes', style: TextStyle(color: green11,),),
                onPressed: () async{
                  unBlockUser(to_unBlock);
                  Navigator.of(context).pop();
                },
              ),
              const Spacer(),
              TextButton(
                child: Text('No', style: TextStyle(color: green11),),
                onPressed: () {Navigator.of(context).pop();},
              ),
            ],
          ),
          ],
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
        );
      },
    );
  }

  Future<void> showUnBlockMessagesDialog(String to_unBlock) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody( children: <Widget>[
              Text('Unblock user to send a message.')
            ],
            ),
          ),
          actions: <Widget>[Row(
            children: [
              TextButton(
                child: Text('Unblock', style: TextStyle(color: green11,),),
                onPressed: () async{
                  unBlockUser(to_unBlock);
                  Navigator.of(context).pop();
                },
              ),
              const Spacer(),
              TextButton(
                child: Text('Cancel', style: TextStyle(color: green11),),
                onPressed: () {Navigator.of(context).pop();},
              ),
            ],
          ),
          ],
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
        );
      },
    );
  }

  void blockUser(String toBlock_uid, String why) async {
    String first_name = await auth.getUserDetail(toBlock_uid, 'first_name');
    String last_name = await auth.getUserDetail(toBlock_uid, 'last_name');
    await db.collection('Users').doc(auth.user!.uid).collection('blocked').doc(toBlock_uid)
        .set({
      'why': why,
      'name' : first_name + " " + last_name,
    });
  }

  void unBlockUser(String toUnBlock_uid) async {
    await db.collection('Users').doc(auth.user!.uid).collection('blocked')
        .doc(toUnBlock_uid).delete();
  }

  Future<bool> isUnBlocked(String userId, String peerId) async {
    if(peerId == "") return false;
    bool unblocked = true;
    await db.collection('Users').doc(userId)
        .collection('blocked').doc(peerId).get().then((snapshot) => {
      if(snapshot.exists) {
        unblocked = false
      }
    });
    return unblocked;
  }
}