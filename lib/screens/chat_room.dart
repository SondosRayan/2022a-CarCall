// import 'package:car_call/models/chat_message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../dataBase.dart';
import '../globals.dart';
import 'package:intl/intl.dart';
// import 'package:http/http.dart';
// import 'package:cached_network_image/cached_network_image.dart';

// final messages = [];
final appBarColor = green11;
final appAppBarTextColor = Colors.white;

final myMessageColor = Colors.white;
final myTextBackgroundColor = green11;

final peerMessageColor = green11;
final peerTextBackgroundColor = blue3;

final backgroundColor = blue1;

class ChatRoomScreen extends StatefulWidget{
  final String userId;
  final String userName;
  final String peerId;
  final String peerName;
  final String peerAvatar;
  ChatRoomScreen({Key? key, required this.userId, required this.userName,
    required this.peerId, required this.peerName, required this.peerAvatar})
      : super(key: key);

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState(
      userId: userId, userName: userName,
      peerId: peerId, peerName: peerName, peerAvatar: peerAvatar);
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  _ChatRoomScreenState({Key? key, required this.userId, required this.userName,
    required this.peerId, required this.peerName, required this.peerAvatar});

  String userId;
  String userName;
  String peerId;
  String peerName;
  String peerAvatar;

  String chatRoomId = "";

