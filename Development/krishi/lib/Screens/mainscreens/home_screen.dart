import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:krishi/components/app_color.dart';
import 'package:krishi/components/images.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 270.h,
            color: AppColors.primary,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 5.h)),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Hello, Sujal",
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Icon(
                        Icons.notifications,
                        color: Colors.white,
                        size: 35,
                      ),
                    ],
                  ),
                    SizedBox(height: 15.h), // Space between the text and the button
                    Container(
                    height: 70.h, // Adjust the height of the white box
                    decoration: BoxDecoration(
                      color: Colors.white, // White background color
                      borderRadius: BorderRadius.circular(10), // Optional: Rounded corners
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top:5, left:25),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "26*C",
                                    style: TextStyle(
                                      fontSize: 26.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "High 32*",
                                    style: TextStyle(
                                      fontSize: 14.sp, // Smaller font size
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey, // Grey color
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 10),
                              Padding(
                                padding: const EdgeInsets.only(top:34.0),
                                child: Text(
                                  "Low 18*",
                                  style: TextStyle(
                                      fontSize: 14.sp, // Smaller font size
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey, // Grey color
                                    ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 20),
                          Container(
                            width: 1,
                            height: 45,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(left:8.0),
                            child: Icon(
                              Icons.wb_sunny,
                              color: AppColors.textPrimary,
                              size: 35,
                            ),
                          ),
                          SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(top:8,left:10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 20,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "Dharan",
                                      style: TextStyle(
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              SizedBox(height: 3),
                              Padding(
                                padding: const EdgeInsets.only(left:8.0,),
                                child: Text(
                                  "Sunny weather",
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                            imagePaths.length, 
                            (index) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                width: 320,
                                height: 120,
                                decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.red[200], // Background color
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                               child: Stack(
                                children: [
                                  Image.asset(
                                  imagePaths[index],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                                Positioned(
                                bottom: 10,
                                left: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Know Best Market\nPrices',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        height: 0.9,
                                      ),
                                    ),
                                    SizedBox(height: 10), // Space between text and button
                                    ElevatedButton(
                                      onPressed: () {
                                        // Define button action here
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange, // Button color
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8), // Rounded corners
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 11),
                                      ),
                                      child: Text(
                                        'View Market',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white, // Text color
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                                ],
                               ),
                              ),
                              ),)
                        ),
                      ),
                    ),
          ),
          SizedBox(height: 10), // Space between sections
          
        ],
      ),
    );
  }
}
