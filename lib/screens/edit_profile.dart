
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pattern_formatter/date_formatter.dart';
import 'package:provider/provider.dart';
import '../auth_repository.dart';
import '../globals.dart';

final TextEditingController firstNameController = TextEditingController();
final TextEditingController lastNameController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController carController = TextEditingController();

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late AuthRepository firebaseUser;
  late String firstName;
  late String lastName;
  late String phone;
  late String car_plate;

  @override
  Widget build(BuildContext context){
    Size size=MediaQuery.of(context).size;
    final screenWidth = MediaQuery.of(context).size.width;
    firebaseUser = Provider.of<AuthRepository>(context);
    firstName = firebaseUser.firstName;
    lastName = firebaseUser.lastName;
    phone = firebaseUser.phoneNumber;
    car_plate = firebaseUser.carPlate;
    initializeControllers();

    return Scaffold(
      backgroundColor: blue1,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Center(
          child: getText('Edit Details', Colors.white, 30, true),
        ),
        backgroundColor: green11,
      ),
      body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(15.0),
          children: <Widget>[
            Center(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      //full name
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child:TextFormField(
                            controller: firstNameController,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Edit first name',
                            ),
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                          )
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child:TextFormField(
                              controller: lastNameController,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Edit last name',
                              ))
                      ),

                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child:TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Edit your phone number',
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
                                labelText: 'Edit your license plate',
                              ))
                      ),
                      getSizeBox(15),
                      Material(
                        color: green11,
                        borderRadius: BorderRadius.circular(20.0),
                        child: MaterialButton(
                          minWidth: screenWidth*0.8,
                          height: 60,
                          child: getText('Save', Colors.white, 25, true),
                          onPressed: () {
                            firebaseUser.updateProfile(
                              firstNameController.text.trim(),
                              lastNameController.text.trim(),
                              phoneController.text.trim(),
                              carController.text.trim(),
                            );
                            Navigator.of(context).pop();
                          },
                        ),
                      ),

                    ]))]),
    );
  }


  void initializeControllers(){

    firstNameController.text =firstName;
    lastNameController.text = lastName;
    phoneController.text = phone;
    carController.text = car_plate;

  }

}