import 'package:car_call/screens/scan_car_screens/scanned_license_plate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../globals.dart';
import 'insert_manually_screen.dart';


class ScanCarOptionsScreen extends StatelessWidget{
  const ScanCarOptionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          }, //TODO: back method
          alignment: Alignment.centerRight,
        ),
        title: const Text('Car\'s License Plate',),
        backgroundColor: green11,
        centerTitle: true ,
      ),
      body: Center(
        child: Container(
          padding:  const EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    makeBox('I would like to:', 250, 100, Colors.transparent, green11, 30, null),
                  ],
                ),
                makeBox('Get it by scanning with camera', 325, 90, blue3, green11, 25, getScanWithCameraOnTap(context)),
                box,
                makeBox('insert it manually', 325, 90, blue3, green11, 25, getInsertManuallyOnTap(context)),
              ],
            ),
          ),
        ),
    );
    //throw UnimplementedError();
  }

  getScanWithCameraOnTap(context){
    return (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ScannedLicensePlateScreen()));
    };
  }

  getInsertManuallyOnTap(context){
    return (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => const InsertManuallyScreen()));
    };
  }






}