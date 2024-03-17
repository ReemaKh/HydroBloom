import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DiscoverPage extends StatelessWidget {
  final Function(String) onAddToGarden;

  DiscoverPage({required this.onAddToGarden});

  @override
  Widget build(BuildContext context) {
    final plants = [
      {'name': 'Pothos', 'image': 'images/pothos.png'},
      {'name': 'Bamboo', 'image': 'images/bamboo.png'},
      {'name': 'Sansevieria', 'image': 'images/sansevieria.png'},
      {'name': 'Peace Lily', 'image': 'images/peace_lily.png'},
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlantCareDetailsPage(
                  plantId: plants[index]['name']!,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class PlantCard extends StatelessWidget {
  final String plantName;
  final String plantImage;
  final VoidCallback onAddToGarden;
  final VoidCallback onTap;

  const PlantCard({
    Key? key,
    required this.plantName,
    required this.plantImage,
    required this.onAddToGarden,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: InkWell(
        onTap: onTap,
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
      ),
    );
  }
}

class PlantCareDetailsPage extends StatelessWidget {
  final String plantId;

  PlantCareDetailsPage({required this.plantId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant Care Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('plants').doc(plantId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text('Plant not found'),
            );
          } else {
            Map<String, dynamic>? data = snapshot.data!.data() as Map<String, dynamic>?;
            if (data != null && data['Plant Requirements'] is Map<String, dynamic>) {
              Map<String, dynamic> plantRequirements = data['Plant Requirements'];
              String water = plantRequirements['Water'];
              String light = plantRequirements['Light'];
              String temperature = plantRequirements['Temperature'];
              String fertilizer = plantRequirements['Fertilizer'];

              String generalInfo = data['General Information'] ?? '';

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'General Information:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      generalInfo,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    iconInfo(context, Icons.water, 'Water', water, Colors.blue),
                    iconInfo(context, Icons.lightbulb, 'Light', light, Colors.yellow),
                    iconInfo(context, Icons.thermostat, 'Temperature', temperature, Colors.red),
                    iconInfo(context, Icons.eco, 'Fertilizer', fertilizer, Colors.green),
                  ],
                ),
              );
            } else {
              return Center(
                child: Text('Error: Invalid plant data'),
              );
            }
          }
        },
      ),
    );
  }
}
  Widget iconInfo(
    BuildContext context,
    IconData icon,
    String title,
    String content,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 30, color: color),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  


