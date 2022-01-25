// import 'package:car_call/models/chat_message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../auth_repository.dart';
import '../../chat_alert_block_auth.dart';
import '../../dataBase.dart';
import '../../globals.dart';
import 'package:intl/intl.dart';

final appBarColor = green11;
final appAppBarTextColor = Colors.white;

final myMessageColor = Colors.white;
final myTextBackgroundColor = const Color.fromRGBO(6,133,138,1);

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

  final db = getDB();

  String userId;
  String userName;
  String peerId;
  String peerName;
  String peerAvatar;
  String chatRoomId = "";
  List<QueryDocumentSnapshot> listMessage = [];
  int _limit = 15;
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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    UserLeavesroom(chatRoomId);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthRepository>(context);
    UserEnterRoom(chatRoomId);
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: green11,
          toolbarHeight: screenWidth(context)*0.18,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: (){
                      // update last message to seen
                      db.collection('messageAlert').doc(userId).collection('Peers').doc(peerId).update({'seen':true});
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back,color: appAppBarTextColor,),
                  ),
                  SizedBox(width: 2,),
                  FutureBuilder(
                    future: auth.getPeerImageUrl(peerId, peerAvatar),
                    builder: (BuildContext context,
                        AsyncSnapshot<String> snapshot) {
                      return Container(
                        // padding: paddingRight20,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: (snapshot.data == null)
                              ? null
                              : NetworkImage(snapshot.data!),
                        ),
                      );
                    },
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
                  InkWell(
                    onTap: onBlockUser,
                    customBorder: CircleBorder(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.block,color: appAppBarTextColor,),
                        FittedBox(
                          fit: BoxFit.fill,
                          child: getText("block", appAppBarTextColor, 15, false),
                        ),
                      ],
                    ),
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
                  buildMessage(index, snapshot.data!.docs[index]),
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
        width: screenWidth(context), // changed
        color: appBarColor,
        child: Row(
          children: <Widget>[
            SizedBox(width: 15,),
            Expanded(
              child: Container(
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
    print("sending 1 ********************");
    ///Check if message is empty or not
    // print("the message is $message");
    if (message.trim() != '') {
      ///Add myself to peer's list of contacts in the first spot of the list
      var blockAuth = BlockAuth(context);
      // check if I blocked this peer
      bool isBlockedPeer = !(await blockAuth.isUnBlocked(userId, peerId));
      if (isBlockedPeer == true) {
        //I can't send message until I unlock him
        blockAuth.showUnBlockMessagesDialog(peerId);
        return;
      }
      // check if I am sending a message to peer who blocked me
      bool isBlockedUser = !(await blockAuth.isUnBlocked(peerId, userId));
      if (isBlockedUser) {
        Fluttertoast.showToast(
            msg: "You can't send message to this user.",
            backgroundColor: Colors.black,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_LONG);
        return;
      }
      textEditingController.clear();
      String time = DateTime.now().millisecondsSinceEpoch.toString();

      ///Add myself to peer's list of contacts in the first spot of the list
      updateMessageAlert(message, time, peerId, userId, userName, false);

      ///Add peer to my list of contacts in the first spot of the list
      updateMessageAlert(message, time, userId, peerId, peerName, true);

      ///Make a message document in firebase
      db.collection('messages').doc(chatRoomId).collection(chatRoomId)
          .doc(time).set(
          {
            'idFrom': userId,
            'senderName': userName,
            'idTo': peerId,
            'timestamp': time,
            'content': message,
          }
      );
    }
    else {
      Fluttertoast.showToast(
          msg: 'Please enter a message before sending.',
          backgroundColor: Colors.black,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG);
    }
  }

  Widget buildMessage(int index, DocumentSnapshot doc) {
    final id = doc.get('idFrom');
    if (id == userId) {
      // Right (my message)
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(
              screenWidth(context) * 0.023 * 6/10*3,
              screenWidth(context) * 0.023 * 6/10,
              screenWidth(context) * 0.023 * 6/10*3,
              screenWidth(context) * 0.023 * 6/5,
            ),
            width: screenWidth(context) * 0.023 * 6 *4,
            decoration: BoxDecoration(
                color: myTextBackgroundColor,
                borderRadius: BorderRadius.only(
                    topLeft:Radius.circular(20),
                    topRight:Radius.zero,
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            margin: EdgeInsets.only(
              bottom: screenWidth(context) * 0.023 * 6/5,
              right: screenWidth(context) * 0.023 * 6/5,
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
                  borderRadius: BorderRadius.only(
                      topLeft:Radius.zero,
                      topRight:Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
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

  void onBlockUser(){
    // if I locked someone I don't want to recieve from him any message & alert
    // I want to block this user so I don't receive any message from him
    // & I can't send to him messages until I unblock him

    // first add this person to my blocked people
    var blockAuth = BlockAuth(context);
    blockAuth.showBlockDialog(peerId,'annoying messages');

    // second
  }

  // other- the user that i add for him the last message with me
  Future<void> updateMessageAlert(String message, String time, String other,
      String me, String meName, bool seen) async {
    var data = {
      'id': me,
      'name': meName,
      'lastMessage': message,
      'timestamp': time,
      'seen': seen ,
    };

    await db.collection('messageAlert').doc(other).collection('Peers').doc(me).set(data);

  }

  UserEnterRoom(String chatRoom){
    db.collection('messages').doc(chatRoomId).collection('users').doc(userId).set(
        {'in':true}
    );
  }

  UserLeavesroom(String chatRoom){
    db.collection('messages').doc(chatRoomId).collection('users').doc(userId).delete();
  }
}