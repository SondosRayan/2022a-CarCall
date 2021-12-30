import 'package:car_call/screens/navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth_repository.dart';
import '../../globals.dart';
import 'login_screen.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmController = TextEditingController();
final TextEditingController firstNameController = TextEditingController();
final TextEditingController lastNameController = TextEditingController();
final TextEditingController genderController = TextEditingController();
final TextEditingController birthController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController carController = TextEditingController();

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
            child: getText('Cancel', Colors.white, 20, true),
            onPressed: () {
              initializeControllers();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
          ),
          actions: [
           TextButton(
            child: getText('Done', Colors.white, 20, true),
            onPressed: () {
              bool flag = firstNameController.text.isNotEmpty &&
                  lastNameController.text.isNotEmpty &&
                  lastNameController.text.isNotEmpty &&
                  lastNameController.text.isNotEmpty &&
                  lastNameController.text.isNotEmpty &&
                  lastNameController.text.isNotEmpty &&
                  lastNameController.text.isNotEmpty &&
                  lastNameController.text.isNotEmpty;
              late Future<User?> res;
              if (flag) {
                res = firebaseUser.completeSignUp(
                    firstNameController.text.trim().toString(),
                    lastNameController.text.trim().toString(),
                    genderController.text.trim().toString(),
                    birthController.text.trim().toString(),
                    phoneController.text.trim().toString(),
                    carController.text.trim().toString()
                );
                if (res == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('There was a problem signing up'))
                  );
                } else {
                  initializeControllers();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NavigationBar()),
                  );
                }

              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(
                        'Please fill all the needed information!')));
              }
            },
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
                          controller: firstNameController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'First name',
                          ),
                        autovalidateMode:
                        AutovalidateMode.onUserInteraction,
                      )
                  ))),
                  Flexible(child:  SizedBox(width: size.width*0.5,child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child:TextFormField(
                          controller: lastNameController,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Last name',
                          ))
                  )))
                ]),

                      //birthday
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child:TextFormField(keyboardType: TextInputType.number,
                              controller: birthController,
                              inputFormatters: [DateInputFormatter(),],
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Enter your birthday',
                              )
                          )
                      ),
                      //gender radio button
                      const Padding(  // TODO: how to get female or male ***DONE***
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child:GenderRadio(),
                      ),
                      //phone number
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child:TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Enter your phone number',
                              ))
                      ),
                      //licence plate
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child:TextFormField(
                              controller: carController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Enter your license plate',
                              ))
                      ),
                    ]))])),
    );
  }

  void initializeControllers(){
    emailController.text = "";
    passwordController.text = "";
    confirmController.text = "";
    firstNameController.text ="";
    lastNameController.text = "";
    genderController.text = "";
    birthController.text = "";
    phoneController.text = "";
    carController.text = "";

  }
}

class GenderRadio extends StatefulWidget {
  const GenderRadio({Key? key}) : super(key: key);
  @override
  _GenderRadioState createState() => _GenderRadioState();
}

class _GenderRadioState extends State<GenderRadio> {
  String gender="Female";

  @override
  Widget build(BuildContext context) {
    genderController.text= "Female";
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Flexible(
              child:Text('Gender:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
              ),
          ),
          Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(child:ListTile(
            title:const Text('Male',style: TextStyle(
              fontSize: 13,
            )),
            leading: Radio(
              value: 'Male',
              groupValue: gender,
              onChanged: (String? value) {
                setState(() {
                  gender=value!;
                  genderController.text = value;
                });},
            ),
          )
          ),
            Flexible(child:ListTile(
              title:const Text('Female',style: TextStyle(
                fontSize: 13,
              )),
              leading: Radio(value: "Female",groupValue: gender, onChanged: (String? value) { setState(() {
                gender=value!;
                genderController.text = value;
              }); },),
            )
            ),]),
        ]);
  }
}


