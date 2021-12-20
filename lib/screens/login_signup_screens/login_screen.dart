import 'package:car_call/globals.dart';
import 'package:flutter/material.dart';
import 'package:car_call/screens/login_signup_screens/signup_screen.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
   bool _isSecure=true;
@override
  Widget build(BuildContext context) {
    final logo= Image.asset('assets/images/car_call_logo.jpg');
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: blue1,
      body: Center(
      child: ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(15.0),
      children: <Widget>[
        Center(
          child: Column( children: <Widget>[
            getText('Welcome to CarCall', green2, 30, true),
            box,
            //welcome logo
            Container(
                width: size.width *0.5,
                height: size.width *0.5,
                decoration: BoxDecoration(
                  color: const Color(0xff7c94b6),
                  image: DecorationImage(
                    image: logo.image,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.all( Radius.circular(100.0)),
                  border: Border.all(
                    color: lightGreen1,
                    width: 4.0,
                  ),
                ),
              ),
            box,
            //mail text filed
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child:TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      border: UnderlineInputBorder(),
                      labelText: 'Enter your email',
                    ))
            ),
            //password text field
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child:TextFormField(
                    obscureText: _isSecure,
                    decoration:  InputDecoration(
                      icon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon:const Icon(Icons.visibility),
                        onPressed:(){setState(() {
                          _isSecure=!_isSecure;
                        });} ,
                      ) ,
                      border: const UnderlineInputBorder(),
                      labelText: 'Enter your password',
                    )
                )),
            box,
            //sign in button
            makeBox('Sign in', MediaQuery.of(context).size.width*0.8, 53,
                    green2, Colors.white, 20,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyHomePage()),
                  );
                }
            ),
            box,
            // sign in with google button
            Material(
                borderRadius: BorderRadius.circular(20),
                color: green2,
                child:MaterialButton(
                    minWidth: MediaQuery.of(context).size.width*0.8,
                    height: 53,
                    onPressed: (){},
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.asset(
                            'assets/icons/google_icon.jpg',
                            height: 40.0,
                            width: 40.0,
                          ),
                          Padding(
                              padding: paddingLeft10,
                              child:
                                  getText('Sign in with Google', Colors.white, 20.0, true),
                          )
                        ]
                    ),
                )),
            box,
            //sign up button
            Material(
                borderRadius: BorderRadius.circular(20),
                color: green2,
                child:MaterialButton(
                    minWidth: MediaQuery.of(context).size.width*0.8,
                    height: 53,
                    onPressed:_onSignUp,
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                              padding: paddingLeft10,
                              child:
                              getText("Don't have an account?", Colors.white, 20.0, false),
                              ),
                          Padding(
                              padding: paddingLeft10,
                              child:
                                getText('Sign up', Colors.white, 20.0, true),
                              )])
                )
            ),
          ]))])));
  }

  void _onSignUp(){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignUpScreen()),
      );
  }
}



