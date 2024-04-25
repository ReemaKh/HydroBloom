import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPlant extends StatelessWidget {
  final String userId;

  AddPlant({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Plant To The Garden' ,style: TextStyle(
      color: Colors.white,
    ),),
        backgroundColor: Color(0xFF009688),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('plants').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
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
                final plantImage = plant['image'];

                return PlantCard(
                  plantId: plantId,
                  plantName: plantName,
                  plantImage: plantImage,
                  onAddToGarden: () => _addToUserGarden(userId, plantId), // Pass userId to the function
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

  Future<void> _addToUserGarden(String userId, String plantId) async {
    try {
      // Fetch plant details
      DocumentSnapshot<Map<String, dynamic>> plantSnapshot =
          await FirebaseFirestore.instance.collection('plants').doc(plantId).get();
      if (!plantSnapshot.exists) {
        print('Plant with ID $plantId not found.');
        return;
      }

      // Get plant name
      String plantName = plantSnapshot.data()!['Name'];
      print('Plant name: $plantName');

       // Add plant to userPlant collection
    String userPlantId = FirebaseFirestore.instance.collection('userPlant').doc().id;
    await FirebaseFirestore.instance.collection('userPlant').doc(userPlantId).set({
      'userPlantId': userPlantId,
      'userId': userId,
      'plantId': plantId,
      'plantName': plantName,
      'plantStatus': {
        'water': false,
        'fertilizer': false,
        'sunlight': false,
        'temperature': false,
        'humidity': false,
      },
      //هاذي كلها فولللس باي ديفولت
      
      // الكونيكتيد فولس لين النبته تصير كونيكتيد لسينسور
      
      'connected': false,
    });

      // Add userPlantId to userGarden collection
      await FirebaseFirestore.instance.collection('userGarden').doc(userId).set({
        'userId': userId,
        'userPlantIds': FieldValue.arrayUnion([userPlantId]),
      }, SetOptions(merge: true));
    } catch (error) {
      print('Error adding plant to user garden: $error');
    }
  }
}

class PlantCard extends StatelessWidget {
  final String plantId;
  final String plantName;
  final String plantImage;
  final VoidCallback onAddToGarden;
  final VoidCallback onTap;

  const PlantCard({
    required this.plantId,
    required this.plantName,
    required this.plantImage,
    required this.onAddToGarden,
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
              child: Image.network(
                plantImage,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    plantName,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: onAddToGarden,
                  ),
                ],
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
        future:
            FirebaseFirestore.instance.collection('plants').doc(plantId).get(),
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
            Map<String, dynamic>? data =
                snapshot.data!.data() as Map<String, dynamic>?;
            if (data != null &&
                data['Plant Requirements'] is Map<String, dynamic>) {
              Map<String, dynamic> plantRequirements =
                  data['Plant Requirements'];
              String water = plantRequirements['Water'];
              String light = plantRequirements['Light'];
              String temperature = plantRequirements['Temperature'];
              String fertilizer = plantRequirements['Fertilizer'];

              String generalInfo = data['General Information'] ?? '';
              String plantImage = data['image'] ?? '';

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color.fromARGB(255, 233, 229, 229),
                            width: 5.0,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(plantImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
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
                    iconInfo(context, Icons.lightbulb, 'Light', light,
                        Colors.yellow),
                    iconInfo(context, Icons.thermostat, 'Temperature',
                        temperature, Colors.red),
                    iconInfo(context, Icons.eco, 'Fertilizer', fertilizer,
                        Colors.green),
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
  return Padding(
    padding: const EdgeInsets.only(bottom: 30.0), 
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
          ],
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 16),
        ),
      ],
    ),
  );
}
