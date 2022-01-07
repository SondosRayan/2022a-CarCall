import 'package:car_call/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../globals.dart';
import 'get_help_screens/get_help_screen.dart';

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
      floatingActionButton: MaterialButton(
        child: Text("+ create help request", style: TextStyle(color:Colors.white),),
        color: green11,
        shape: RoundedRectangleBorder(
            borderRadius:BorderRadius.all(Radius.circular(20.0))),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GetHelpScreen()),
          );
        },),
      //TextButton(
      //  style: TextStyle,
      //  onPressed: (){}, child: Text('create new request'),
      //),
      backgroundColor: blue1,
      appBar: AppBar(
        backgroundColor: green11,
        automaticallyImplyLeading: false,
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
              children: snapshot.data!.docs.map((doc){
                return Card(
                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(10.0))),
                  child: ListTile(
                    trailing: IconButton(icon: Icon(Icons.delete), color: blue6,
                      onPressed: () async {
                        await confirmDeleteDialog(doc, context);
                      },),
                      title: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: "You asked for help with ", style: TextStyle(color: green11),),
                            TextSpan(text: doc.get('type'), style: TextStyle(color: green11, fontWeight: FontWeight.bold),),
                            TextSpan(text: ".", style: TextStyle(color: green11),),
                          ]
                        ),
                      ),),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }

  Future<void> confirmDeleteDialog(doc, BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: SingleChildScrollView(
            child: RichText(
              text: TextSpan(
                  children: [
                    TextSpan(text: "Are you sure you want to cancel your ", style: TextStyle(color: green11),),
                    TextSpan(text: doc.get('type'), style: TextStyle(color: green11, fontWeight: FontWeight.bold),),
                    TextSpan(text: " request?", style: TextStyle(color: green11),),
                  ]
              ),)
          ),
          actions: <Widget>[
            Row(
              children: [
                TextButton(
                  child: Text('YES', style: TextStyle(color: green11)),
                  onPressed: () async {
                    await _onDeleteRequest(doc);
                    Navigator.of(context).pop();
                  },
                ),
                const Spacer(),
                TextButton(
                  child: Text('NO', style: TextStyle(color: green11)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },),
              ],),
          ],
        );
      },
    );
  }

  _onDeleteRequest(doc) async {
    String request_id = "";
    await db.collection('Users').doc(auth.user!.uid).collection('Requests').doc(doc.id).get()
        .then((snapshot){
          request_id = snapshot.get('request_id');
        });
    await db.collection('Users').doc(auth.user!.uid).collection('Requests').doc(doc.id).delete();
    await db.collection('Requests').doc(request_id).delete();
    print("request deleted successfully!"); //TODO: implement delete request!
  }

}
