import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hydrobloomapp/widgets/profile_page.dart';


class sensorConnect extends StatefulWidget {
  const sensorConnect({Key? key}) : super(key: key);

  @override
  _sensorConnectState createState() => _sensorConnectState();
}

class _sensorConnectState extends State<sensorConnect> {
  String? connectionCode;

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Connection Code'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
         
          children: [
            Text(
              'Please enter the 8-character connection \n code that was provided with the sensor:',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: 'Enter Connection Code'),
              onChanged: (value) {
                setState(() {
                  connectionCode = value;
                });
              },
              onSubmitted: (_) {
                _handleConnect();
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleConnect,
              child: Text('Next'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color.fromARGB(255, 160, 86, 136), // text color
                padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 14.0),
                textStyle: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleConnect() {
    if (connectionCode != null && connectionCode!.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('sensors')
          .where('connectionCode', isEqualTo: connectionCode)
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.docs.isNotEmpty) {
          final sensorData = snapshot.docs.first.data();
          final userPlantId = (sensorData as Map<String, dynamic>)['userPlantId'];
          if (userPlantId == null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ConnectPage(connectionCode: connectionCode)),
            );
          } else {
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
          }
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Invalid connection code.'),
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
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Connection code cannot be empty.'),
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

class ConnectPage extends StatefulWidget {
  final String? connectionCode;

  const ConnectPage({Key? key, this.connectionCode}) : super(key: key);

  @override
  _ConnectPageState createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  List<String> userPlant = [];
  String? selectedPlant;
  String? sensorName;

  @override
  void initState() {
    super.initState();
    fetchUserPlant();
    fetchSensorName();
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

  Future<void> fetchSensorName() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('sensors')
          .where('connectionCode', isEqualTo: widget.connectionCode)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          sensorName = snapshot.docs.first['name'].toString();
        });
      }
    } catch (error) {
      print('Error fetching sensor name: $error');
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

  Future<void> connectSensorToPlant(String userPlantId) async {
    try {
      // Check if the sensor is already connected
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('sensors')
          .where('connectionCode', isEqualTo: widget.connectionCode)
          .get();

      
      // Update sensor document with userPlantId
      snapshot = await FirebaseFirestore.instance
          .collection('sensors')
          .where('connectionCode', isEqualTo: widget.connectionCode)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        String sensorId = snapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('sensors')
            .doc(sensorId)
            .update({'userPlantId': userPlantId});

        // Update userPlant to mark as connected
        await FirebaseFirestore.instance
            .collection('userPlant')
            .doc(userPlantId)
            .update({'connected': true});

        // Show success dialog
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
                   Navigator.pop(context);
                   Navigator.pop(context);
                   Navigator.pop(context);
                
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
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
        title: Text('Connect Sensor'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          
          children: [
            Text(
              '\n \n \n Sensor Name: $sensorName \n \n \n Please select a plant:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedPlant != null) {
                  String userId = FirebaseAuth.instance.currentUser!.uid;
                  getUserPlantId(userId, selectedPlant!).then((userPlantId) {
                    if (userPlantId.isNotEmpty) {
                      connectSensorToPlant(userPlantId);
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text('User plant ID is null. Cannot connect sensor.'),
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
                  });
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('Please select a plant before connecting.'),
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
              child: Text('Connect'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor:  Color.fromARGB(255, 160, 86, 136), // text color
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
