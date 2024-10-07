import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class TaskController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;


Future<void> assignTaskToDriver({
  required String driverId,
  required DateTime startTime,
  required DateTime endTime,
  required String pickupLocation,
  required String dropLocation,
}) async {
  try {
    await FirebaseFirestore.instance.collection('tasks').add({
      'driverId': driverId,
      'timeSlot': {
        'start': startTime,
        'end': endTime,
      },
      'pickupLocation': pickupLocation,
      'dropLocation': dropLocation,
      'taskStatus': 'assigned',
      'createdAt': FieldValue.serverTimestamp(),
    });
    Get.snackbar("Success", "Task assigned to driver");
  } catch (e) {
    Get.snackbar("Error", e.toString());
  }
}

void startTask(dynamic taskId) async {
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(taskId)
        .update({
      'taskStatus': 'started',
      'startTime': FieldValue.serverTimestamp(),
    });
    Get.snackbar('Success', 'Task started');
  }


  void completeTask(dynamic taskId) async {
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(taskId)
        .update({
      'taskStatus': 'completed',
      'completeTime': FieldValue.serverTimestamp(),
    });
    Get.snackbar('Success', 'Task completed');
  }

}