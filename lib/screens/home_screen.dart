import 'dart:collection';

import 'package:car_call/screens/login_signup_screens/login_screen.dart';
import 'package:car_call/screens/scan_car_screens/scan_car_options_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../dataBase.dart';
import '../globals.dart';
import '../my_notification.dart';
import 'get_help_screens/get_help_screen.dart';
import 'package:car_call/auth_repository.dart';
import 'google_map_screen.dart';
import 'navigation_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with AutomaticKeepAliveClientMixin{
  late AuthRepository firebaseUser;
  final DocumentReference<Map<String, dynamic>> db = getDB();
    double current_lat=0;
    double current_lon=0;
    String defaultLocation="52.2165157, 6.9437819";
    double my_radius=20;
    TextEditingController radius_controller =TextEditingController();

  double getDistance(String location){
      double lat=double.parse(location.split(",")[0]);
      double lon=double.parse(location.split(",")[1]);
      double distance =  Geolocator.distanceBetween(current_lat, current_lon, lat, lon)/1000;
      distance = double.parse((distance).toStringAsFixed(1));
     // print ("distance = $distance");
      return distance;
    }
  bool isFar(String location) {
      double distance =  getDistance(location);
      //print ("distance in isFar= $distance");
      if(distance.abs() > my_radius) {
        return true;
      }
      return false;
    }
  Future<Position>_getCurrentLocation() async {

    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
  setLocation() async {
    Position loc = await _getCurrentLocation();
    setState(() {
      current_lat = loc.latitude;
      current_lon = loc.longitude;
      //print("*****location is:$current_lat,$current_lon");

    });
  }
  selectRadius(){
    radius_controller.text="$my_radius";
    return AlertDialog(
      content: SingleChildScrollView(
        child: ListBody( children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.number,
              controller: radius_controller,
              decoration: const InputDecoration(
                icon: Icon(Icons.edit),
                border: UnderlineInputBorder(),
                labelText: 'Edit your radius',
              ))
        ],),
      ),
      actions: <Widget>[Row(
        children: [
          TextButton(
            child: Text('OK', style: TextStyle(color: green11,),),
            onPressed: () async{
              setState(() {
                my_radius=double.parse(radius_controller.text.toString());
                my_radius = double.parse((my_radius).toStringAsFixed(1));
              });
              Navigator.of(context).pop();
            },
          ),
          const Spacer(),
          TextButton(
            child: Text('CANCEL', style: TextStyle(color: green11),),
            onPressed: () {Navigator.of(context).pop();},
          ),
        ],
      ),
      ],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
    );
  }

  @override
  void initState() {
    super.initState();
    setLocation();
    setState(() {
      radius_controller.text="$my_radius";
    });
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    firebaseUser = Provider.of<AuthRepository>(context);
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget? _buildBody() {
    // TODO: return a widget representing a page
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Material(
        child: Container(
          color: Colors.white,
          child: Column(
            // we have 4 elements in Column
            // 1. hello, name & picture
            // 2. scan car & get help button
            // 3. requests sentence
            // 4. all requests
            children: [
              //TODO ///////////
              box, box,
              Container(
                height: MediaQuery.of(context).size.height*0.12,
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        padding: paddingLeft20,
                        child:
                        FittedBox(
                          fit: BoxFit.fill,
                          child: getText("Hello,\n"+firebaseUser.firstName.toString(),
                              Colors.black, 38, true),
                        ),
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
                ),
              ),
              // box, box,
              getSizeBox(5),
              Container(
                // width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.25,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          makeBoxWithPic('assets/images/camera.png', 107, 105,
                              'Scan Car', 158, 158, blue2, Colors.black, 28,
                                  (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ScanCarOptionScreen()),
                                );
                              }
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
                    ),
                  ],
                ),
              ),
              getSizeBox(10),
              //TODO ///////////
              // now building the list
              // makeBox("sign out", 100, 50, grey, Colors.black, 18, onPress)
              Container(
                width:size.width,
                padding: const EdgeInsets.only(top: 10.0),
                child:Column(
                  children: [Row(mainAxisAlignment:MainAxisAlignment.center,children:[  Text('People Who Need Help',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(alignment:Alignment.centerRight,child:IconButton(icon:Icon(Icons.settings,color: green11,), onPressed: () { showDialog(context: context,  builder:(BuildContext context) {return selectRadius(); });},))
                  ]
              )

                  ],
                ),
                decoration: BoxDecoration(color:blue3,borderRadius:BorderRadius.only(topLeft:Radius.circular(20),topRight:Radius.circular(20),bottomLeft: Radius.zero,bottomRight: Radius.zero)),
              ),
              (firebaseUser.user == null) ? Container() :
              Flexible(
                  fit: FlexFit.tight,
                  child: Container(
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
                            shrinkWrap: true,
                            children: snapshot.data!.docs.map((doc){
                              late String location;
                              try{
                               location=doc.get('location');
                              }
                              catch(e) {
                                location=defaultLocation;
                                //print("***error in location**");
                              };
                              //if(location==""){location=defaultLocation;}
                              return ((doc.get('sender') == firebaseUser.user!.uid)||isFar(location))
                                  ? Wrap() :
                              Padding(
                                padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                                child: Card(
                                  shape: RoundedRectangleBorder(/*side:BorderSide(color: Colors.grey,width: 2.0),*/borderRadius:BorderRadius.all(Radius.circular(20))),
                                  shadowColor: Colors.black,//Colors.grey.shade200,
                                  color: Colors.white,
                                  child: ListTile(
                                    title: Column(
                                      children: [
                                        Text("${doc.get('sender_name')}"+
                                            " needs help with ${doc.get('type')}.", style:
                                        TextStyle(color: Colors.black, fontSize: 20),),
                                        box,
                                        Container(
                                          height: 30,
                                          child: Center(child:Row(mainAxisAlignment:MainAxisAlignment.center,
                                            children: [
                                              // View location button
                                              Material(
                                                borderRadius: BorderRadius.circular(20.0), color: blue6,
                                                child: MaterialButton(
                                                onPressed: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                                      MyMapView(location,current_lat,current_lon)));
                                                                                                  },
                                                child:Row(children:[Icon(Icons.location_on), Text('View Location',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),),
                                                ]),
                                              )),
                                              SizedBox(width: 20,),
                                              // i can help button
                                           Material(
                                            borderRadius: BorderRadius.circular(20.0),
                                            color: blue6,
                                            child:TextButton(child: Text('I can help',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),),
                                                onPressed: () {
                                                  _onOfferHelp(doc.get('type'), context, doc.get('sender'));
                                                },
                                              ),
                                            ),
                                          ]
                                          )),
                                        ),
                                        Container(
                                          alignment: Alignment.bottomRight,
                                          child: getText( ""+getDistance(location).toString()+" km away"+ "   ",Colors.blueGrey, 11, false),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),//.removeWhere((value) => value == null),
                          );
                          // mylist.removeWhere((value) => value == null);
                          // return mylist;
                        }
                      },
                    ),
                  )),
            ],),
        ),
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
                        FirebaseAuth.instance.currentUser!.uid, to,"");
                    await m.SendHelpOffer();
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  NavigationBar()));
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


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}

