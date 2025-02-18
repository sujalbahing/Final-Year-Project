import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:krishi/Screens/auth/signup.dart';
import 'package:krishi/components/custom_textfield.dart';
import 'package:krishi/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:krishi/components/app_color.dart';
import '../../model/loginuser.dart';
import 'package:krishi/navigation/navigation.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false; // Added loading state

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
                    icon: Icons.lock,
                    obscureText: true),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 45.w, vertical: 10.h),
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
                onPressed: isLoading ? null : () => login(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[400],
                  minimumSize: Size(20.w, 51.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  shadowColor: Colors.green[200],
                  elevation: 5,
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : const Text(
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
                },
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
          SizedBox(height: 14.4.h),
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

  /// **Handles user login**
  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showErrorSnackbar("Please enter both email and password.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final url = Uri.parse('${ApiEndPoints.baseUrl}user/login/');

      final body = jsonEncode({
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
      });

      final response = await http.post(
        url,
        body: body,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        if (responseData.containsKey("token")) {
          final loginUser = LoginUser.fromJson(responseData);
          final accessToken = loginUser.token.access;

          await saveToken(accessToken); // Save the token

          // Navigate to Home Screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NavigationScreen()),
          );
        } else {
          _showErrorSnackbar("Invalid response from server.");
        }
      } else {
        _handleErrorResponse(response);
      }
    } catch (e) {
      _showErrorSnackbar("Something went wrong. Please try again.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// **Function to save access token**
  Future<void> saveToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    print("Token saved successfully.");
  }

  /// **Handles failed login response**
  void _handleErrorResponse(http.Response response) {
    try {
      final responseData = jsonDecode(response.body);
      String errorMessage = "Login failed. Please try again.";

      if (responseData.containsKey("errors")) {
        if (responseData["errors"].containsKey("non_field_errors")) {
          errorMessage = responseData["errors"]["non_field_errors"][0];
        }
      }

      _showErrorSnackbar(errorMessage);
    } catch (e) {
      _showErrorSnackbar("Invalid response from server.");
    }
  }

  /// **Displays an error message in a Snackbar**
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }
}