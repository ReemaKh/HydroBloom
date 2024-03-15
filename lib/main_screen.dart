import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'widgets/guide_page.dart';
import 'widgets/notifications_page.dart';
import 'widgets/my_garden_page.dart';
import 'widgets/discover_page.dart';
import 'widgets/profile_page.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1; // Default to 'Discover'
  List<String> myGarden = []; // Example garden list

  void onAddToGarden(String plantName) {
    if (!myGarden.contains(plantName)) {
      setState(() {
        myGarden.add(plantName);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      GuidePage(),
      NotificationsPage(),
      MyGardenPage(myGarden: myGarden), // Pass the garden list
      DiscoverPage(onAddToGarden: onAddToGarden), // Pass the callback
      ProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitleForSelectedPage(_selectedIndex)),
      ),
      body: _pages[_selectedIndex], // Directly show the selected page
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Color(0xFF009688), // Use a specific color
        items: [
          TabItem(icon: Icons.book, title: 'Guide'),
          TabItem(icon: Icons.notifications, title: 'Notifications'),
          TabItem(icon: Icons.grass, title: 'My Garden'),
          TabItem(icon: Icons.search, title: 'Discover'),
          TabItem(icon: Icons.person, title: 'Profile'),
        ],
        initialActiveIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _getTitleForSelectedPage(int index) {
    switch (index) {
      case 0: return 'Guide';
      case 1: return 'Notifications';
      case 2: return 'My Garden';
      case 3: return 'Discover';
      case 4: return 'Profile';
      default: return 'Plant App';
    }
  }
}