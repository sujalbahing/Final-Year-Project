import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:krishi/components/app_color.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backPrimary,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // ✅ Background Container (Green Background)
          Container(
            height: 200.h, // Controls how much green background is shown
            width: double.infinity,
            color: AppColors.primary,
          ),

          // ✅ AppBar with "Profile" Title
          Positioned(
            top: 0.h, // Adjust based on status bar height
            left: 0,
            right: 0,
            child: AppBar(
              title: const Text(
                "Profile",
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent, // Make it blend with background
              elevation: 0, // Remove shadow
            ),
          ),

          // ✅ Profile Content
          Column(
            children: [
              SizedBox(height: 130.h), // Spacing for profile image

              // ✅ Profile Image (Overlapping Background)
              CircleAvatar(
                radius: 63,
                backgroundColor: Colors.white, // Optional white border effect
                child: ClipOval(
                  child: Image.asset(
                    'assets/p1.jpg',
                    fit: BoxFit.cover,
                    width: 120, // Slightly smaller than CircleAvatar
                    height: 120,
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // ✅ User Name
              Text(
                "Sujal Rai",  // Replace with dynamic user data
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
              ),

              // ✅ User Email
              Text(
                "sujal@example.com",  // Replace with dynamic user data
                style: TextStyle(fontSize: 16.sp, color: Colors.grey),
              ),

              SizedBox(height: 20.h),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(color: Colors.grey, thickness: 1),
              ),

              // ✅ Profile Options (Without White Box)
              _buildProfileOption(Icons.person, "Edit Profile", () {}),
              _buildProfileOption(Icons.settings, "Settings", () {}),
              _buildProfileOption(Icons.language, "Language", () {}),
              _buildProfileOption(Icons.delivery_dining, "Order", () {}),
              _buildProfileOption(Icons.privacy_tip, "Privacy", () {}),

              // ✅ Divider Above Logout
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(color: Colors.grey, thickness: 1),
              ),

              // ✅ Logout Option (Red Color)
              _buildProfileOption(Icons.logout, "Logout", () {}, isLogout: true),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ Helper Widget for Profile Options (Handles Logout Separately)
  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap, {bool isLogout = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: ListTile(
        leading: Icon(icon, color: isLogout ? Colors.red : AppColors.primary), // Red for logout
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: isLogout ? Colors.red : Colors.black, // Red for logout
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }
}