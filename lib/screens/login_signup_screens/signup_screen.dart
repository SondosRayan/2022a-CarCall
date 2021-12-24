import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth_repository.dart';
import '../../globals.dart';
import '../home_screen.dart';
import 'login_screen.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
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
          actions: [
           TextButton(
            onPressed: () {
              //TODO: addInfoToUserData
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MyHomePage()));},
            child: getText('Done', Colors.white, 20, true),
            ),
          ],
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
                      //full name
                      Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(child: SizedBox(width: size.width*0.5,child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child:TextFormField(
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'First name',
                          ))
                  ))),
                  Flexible(child:  SizedBox(width: size.width*0.5,child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child:TextFormField(
                          decoration: const InputDecoration(
                            /*fillColor: Colors.white,
                            filled: true,*/
                            border: UnderlineInputBorder(),
                            labelText: 'First name',
                          ))
                  )))
                ]),

                      //birthday
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child:TextFormField(keyboardType: TextInputType.number,
                              inputFormatters: [DateInputFormatter(),],
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Enter your birthday',
                              ))
                      ),
                      //gender radio button
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child:GenderRadio(),
                      ),
                      //phone number
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child:TextFormField(keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Enter your phone number',
                              ))
                      ),
                      //licence plate
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child:TextFormField(keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Enter your license plate',
                              ))
                      ),
                    ]))])),
    );
  }
}

class GenderRadio extends StatefulWidget {
  const GenderRadio({Key? key}) : super(key: key);
  @override
  _GenderRadioState createState() => _GenderRadioState();
}

class _GenderRadioState extends State<GenderRadio> {
  String gender="";

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Flexible(child:Text('Gender:',style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ))),
          Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(child:ListTile(
            title:const Text('Male',style: TextStyle(
              fontSize: 13,
            )),
            leading: Radio(value: 'Male',groupValue: gender, onChanged: (String? value) { setState(() {
              gender=value!;
            }); },),
          )
          ),
            Flexible(child:ListTile(
              title:const Text('Female',style: TextStyle(
                fontSize: 13,
              )),
              leading: Radio(value: 'Female',groupValue: gender, onChanged: (String? value) { setState(() {
                gender=value!;
              }); },),
            )
            ),]),
        ]);
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = Provider.of<AuthRepository>(context);
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController ConfirmController = TextEditingController();
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
                                  controller: ConfirmController,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Confirm password',
                                  ))
                          ),
                          makeBox2('Continue', MediaQuery.of(context).size.width*0.8, 53,
                              green2, Colors.white, 20,
                                  () async{
                            if(ConfirmController.text.trim() != passwordController.text.trim()){
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Password does not match, please confirm password') ));
                            }
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
                          )


                        ]))])),
    );
  }
}


