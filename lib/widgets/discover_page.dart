import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DiscoverPage extends StatelessWidget {
  //final Function(String) onAddToGarden;

  //DiscoverPage({required this.onAddToGarden});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('plants').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No plants found'),
            );
          } else {
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final plant = snapshot.data!.docs[index];
                final plantId = plant.id;
                final plantName = plant['Name'];
                final plantImage = 'images/${plantName.toLowerCase().replaceAll(' ', '_')}.png';

                return PlantCard(
                  plantId: plantId,
                  plantName: plantName,
                  plantImage: plantImage,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlantCareDetailsPage(
                          plantId: plantId,
                          plantName: plantName,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class PlantCard extends StatelessWidget {
  final String plantId;
  final String plantName;
  final String plantImage;
  final VoidCallback onTap;

  const PlantCard({
    required this.plantId,
    required this.plantName,
    required this.plantImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                plantImage,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                plantName,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlantCareDetailsPage extends StatelessWidget {
  final String plantId;
  final String plantName;

  PlantCareDetailsPage({required this.plantId, required this.plantName});

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
                    const Text(
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

Widget iconInfo(BuildContext context, IconData icon, String title, String value, Color color) {
  return Row(
    children: [
      Icon(icon, color: color),
      SizedBox(width: 8),
      Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(width: 8),
      Text(
        value,
        style: TextStyle(fontSize: 16),
      ),
    ],
  );
}
