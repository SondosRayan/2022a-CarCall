import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../globals.dart';
import 'alert_option_screen.dart';

class ScannedLicensePlateScreen extends StatelessWidget{
  const ScannedLicensePlateScreen();

  @override
  Widget build(BuildContext context) {
    TextEditingController _license_plate = TextEditingController(text: "6666666");
    return  Scaffold(
      body: Center(
        child: Container(
          padding:  EdgeInsets.all(22),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(width: 370, height: 260, color: Colors.grey,),
              box, box,
              Row(children: [
                Text('Car Number:', style: TextStyle(color: green11, fontWeight: FontWeight.bold,
                fontSize: 25)),
              ],),//TODO: add picture of licenxe plate
              TextField(controller: _license_plate, keyboardType: TextInputType.number,
                obscureText: false, cursorColor: green11, style: TextStyle(color: green11),
              ),
              box,
              makeBox('Continue', 350, 60, blue3, green11, 25, getContinueTapFunction(context)),
              box,
              makeBox('Try Again', 350, 60, blue4, green11, 25, null), //TODO: add camera page
            ],
          ),
        ),
      )
    );
  }

  getContinueTapFunction(context){
    return (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => const AlertOptionScreen()));
    };
  }


}