import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../globals.dart';
import '../../my_notification.dart';
import '../home_screen.dart';

class GetHelpScreen extends StatelessWidget {
  const GetHelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:
      Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            toolbarHeight: 90,
            elevation: 0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: true,
            title: Row(
              children: [
                IconButton(
                  color: green11,
                  onPressed: () {
                    // Navigate back to first route when tapped.
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                getText('I need help with:', green11, 37, false),
              ],
            )
        ),

        body: ListView(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  makeBox('Water', 335, 93, blue1, green11, 30,
                          (){showOptionDialog("Water", context);}),
                  box,
                  makeBox('Oil', 335, 93, blue2, green11, 30,
                          (){showOptionDialog("Oil", context);}),
                  box,
                  makeBox('Flat Tire', 335, 93, blue3, green11, 30,
                          (){showOptionDialog("Flat Tire", context);}),
                  box,
                  makeBox('Fuel', 335, 93, blue4, green11, 30,
                          (){showOptionDialog("Fuel", context);}),
                  box,
                  makeBox('Battery', 335, 93, blue5, green11, 30,
                          (){showOptionDialog("Battery", context);}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showOptionDialog(String helpOption, BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                getText('Are you sure you need help with ', Colors.grey.shade700, 16, false),
                Row(
                  children: [
                    getText(helpOption, Colors.grey.shade700, 16, true),
                    getText(' ?', Colors.grey.shade700, 16, false),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              children: [
                TextButton(
                  child: getText('YES', green11, 16, true),
                  onPressed: () async {
                    myNotification m = myNotification(NotificationTitle.HelpRequest, helpOption,
                        FirebaseAuth.instance.currentUser!.uid, "");
                    await m.BroadCastHelpRequest();
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  MyHomePage()));
                    // to show another dialog for the GPS
                  },
                ),
                const Spacer(),
                TextButton(
                  child: getText('NO', green11, 16, true),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}