import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dine_ease/data/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectivityController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    _connectivity.onConnectivityChanged.listen(
        (event) => event.map((e) => _updateConnectionStatus(e)).toList());
    super.onInit();
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      await Future.delayed(const Duration(microseconds: 200));
      Get.bottomSheet(
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Image(image: noInternetPng),
        ),
        isDismissible: false,
      );
    } else {
      Get.isBottomSheetOpen == true ? Get.back() : null;
    }
  }
}
