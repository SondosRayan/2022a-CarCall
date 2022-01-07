
import 'package:car_call/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../globals.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  Set<my_message> _alerts = <my_message>{};
  late AuthRepository auth ;
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context){
    auth = Provider.of<AuthRepository>(context);
    return Scaffold(
      backgroundColor: blue1,
          appBar: AppBar(
            backgroundColor: green11,
            automaticallyImplyLeading: false,
            /*bottom: const TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(icon: Text("Alerts")),
                Tab(icon: Text("Help Offers")),
              ],
            ),*/
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
                        .collection('Alerts').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView(
                          children: snapshot.data!.docs.map((doc){
                            return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:BorderRadius.all(Radius.circular(10.0))),
                              child: ListTile(
                                  trailing: IconButton(icon: Icon(Icons.block), color: green11,
                                    onPressed: (){},
                                  ),
                                  title:
                                  RichText(
                                    text: TextSpan(
                                        children: [
                                          TextSpan(text: "Hi ${auth.firstName}, ${doc.get('sender_name')}"
                                            +" sent you an alert about ", style: TextStyle(color: green11),),
                                          TextSpan(text: doc.get('type'), style: TextStyle(color: green11, fontWeight: FontWeight.bold),),
                                          TextSpan(text: ".", style: TextStyle(color: green11),),
                                        ]
                                    ),
                                  )
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
                            return Card(
                              shape: RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(10.0))),
                              child: ListTile(
                                trailing: IconButton(icon: Icon(Icons.chat),color: green11, onPressed: () {},),
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

}