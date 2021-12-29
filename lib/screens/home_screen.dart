import 'package:car_call/screens/login_signup_screens/login_screen.dart';
import 'package:car_call/screens/scan_car_screens/scan_car_options_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../globals.dart';
import 'get_help_screens/get_help_screen.dart';
import 'package:car_call/auth_repository.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late AuthRepository firebaseUser;
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
                        backgroundImage: (snapshot.data == null)
                            ? null
                            : NetworkImage(snapshot.data!),
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
                      MaterialPageRoute(builder: (context) => const ScanCarOptionsScreen()),
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
            // makeBox("sign out", 100, 50, grey, Colors.black, 18, onPress)
                SizedBox(
                  width: 100,
                  height: 50,
                  child: Material(
                             color: grey,
                             borderRadius: BorderRadius.circular(20.0),
                             child: MaterialButton(
                                     // color: Colors.blue,
                                    child: Align(
                                    alignment: Alignment.center,
                                    child: getText("sign out", CupertinoColors.black, 18, true),
                                    ),
                                    onPressed: _onPress,
                             ),
                  )
          ),
        ],),
      ),
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

