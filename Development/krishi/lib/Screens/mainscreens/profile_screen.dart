import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:krishi/components/app_color.dart';
import 'package:krishi/utils/api_endpoints.dart';
import 'package:krishi/Screens/auth/login.dart'; // Import Login Screen

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "Loading...";
  String email = "Loading...";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  /// **Fetch User Profile from API**
  Future<void> fetchUserProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      if (token == null) {
        setState(() {
          name = "Not Logged In";
          email = "Please login";
          isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('${ApiEndPoints.baseUrl}user/profile/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          name = data['name'] ?? "Unknown";
          email = data['email'] ?? "No Email";
          isLoading = false;
        });
      } else {
        setState(() {
          name = "Error";
          email = "Could not load data";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        name = "Error";
        email = "Could not load data";
        isLoading = false;
      });
    }
  }

  /// **Logout Function**
  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refresh_token');

    if (refreshToken == null) {
      print("No refresh token found. Logging out...");
      _clearUserData();
      return;
    }

    final response = await http.post(
      Uri.parse('${ApiEndPoints.baseUrl}user/logout/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"refresh": refreshToken}),
    );

    if (response.statusCode == 205) {
      print("Logout successful");
      _clearUserData();
    } else {
      print("Logout failed: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to log out. Try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// **Clear stored user data and navigate to login screen**
  Future<void> _clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login()), // Redirect to login
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backPrimary,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(height: 200.h, width: double.infinity, color: AppColors.primary),
          Positioned(
            top: 0.h,
            left: 0,
            right: 0,
            child: AppBar(
              title: const Text("Profile", style: TextStyle(color: Colors.white)),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(icon: const Icon(Icons.settings, color: Colors.white), onPressed: () {}),
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(height: 130.h),
              CircleAvatar(
                radius: 63,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image.asset('assets/p1.jpg', fit: BoxFit.cover, width: 120, height: 120),
                ),
              ),
              SizedBox(height: 20.h),
              Text(isLoading ? "Loading..." : name, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
              Text(isLoading ? "Loading..." : email, style: TextStyle(fontSize: 16.sp, color: Colors.grey)),
              SizedBox(height: 20.h),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Divider(color: Colors.grey, thickness: 1)),
              _buildProfileOption(Icons.person, "Edit Profile", () {}),
              _buildProfileOption(Icons.language, "Language", () {}),
              _buildProfileOption(Icons.delivery_dining, "Order", () {}),
              _buildProfileOption(Icons.chat, "Chat", () {}),
              _buildProfileOption(Icons.privacy_tip, "Privacy", () {}),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Divider(color: Colors.grey, thickness: 1)),
              _buildProfileOption(Icons.logout, "Logout", _logout, isLogout: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap, {bool isLogout = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: ListTile(
        leading: Icon(icon, color: isLogout ? Colors.red : AppColors.primary),
        title: Text(title, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: isLogout ? Colors.red : Colors.black)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }
}