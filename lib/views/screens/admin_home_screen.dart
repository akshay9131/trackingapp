import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/core/themes/colors.dart';
import 'package:delivery_app/views/controllers/auth_controller.dart';
import 'package:delivery_app/views/screens/assigned_task_screen.dart';
import 'package:delivery_app/views/screens/task_assign_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminHomeScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: whiteColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text('Admin Panel',
            style: GoogleFonts.aBeeZee(
                fontSize: 20, color: whiteColor, fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => authController.signOut(),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: authController.getAllDrivers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No drivers found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var driver = snapshot.data![index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: darkColor, blurRadius: 1)]),
                  child: Row(
                    children: [
                      Container(
                        width: 15,
                      ),
                      Container(
                        width: 345,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Driver: ${driver['name']}',
                              style: GoogleFonts.aBeeZee(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              'Email: ${driver['email']}',
                              style: GoogleFonts.aBeeZee(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              'Vehicle: ${driver['vehicle_id'] ?? 'No vehicle'}',
                              style: GoogleFonts.aBeeZee(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AssignedTaskScreen(
                                                  uid: driver.id,
                                                )));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    width: 150,
                                    child: Center(
                                      child: Text(
                                        "Previous Delivery",
                                        style: GoogleFonts.aBeeZee(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: whiteColor),
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AssignTaskScreen(
                                                  driverId: driver.id,
                                                )));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    width: 150,
                                    child: Center(
                                      child: Text(
                                        "Assign Delivery",
                                        style: GoogleFonts.aBeeZee(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: whiteColor),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
