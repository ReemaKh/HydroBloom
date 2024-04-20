import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'widgets/guide_page.dart';
import 'widgets/notifications_page.dart';
import 'widgets/my_garden_page.dart';
import 'widgets/discover_page.dart';
import 'widgets/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1; 
  String userId = ''; 

  @override
  void initState() {
    super.initState();
    fetchUserId(); 
  }

  void fetchUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          userId = user.uid;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      GuidePage(),
      NotificationsPage(),
      MyGardenPage(userId: userId),
      DiscoverPage(),
      ProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitleForSelectedPage(_selectedIndex)),
        automaticallyImplyLeading: false,
      ),
      body: _pages[_selectedIndex], 
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Color(0xFF009688), 
        items: [
          TabItem(icon: Icons.book, title: 'Guide'),
          TabItem(icon: Icons.notifications, title: 'Alerts'),
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
      case 0:
        return 'Guide';
      case 1:
        return 'Alerts';
      case 2:
        return 'My Garden';
      case 3:
        return 'Discover';
      case 4:
        return 'Profile';
      default:
        return 'Plant App';
    }
  }
}
