import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_ease/model/user_model.dart';
import 'package:dine_ease/view/auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserService {
  final _userCollection = FirebaseFirestore.instance.collection('users');
  final _auth = FirebaseAuth.instance;
  final User? _user = FirebaseAuth.instance.currentUser;

  ///register new user
  Future<void> registerNewUser(
      String email, String password, String name, String number) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        _saveUserProfile(
          UserModel(
            uid: credential.user!.uid,
            password: password,
            email: email,
            number: number,
            name: name,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      throw e.code;
    } catch (e) {
      throw e.toString();
    }
  }

  ///login  registered user
  Future<void> loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw e.code;
    } catch (e) {
      throw e.toString();
    }
  }

  ///save user profile to cloud fire store
  Future<void> _saveUserProfile(UserModel user) async {
    try {
      await _userCollection.doc(user.uid).set(user.toJson());
    } catch (e) {
      throw e.toString();
    }
  }

  ///update user address
  Future<void> updateUserAddress(String address, String uid) async {
    try {
      await _userCollection.doc(uid).update({
        "address": address,
      });
    } catch (e) {
      throw e.toString();
    }
  }

  ///user logout
  Future<void> logoutUser() async {
    try {
      await _auth.signOut();
      Get.offAll(() => const LoginPage());
    } catch (e) {
      throw e.toString();
    }
  }

  ///delete user and profile
  Future<void> deleteUser() async {
    try {
      await _auth.currentUser!.delete();
      await _userCollection.doc(_user!.uid).delete();
      Get.offAll(() => const LoginPage());
    } catch (e) {
      throw e.toString();
    }
  }
}
