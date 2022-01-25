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
                  backgroundColor: blue7,
                  appBar: AppBar(
                    centerTitle: true,
                    backgroundColor: green11,
                    automaticallyImplyLeading: false,
                    title: getText("Chat", Colors.white, 30, true),
                  ),
                  body: Container(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: db.collection('messageAlert').doc(auth.user!.uid)
                          .collection('Peers').orderBy('timestamp', descending: true).snapshots(),
                      builder: (context, snapshot) {
                        if(!snapshot.hasData){ // ?????
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.data!.docs.isEmpty) {
                          return ListView(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  getSizeBox(screenHeight(context)*0.08),
                                  /*getText("You haven't chat with anyone",
                                      green11, 18, true),*/
                                  getText("sorry, no messages to show",
                                      Colors.grey.shade600, 18, true),
                                  getSizeBox(screenHeight(context)*0.05),
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 500),
                                    // height: screenHeight(context)*0.75,
                                    width: screenWidth(context)*0.9,
                                    child: Image.asset('assets/images/no-search-results.gif'),),
                                ],
                              ),
                            ],
                          );
                        } else {
                          int index = 0;
                          return ListView(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.020),
                            children: snapshot.data!.docs.map((doc){
                              index++;
                              return buildListCard(doc, index);
                            }).toList(),
                          );
                        }
                      }
                    ),
                  ),
                ),
              ]),

    );

  }

  Widget buildListCard(QueryDocumentSnapshot doc, int position){
    String peerId = doc.get('id');
    // await auth.getUserFullName(peerId)
    String name=doc.get('name'); // TODO to get the full name
    String lastMessage = doc.get('lastMessage');
    String message_time = doc.get('timestamp');
    bool seen = doc.get('seen');

    DateTime message_date = DateTime.fromMillisecondsSinceEpoch(
        int.parse(message_time));
    Duration diff = DateTime.now().difference(message_date);
    String stringTimeAgo = getDifference(diff);

    return AnimationConfiguration.staggeredList(
        position: position,
        duration: const Duration(milliseconds: 1500),
        child: SlideAnimation(
          verticalOffset: 200.0,
          child: FadeInAnimation(
            child: Container(
              padding: EdgeInsets.only(bottom: s10(context)),
              child: MaterialButton(
                color: blue4,
                padding: getPaddingAll(s10(context)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(s10(context))),
                onPressed: () {
                  var uidd = auth.user!.uid;
                  db.collection('messageAlert').doc(uidd).collection('Peers').doc(peerId).update({'seen':true});
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChatRoomScreen(
                      userId: uidd,
                      userName: auth.fullName, // TODO
                      peerId: peerId,
                      peerName: name,
                      peerAvatar: getNameAvatar(name),
                    );
                  })).then((_) => f_reload());
                },
                child: Row(
                  children: [
                    // the image
                    FutureBuilder(
                      future: auth.getPeerImageUrl(peerId, getNameAvatar(name)),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Container(
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: (snapshot.data == null)
                                ? null
                                : NetworkImage(snapshot.data!),
                          ),
                        );
                      },
                    ),
                    // by column we need the name & last message
                    Flexible(
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.only(left: s10(context)),
                          child: Column(
                            children: [
                              // getText(name, green11, 22, true),
                              Text(name,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 22,
                                    color: green11,
                                    fontWeight: FontWeight.w900,
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
                    Column(
                      children: [
                        seen ? Container() : /*Icon(Icons.circle, color: lightGreen1),*/
                        GradientIcon(
                          Icons.circle,
                          25.0,
                          LinearGradient(
                            colors: <Color>[
                              green11,
                              lightGreen1,
                              green2,
                              green11,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        getSizeBox(5),
                        getText(stringTimeAgo, green11, 11 , false),//TODO
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),);
  }

  void f_reload() {
    setState(() {});
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class GradientIcon extends StatelessWidget {
  GradientIcon(
      this.icon,
      this.size,
      this.gradient,
      );

  final IconData icon;
  final double size;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: SizedBox(
        width: size * 1.2,
        height: size * 1.2,
        child: Icon(
          icon,
          size: size,
          color: Colors.white,
        ),
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return gradient.createShader(rect);
      },
    );
  }
}