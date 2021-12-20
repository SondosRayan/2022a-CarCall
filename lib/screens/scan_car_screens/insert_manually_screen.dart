import 'package:car_call/screens/scan_car_screens/alert_option_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../globals.dart';

class InsertManuallyScreen extends StatelessWidget{
  const InsertManuallyScreen();

  @override
  Widget build(BuildContext context) {
    TextEditingController _license_plate = TextEditingController(text: "");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: green11,
          onPressed: () {
            Navigator.pop(context);
          },
          alignment: Alignment.centerRight,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
        body: Center(
          child: Container(
            padding:  EdgeInsets.all(22),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                box,
                Row(children: [
                  Text('Car Number:', style: TextStyle(color: green11, fontWeight: FontWeight.bold,
                      fontSize: 25)),
                ],),//TODO: add picture of licenxe plate
                TextField(controller: _license_plate, keyboardType: TextInputType.number,
                  obscureText: false, cursorColor: green11, style: TextStyle(color: green11),
                ),
                box,
                makeBox('Continue', 350, 60, blue3, green11, 25, getContinueTapFunction(context)),
              ],
            ),
          ),
        )
    );
    //throw UnimplementedError();
  }

  getContinueTapFunction(context){
    return (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => const AlertOptionScreen()));
    };
  }


}