  List<QueryDocumentSnapshot> listMessage = [];
  int _limit = 15; //?????
  bool isLoading = false;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    if (userId.hashCode <= peerId.hashCode) {
      chatRoomId = '$userId-$peerId';
    } else {
      chatRoomId = '$peerId-$userId';
    }
    listScrollController.addListener((){
      if (listScrollController.offset >=
          listScrollController.position.maxScrollExtent &&
          !listScrollController.position.outOfRange) {
        setState(() {
          _limit += 15;
        });
      }
    });
    focusNode.addListener((){
      focusNode.hasFocus? setState((){}):null;
    });
    isLoading = false;
    // print("the id of sending message is: $userId his name is $userName");
    // print("the id of receiving message is: $peerId his name is $peerName");
    // print("the id of chatters is: $chattersId");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: green11,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back,color: appAppBarTextColor,),
                  ),
                  SizedBox(width: 2,),
                  CircleAvatar(
                    backgroundImage: null,
                    maxRadius: 20,
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        getText(peerName, appAppBarTextColor, 20, true),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.block,color: appAppBarTextColor,),
                      FittedBox(
                        fit: BoxFit.fill,
                        child: getText("block", appAppBarTextColor, 15, false),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: buildListMessage(),
              ),
              buildBottomArea(),
            ],
          ),
          isLoading ? Center(child:CircularProgressIndicator()) : Container()
        ],
      ),
    );
  }

  Widget buildListMessage() {
    final db = getDB();
    return Container(
      color: backgroundColor,
      child: chatRoomId == ''
          ? Center(
          child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
        stream: db.collection('messages').doc(chatRoomId).collection(chatRoomId)
            .orderBy('timestamp', descending: true)
            .limit(_limit)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator());
          } else {
            // return Container();
            listMessage.addAll(snapshot.data!.docs);
            return ListView.builder(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.023 * 6/5),
              itemBuilder: (context, index) =>
                  buildItem(index, snapshot.data!.docs[index]),
              itemCount: snapshot.data!.docs.length,
              reverse: true,
              controller: listScrollController,
            );
          }
        },
      ),
    );

  }

  Widget buildBottomArea() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
        height: 60,
        width: double.infinity,
        color: appBarColor,
        child: Row(
          children: <Widget>[
            SizedBox(width: 15,),
            Expanded(
              child: TextField(
                controller: textEditingController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: "Write message...",
                    hintStyle: TextStyle(color: Colors.white),
                    labelStyle: TextStyle(color: Colors.white),
                    /*focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),*/
                    border: InputBorder.none

                ),
              ),
            ),
            SizedBox(width: 15,),
            FloatingActionButton(
              backgroundColor: Colors.white,
              elevation: 0,
              child: Icon(Icons.send,color: appBarColor,size: 18,),
              onPressed: (){
                String message = textEditingController.text;
                // print("before sending the message is $message");
                sendMessage(message);
              },
            ),
          ],

        ),
      ),
    );
  }

  Future<void> sendMessage(String message) async {
    ///Check if message is empty or not
    print("the message is $message");
    if (message.trim() != '') {
      textEditingController.clear();
      ///Add myself to peer's list of contacts in the first spot of the list
      final db = getDB();
      ///??????????????????????????
      ///delete the document of peer in the current user data
      // var collection = db.collection('Users').doc(userId).collection('Messages');
      // var snapshot = await collection.where('peerId', isEqualTo: peerId).get();
      // await snapshot.docs.first.reference.delete();
      /*db.collection('Users').doc(userId).collection('Messages')
          .doc(DateTime.now().millisecondsSinceEpoch.toString()).set(
          {
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'lastMessage': message,
            'peerId': peerId,
            'sentByMe': 'Yes',
            'isRead': 'Yes',
          }
      );*/
      var map=await db.collection('messageAlert').doc(peerId).get();
      late List oldMap;
      try {
        oldMap = map['users'];
        oldMap.removeWhere((element) => element['id']==userId);
      }catch(e){
        print(e);
        oldMap = [];
      }
      // print("hello3");
      List newMap=[{'id':userId,'name':userName}];
      newMap.addAll(oldMap);
      db.collection('messageAlert').doc(peerId).set({'users':newMap});
      ///Add peer to my list of contacts in the first spot of the list
      // var peerDoc=db.collection('Users').doc(peerId).get();
      map=await db.collection('messageAlert').doc(userId).get();
      try {
        oldMap = map['users'];
        oldMap.removeWhere((element) => element['id'] == peerId);
      }catch(e){
        print(e);
        oldMap = [];
      }
      newMap=[{'id':peerId,'name':peerName,'lastMessage': message}];
      newMap.addAll(oldMap);
      db.collection('messageAlert').doc(userId).set({'users':newMap});
      ///??????????????????????????
      ///Make a message document in firebase
      db.collection('messages').doc(chatRoomId).collection(chatRoomId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString()).set(
          {
            'idFrom': userId,
            'senderName': userName,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': message,
          }
      );
      ///?????????????????????????
    }
    else {
      Fluttertoast.showToast(
          msg: 'Please enter a message before sending.',
          backgroundColor: Colors.black,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG);
    }
  }

  Widget buildItem(int index, DocumentSnapshot doc) {
    final id = doc.get('idFrom');
    if (id == userId) {
      // Right (my message)
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.023 * 6/10*3,
              MediaQuery.of(context).size.width * 0.023 * 6/10,
              MediaQuery.of(context).size.width * 0.023 * 6/10*3,
              MediaQuery.of(context).size.width * 0.023 * 6/5,
            ),
            width: MediaQuery.of(context).size.width * 0.023 * 6 *4,
            decoration: BoxDecoration(
                color: myTextBackgroundColor,
                borderRadius: BorderRadius.circular(20.0)),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.width * 0.023 * 6/5,
              right: MediaQuery.of(context).size.width * 0.023 * 6/5,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getText(doc.get('content'), myMessageColor, 15, false),
                Container(
                  alignment: Alignment.bottomRight,
                  child: getText(
                      DateFormat('kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(doc.get('timestamp')))),
                      myMessageColor, 11, false),
                ),
              ],
            ),
          ),
        ],
      );
    }
    else {
      // Left (peer message)
      return Container(
        margin: EdgeInsets.only(bottom: s10(context)),
        child: Row(
          children: <Widget>[
            //Display text message
            Container(
              padding: EdgeInsets.all( s10(context)),
              width: s50(context)*4,
              decoration: BoxDecoration(
                  color: peerTextBackgroundColor,
                  borderRadius: BorderRadius.circular(20.0)),
              margin: EdgeInsets.only(left: s10(context)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getText(doc.get('content'), peerMessageColor, 15, false),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: getText(DateFormat('kk:mm').format(
                        DateTime.fromMillisecondsSinceEpoch(
                            int.parse(doc.get('timestamp')))),
                        peerMessageColor, 11, false),
                  )
                ],
              ),
            )
          ],
        ),
      );
    }
  }
}