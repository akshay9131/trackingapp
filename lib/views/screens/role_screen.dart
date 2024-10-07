import 'package:delivery_app/core/themes/colors.dart';
import 'package:delivery_app/views/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class RoleScreen extends StatelessWidget {
  const RoleScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: whiteColor,
        body: Container(
          height: Get.size.height,
          width: Get.size.width,
          color: whiteColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>LoginScreen(
                    role: "admin",
                  ))); 
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(200)
                      ),
                      child: Image.asset('assets/images/admin.png', height: 80,)
                      
                    ),
                    SizedBox(height: 10,),
                    Text("Admin", style: GoogleFonts.aBeeZee(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),)
                  ],
                ),
              ),
              const SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 1,
                    width: 100,
                    color: primaryColor,
                  ),
                  SizedBox(width: 10,),
                   Text("OR", style: GoogleFonts.aBeeZee(
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                  ),),
                  SizedBox(width: 10,),
                  Container(
                    height: 1,
                    width: 100,
                    color: primaryColor,
                  ),
                ],
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginScreen(
                    role: "driver",
                  )));
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(200)
                      ),
                      child: Image.asset('assets/images/driver.png', height: 80,)
                      
                    ),
                    SizedBox(height: 10,),
                    Text("Driver", style: GoogleFonts.aBeeZee(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),)
                  ],
                ),
              ),
            ],
          ),
        ),
      ));
  }
}