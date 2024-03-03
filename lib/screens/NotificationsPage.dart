import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1; // Default to 'Discover'
  List<String> myGarden = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void addToGarden(String plantName) {
    if (!myGarden.contains(plantName)) {
      setState(() {
        myGarden.add(plantName);
      });
    }
  }

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      GuidePage(),
      NotificationsPage(),
      MyGardenPage(myGarden: myGarden),
      DiscoverPage(onAddToGarden: addToGarden),
      ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitleForSelectedPage(_selectedIndex)),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Color(0xFF009688),
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

  String _getTitleForSelectedPage(int index) {
    switch (index) {
      case 0:
        return 'Guide';
      case 1:
        return 'Notifications';
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

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null || !user.emailVerified) {
      // User is not signed in or email is not verified
      return const Scaffold(
        body: Center(
          child: Text('Please verify your email to be able to enjoy the application.'),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: const <Widget>[
        PlantCareCard(
          title: 'Your Pothos Needs Light',
          subtitle: 'Move your plant closer to the sun',
          icon: Icons.wb_sunny,
          timeAgo: '2h ago',
        ),
        PlantCareCard(
          title: 'Your Bamboo Needs Water',
          subtitle: 'Change the water for your plant',
          icon: Icons.invert_colors,
          timeAgo: '2h ago',
        ),
        PlantCareCard(
          title: 'Your Bamboo Is Hungry',
          subtitle: 'Fertilize your plant',
          icon: Icons.local_florist,
          timeAgo: '4d ago',
        ),
      ],
    );
  }
}


class PlantCareCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String timeAgo;

  const PlantCareCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.timeAgo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(icon, size: 24.0, color: Colors.black54),
                SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    subtitle,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Text(
              timeAgo,
              style: TextStyle(color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}

class GuidePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16.0),
        childAspectRatio: 8.0 / 9.0,
        children: <Widget>[
          GuideItem(
            title: 'Find out your plant disease and treatment',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DiseaseTreatmentPage()));
            },
          ),
          GuideItem(
            title: 'The correct way to change water',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => WaterChangePage()));
            },
          ),
          GuideItem(
            title: 'DIY Fertilizer at your home',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FertilizerPage()));
            },
          ),
          GuideItem(
            title: 'The correct way to fertilizing',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FertilizingPage()));
            },
          ),
          // ... other items
        ],
      ),
    );
  }
}

class GuideItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  GuideItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.info_outline),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
              ),
            ),
            TextButton(
              child: Text('Learn more'),
              onPressed: onTap,
            ),
          ],
        ),
      ),
    );
  }
}

class DiseaseTreatmentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disease Treatment'),
      ),
      body: Center(
        child: Text('Information about plant disease treatment'),
      ),
    );
  }
}

class WaterChangePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Water Change'),
      ),
      body: Center(
        child: Text('Information about the correct way to change water'),
      ),
    );
  }
}

class FertilizerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DIY Fertilizer'),
      ),
      body: Center(
        child: Text('Instructions for creating fertilizer at home'),
      ),
    );
  }
}

class FertilizingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fertilizing Methods'),
      ),
      body: Center(
        child: Text('Information about the correct way to fertilize plants'),
      ),
    );
  }
}




class DiscoverPage extends StatelessWidget {
  final Function(String) onAddToGarden;

  DiscoverPage({required this.onAddToGarden});

  @override
  Widget build(BuildContext context) {
    
    final plants = [
      {'name': 'Pothos', 'image': 'logo-2.png'},
      {'name': 'Bamboo', 'image': 'logo-2.png'},
      {'name': 'Sansevieria', 'image': 'logo-2.png'},
      {'name': 'Peace Lily', 'image': 'logo-2.png'},
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
      ),
      itemCount: plants.length,
      itemBuilder: (context, index) {
        return PlantCard(
          plantName: plants[index]['name']!,
          plantImage: plants[index]['image']!,
          onAddToGarden: () => onAddToGarden(plants[index]['name']!),
        );
      },
    );
  }
}

class PlantCard extends StatelessWidget {
  final String plantName;
  final String plantImage;
  final VoidCallback onAddToGarden;

  const PlantCard({
    Key? key,
    required this.plantName,
    required this.plantImage,
    required this.onAddToGarden,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            plantImage,
            height: 100,
            fit: BoxFit.contain,
          ),
          Text(
            plantName,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: Colors.green),
            onPressed: onAddToGarden,
          ),
        ],
      ),
    );
  }
}

class MyGardenPage extends StatefulWidget {
  final List<String> myGarden;

  MyGardenPage({required this.myGarden});

  @override
  _MyGardenPageState createState() => _MyGardenPageState();
}

class _MyGardenPageState extends State<MyGardenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 3,
        ),
        itemCount: widget.myGarden.length,
        itemBuilder: (context, index) {
          String plantName = widget.myGarden[index];
          return PlantGardenCard(
            plantName: plantName,
            onDelete: () => setState(() {
              widget.myGarden.remove(plantName);
            }),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DiscoverPage(onAddToGarden: (String name) {
              setState(() {
                widget.myGarden.add(name);
              });
              Navigator.pop(context);
            })),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF009688),
      ),
    );
  }
}

// PlantGardenCard Widget
class PlantGardenCard extends StatelessWidget {
  final String plantName;
  final VoidCallback onDelete;

  const PlantGardenCard({
    Key? key,
    required this.plantName,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Color(0xFF009688),
              child: Text(plantName[0]),
            ),
            Text(
              plantName,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: <Widget>[
                Icon(Icons.wb_sunny, color: Colors.orange),
                Icon(Icons.opacity, color: Colors.blue),
                Icon(Icons.thermostat_outlined, color: Colors.red),
                Icon(Icons.spa, color: Colors.green),
              ],
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}



class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Profile Content')),
    );
  }
}