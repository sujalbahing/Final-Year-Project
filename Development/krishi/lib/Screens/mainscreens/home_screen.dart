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
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<MarketPrice>>? futureMarketPrices;
  Future<Map<String, dynamic>>? futureWeatherData;
  String userName = "Loading..."; // ✅ State variable to store the user's name


  @override
  void initState() {
    super.initState();
    futureMarketPrices = fetchMarketPrices();
    futureWeatherData = fetchWeatherData("Kathmandu");
    fetchUserName(); // ✅ Fetch the logged-in user's name
  }
  

  Future<List<MarketPrice>> fetchMarketPrices() async {
    try {
      final response = await http.get(Uri.parse(ApiEndPoints.marketPriceUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.take(10).map((json) => MarketPrice.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load market prices");
      }
    } catch (e) {
      throw Exception("Error fetching market prices: $e");
    }
  }

  Future<Map<String, dynamic>> fetchWeatherData(String city) async {
    final url = '${ApiEndPoints.weatherUrl}?city=$city';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to load weather data");
      }
    } catch (e) {
      throw Exception("Error fetching weather data: $e");
    }
  }

  /// **Fetch Logged-in User's Name**
  Future<void> fetchUserName() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      if (token == null) {
        setState(() {
          userName = "Guest"; // ✅ Show Guest if no token found
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
          userName = data['name'] ?? "User"; // ✅ Update UI with fetched name
        });
      } else {
        setState(() {
          userName = "User"; // Default fallback
        });
      }
    } catch (e) {
      setState(() {
        userName = "Error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.backPrimary,
    body: FutureBuilder<Map<String, dynamic>>(
      future: futureWeatherData,
      builder: (context, snapshot) {
        Map<String, dynamic>? weatherData;  // Default: null

        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          weatherData = snapshot.data!;
        }

        return Stack(
          clipBehavior: Clip.none,
          children: [
            _buildHeaderSection(weatherData),  // ✅ Pass weather data or null
            Positioned(
              left: 0,
              right: 0,
              top: 200.h,
              child: _buildHorizontalScrollSection(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 355.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategorySection(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMarketPriceSection(),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );
 }

  /// ✅ **Updated Header Section with Dynamic User Name**
  Widget _buildHeaderSection(Map<String, dynamic>? weather) {
    return Container(
      height: 270.h,
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderRow(),
          SizedBox(height: 15.h),
          _buildWeatherInfoCard(weather), // ✅ Pass null if weather data is missing
        ],
      ),
    );
  }

  /// ✅ **Updated Header Row to Show Dynamic User Name**
  Widget _buildHeaderRow() {
    return Padding(
      padding: EdgeInsets.only(top: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Hello, $userName", // ✅ Now dynamically shows the logged-in user's name
            style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Icon(Icons.notifications, color: Colors.white, size: 35),
        ],
      ),
    );
  }


  Widget _buildWeatherInfoCard(Map<String, dynamic>? weather) {
  if (weather == null) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Center(
        child: Text(
          "No weather data available",
          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
      ),
    );
  }
  return Container(
    height: 70.h,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 25),
    child: Row(
      children: [
        _buildTemperatureColumn(weather),
        const VerticalDivider(color: Colors.grey, thickness: 1),
        _buildWeatherIcon(weather),
        _buildLocationInfo(weather),
      ],
    ),
  );
}

  Widget _buildTemperatureColumn(Map<String, dynamic> weather) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 3),
      Text(
        "${weather['temperature'].toInt()}°C",  // ✅ Remove decimals
        style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 3),
      Row(
        children: [
          Text(
            "High ${weather['high'].toInt()}°C",  // ✅ Remove decimals
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
          SizedBox(width: 10),
          Text(
            "Low ${weather['low'].toInt()}°C",  // ✅ Remove decimals
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
        ],
      ),
    ],
  );
}

  Widget _buildWeatherIcon(Map<String, dynamic> weather) {
    IconData weatherIcon;

    switch (weather['weather'].toLowerCase()) {
      case "clear sky":
        weatherIcon = Icons.wb_sunny;
        break;
      case "few clouds":
      case "scattered clouds":
        weatherIcon = Icons.cloud;
        break;
      case "rain":
      case "light rain":
        weatherIcon = Icons.beach_access;
        break;
      case "thunderstorm":
        weatherIcon = Icons.flash_on;
        break;
      case "snow":
        weatherIcon = Icons.ac_unit;
        break;
      default:
        weatherIcon = Icons.cloud_queue;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Icon(weatherIcon, color: AppColors.textPrimary, size: 34),
    );
  }

  Widget _buildLocationInfo(Map<String, dynamic> weather) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.location_on, size: 20),
            SizedBox(width: 5),
            Text(weather['location']),
          ]),
          SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              weather['weather'],
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalScrollSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 18, top: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: imagePaths.map((path) => _buildImageCard(path)).toList(),
        ),
      ),
    );
  }

  Widget _buildImageCard(String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: 320,
        height: 120,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.red[200]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Image.asset(imagePath, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
              Positioned(
                bottom: 10,
                left: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Know Best Market\nPrices',
                      style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, height: 0.9),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
                        padding: const EdgeInsets.symmetric(horizontal: 11),
                      ),
                      child: const Text("View Market", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildSectionTitle("Categories"),
      SizedBox(height: 8,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCategoryItem(CarbonIcons.shopping_cart, "Market", Colors.red),
          _buildCategoryItem(CarbonIcons.agriculture_analytics, "Services", Colors.green),
          _buildCategoryItem(CarbonIcons.calculator, "P/L Cal", Colors.blue),
          _buildCategoryItem(CarbonIcons.data_1, "Diagnosis", Colors.orange),
        ],
      ),
    ],
  );
 }


  Widget _buildCategoryItem(IconData icon, String title, Color color) {
  return Column(
    children: [
      Container(
        width: 80,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white, // Outer Box Color
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color, // Inner Box Color
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 30,
                  color: Colors.white, // Icon color
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 8), // Spacing between box and text
      Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
 }

  Widget _buildMarketPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8,),
        _buildSectionTitle("Market Prices"),
        FutureBuilder<List<MarketPrice>>(
          future: futureMarketPrices,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No market data available"));
            }
            return Column(
              children: snapshot.data!.map((market) => _buildMarketPriceCard(market)).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMarketPriceCard(MarketPrice market) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Image Placeholder
          Image.asset(
            'assets/veg2.jpg', // Replace with actual images
            width: 50,
            height: 50,
          ),
          const SizedBox(width: 10),

          // Commodity Name
          Expanded(
            child: Text(
              market.commodity, // Fetching from API
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          // Price and Unit
          Text(
            'Rs ${market.price} / ${market.unit}', // Fetching from API
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          // Price Trend Icon (Change dynamically if needed)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Icon(
              FontAwesomeIcons.arrowUp, // Change this based on price trend
              color: Colors.green, // Can be green (up) or red (down)
              size: 20,
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.only(left: 16, top: 12),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
}