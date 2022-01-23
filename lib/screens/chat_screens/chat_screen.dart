import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_call/globals.dart';
import 'package:car_call/screens/chat_screens/chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../auth_repository.dart';
import '../../dataBase.dart';

Set<String> UnreadMessages = Set<String>();

class ChatScreen extends StatefulWidget {
  ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with AutomaticKeepAliveClientMixin {

  late AuthRepository auth ;
  final db = getDB();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    auth = Provider.of<AuthRepository>(context);

    return auth.user == null ? Container()
        : Material(
        child:
           Stack(
              children: <Widget>[
                Scaffold(
                  resizeToAvoidBottomInset: true,
                  backgroundColor: blue2,
                  appBar: AppBar(
                    centerTitle: true,
                    backgroundColor: green11,
                    automaticallyImplyLeading: false,
                    title: getText("Chat", Colors.white, 30, true),
                  ),
                  body: Container(
                    child: FutureBuilder(
                      future: db.collection('messageAlert').doc(auth.user!.uid).get(),
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        if (!snapshot.hasData || snapshot.connectionState != ConnectionState.done) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }else{
                          return ListView.builder(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.020),
                              itemCount: snapshot.data['users'].length,
                              itemBuilder: (context, index){
                                var peersList = snapshot.data['users'][index]; //this
                                return buildListCard(peersList, index);
                              });
                        }
                    },
                    ),
                  ),
                ),
              ]),

    );

  }

  Widget buildListCard(Map peers, int position){
    String peerId = peers['id'];
    String name=peers['name'];
    String lastMessage = peers['lastMessage'];
    String message_time = peers['timestamp'];

    DateTime message_date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(message_time));
    Duration diff = DateTime.now().difference(message_date);
    String stringTimeAgo = getDifference(diff);

    String imageUrl =
        "https://ui-avatars.com/api/?bold=true&background=random&name=" +
            name;

    return AnimationConfiguration.staggeredList(
        position: position,
        duration: const Duration(milliseconds: 1500),
        child: SlideAnimation(
          verticalOffset: 200.0,
          child: FadeInAnimation(
            child: Container(
              padding: EdgeInsets.only(bottom: s10(context)),
              child: MaterialButton(
                color: blue5,
                padding: getPaddingAll(s10(context)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(s10(context))),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChatRoomScreen(
                      userId: auth.user!.uid,
                      userName: auth.fullName,
                      peerId: peerId,
                      peerName: name,
                      peerAvatar: '',
                    );
                  })).then((_) => f_reload());
                },
                child: Row(
                  children: [
                    // the image
                    Material(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      clipBehavior: Clip.hardEdge,
                      child: imageUrl != ''
                          ? CachedNetworkImage( // TODO
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.0,
                            valueColor: AlwaysStoppedAnimation<Color>(green11),
                          ),
                          width: s50(context) * 1.2,
                          height: s50(context) * 1.2,
                          padding: EdgeInsets.all(s5(context) * 3),
                        ),
                        imageUrl: imageUrl,
                        width: s50(context) * 1.2,
                        height: s50(context) * 1.2,
                        fit: BoxFit.cover,
                      )
                          : Icon(
                        Icons.account_circle,
                        size: s50(context),
                        color: Colors.grey,
                      ),
                    ),
                    // by column we need the name & last message
                    Flexible(
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.only(left: s10(context)),
                          child: Column(
                            children: [
                              Text(name,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    shadows: [
                                      Shadow(
                                        // bottomLeft
                                          offset: Offset(-1, -1),
                                          color: green11),
                                      Shadow(
                                        // bottomRight
                                          offset: Offset(1, -1),
                                          color: green11),
                                      Shadow(
                                        // topRight
                                          offset: Offset(1, 1),
                                          color: green11),
                                      Shadow(
                                        // topLeft
                                          offset: Offset(-1, 1),
                                          color: green11),
                                    ],
                                ),
                              ),
                              Text(lastMessage,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: green11,
                                ),
                              ),
                              // getText(lastMessage, green11, 15, false),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // time passed
                    Container(
                      // padding: EdgeInsets.only(left: 10.0 , right: 10.0),
                      child: getText(stringTimeAgo, green11, 11 , false),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),);
  }

  Widget buildListTile(BuildContext context, Map listItem,
      /*AsyncSnapshot<String> imageUrlAsync,*/int index) {

    String name=listItem['name'];
    String lastMessage = listItem['lastMessage'];
    String time = listItem['timestamp'];
    /*
    late String imageUrl;
    try{
      imageUrl = imageUrlAsync.data!;
    }catch(e){
      print(e);
      //if (imageUrl == null)
      imageUrl =
          "https://ui-avatars.com/api/?bold=true&background=random&name=" +
              name;
    }
     */
    String? imageUrl = null;
    if (imageUrl == null) {
      imageUrl =
          "https://ui-avatars.com/api/?bold=true&background=random&name=" +
              name;
    }

    return Container(
      padding: EdgeInsets.only(bottom: s10(context)),
      child: FlatButton(
        color: blue5,
        padding: EdgeInsets.fromLTRB(
            s25(context), s10(context), s25(context), s10(context)),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(s10(context))),
        onPressed: () {
          setState(() {
            // this.userID = userID;
            // this.peerId=listItem['id'];
            // this.peerName = listItem['name'];
            // this.imageUrl = imageUrl;
            // this.lastMessage = lastMessage;
            // this.inChat = true;
          });
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ChatRoomScreen(
              userId: auth.user!.uid,
              userName: auth.fullName,
              peerId: listItem['id'],
              peerName: listItem['name'],
              peerAvatar: '',
            );
          }));
        },
        child: Row(
          children: [
            // the image of peerId
            Material(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              clipBehavior: Clip.hardEdge,
              child: imageUrl != ''
                  ? CachedNetworkImage( // TODO
                placeholder: (context, url) => Container(
                  child: CircularProgressIndicator(
                    strokeWidth: 1.0,
                    valueColor: AlwaysStoppedAnimation<Color>(green11),
                  ),
                  width: s50(context) * 1.2,
                  height: s50(context) * 1.2,
                  padding: EdgeInsets.all(s5(context) * 3),
                ),
                imageUrl: imageUrl,
                width: s50(context) * 1.2,
                height: s50(context) * 1.2,
                fit: BoxFit.cover,
              )
                  : Icon(
                Icons.account_circle,
                size: s50(context),
                color: Colors.grey,
              ),
            ),
            Flexible(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.01),
                        child: Column(
                          children: [
                            Text(
                              name,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      // bottomLeft
                                        offset: Offset(-1, -1),
                                        color: green11),
                                    Shadow(
                                      // bottomRight
                                        offset: Offset(1, -1),
                                        color: green11),
                                    Shadow(
                                      // topRight
                                        offset: Offset(1, 1),
                                        color: green11),
                                    Shadow(
                                      // topLeft
                                        offset: Offset(-1, 1),
                                        color: green11),
                                  ],
                                  fontWeight: FontWeight.w900),
                            ),
                            getText(lastMessage, green11, 15, false),
                          ],
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(
                          s10(context), 0.0, 0.0, s5(context)),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(left: s10(context)),
              ),
            ),
            getText(
                DateFormat('kk:mm').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        int.parse(time))),
                green11, 15 , false),
          ],
        ),
      ),
    );
  }

  void f_reload() {
    setState(() {});
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}