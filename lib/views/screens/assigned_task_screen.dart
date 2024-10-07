import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/core/themes/colors.dart';
import 'package:delivery_app/views/controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AssignedTaskScreen extends StatefulWidget {
  final String uid;
  AssignedTaskScreen({required this.uid});
  @override
  State<AssignedTaskScreen> createState() => _AssignedTaskScreenState();
}

class _AssignedTaskScreenState extends State<AssignedTaskScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    User? user = auth.currentUser;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_rounded, color: whiteColor,),onPressed: () {
          Get.back();
        },),
        title: Text('Previous Tasks',
            style: GoogleFonts.aBeeZee(
                fontSize: 20, color: whiteColor, fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .where('driverId', isEqualTo: widget.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No tasks assigned'));
          }

          var tasks = snapshot.data!.docs;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              var task = tasks[index];
              var timeSlot = task['timeSlot'];
              DateTime start =
                  (task['timeSlot']['start'] as Timestamp).toDate();
              DateTime end = (task['timeSlot']['end'] as Timestamp).toDate();
              // if (task['taskStatus'] == 'completed') {
              dynamic pickup = task['taskStatus'] == 'completed' ? (task['startTime'] ?? "" as Timestamp).toDate() : null;
              dynamic drop = task['taskStatus'] == 'completed' ? (task['completeTime'] ?? "" as Timestamp).toDate() : null;
              // }
              
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
                              'Task ${index + 1}',
                              style: GoogleFonts.aBeeZee(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor),
                            ),
                            Text(
                              'Pickup: ${task['pickupLocation']}',
                              style: GoogleFonts.aBeeZee(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor),
                            ),
                            SizedBox(height: 3,),
                            Text('Drop: ${task['dropLocation']}',
                            style: GoogleFonts.aBeeZee(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor),
                            ),
                            SizedBox(height: 3,),
                            Text(
                                'Time Slot: ${DateFormat('hh:mm a').format(start)} - ${DateFormat('hh:mm a').format(end)}', 
                                style: GoogleFonts.aBeeZee(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor),),
                            SizedBox(height: 3,),
                            Text('Status: ${task['taskStatus']}',
                            style: GoogleFonts.aBeeZee(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor),),
                                  pickup != null ?
                            SizedBox(height: 3,) : SizedBox(),
                            pickup != null  ?
                            Text('Pickup time: ${DateFormat('hh:mm a').format(pickup)}',
                            style: GoogleFonts.aBeeZee(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor),) : SizedBox(),
                                  pickup != null  ?
                            SizedBox(height: 3,) : SizedBox(),
                            pickup != null  ?
                            Text('Drop time: ${DateFormat('hh:mm a').format(drop)}',
                            style: GoogleFonts.aBeeZee(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor),) : SizedBox(),
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
