import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:krishi/Screens/auth/login.dart';
import 'package:http/http.dart' as http;

import '../../utils/api_endpoints.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController= TextEditingController();
  final TextEditingController passwordController= TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/top1.png',
                  height: 277.h,
                  width: 430.w,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Text(
              'Signup',
              style: TextStyle(
                fontSize: 40.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'K2D-BoldItalic',
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 23.h),
             Center(
              child: Container(
                height: 46.h,
                width: 320, // Set desired width here
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email, color: Colors.grey),
                    hintText: 'User Name',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16.sp),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
            ),
            SizedBox(height: 23.h),
            Center(
              child: Container(
                height: 46.h,
                width: 320, // Set desired width here
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email, color: Colors.grey),
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16.sp),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
            ),
            SizedBox(height: 23.h),
             Center(
              child: Container(
                height: 46.h,
                width: 320, // Set desired width here
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16.sp),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
            ),
            SizedBox(height: 23.h),
             Center(
              child: Container(
                height: 46.h,
                width: 320, // Set desired width here
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                    hintText: 'Confirm Password',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16.sp),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
            ),
            SizedBox(height: 52.h),
            ElevatedButton(
              onPressed: registerUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[400],
                minimumSize: Size(200.w, 51.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                shadowColor: Colors.green[200],
                elevation: 5,
              ),
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Don't have an account? ",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                }, // Handle the sign-up tap
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey, // Change color for emphasis
                  ),
                ),
              ),
            ],
          ),
            SizedBox(height: 5.h),
            Image.asset(
              'assets/bot1.png',
              width: double.infinity,
              height: 165.h,
              fit: BoxFit.cover,
            ),
          ],
        ),
      );
  }


  void registerUser() async {
    // Validate inputs first
    if (usernameController.text.isEmpty || 
        emailController.text.isEmpty ||
        passwordController.text.isEmpty || 
        confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required'))
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match'))
      );
      return;
    }

    try {
      final url = Uri.parse('${ApiEndPoints.baseUrl}user/register/');
      final body = {
        'name': usernameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'password2': confirmPasswordController.text,
        'tc': true
      };
      print(body);


      final response = await http.post(
        url, 
        body: json.encode(body), 
        headers: {'Content-Type': 'application/json'}
      );
      print(response.statusCode);

      if (response.statusCode == 201) {
        // Clear the form
        usernameController.clear();
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User Created Successfully'))
        );
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => const Login())
        );
      } else {
        print('Error response: ${response.body}');  // Log the full response
  final Map<String, dynamic> errorData = jsonDecode(response.body);
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      errorData['detail'] ?? 
      errorData['error'] ?? 
      'Registration failed. Please try again.'
    ),
  ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${e.toString()}')
      ));
    }
  }
}