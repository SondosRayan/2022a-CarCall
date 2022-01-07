
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
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: green11,
            bottom: const TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(icon: Text("Alerts")),
                Tab(icon: Text("Help Offers")),
              ],
            ),
            title: const Text('Notifications'),
            centerTitle: true,

          ),
          body: TabBarView(
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
                    children: snapshot.data!.docs.map((doc) {
                      return Card(
                        child: ListTile(
                          title:
                          Text("Hi ${auth.firstName}, "+
                              "${doc.get('sender_name')}"+
                              " sent you an alert about ${doc.get('type')}.", style:
                          TextStyle(color: green11),)                        ),
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
                      children: snapshot.data!.docs.map((doc) {
                        return Card(
                          child: ListTile(
                            title:
                            Text("Hi ${auth.firstName}, you received a help offer from "+
                                "${doc.get('sender_name')}"+
                                ", regarding your ${doc.get('type')} request", style:
                            TextStyle(color: green11),)
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              )
            ],
          ),
        ),
      );
  }


}

/*

  @override
  Widget build(BuildContext context){
    auth = Provider.of<AuthRepository>(context);

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Text("Alerts")),
                Tab(icon: Text("Help Offers")),
              ],
            ),
            title: const Text('Notifications'),
          ),
          body: TabBarView(
            children: [
              StreamBuilder(
              stream: db.collection('Users')
                  .doc(auth.user!.uid).collection('Alerts')
                  .snapshots(),
              builder: (context, snapshot){
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  auth.getUserAlerts(); //TODO: check
                  _alerts = auth.alerts;
                  return _buildAlerts(snapshot);
                }

              }),
              ListView(

              )
            ],
          ),
        ),
      );
  }

 */

