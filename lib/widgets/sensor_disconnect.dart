import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SensorDisconnect extends StatefulWidget {
  const SensorDisconnect({Key? key}) : super(key: key);
  @override
  _SensorDisconnectState createState() => _SensorDisconnectState();
}

class _SensorDisconnectState extends State<SensorDisconnect> {
  List<String> connectedSensors = [];
  String? selectedSensor;
  String? userId;
  List<String> userPlantIds = [];

  @override
  void initState() {
    super.initState();
    fetchUserPlantIds();
  }

  Future<void> fetchUserPlantIds() async {
    try {
      userId = FirebaseAuth.instance.currentUser!.uid;

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('userPlant')
          .where('userId', isEqualTo: userId)
          .get();

      userPlantIds = snapshot.docs.map((doc) => doc.id).toList();

      fetchConnectedSensors();
    } catch (error) {
      print('Error fetching user plant ids: $error');
    }
  }

  Future<void> fetchConnectedSensors() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('sensors')
          .where('userPlantId', whereIn: userPlantIds)
          .get();

      List<String> fetchedSensors =
          snapshot.docs.map((doc) => doc['name'].toString()).toList();

      setState(() {
        connectedSensors = fetchedSensors;
      });
    } catch (error) {
      print('Error fetching connected sensors: $error');
    }
  }

  Future<void> disconnectSensorFromPlant(String selectedSensor) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('sensors')
          .where('name', isEqualTo: selectedSensor)
          .get();

      if (snapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in snapshot.docs) {
          if (doc.data() != null &&
              (doc.data() as Map<String, dynamic>).containsKey('userPlantId') &&
              doc['userPlantId'] == null) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('The selected sensor is already not connected to any plant.'),
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

          if (doc.data() != null &&
              (doc.data() as Map<String, dynamic>).containsKey('userPlantId') &&
              doc['userPlantId'] != null) {
            String sensorId = doc.id;
            String userPlantId = doc['userPlantId'];

            // Update sensor document to remove userPlantId
            await FirebaseFirestore.instance
                .collection('sensors')
                .doc(sensorId)
                .update({'userPlantId': null});

            // Update userPlant document to set connected field to false
            await FirebaseFirestore.instance
                .collection('userPlant')
                .doc(userPlantId)
                .update({'connected': false});

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Success'),
                  content: Text('Sensor disconnected from plant successfully.'),
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
      }
    } catch (error) {
      print('Error disconnecting sensor from plant: $error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to disconnect sensor from plant. Please try again.'),
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
        title: Text('Disconnect Sensor'),
      ),
      body: Padding(
        padding: EdgeInsets.all(120.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Select a connected sensor:',
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
              items: connectedSensors
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (selectedSensor!= null) {
                  disconnectSensorFromPlant(selectedSensor!);
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Please select a sensor to disconnect.'),
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
              },
              child: Text(
                'Disconnect',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              style: ElevatedButton.styleFrom(
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