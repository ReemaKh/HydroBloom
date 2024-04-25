import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SensorsPage extends StatefulWidget {
  const SensorsPage({Key? key}) : super(key: key);

  @override
  _SensorsPageState createState() => _SensorsPageState();
}

class _SensorsPageState extends State<SensorsPage> {
  List<String> availableSensors = [];
  List<String> userPlant = [];
  String? selectedSensor;
  String? selectedPlant;

  @override
  void initState() {
    super.initState();
    fetchAvailableSensors();
    fetchUserPlant();
  }

  Future<void> fetchAvailableSensors() async {
  try {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('sensors')
        .where('userPlantId', isEqualTo: null)
        .get();

    List<String> fetchedSensors = snapshot.docs
        .map((doc) => doc['name'].toString())
        .toList();

    setState(() {
      availableSensors = fetchedSensors;
    });
  } catch (error) {
    print('Error fetching available sensors: $error');
  }
}

Future<void> fetchUserPlant() async {
  try {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('userPlant')
        .where('userId', isEqualTo: userId)
        .where('connected', isEqualTo: false)
        .get();

    List<String> fetchedPlants = snapshot.docs
        .map((doc) => doc['plantName'].toString())
        .toList();

    setState(() {
      userPlant = fetchedPlants;
    });
  } catch (error) {
    print('Error fetching user plants: $error');
  }
}

 Future<void> connectSensorToPlant(String selectedSensor, String selectedPlant) async {
  String userId = FirebaseAuth.instance.currentUser!.uid;

  try {
    // Check if the selected sensor is already connected to any plant
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('sensors')
        .where('name', isEqualTo: selectedSensor)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // Iterate over the documents to find if any sensor is already connected to a plant
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        // Check if doc.data() is not null before accessing it
        if (doc.data() != null && (doc.data() as Map<String, dynamic>).containsKey('userPlantId') && doc['userPlantId'] != null) {
          // If the sensor is already connected, show error message and return
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('The selected sensor is already connected to a plant.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
          return;
        }
      }
    }

    // If the execution reaches here, the sensor is not connected to any plant
    // Update sensor document with userPlantId only if it exists
    await FirebaseFirestore.instance
        .collection('sensors')
        .where('name', isEqualTo: selectedSensor)
        .limit(1)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        String sensorId = snapshot.docs.first.id;
        Map<String, dynamic> dataToUpdate = {'userPlantId': userId};

        // Check if doc.data() is not null before accessing it
        if (snapshot.docs.first.data() != null && (snapshot.docs.first.data() as Map<String, dynamic>).containsKey('userPlantId')) {
          // If the field doesn't exist, remove it from the data to update
          dataToUpdate.remove('userPlantId');
        }

        FirebaseFirestore.instance
            .collection('sensors')
            .doc(sensorId)
            .update(dataToUpdate);
      }
    });

    // Update userPlant document with connected field
    await FirebaseFirestore.instance
        .collection('userPlant')
        .where('userId', isEqualTo: userId)
        .where('plantName', isEqualTo: selectedPlant)
        .limit(1)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        String userPlantId = snapshot.docs.first.id;
        FirebaseFirestore.instance
            .collection('userPlant')
            .doc(userPlantId)
            .update({'connected': true});
      }
    });

    // Show success message
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Sensor connected to plant successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  } catch (error) {
    // Show error message if any error occurs during the process
    print('Error connecting sensor to plant: $error');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Failed to connect sensor to plant. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select a sensor:',
              style: TextStyle(
                fontSize: 18,
fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedSensor,
              onChanged: (String? newValue) {
                setState(() {
                  selectedSensor = newValue;
                });
              },
              items: availableSensors.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Text(
              'Select a plant:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedPlant,
              onChanged: (String? newValue) {
                setState(() {
                  selectedPlant = newValue;
                });
              },
              items: userPlant.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (selectedSensor != null && selectedPlant != null) {
                  connectSensorToPlant(selectedSensor!, selectedPlant!);
                }
              },
              child: Text('Connect'),
            ),
          ],
        ),
      ),
    );
  }
}