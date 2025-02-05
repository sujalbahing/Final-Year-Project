import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:krishi/components/app_color.dart';
import 'package:krishi/components/images.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:krishi/model/market_price.dart'; 
import 'package:http/http.dart' as http; 
import 'dart:convert';
import 'package:krishi/utils/api_endpoints.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<MarketPrice> marketPrices = []; // Store fetched market data
  bool isLoading = true; // Show a loading indicator

  @override
  void initState() {
    super.initState();
    fetchMarketPrices(); // Fetch market prices on screen load
  }

  Future<void> fetchMarketPrices() async {
    try {
      final url = Uri.parse(ApiEndPoints.marketPriceUrl); // ✅ Use API Endpoint
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          marketPrices = data.take(10).map((json) => MarketPrice.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load market prices");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error fetching market prices: $e"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backPrimary,
      body: SingleChildScrollView( // Wrap the entire body with SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Container for header section
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
                      padding: EdgeInsets.only(top: 5.h),
                      child: Row(
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
                    ),
                    SizedBox(height: 15.h),
                    Container(
                      height: 70.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
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
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
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
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey,
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
                                    padding: const EdgeInsets.only(left:8.0),
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
            // Mid Section (Scrollable horizontal row)
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
                                        backgroundColor: AppColors.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(21),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 11),
                                      ),
                                      child: Text(
                                        'View Market',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
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
                    ),
                  ),
                ),
              ),
            ),
            // Categories Section
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                "Categories",
                style: TextStyle(
                  fontSize: 21,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                4,
                (index) => Column(
                  children: [
                    Container(
                      width: 80,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppColors.boxColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                index == 0
                                    ? CarbonIcons.shopping_cart 
                                    : index == 1
                                        ? CarbonIcons.agriculture_analytics
                                        : index == 2
                                            ? CarbonIcons.calculator
                                            : CarbonIcons.data_1,
                                size: 30,
                                color: index == 0
                                  ? Colors.red            // Color for shopping_cart
                                  : index == 1
                                      ? Colors.green      // Color for agriculture_analytics
                                      : index == 2
                                          ? Colors.blue    // Color for calculator
                                          : Colors.orange,  // Color for data_1
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              index == 0
                                  ? 'Market'
                                  : index == 1
                                      ? 'Services'
                                      : index == 2
                                          ? 'P/L Cal'
                                          : 'Diagnosis',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
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
            // Market Prices Section
            Padding(
              padding: const EdgeInsets.only(left: 16, top:12,),
              child: Text(
                "Market Prices",
                style: TextStyle(
                  fontSize: 21,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: isLoading
                ? Center(child: CircularProgressIndicator()) // Show loading indicator
                : marketPrices.isEmpty
                    ? Center(child: Text("No market data available")) // Show if no data
                    : Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(), // Smooth scrolling effect
                          itemCount: marketPrices.length > 10 ? 10 : marketPrices.length,
                          itemBuilder: (context, index) {
                            final market = marketPrices[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      width: double.infinity,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          // Vegetable Image (Placeholder)
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Image.asset(
                              'assets/veg2.jpg', // Replace with actual images
                              width: 50,
                              height: 50,
                            ),
                          ),
                          
                          // Commodity Name
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              market.commodity, // Fetching from API
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),

                          // Spacer to push price to right
                          Spacer(),

                          // Price
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Row(
                              children: [
                                Text(
                                  'Rs', // Static text
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  market.price, // Fetching from API
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  '/${market.unit}', // Fetching from API
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Arrow Up/Down Indicator (Can be updated dynamically)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              FontAwesomeIcons.arrowUp,
                              color: Colors.green, // Change dynamically if needed
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
           ),
          ],
        ),
      ),
    );
  }
}
