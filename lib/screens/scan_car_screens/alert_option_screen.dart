import 'dart:ui';
import 'package:car_call/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth_repository.dart';
import '../../globals.dart';
import '../../my_notification.dart';
import '../navigation_bar.dart';

class AlertOptionScreen extends StatelessWidget {
  String carNumber;
  AlertOptionScreen({Key? key, required this.carNumber})
      : super(key: key);
  late AuthRepository firebaseUser;

  @override
  Widget build(BuildContext context) {
    firebaseUser = Provider.of<AuthRepository>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 90,
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        leading: IconButton(
          color: green11,
          onPressed: (){
            // Navigate back to first route when tapped.
            Navigator.pop(context);},
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          'Choose a message to send:',
          style:TextStyle(color:green11, fontSize: 23, fontWeight: FontWeight.normal),
          textAlign: TextAlign.left,
        ),
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                makeBox('Blocking Car', 335, 95, blue1, green11, 25, (){showOptionDialog('Blocking Car', context);}),
                box9,
                makeBox('Opened Window', 335, 95, blue2, green11, 25, (){showOptionDialog('Opened Window', context);}),
                box9,
                makeBox('Lights On', 335, 95, blue3, green11, 25, (){showOptionDialog('Lights On', context);}),
                box9,
                makeBox('Double Parking', 335, 95, blue4, green11, 25, (){showOptionDialog('Double Parking', context);}),
                box9,
                makeBox('Private Parking', 335, 95, blue5, green11, 25, (){showOptionDialog('Private Parking', context);}),
                box9,
                makeBox('Car Crash', 335, 95, blue6, green11, 25, (){showOptionDialog('Car Crash', context);}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showOptionDialog(String alertOption, context) async {
    TextSpan dialogText = (alertOption != 'Car Crash')?
    getDialogText(alertOption):
    getCarCrashDialogText(alertOption);

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody( children: <Widget>[
              RichText(text: dialogText,)
            ],),
          ),
          actions: <Widget>[Row(
            children: [
              TextButton(
                child: Text('SEND ALERT', style: TextStyle(color: green11,),),
                onPressed: () async{
                  //Maha added
                  var sender_uid = FirebaseAuth.instance.currentUser!.uid;
                  var reciever_uid = await firebaseUser.getOwner(carNumber);
                  bool found = (reciever_uid == "")? false: true ;
                  bool unBlocked = await firebaseUser.isUnBlocked(reciever_uid);
                  if(found && unBlocked){
                    myNotification alert_notific =  myNotification(NotificationTitle.Alert, alertOption,
                        sender_uid , reciever_uid, "");
                    await alert_notific.SendAlert();
                  }
                  _showDialog(context,found && unBlocked);

                  //until here
                },
              ),
              const Spacer(),
              TextButton(
                child: Text('CANCEL', style: TextStyle(color: green11),),
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

  _showDialog(BuildContext context, bool found){
    String found_text = "An alert was successully sent.";
    String not_found_text = "Sorry! car owner was not found.";
    String dialog_text = found? found_text: not_found_text;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context)
    {
      return AlertDialog(
        content: SingleChildScrollView(
            child: Text(dialog_text)
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Ok', style: TextStyle(color: green11),),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  const MyNavigationBar()));
            },
          ),
        ],
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
      );
    });
  }


  TextSpan getDialogText(String alertOption){
    return TextSpan(
      text: 'Are you sure you want to send ',
      style: TextStyle(color:Colors.grey.shade700, fontSize: 16, fontWeight: FontWeight.normal),
      children: <TextSpan>[
        TextSpan(
          text: alertOption,
          style: TextStyle(color:Colors.grey.shade700, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        TextSpan(
            text: '?',
            style:TextStyle(color:Colors.grey.shade700, fontSize: 16, fontWeight: FontWeight.normal)
        ),],);
  }

  TextSpan getCarCrashDialogText(String alertOption){
    return TextSpan(
      text: 'Before sending a ',
      style: TextStyle(color:Colors.grey.shade700, fontSize: 16, fontWeight: FontWeight.normal),
      children: <TextSpan>[
        TextSpan(
          text: alertOption,
          style: TextStyle(color:Colors.grey.shade700, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        TextSpan(
            text: ' alert you should know that your phone number will be provided in the alert.\n',
            style:TextStyle(color:Colors.grey.shade700, fontSize: 16, fontWeight: FontWeight.normal)
        ),
        getDialogText(alertOption),
      ],
    );
  }

}