import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_app/views/screens/admin_home_screen.dart';
import 'package:delivery_app/views/screens/driver_home_screen.dart';
import 'package:delivery_app/views/screens/login_screen.dart';
import 'package:delivery_app/views/screens/role_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  var user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    user.bindStream(auth.authStateChanges());
  }

  Future<void> signUp(String email, String password, String name, String role, String? vehicleId) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        if (role == "admin") {
          await _saveAdminToFirestore(user.uid, name, email, role);
        } else {
          await _saveDriverToFirestore(user.uid, name, email, role, vehicleId!);
        } // Redirect to Home Screen after signup
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('admin').doc(user.uid).get();
        if (userDoc.exists) {
          Get.offAll(() => AdminHomeScreen());
        } else {
          DocumentSnapshot driverDoc = await FirebaseFirestore.instance.collection('driver').doc(user.uid).get();
          if (driverDoc.exists) {
            Get.offAll(() => DriverTaskScreen());
          } else {
            Get.snackbar("Error", "User role not found");
          }
        }
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
    user.refresh();
    Get.offAll(() => const RoleScreen());
  }

  // Save user to Firestore
  Future<void> _saveAdminToFirestore(String uid, String name, String email, String role) async {
    await FirebaseFirestore.instance.collection('admin').doc(uid).set({
      'name': name,
      'email': email,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _saveDriverToFirestore(String uid, String name, String email, String role, String vehicleId) async {
    await FirebaseFirestore.instance.collection('driver').doc(uid).set({
      'name': name,
      'email': email,
      'role': role,
      'vehicle_id': vehicleId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<String?> getUserRole(String uid) async {
    DocumentSnapshot adminDoc = await FirebaseFirestore.instance.collection('admin').doc(uid).get();
    if (adminDoc.exists) {
      return 'admin';
    } else {
      DocumentSnapshot driverDoc = await FirebaseFirestore.instance.collection('driver').doc(uid).get();
      if (driverDoc.exists) {
        return 'driver';
      }
    }
    return null; 
  }

  // Fetch all drivers for Admin
  Future<List<QueryDocumentSnapshot>> getAllDrivers() async {
    QuerySnapshot driversSnapshot = await FirebaseFirestore.instance.collection('driver').get();
    return driversSnapshot.docs; // Returns list of all driver documents
  }

  // Fetch current driver's data
  Future<DocumentSnapshot> getDriverData(String uid) async {
    return await FirebaseFirestore.instance.collection('driver').doc(uid).get();
  }
}