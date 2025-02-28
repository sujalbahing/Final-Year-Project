import 'package:flutter/material.dart';
import 'package:krishi/components/app_color.dart';

// Product model
class Product {
  final String name;
  final String imageUrl;

  Product({required this.name, required this.imageUrl});
}

// List of products with unique images and names
final List<Product> products = [
  Product(name: "Fresh Apples", imageUrl: "assets/veg1.jpg"),
  Product(name: "Organic Tomatoes", imageUrl: "assets/veg2.jpg"),
  Product(name: "Green Broccoli", imageUrl: "assets/veg2.jpg"),
  Product(name: "Carrots", imageUrl: "assets/veg1.jpg"),
  Product(name: "Potatoes", imageUrl: "assets/veg2.jpg"),
  Product(name: "Red Chilies", imageUrl: "assets/veg1.jpg"),
];

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top section - Green background with title and search bar
          Container(
            width: double.infinity,
            height: 190,
            color: AppColors.primary,
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 60, bottom: 20),
                  child: Text(
                    "Marketplace",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Search bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search products...",
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bottom section - Product Grid with padding between boxes
          Expanded(
            child: Container(
              width: double.infinity,
              color: AppColors.backPrimary,
              padding: const EdgeInsets.only(top: 40, bottom: 20, left: 30, right: 30),
              child: GridView.builder(
                padding: EdgeInsets.zero, // Removes any padding at the top
                itemCount: products.length, // Dynamic item count
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 items per row
                  crossAxisSpacing: 15, // Horizontal space
                  mainAxisSpacing: 15, // Vertical space
                  childAspectRatio: 0.85, // Adjust box height
                ),
                itemBuilder: (context, index) {
                  final product = products[index]; // Get product from list
                  return Padding(
                    padding: const EdgeInsets.all(5), // Padding inside each box
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Product Image
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              child: Image.asset(
                                product.imageUrl, // Unique image for each product
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Product Name
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              product.name, // Unique name for each product
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
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
    );
  }
}