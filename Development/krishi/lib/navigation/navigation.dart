import 'package:flutter/material.dart';
import 'package:krishi/Screens/mainscreens/chat_screen.dart';
import 'package:krishi/Screens/mainscreens/home_screen.dart';
import 'package:krishi/Screens/mainscreens/marketplace_screen.dart';
import 'package:krishi/Screens/mainscreens/profile_screen.dart';
import 'package:krishi/Screens/mainscreens/shopping_screen.dart';

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;

  // ✅ Ensure there are 4 screens to match 4 navigation items
  final List<Widget> _pages = [
    HomeScreen(),
    MarketplaceScreen(),
    ShoppingScreen(),
    // ChatScreen(chatRoomName: "room123"),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront),
            label: 'Market',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shop',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.chat),
          //   label: 'Chat',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

// ✅ Temporary Placeholder Screen to prevent crashes
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text("$title Page Coming Soon!")),
    );
  }
}