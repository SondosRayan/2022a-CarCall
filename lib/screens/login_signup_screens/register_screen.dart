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
  bool _isSecure=true;
  bool _isSecure2=true;
  late AuthRepository firebaseUser;
  @override
  Widget build(BuildContext context) {
    firebaseUser = Provider.of<AuthRepository>(context);
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
      body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(15.0),
          children: <Widget>[
            box,
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
                            ),)),
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
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child:TextFormField(
                              controller: confirmController,
                              obscureText: _isSecure2,
                              decoration:  InputDecoration(
                                icon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon:const Icon(Icons.visibility),
                                  onPressed:(){setState(() {
                                    _isSecure2=!_isSecure2;
                                  });} ,
                                ) ,
                                border: const UnderlineInputBorder(),
                                labelText: 'Confirm password',
                              )
                          )
                      ),
                      makeBox2('Continue', MediaQuery.of(context).size.width*0.8, 53,
                          green2, Colors.white, 20,_onContinue
                      )


                    ]))]),
    );
  }

  Future<Null> _onContinue()async{
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
        var res = firebaseUser.signUpWithEmailPass(
            emailController.text, passwordController.text);
        if(res == null){
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(
                  'Error occurred. Please try again!')));
        }else{
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignUpScreen()),
          );
        }

      }
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