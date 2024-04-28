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
  try {
    // Fetch the user ID
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Fetch the userPlantId based on the selected plant
    String userPlantId = await getUserPlantId(userId, selectedPlant);

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
    // Update sensor document with userPlantId
    await FirebaseFirestore.instance
        .collection('sensors')
        .where('name', isEqualTo: selectedSensor)
        .limit(1)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        String sensorId = snapshot.docs.first.id;
        FirebaseFirestore.instance
            .collection('sensors')
            .doc(sensorId)
            .update({'userPlantId': userPlantId});
      }
    });

    // Update userPlant document with connected field
    await FirebaseFirestore.instance
        .collection('userPlant')
        .doc(userPlantId)
        .update({'connected': true});

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

// Function to get userPlantId based on the selected plant
Future<String> getUserPlantId(String userId, String selectedPlant) async {
  String userPlantId = '';
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('userPlant')
        .where('userId', isEqualTo: userId)
        .where('plantName', isEqualTo: selectedPlant)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      userPlantId = snapshot.docs.first.id;
    }
  } catch (error) {
    print('Error fetching user plant ID: $error');
  }
  return userPlantId;
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sensor Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(120.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
              child: Text('Connect',style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF009688),
                  padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 14.0),
                  textStyle: TextStyle(fontSize: 16.0),
                ),
              
            ),
          ],
        ),
      ),
    );
  }
}