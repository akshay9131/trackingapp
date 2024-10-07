import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/core/themes/colors.dart';
import 'package:delivery_app/views/controllers/auth_controller.dart';
import 'package:delivery_app/views/screens/admin_home_screen.dart';
import 'package:delivery_app/views/screens/login_screen.dart';
import 'package:delivery_app/views/screens/role_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'driver_home_screen.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      User? currentUser = authController.auth.currentUser;

      if (currentUser != null) {
        DocumentSnapshot adminDoc = await FirebaseFirestore.instance.collection('admin').doc(currentUser.uid).get();
        if (adminDoc.exists) {
          Get.offAll(() => AdminHomeScreen());
        } else {
          DocumentSnapshot driverDoc = await FirebaseFirestore.instance.collection('driver').doc(currentUser.uid).get();
          if (driverDoc.exists) {
            Get.offAll(() => DriverTaskScreen());
          } else {
            Get.offAll(() => RoleScreen());
          }
        }
      } else {
        Get.offAll(() => RoleScreen());
      }
    });

    return Scaffold(
      backgroundColor: whiteColor,
      body: Container(
        height: Get.size.height,
        width: Get.size.width,
        decoration: const BoxDecoration(color: whiteColor),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splash.png',
              scale: 1,
            ),
            Text(
              "Deliver App",
              style: GoogleFonts.aBeeZee(fontSize: 30, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}