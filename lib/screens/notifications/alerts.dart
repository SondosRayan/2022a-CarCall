
import 'package:car_call/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../dataBase.dart';
import '../../globals.dart';
import '../chat_room.dart';
import '../navigation_bar.dart';

Set<String> UnreadNotifications = Set<String>();


class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>{
  late AuthRepository auth ;
  final db = getDB();



  @override
  Widget build(BuildContext context){
    auth = Provider.of<AuthRepository>(context);

    return Scaffold(
      backgroundColor: blue1,
      appBar: AppBar(
        backgroundColor: green11,
        automaticallyImplyLeading: false,

        title: const Text('Notifications'),
        centerTitle: true,

      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Container(
              constraints: BoxConstraints(maxHeight: 150.0),
              child: Material(
                shadowColor: Colors.black,
                color: Color.fromRGBO(95,157,165,1),
                child: TabBar(
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(icon: Text("Alerts")),
                    Tab(icon: Text("Help Offers")),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: db.collection('Users').doc(auth.user!.uid)
                        .collection('Alerts').orderBy('timestamp', descending: true).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView(
                          children: snapshot.data!.docs.map((doc){
                            Timestamp notification_time = doc.get('timestamp');
                            DateTime notification_date = notification_time.toDate();
                            Duration diff = DateTime.now().difference(notification_date);
                            String stringTimeAgo = getDifference(diff);
                            if(doc.get('read') == false){
                              UnreadNotifications.add('A'+doc.id);
                            }

                            return GestureDetector(
                              onTap: () => {
                                setState(() {
                                  doc.reference.update({'read': true});
                                  UnreadNotifications.remove('A'+doc.id);
                                })
                              },
                              child: Card(
                                color : (doc.get('read') == true? Colors.white : blue2),
                                shape: RoundedRectangleBorder(
                                    borderRadius:BorderRadius.all(Radius.circular(10.0))),
                                child: Column(
                                  children: [
                                    ListTile(
                                        trailing: IconButton(icon: Icon(Icons.block), color: green11,
                                          onPressed: (){
                                            _showBlockDialog(doc.get('sender'), context);
                                          },
                                        ),
                                        title:
                                        RichText(
                                          text: TextSpan(
                                              children: [
                                                TextSpan(text: "Hi ${auth.firstName}, ${doc.get('sender_name')}"
                                                    +" sent you an alert about ", style: TextStyle(color: green11),),
                                                TextSpan(text: doc.get('type'), style: TextStyle(color: green11, fontWeight: FontWeight.bold),),
                                                TextSpan(text: ".", style: TextStyle(color: green11),),
                                                TextSpan(text: (doc.get('type') == 'Car Crash')?
                                                "You can contact ${doc.get('sender_name')} on this phone number "
                                                    +doc.get('phoneNumber')+"."
                                                    : null, style: TextStyle(color: green11) ),
                                              ]
                                          ),
                                        )
                                    ),
                                    Column(
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              alignment: Alignment.bottomRight,
                                              child: getText( stringTimeAgo+ "   ",Colors.blueGrey, 11, false),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),

                        );
                      }
                    },
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: db.collection('Users').doc(auth.user!.uid)
                        .collection('Offers').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView(
                          children: snapshot.data!.docs.map((doc){
                            Timestamp notification_time = doc.get('timestamp');
                            DateTime notification_date = notification_time.toDate();
                            Duration diff = DateTime.now().difference(notification_date);
                            String stringTimeAgo = getDifference(diff);
                            if(doc.get('read') == false){
                              UnreadNotifications.add('O'+doc.id);
                            }

                            return GestureDetector(
                              onTap: () => {
                                setState(() {
                                  doc.reference.update({'read': true});
                                  UnreadNotifications.remove('O'+doc.id);
                                })
                              },
                              child: Card(
                                color : (doc.get('read') == true? Colors.white : blue2),
                                shape: RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(10.0))),
                                child: Column(
                                  children: [
                                    ListTile(
                                        trailing: IconButton(icon: Icon(Icons.chat),color: green11,
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) =>
                                                  ChatRoomScreen(
                                                    userId: auth.user!.uid,
                                                    userName: auth.fullName,
                                                    peerId: doc.get('sender'),
                                                    peerName: doc.get('sender_name'),
                                                    peerAvatar: "",) //TODO
                                              ),
                                            );
                                          },
                                        ),
                                        title:
                                        RichText(
                                          text: TextSpan(
                                              children: [
                                                TextSpan(text: "Hi ${auth.firstName}, you received a help offer from "
                                                    +"${doc.get('sender_name')}, regarding your ",
                                                  style: TextStyle(color: green11),),
                                                TextSpan(text: doc.get('type'), style: TextStyle(color: green11, fontWeight: FontWeight.bold),),
                                                TextSpan(text: " request.", style: TextStyle(color: green11),),
                                              ]
                                          ),
                                        )
                                    ),
                                    Container(
                                      alignment: Alignment.bottomRight,
                                      child: getText( stringTimeAgo + "   ",Colors.blueGrey, 11, false),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );}
                    },)
                ],
              ),
            ),
          ],
        ),
      ),        );
  }

  Future<void> _showBlockDialog(String to_Block, context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody( children: <Widget>[
              Text('Are you sure you want to block this user?')
            ],
            ),
          ),
          actions: <Widget>[Row(
            children: [
              TextButton(
                child: Text('Yes', style: TextStyle(color: green11,),),
                onPressed: () async{
                  auth.blockUser(to_Block, 'annoying alerts');
                  Navigator.of(context).pop();
                },
              ),
              const Spacer(),
              TextButton(
                child: Text('No', style: TextStyle(color: green11),),
                onPressed: () {Navigator.of(context).pop();},
              ),
            ],
          ),
          ],
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
        );
      },
    );
  }

  String getDifference(Duration diff){
    int DaysAgo = diff.inDays;
    int HoursAgo = diff.inHours;
    int MinutesAgo = diff.inMinutes;
    int secondsAgo = diff.inSeconds;
    String stringTimeAgo = "";
    if(DaysAgo > 0){
      if(HoursAgo == 1){
        stringTimeAgo = DaysAgo.toString()+" Day Ago";
      }else{
        stringTimeAgo = DaysAgo.toString()+" Days Ago";
      }
    }
    else if(HoursAgo > 0){
      if(HoursAgo == 1){
        stringTimeAgo = HoursAgo.toString()+" Hour Ago";
      }else{
        stringTimeAgo = HoursAgo.toString()+" Hours Ago";
      }
    }
    else if(MinutesAgo >0){
      if(HoursAgo == 1){
        stringTimeAgo = MinutesAgo.toString()+" Minute Ago";
      }else{
        stringTimeAgo = MinutesAgo.toString()+" Minutes Ago";
      }
    }
    else if(secondsAgo >=3){
      stringTimeAgo = secondsAgo.toString()+" Seconds Ago";
    }
    else{
      stringTimeAgo = "just now";
    }
    return stringTimeAgo;
  }





}

