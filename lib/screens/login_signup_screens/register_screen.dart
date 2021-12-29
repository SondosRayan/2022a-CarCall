import 'package:car_call/screens/login_signup_screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth_repository.dart';
import '../../globals.dart';
import 'login_screen.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  @override
  Widget build(BuildContext context) {
    final firebaseUser = Provider.of<AuthRepository>(context);
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: blue1,
      appBar:
      AppBar(
        leadingWidth: 90,
        centerTitle: true,
        title: getText('Sign up', Colors.white, 25, true),
        backgroundColor: green2,
        leading: TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          },
          child: getText('Cancel', Colors.white, 20, true),
        ),

      ),
      body: Center(
          child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(15.0),
              children: <Widget>[
                Center(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                              child: Icon(Icons.person,size: size.width*0.3,),
                              decoration: BoxDecoration(
                                borderRadius:
                                const BorderRadius.all( Radius.circular(100.0)),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 4.0,
                                ),))
                          ,
                          //mail
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              child:TextFormField(
                                  controller: emailController,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Enter your email',
                                  ))
                          ),
                          //password
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              child:TextFormField(
                                  controller: passwordController,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Choose password',
                                  ))
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              child:TextFormField(
                                  controller: confirmController,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Confirm password',
                                  ))
                          ),
                          makeBox2('Continue', MediaQuery.of(context).size.width*0.8, 53,
                              green2, Colors.white, 20,
                                  () async{
                                if(confirmController.text.trim() != passwordController.text.trim()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text(
                                          'Password does not match, please confirm password')));
                                }
                                else{
                                  /* TODO: here I just wanna make sure that the email and password are OK to use
                                           signing up will be later when I get all the information
                                           don't forget to add async
                                  */
                                  // TODO: navigate to the signup screen to add all the information **DONE**
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
                                  );

                                }}
                          )


                        ]))])),
    );
  }
}

/*
                            else{
                                var res = firebaseUser.signUp(
                                    emailController.text.trim().toString(),
                                    passwordController.text.trim().toString());
                                if (res == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('There was a problem signing up') ));
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
                                  );
                                }
                              }}
 */