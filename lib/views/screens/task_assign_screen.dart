import 'package:delivery_app/core/themes/colors.dart';
import 'package:delivery_app/views/controllers/auth_controller.dart';
import 'package:delivery_app/views/controllers/task_controller.dart';
import 'package:delivery_app/views/screens/location_screen.dart';
import 'package:delivery_app/views/widget/custom_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AssignTaskScreen extends StatefulWidget {
  final String driverId;
  const AssignTaskScreen({Key? key, required this.driverId}) : super(key: key);

  @override
  _AssignTaskScreenState createState() => _AssignTaskScreenState();
}

class _AssignTaskScreenState extends State<AssignTaskScreen> {
  final AuthController authController = Get.put(AuthController());
  final TaskController taskController = Get.put(TaskController());

  final TextEditingController pickupController = TextEditingController();
  final TextEditingController dropController = TextEditingController();

  DateTime? startTime;
  DateTime? endTime;

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        DateTime now = DateTime.now();
        DateTime selectedTime = DateTime(
            now.year, now.month, now.day, picked.hour, picked.minute);
        if (isStart) {
          startTime = selectedTime;
        } else {
          endTime = selectedTime;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_rounded, color: whiteColor,),onPressed: () {
          Get.back();
        },),
        title: Text('Assigned Task',
            style: GoogleFonts.aBeeZee(
                fontSize: 20, color: whiteColor, fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextFormField(hintText: "Pick Up Location", controller: pickupController),
            SizedBox(height: 10,),
            CustomTextFormField(hintText: "Drop Location", controller: dropController),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: darkColor.withOpacity(0.5))
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 300,
                    child: Text(
                        "Start Time: ${startTime != null ? DateFormat('hh:mm a').format(startTime!) : ''}"),
                  ),
                  IconButton(
                    icon: Icon(Icons.access_time),
                    onPressed: () => _selectTime(context, true),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: darkColor.withOpacity(0.5))
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 300,
                    child: Text(
                    "End Time: ${endTime != null ? DateFormat('hh:mm a').format(endTime!) : ''}"),
                  ),
                  IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: () => _selectTime(context, false),
                ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () async {
                final locations = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LocationPickerScreen()),
                );

                if (locations != null) {
                  setState(() {
                    pickupController.text = locations['pickup'];
                    dropController.text = locations['drop'];
                  });
                }
              },
              child: Text('Select Pickup and Drop Location',style:  GoogleFonts.aBeeZee(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: primaryColor),),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (pickupController.text.isNotEmpty &&
                    dropController.text.isNotEmpty &&
                    startTime != null &&
                    endTime != null) {
                  await taskController.assignTaskToDriver(
                    driverId: widget.driverId,
                    startTime: startTime!,
                    endTime: endTime!,
                    pickupLocation: pickupController.text,
                    dropLocation: dropController.text,
                  );
                  Get.back();
                } else {
                  Get.snackbar("Error", "Please fill all fields and select times");
                }
              },
              child: Text('Assign Task',style:  GoogleFonts.aBeeZee(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: primaryColor),),
            ),
          ],
        ),
      ),
    );
  }
}