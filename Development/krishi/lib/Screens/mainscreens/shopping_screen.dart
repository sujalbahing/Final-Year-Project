import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ShoppingScreen extends StatefulWidget {
  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  final String apiBaseUrl = "http://127.0.0.1:8000/api/payment/esewa-payment/"; // Django API

  // ✅ Sample marketplace items (replace with API data)
  final List<Map<String, dynamic>> items = [
    {"id": 1, "name": "Organic Apples", "price": 500},
    {"id": 2, "name": "Fresh Vegetables", "price": 300},
    {"id": 3, "name": "Organic Honey", "price": 700},
  ];

  Future<void> makePayment(int amount) async {
  try {
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/payment/esewa-payment/"),
      body: jsonEncode({"amount": amount}),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer YOUR_ACCESS_TOKEN", // ✅ Ensure token is correct
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String esewaUrl = data["esewa_url"];

      if (await canLaunch(esewaUrl)) {
        await launch(esewaUrl);
      } else {
        throw "Could not launch eSewa";
      }
    } else {
      print("❌ Payment API Error: ${response.body}");
    }
  } catch (e) {
    print("❌ Payment Error: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Marketplace")),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: Icon(Icons.shopping_cart, color: Colors.green),
              title: Text(item["name"], style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Rs ${item["price"]}"),
              trailing: ElevatedButton(
                onPressed: () => makePayment(item["price"]),  // ✅ Pay via eSewa
                child: Text("Buy Now"),
              ),
            ),
          );
        },
      ),
    );
  }
}