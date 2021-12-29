import 'package:car_call/globals.dart';
import 'package:car_call/screens/login_signup_screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:car_call/screens/login_signup_screens/signup_screen.dart';
import 'package:provider/provider.dart';
import '../../auth_repository.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isSecure=true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // final AuthService _auth = AuthService();
    final firebaseUser = Provider.of<AuthRepository>(context);
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
                                controller: emailController,
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
                                controller: passwordController,
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
                        firebaseUser.status == Status.Authenticating
                            ? const Center(child: CircularProgressIndicator())
                            :
                        makeBox2('Sign in', MediaQuery.of(context).size.width*0.8, 53,
                            green2, Colors.white, 20,
                                () async{
                              bool res = await firebaseUser.signIn(
                                  emailController.text.trim(),
                                  passwordController.text.trim());
                              if (!res) {
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //     login_error_snackBar);
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const MyHomePage()),
                                );
                              }
                            }
                        ),
                        box,
                        // sign in with google button
                        firebaseUser.status == Status.Authenticating
                            ? const Center(child: CircularProgressIndicator())
                            :
                        Material(
                            borderRadius: BorderRadius.circular(20),
                            color: green2,
                            child:MaterialButton(
                              minWidth: MediaQuery.of(context).size.width*0.8,
                              height: 53,
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
                              onPressed: () async{
                                await firebaseUser.signInWithGoogle();
                                // if (await firebaseUser.signInWithGoogleCheckIfFirstTime()) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                                );
                                // firstSignUpSheet(context, 3);
                                // } else {
                                //
                                //   // Navigator.pushAndRemoveUntil(
                                //   //     context,
                                //   //     MaterialPageRoute<void>(
                                //   //         builder: (context) => const LoginScreen()),
                                //   //         (r) => false);
                                // }
                              },
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
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

// void _onSignin() async{
//   bool res = await firebaseUser.signIn(
//       emailController.text.trim(),
//       passwordController.text.trim());
//   if (!res) {
//     ScaffoldMessenger.of(context).showSnackBar(
//         login_error_snackBar);
//   } else {
//     Navigator.pop(context);
//   }
// }
}



