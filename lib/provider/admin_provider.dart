import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_ease/model/food_model.dart';
import 'package:dine_ease/model/order_model.dart';
import 'package:dine_ease/model/redeem_model.dart';
import 'package:dine_ease/view/auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AdminProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _foodCollection = FirebaseFirestore.instance.collection('foods');
  final _orderCollection = FirebaseFirestore.instance.collection('orders');
  final _redeemCollection = FirebaseFirestore.instance.collection('redeems');
  final _fireStorage = FirebaseStorage.instance.ref();
  final ImagePicker _picker = ImagePicker();

  bool isVeg = false;
  String? selectedCategory;
  File? file;
  Uint8List? imageData;

  List<OrderModel> allOrders = [];

  List<String> availableCategory = [
    "Biriyani",
    "Burger",
    "Grill",
    "Noodles",
    "Pizza"
  ];

  ///select category
  selectCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  ///select for is veg or non veg
  selectVegOrNonVeg(value) {
    isVeg = value;
    notifyListeners();
  }

  ///to upload picked image in firebase storage
  Future<String> _uploadFoodImage(String title) async {
    late UploadTask uploadTask;
    try {
      Reference reference = _fireStorage.child("foods/$title");
      if (kIsWeb && imageData != null) {
        uploadTask = reference.putData(imageData!);
      } else if (file != null) {
        uploadTask = reference.putFile(file!);
      }
      await uploadTask.whenComplete(() => null);
      final path = await reference.getDownloadURL();
      return path;
    } catch (e) {
      throw e.toString();
    }
  }

  ///to upload food in fire store
  Future<void> uploadFoodModel(FoodModel food) async {
    try {
      final doc = _foodCollection.doc();
      final docId = doc.id;

      await doc.set(FoodModel(
              id: docId,
              image: await _uploadFoodImage(food.title!),
              description: food.description,
              title: food.title,
              price: food.price,
              offer: food.offer,
              time: food.time,
              coins: food.coins,
              category: selectedCategory,
              veg: isVeg)
          .toJson());
    } catch (e) {
      throw e.toString();
    }
  }

  ///to pick the image and crop and update in ui
  Future<void> pickImage(BuildContext context) async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 40);
    if (pickedImage != null) {
      //crop images
      _cropImage(pickedImage, context);
    }
  }

  ///for crop the picked image
  Future<void> _cropImage(XFile imageFile, BuildContext context) async {
    CroppedFile? croppedFile =
        await ImageCropper().cropImage(sourcePath: imageFile.path, uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
          ]),
      IOSUiSettings(title: 'Cropper', aspectRatioPresets: [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
      ]),
      WebUiSettings(context: context)
    ]);
    if (kIsWeb) {
      Uint8List byteImage = await croppedFile!.readAsBytes();
      imageData = byteImage;
      notifyListeners();
    }
    file = File(croppedFile!.path);
    notifyListeners();
  }

  ///when order is prepared to delete form
  Future<void> completeOrder(String id) async {
    try {
      await _orderCollection.doc(id).update({"status": "completed"});
    } catch (e) {
      throw e.toString();
    }
  }

  ///for admin login to firebase by a particular email and password
  Future<void> adminLogin(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw e.code;
    } catch (e) {
      throw e.toString();
    }
  }

  ///admin logout
  Future<void> logoutAdmin() async {
    try {
      await _auth.signOut();
      Get.offAll(() => const LoginPage());
    } catch (e) {
      throw e.toString();
    }
  }

  ///add redeem offer
  Future<void> addRedeemOffer(RedeemModel data) async {
    try {
      final doc = _redeemCollection.doc();
      final docId = doc.id;

      await doc.set(
        RedeemModel(
          id: docId,
          food: data.food,
          point: data.point,
        ).toMap(),
      );
    } catch (e) {
      throw e.toString();
    }
  }

  ///change redeem offer
  Future<void> changeRedeemOffer(String id, RedeemModel data) async {
    try {
      await _redeemCollection.doc(id).update(data.toMap());
    } catch (e) {
      throw e.toString();
    }
  }

  ///delete redeem offer
  Future<void> deleteRedeemOffer(String id) async {
    try {
      await _redeemCollection.doc(id).delete();
    } catch (e) {
      throw e.toString();
    }
  }

  ///to get all foods
  Future<List<FoodModel>> getAllFoods() async {
    try {
      var foods = await _foodCollection.get();
      return foods.docs.map((e) => FoodModel.fromJson(e)).toList();
    } catch (e) {
      throw e.toString();
    }
  }
}
