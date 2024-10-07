import 'package:delivery_app/core/themes/colors.dart';
import 'package:delivery_app/views/controllers/auth_controller.dart';
import 'package:delivery_app/views/screens/login_screen.dart';
import 'package:delivery_app/views/widget/custom_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatefulWidget {
  final String role;
  
  SignUpScreen({required this.role});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthController authController = Get.put(AuthController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController vehicleIdController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_rounded, color: whiteColor,),onPressed: () {
          Get.back();
        },),
        title: Text('Sign Up as ${widget.role}', style: GoogleFonts.aBeeZee(fontSize: 25, fontWeight: FontWeight.bold, color: whiteColor)),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 100),
                Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(200)
                      ),
                      child: Image.asset(widget.role == "admin" ? 'assets/images/admin.png' : 'assets/images/driver.png', height: 60,)
                      
                    ),
                Text(
                  'Sign Up as ${widget.role}',
                  style: GoogleFonts.aBeeZee(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                CustomTextFormField(
                  isMaxLine: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  suffixIcon: Icons.person,
                  hintText: 'Enter your name',
                  controller: nameController,
                ),
                SizedBox(height: 10),
                CustomTextFormField(
                  isMaxLine: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    } else if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  suffixIcon: Icons.email_outlined,
                  hintText: 'Enter your email address',
                  controller: emailController,
                ),
                SizedBox(height: 10),
                CustomTextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  obscureText: true,
                  isMaxLine: 1,
                  suffixIcon: Icons.password,
                  hintText: 'Enter Password',
                  controller: passwordController,
                ),
                SizedBox(height: 10),
                widget.role == "driver" 
                    ? CustomTextFormField(
                        isMaxLine: 1,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your vehicle ID';
                          }
                          return null;
                        },
                        suffixIcon: Icons.pedal_bike_rounded,
                        hintText: 'Enter Vehicle ID',
                        controller: vehicleIdController,
                      )
                    : Container(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      authController.signUp(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                        nameController.text.trim(),
                        widget.role,
                        vehicleIdController.text.trim(),
                      );
                    }
                  },
                  child: Container(
                    width: 120,
                    child: Center(child: Text('Sign Up', style: GoogleFonts.aBeeZee(
                      fontWeight: FontWeight.bold,
                      color: primaryColor
                    ))),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Get.offAll(() => LoginScreen(role: widget.role));
                  },
                  child: Text('Already have an account? Log in', style: GoogleFonts.aBeeZee(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: primaryColor
            )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
