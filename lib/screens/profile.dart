import 'package:car_call/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth_repository.dart';
import 'blocked.dart';
import 'login_signup_screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {

  late AuthRepository firebaseUser;
  final profilePic= Image.asset('assets/images/car_call_logo.jpg');

  @override
  Widget build(BuildContext context) {
    firebaseUser = Provider.of<AuthRepository>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final fullName = firebaseUser.firstName + " " + firebaseUser.lastName;
    final email = firebaseUser.getUserEmail();
    late var email1;
    email==null ? email1=" " : email1=email;
    final gender = firebaseUser.gender;
    final birthDate = firebaseUser.birthDate;
    final phone = firebaseUser.phoneNumber;
    final car = firebaseUser.carPlate;
    // TODO: to add blocked at the future

    super.build(context);
    return Scaffold(
      backgroundColor: blue1,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: getText('My Profile', Colors.white, 30, true),
        ),
        backgroundColor: green11,
      ),
      body: Column(
        children: [
          Container(
            color: green2,
            child: Row(
              children: [
                // pic&change ,
                Column(
                  // mainAxisSize: MainAxisSize.max,
                  children: [
                    FutureBuilder(
                      future: firebaseUser.getImageUrl(),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Container(
                          padding: getPaddingAll(20),
                          child: CircleAvatar(
                            radius: imageRadius,
                            backgroundImage: (snapshot.data == null)
                                ? null
                                : NetworkImage(snapshot.data!),
                          ),
                        );
                      },
                    ),
                    // change avatar
                    // getTextNoSize('change avatar', Colors.white, true)
                  ],
                ),
                // by col user&mail
                Expanded(
                  child:Column(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      getText('User Name:', Colors.white, 20, false),
                      getText(fullName, Colors.white, 25, true),
                      getSizeBox(10),
                      getText('Email:', Colors.white, 20, false),
                      FittedBox(
                        fit: BoxFit.fill,
                        child: getText(email1, Colors.white, 25, true),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          getSizeBox(5),
          Expanded(
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 75,
                  child:
                    Card(
                    // margin:,
                    color: blue4,
                    shape: RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(10.0))),
                    child: Container(
                      padding: getPaddingAll(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getText('Gender: ', green11, 25, false),
                          Spacer(),
                          getText(gender, green11, 25, true),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 75,
                  child:
                  Card(
                    // margin:,
                    color: blue4,
                    shape: RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(10.0))),
                    child: Container(
                      padding: getPaddingAll(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getText('Birth Date: ', green11, 25, false),
                          Spacer(),
                          getText(birthDate, green11, 25, true),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 75,
                  child:
                  Card(
                    // margin:,
                    color: blue4,
                    shape: RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(10.0))),
                    child: Container(
                      padding: getPaddingAll(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getText('Phone Number: ', green11, 25, false),
                          Spacer(),
                          getText(phone, green11, 25, true),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 75,
                  child:
                  Card(
                    // margin:,
                    color: blue4,
                    shape: RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(10.0))),
                    child: Container(
                      padding: getPaddingAll(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getText('My Car Plate: ', green11, 25, false),
                          Spacer(),
                          getText(car, green11, 25, true),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 75,
                  child:
                  Card(
                    // margin:,
                    color: blue4,
                    shape: RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(10.0))),
                    child: Container(
                      padding: getPaddingAll(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getText('Blocked: ', green11, 25, false),
                          Spacer(),
                          IconButton(
                            icon : Icon(Icons.arrow_forward_ios),
                            color: green11,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const BlockedScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                getSizeBox(15),
                Material(
                  color: green11,
                  borderRadius: BorderRadius.circular(20.0),
                  child: MaterialButton(
                    minWidth: screenWidth*0.8,
                    height: 60,
                    child: getText('Sign Out', Colors.white, 25, true),
                    onPressed: _onPress,
                  ),
                ),
                getSizeBox(20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onPress() async {
    const signout_snackBar = SnackBar(
        content: Text('Successfully logged out'));
    await firebaseUser.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false
    );
    ScaffoldMessenger.of(context).showSnackBar(signout_snackBar);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

/*
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
 */