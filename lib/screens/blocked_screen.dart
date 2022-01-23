import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth_repository.dart';
import '../chat_alert_block_auth.dart';
import '../dataBase.dart';
import '../globals.dart';

class BlockedScreen extends StatefulWidget {
  const BlockedScreen({Key? key}) : super(key: key);

  @override
  _BlockedScreenState createState() => _BlockedScreenState();
}

class _BlockedScreenState extends State<BlockedScreen> {

  final DocumentReference<Map<String, dynamic>> db = getDB();
  late AuthRepository auth ;

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthRepository>(context);
    return Scaffold(
      backgroundColor: blue1,
      appBar: AppBar(
        backgroundColor: green11,
        title: const Text('Blocked'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('Users').doc(auth.user!.uid)
            .collection('blocked').snapshots(),
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
                      trailing: TextButton(child: Text('unblock', style: TextStyle(color: green11),),
                        onPressed: (){
                          var blockAuth = BlockAuth(context);
                          blockAuth.showUnBlockDialog(doc.id);
                        },
                      ),
                      title:Text(doc.get('name'), style: TextStyle(color:green11)),
                    )
                  );
              }).toList(),
            );}
          },
      ),
    );
  }
}
