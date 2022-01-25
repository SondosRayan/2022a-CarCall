import 'package:car_call/screens/login_signup_screens/login_screen.dart';
import 'package:car_call/screens/navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../auth_repository.dart';

enum AuthStatus{
  notLoggedIn,
  loggedIn,
}

class OurRoot extends StatefulWidget {
  const OurRoot({Key? key}) : super(key: key);
  @override
  _OurRootState createState() => _OurRootState();
}

class _OurRootState extends State<OurRoot> {
  AuthStatus _authStatus = AuthStatus.notLoggedIn;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    //get the state, check current user, set AuthStatus based on state
    AuthRepository _auth = Provider.of<AuthRepository>(context);
    bool isLogged = _auth.isAuthenticated;
    if(isLogged){
      setState(() {
        _authStatus = AuthStatus.loggedIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    late Widget retVal;

    switch (_authStatus){
      case AuthStatus.notLoggedIn:
        retVal = LoginScreen();
      break;
      case AuthStatus.loggedIn:
        retVal = MyNavigationBar(index: 0);
      break;
      default:{
        print("Invalid choice");
      }
      break;
    }
    return retVal;
  }
}
