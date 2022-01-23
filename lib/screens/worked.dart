import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_call/globals.dart';
import 'package:car_call/screens/chat_screens/chat_room.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../auth_repository.dart';
import '../dataBase.dart';

class ChatScreen extends StatefulWidget {
  // String userID;
  ChatScreen({Key? key, /*required this.userID*/}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState(/*userID*/);
}

class _ChatScreenState extends State<ChatScreen>
    with AutomaticKeepAliveClientMixin {

  late AuthRepository auth ;
  final db = getDB();

  late String userID;
  var peerId;
  var peerName;
  var imageUrl;
  var lastMessage;
  // bool inChat = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    auth = Provider.of<AuthRepository>(context);
    if(auth.user != null){
      userID = auth.user!.uid;
    }
    return auth.user == null ? Container()
        : Material(
        child: Consumer<AuthRepository>(builder: (context, userRep, _) {
          return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Scaffold(
                  resizeToAvoidBottomInset: true,
                  backgroundColor: blue1,
                  appBar: AppBar(
                    centerTitle: true,
                    backgroundColor: green11,
                    automaticallyImplyLeading: false,
                    title:
                    getText("Chat", Colors.white, 30, true),
                  ),
                  body: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Container(
                      child: FutureBuilder(
                        future: db.collection('messageAlert').doc(userID).get(),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if (!snapshot.hasData || snapshot.connectionState != ConnectionState.done) {
                            return Center(
                              child: SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: CircularProgressIndicator(
                                    valueColor: new AlwaysStoppedAnimation<Color>(green11),
                                  )
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            return ListView.builder(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.020),
                              itemCount: snapshot.data['users'].length,
                              itemBuilder: (context, index) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 1500),
                                  child: SlideAnimation(
                                    verticalOffset: 200.0,
                                    child: FadeInAnimation(
                                      child: FutureBuilder(
                                          future: FirebaseStorage.instance
                                              .ref("userImages/")
                                              .child(snapshot.data['users'][index]['id'])
                                              .getDownloadURL(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<String>
                                              imageLink) {
                                            return buildListTile(
                                                context,
                                                snapshot.data['users'][index],
                                                imageLink,index);}
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );


                          }
                          else {
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.red),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ]);
        })
    );

  }

  Widget buildListTile(BuildContext context, Map listItem,
      AsyncSnapshot<String> imageUrlAsync,int index) {

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
            this.userID = userID;
            this.peerId=listItem['id'];
            this.peerName = listItem['name'];
            this.imageUrl = imageUrl;
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

