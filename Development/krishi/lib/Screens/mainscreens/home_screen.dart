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
  Future<List<MarketPrice>>? futureMarketPrices;
  Future<Map<String, dynamic>>? futureWeatherData;

  @override
  void initState() {
    super.initState();
    futureMarketPrices = fetchMarketPrices();
    futureWeatherData = fetchWeatherData("Dharan");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backPrimary,
      body: Stack(
        clipBehavior: Clip.none, // Allows content to overflow (for overlap)
        children: [
          // Header Section (Background)
          _buildHeaderSection(),

          // Horizontal Scroll Section (Overlapping)
          Positioned(
            left: 0,
            right: 0,
            top: 200.h, // Adjust this value to fine-tune overlap
            child: _buildHorizontalScrollSection(),
          ),

          // Other sections - Keeping _buildCategorySection() fixed
          Padding(
            padding: EdgeInsets.only(top: 355.h), // Ensures proper spacing below the overlap
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCategorySection(), // ✅ Fixed, will not scroll
                
                // ✅ Wrap only _buildMarketPriceSection() in SingleChildScrollView
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMarketPriceSection(),
                        SizedBox(height: 10), // Bottom padding for spacing
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
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
          _buildWeatherInfoCard(),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Padding(
      padding: EdgeInsets.only(top: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Hello, Sujal",
            style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Icon(Icons.notifications, color: Colors.white, size: 35),
        ],
      ),
    );
  }

  Widget _buildWeatherInfoCard() {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          _buildTemperatureColumn(),
          const VerticalDivider(color: Colors.grey, thickness: 1),
          _buildWeatherIcon(),
          _buildLocationInfo(),
        ],
      ),
    );
  }

  Widget _buildTemperatureColumn() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 3,),
      Text(
        "26°C",
        style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 3), // Adjust spacing between temperature and High/Low row
      Row(
        children: [
          Text(
            "High 32°C",
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
          SizedBox(width: 10), // Adds spacing between "High 32°C" and "Low 18°C"
          Text(
            "Low 18°C",
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
        ],
      ),
    ],
  );
}

  Widget _buildWeatherIcon() {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0),
      child: Icon(Icons.wb_sunny, color: AppColors.textPrimary, size: 34),
    );
  }

  Widget _buildLocationInfo() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: const [Icon(Icons.location_on, size: 20), SizedBox(width: 5), Text("Dharan")]),
          const SizedBox(height: 3),
          Text(
            "Sunny weather",
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
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
            'assets/veg1.jpg', // Replace with actual images
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