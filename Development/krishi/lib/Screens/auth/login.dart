import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:krishi/Screens/auth/signup.dart';
import 'package:krishi/components/custom_button.dart';
import 'package:krishi/components/custom_textfield.dart';
import 'package:krishi/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:krishi/components/app_color.dart';

import '../../model/loginuser.dart';
import '../mainscreens/home_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
          Image.asset(
            'assets/top2.png',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10.h),
          Text(
            'Login',
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              fontFamily: 'K2D-BoldItalic',
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              children: [
                CustomTextField(
                    controller: emailController,
                    hintText: 'Email',
                    icon: Icons.mail),
                SizedBox(height: 20.h),
                CustomTextField(
                    controller: passwordController,
                    hintText: "Password",
                    icon: Icons.lock),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 45.w, vertical: 10.h), // Adjust padding as needed
              child: Text(
                'Forgot Your Password?',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          SizedBox(height: 15.h),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 250.w,
              child: ElevatedButton(
                onPressed: () {
                  login();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[400],
                  minimumSize: Size(20.w, 51.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  shadowColor: Colors.green[200],
                  elevation: 5,
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                    MaterialPageRoute(builder: (context) => const SignUp()),
                  );
                }, // Handle the sign-up tap
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // IconButton(
              //   icon: Icon(FontAwesome.facebook_square, size: 30, color: Color(0xFF3D5A98)),
              //   onPressed: () {},
              // ),
              // SizedBox(width: 20),
              // IconButton(
              //   icon: Icon(FontAwesome.google, size: 30, color: Colors.red),
              //   onPressed: () {},
              // ),
            ],
          ),
          SizedBox(height: 3.h),
          Image.asset(
            'assets/bot1.png',
            width: double.infinity,
            height: 170.h,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  Future<void> login() async {
    try {
      // TODO: Implement login logic here
      String accessToken = '';
      final prefs = await SharedPreferences.getInstance();
      final url = Uri.parse('${ApiEndPoints.baseUrl}user/login/');
      final body = {
        'email': emailController.text,
        'password': passwordController.text,
      };

      final response = await http.post(url,
          body: json.encode(body),
          headers: {"Content-Type": "application/json"});

      if (response.statusCode == 200) {
        final responseData = LoginUser.fromJson(jsonDecode(response.body));
        accessToken = responseData.token.access;
        prefs.setString('token', accessToken);

        // Navigate to the home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
