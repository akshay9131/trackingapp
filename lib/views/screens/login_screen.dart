import 'package:delivery_app/core/themes/colors.dart';
import 'package:delivery_app/views/controllers/auth_controller.dart';
import 'package:delivery_app/views/screens/signup_screen.dart';
import 'package:delivery_app/views/widget/custom_textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  final String? role;  

  LoginScreen({this.role});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.put(AuthController());

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(leading: IconButton(icon: Icon(Icons.arrow_back_rounded, color: whiteColor,),onPressed: () {
          Get.back();
        },),title: Text('Login as ${widget.role}', style: GoogleFonts.aBeeZee(fontSize: 25, fontWeight: FontWeight.bold, color: whiteColor)), centerTitle: true,backgroundColor: primaryColor,), // Show the role in the app bar
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              SizedBox(height: 150,),
              Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(200)
                      ),
                      child: Image.asset(widget.role == "admin" ? 'assets/images/admin.png' : 'assets/images/driver.png', height: 60,)
                      
                    ),
              Text(
                'Login as ${widget.role}',
                style: GoogleFonts.aBeeZee(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
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
                          controller: emailController),
              SizedBox(height: 10),
             CustomTextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Password';
                            } else if (value.length < 6) {
                              return 'Password must be atleast 6 characters';
                            }
                            return null;
                          },
                          obscureText: true,
                          isMaxLine: 1,
                          suffixIcon: Icons.password,
                          hintText: 'Enter Password',
                          controller: passwordController),
              SizedBox(height: 20),
              ElevatedButton(
                
                onPressed: () {
                  authController.signIn(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );
                },
                child: Container(
                  
                  width: 120,
                  child: Center(child: Text('Login', style: GoogleFonts.aBeeZee(
                    color: primaryColor,
                    fontWeight: FontWeight.bold
                  ),))),
              ),
              SizedBox(height: 10),
              widget.role == "admin" ? SizedBox() :
              TextButton(
                onPressed: () {
                  Get.offAll(() => SignUpScreen(role: widget.role ?? "",)); 
                },
                child: Text('Don\'t have an account? Sign up', style: GoogleFonts.aBeeZee(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: primaryColor
            )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
