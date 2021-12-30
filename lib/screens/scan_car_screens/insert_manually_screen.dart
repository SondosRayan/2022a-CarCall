import 'package:car_call/screens/scan_car_screens/alert_option_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth_repository.dart';
import '../../globals.dart';


class InsertManuallyScreen extends StatefulWidget {
  const InsertManuallyScreen({Key? key}) : super(key: key);

  @override
  _InsertManuallyScreenState createState() => _InsertManuallyScreenState();
}

class _InsertManuallyScreenState extends State<InsertManuallyScreen > {

  late AuthRepository firebaseUser;
  TextEditingController license_plate = TextEditingController(text: "");
  bool _validCar = false;

  @override
  Widget build(BuildContext context) {
    firebaseUser=Provider.of<AuthRepository>(context);
    setState(() {
      license_plate.text.isEmpty ? _validCar = true : _validCar = false;
    });
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
                TextField(
                  // validator: (value) => value!.isEmpty
                  //     ? 'Please Enter an Email Address' : null,
                  controller: license_plate,
                  decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    errorText: _validCar
                        ? "Please enter car number!"
                        : null,
                  ),
                ),
                // TextField(
                //     decoration: InputDecoration(
                //       errorText: _validCar ?"Enter car number" : null,
                //       border: const UnderlineInputBorder(),
                //     ),
                //     controller: _license_plate,
                //     cursorColor: green11,
                //     style: TextStyle(color: green11)),
                box,
                makeBox('Continue', 350, 60, blue3, green11, 25, getContinueTapFunction(context)),

                Flexible(child:
                Image.asset(
                  'assets/images/car_plate.png',
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),),

              ],
            ),
          ),
        )
    );
    //throw UnimplementedError();
  }
  getContinueTapFunction(context) {
    setState(() {
      license_plate.text.isEmpty ? _validCar = true : _validCar = false;
    });
    if (license_plate.text.isNotEmpty) {
      // firebaseUser.getUIDbyCarNumber(_license_plate.value.text);
      return () {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            AlertOptionScreen(carNumber: license_plate.text)));
      };
    }
  }
}
