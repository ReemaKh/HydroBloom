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
  String? selectedSensor;

  @override
  void initState() {
    super.initState();
    fetchAvailableSensors();
  }

  Future<void> fetchAvailableSensors() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('sensors')
          .where('userPlantId', isEqualTo: null)
          .get();

      List<String> fetchedSensors =
          snapshot.docs.map((doc) => doc['name'].toString()).toList();
      setState(() {
        availableSensors = fetchedSensors;
      });
    } catch (error) {
      print('Error fetching available sensors: $error');
    }
  }

  Future<void> connectSensorToPlant(String selectedSensor) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('sensors')
          .where('name', isEqualTo: selectedSensor)
          .where('userPlantId', isNotEqualTo: null)
          .get();

      if (snapshot.docs.isNotEmpty) {
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
              .update({'userPlantId': userId});
        }
      });

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
            ElevatedButton(
              onPressed: () {
                if (selectedSensor != null) {
                  connectSensorToPlant(selectedSensor!);
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