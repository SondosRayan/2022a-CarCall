import 'package:car_call/screens/login_signup_screens/login_screen.dart';
import 'package:car_call/screens/scan_car_screens/scan_car_options_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import '../globals.dart';
import '../my_notification.dart';
import 'get_help_screens/get_help_screen.dart';
import 'package:car_call/auth_repository.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late AuthRepository firebaseUser;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {

    firebaseUser = Provider.of<AuthRepository>(context);
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
                  getText("Hello,\n"+firebaseUser.firstName.toString(),
                          Colors.black, 38, true),
                ),
                const Spacer(),
                // avatar image to do
                FutureBuilder(
                  future: firebaseUser.getImageUrl(),
                  builder: (BuildContext context,
                      AsyncSnapshot<String> snapshot) {
                    return Container(
                      padding: paddingRight20,
                      child: CircleAvatar(
                        radius: imageRadius,
                        // backgroundImage: (snapshot.data == null)
                        //     ? null
                        //     : NetworkImage(snapshot.data!),
                      ),
                    );
                  },
                ),

                // Container(
                //   padding: paddingRight20,
                //   child: CircleAvatar(
                //     radius: imageRadius,
                //     // backgroundImage: const AssetImage('assets/images/watermelon.jpg'),
                //   ),
                // )
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
            box,
            // now building the list
            // makeBox("sign out", 100, 50, grey, Colors.black, 18, onPress)
            Text('People Who Need Help', style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),),
            Flexible(
              child: Material(
                borderRadius: BorderRadius.circular(20),
                color: blue3,
                child: StreamBuilder<QuerySnapshot>(
                      stream: db.collection('Requests').snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListView(
                            children: snapshot.data!.docs.map((doc){
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(7, 4, 7, 4),
                                child: Material(
                                  borderRadius: BorderRadius.circular(20.0),
                                  shadowColor: Colors.black,//Colors.grey.shade200,
                                  color: Colors.white,
                                  child: (doc.get('sender') == firebaseUser.user!.uid)? null:
                                      ListTile(
                                        title:
                                        Column(
                                          children: [
                                            Text("${doc.get('sender_name')}"+
                                                    " needs help with ${doc.get('type')}.", style:
                                            TextStyle(color: Colors.black, fontSize: 20),),
                                            box,
                                            Container(
                                              height: 30,
                                              child: Material(
                                                borderRadius: BorderRadius.circular(20.0),
                                                color: blue6,
                                                child: TextButton(child: Text('I can help',
                                                  style: TextStyle(
                                                    color: Colors.black,

                                                  ),),
                                                  onPressed: () {
                                                    _onOfferHelp(doc.get('type'), context, doc.get('sender'));
                                                  },
                                                ),
                                              ),
                                            )
                                          ],
                                        ),

                                      ),
                                  ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
              ),
            ),
            
        ],),
      ),
    );
  }

  Future<void> _onOfferHelp(String helpOption, BuildContext context, String to) async {
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
                getText('Are you sure you can help with ', Colors.grey.shade700, 16, false),
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
                        FirebaseAuth.instance.currentUser!.uid, to);
                    await m.SendHelpOffer();
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

  Future<void> _onPress() async {
    const signout_snackBar = SnackBar(
        content: Text('Successfully logged out'));
    await firebaseUser.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
    ScaffoldMessenger.of(context).showSnackBar(signout_snackBar);
  }

}

