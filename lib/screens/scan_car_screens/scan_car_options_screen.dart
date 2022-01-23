import 'package:camera/camera.dart';
import 'package:car_call/screens/scan_car_screens/take_picture_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../globals.dart';
import 'insert_manually_screen.dart';

class ScanCarOptionScreen extends StatefulWidget {
  const ScanCarOptionScreen({Key? key}) : super(key: key);
  @override
  _ScanCarOptionScreenState createState() => _ScanCarOptionScreenState();
}

class _ScanCarOptionScreenState extends State<ScanCarOptionScreen> {
  static String _text = "TEXT";
  late var firstCamera;
  @override
  void initState() {
    super.initState();
  }
  initialized() async {
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();
    // Get a specific camera from the list of available cameras.
    firstCamera = cameras.first;
  }
  @override
  Widget build(BuildContext context) {
    initialized();
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
                // makeBoxWithPic('assets/images/thinking.jpg', 107, 105,
                //     'Scan Car', 158, 158, blue2, Colors.black, 28, null
                // ),
                Flexible(child:
                Image.asset(
                  'assets/images/thinking.jpg',
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),),
              ],
            ),
          ),
        ),

    );
  }
  getScanWithCameraOnTap(context){
    return (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => TakePictureScreen(camera: firstCamera)));
    };
  }

  getInsertManuallyOnTap(context){
    return (){
      Navigator.push(context, MaterialPageRoute(builder: (context) =>  InsertManuallyScreen()));
    };
  }
}