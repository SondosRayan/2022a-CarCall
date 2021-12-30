import 'package:car_call/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth_repository.dart';
import 'login_signup_screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {

  late AuthRepository firebaseUser;

  @override
  Widget build(BuildContext context) {
    firebaseUser = Provider.of<AuthRepository>(context);
    super.build(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 100,
                height: 50,
                child: Material(
                  color: blue5,
                  borderRadius: BorderRadius.circular(20.0),
                  child: MaterialButton(
                    // color: Colors.blue,
                    child: Align(
                      alignment: Alignment.center,
                      child: getText("sign out", Colors.black, 18, true),
                    ),
                    onPressed: _onPress,
                  ),
                )
            ),
            box,
            getText("Profile Screen!\nwait for sprint 2", Colors.black, 20, true),
            box,
            Material(
              color: blue5,
              borderRadius: BorderRadius.circular(20.0),
              child: MaterialButton(
                // color: blue5,
                child: Align(
                  alignment: Alignment.center,
                  child: getText("More Info", Colors.black, 18, true),
                ),
                onPressed:(){
                  showAboutDialog(
                    context: context,
                    applicationVersion: '1.0.0',
                    applicationName: 'CarCall',
                  /*children: [
                    Text("blablabla"),
                  ]*/);
                }
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: ButtomAppBar(
      //   currentTab: _currentTab,
      // ),
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


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
