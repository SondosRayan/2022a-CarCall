import 'package:car_call/screens/scan_car_screens/scan_car_options_screen.dart';
import 'package:flutter/material.dart';
import '../globals.dart';
import 'get_help_screens/get_help_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Column(
          // we have 4 elements in Column
          // 1. hello, name & picture
          // 2. scan car & get help button
          // 3. requests sentence
          // 4. all requests
          children: [
            box, box,
            Row(
              children: [
                Container(
                  padding: paddingLeft20,
                  child:
                  getText('Hello,\nSondos', Colors.black, 38, true),
                ),
                const Spacer(),
                // avatar image to do
                Container(
                  padding: paddingRight20,
                  child: CircleAvatar(
                    radius: imageRadius,
                    // backgroundImage: const AssetImage('assets/images/watermelon.jpg'),
                  ),
                )
              ],
            ),
            box, box,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                makeBoxWithPic('assets/images/camera.png', 107, 105,
                    'Scan Car', 158, 158, blue2, Colors.black, 28,
                        (){ Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ScanCarOptionScreen()),
                    );}
                ),
                makeBoxWithPic('assets/images/get help.png', 110, 115,
                    'Get Help', 158, 158, grey, Colors.black, 28,
                        (){ Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GetHelpScreen()),
                    );}
                ),

              ],
            ),
            box,
            // now building the list

          ],
        ),
      ),
    );
  }
}

