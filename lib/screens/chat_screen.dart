import 'package:car_call/globals.dart';
import 'package:car_call/screens/chat_room.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

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
  bool inChat = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    auth = Provider.of<AuthRepository>(context);
    userID = auth.user!.uid;
    return Material(
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
                  body: GestureDetector(
                    onTap: () {
                      // FocusScope.of(context).unfocus();
                      /*
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return ChatDetailScreen(
                          userId: userID,
                          userName: '',
                          peerId: '',
                          peerName: '',
                          peerAvatar: '',
                        );
                      }));
                       */
                    },
                    child: Container(),
                  ),
            ),
          ]);
        })
    );

  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

