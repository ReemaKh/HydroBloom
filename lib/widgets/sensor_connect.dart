import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class sensorConnect extends StatefulWidget {
  const sensorConnect({Key? key}) : super(key: key);

  @override
  _sensorConnectState createState() => _sensorConnectState();
}

class _sensorConnectState extends State<sensorConnect> {
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
      String userId = FirebaseAuth.instance.currentUser!.uid;
      String userPlantId = await getUserPlantId(userId, selectedPlant);

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('sensors')
          .where('name', isEqualTo: selectedSensor)
          .get();

      if (snapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in snapshot.docs) {
          if (doc.data() != null && (doc.data() as Map<String, dynamic>).containsKey('userPlantId') && doc['userPlantId'] != null) {
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

      await FirebaseFirestore.instance
          .collection('userPlant')
          .doc(userPlantId)
          .update({'connected': true});

      showDialog(
        context:context,
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
        title: Text('Connect Sensor'),
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
                if (selectedSensor == null || selectedPlant == null) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Please select a sensor and a plant before pressing connect button.'),
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
                } else {
                  connectSensorToPlant(selectedSensor!, selectedPlant!);
                }
              },
              child: Text('Connect'),
              style: ElevatedButton.styleFrom(
                
              
                foregroundColor: Colors.white,
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