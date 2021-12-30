import 'package:car_call/screens/scan_car_screens/alert_option_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth_repository.dart';
import '../../globals.dart';

class InsertManuallyScreen extends StatelessWidget{
  InsertManuallyScreen();
  late AuthRepository firebaseUser;
  TextEditingController _license_plate = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    firebaseUser=Provider.of<AuthRepository>(context);
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
    // firebaseUser.getUIDbyCarNumber(_license_plate.value.text);
    return (){
      Navigator.push(context, MaterialPageRoute(builder: (context) =>  AlertOptionScreen(carNumber:_license_plate.text.trim())));
    };
  }


}