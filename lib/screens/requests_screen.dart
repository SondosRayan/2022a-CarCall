import 'package:car_call/auth_repository.dart';
import 'package:car_call/screens/get_help_screens/get_help_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../globals.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({Key? key}) : super(key: key);

  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  late AuthRepository auth ;
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context){
    auth = Provider.of<AuthRepository>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: green11,
        title: const Text('My Requsets'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('Users').doc(auth.user!.uid)
            .collection('Requests').snapshots(),
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
                      Text("You asked for help with ${doc.get('type')}.", style:
                      TextStyle(color: green11),)                        ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}