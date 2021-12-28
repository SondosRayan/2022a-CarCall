import 'package:car_call/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfile{
  // late User? user=AuthRepository.instance().user;
  final String uid;
  late String name;
  late String email;
  late String password;
  late String gender;
  late String birthDate; // ?? check
  late String phoneNumber;
  late String carPlate;
  // to add blocked list (list of uid)

  UserProfile({required this.uid});

  // Future<String> getBirthDate(User user) async {
  //   await AuthRepository.instance().firebaseFirestore.collection('Users')
  //       .doc(user!.uid)
  //       .update({data});
  // }

}