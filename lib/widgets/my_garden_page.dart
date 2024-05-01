import 'package:flutter/material.dart';
import 'package:hydrobloomapp/widgets/add_plant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MyGardenPage extends StatefulWidget {
  final String userId;

  MyGardenPage({required this.userId});

  @override
  _MyGardenPageState createState() => _MyGardenPageState();
}
class _MyGardenPageState extends State<MyGardenPage> {
  List<String> myGarden = [];
  Map<String, String> plantNames = {};

  @override
  void initState() {
    super.initState();
    fetchGardenData();
  }

  Future<void> fetchGardenData() async {
  QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
      .collection('userPlant')
      .where('userId', isEqualTo: widget.userId)
      .get();

  if (snapshot.docs.isNotEmpty) {
    setState(() {
      myGarden = snapshot.docs.map((doc) => doc['userPlantId'] as String).toList();
    });

    await fetchPlantNames();
  }
}


  Future<void> fetchPlantNames() async {
  for (String userPlantId in myGarden) {
    DocumentSnapshot<Map<String, dynamic>> userPlantSnapshot =
        await FirebaseFirestore.instance.collection('userPlant').doc(userPlantId).get();

    if (userPlantSnapshot.exists) {
      setState(() {
        plantNames[userPlantId] = userPlantSnapshot.data()!['plantName'] as String;
      });
    }
  }
}


  void removeFromGarden(String userPlantId) async {
  if (myGarden.contains(userPlantId)) {
    setState(() {
      myGarden.remove(userPlantId);
    });

    await FirebaseFirestore.instance
        .collection('userPlant')
        .doc(userPlantId)
        .delete();

    await fetchPlantNames();  
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 3,
        ),
        itemCount: myGarden.length,
        itemBuilder: (context, index) {
          String userPlantId = myGarden[index];
          String plantName = plantNames[userPlantId] ?? 'Unknown';
          return PlantGardenCard(
            plantName: plantName,
            onDelete: () => removeFromGarden(userPlantId),
            userPlantId: userPlantId,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPlant(userId: widget.userId)),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF009688),
      ),
    );
  }
}

class PlantGardenCard extends StatelessWidget {
  final String plantName;
  final VoidCallback onDelete;
  final String userPlantId;

  const PlantGardenCard({
    Key? key,
    required this.plantName,
    required this.onDelete,
    required this.userPlantId,
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
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                 .collection('userPlant')
                 .doc(userPlantId)
                 .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.exists) {
                  Map<String, dynamic>? plantData = snapshot.data!.data();

                  return Row(
                    children: <Widget>[
                      _buildStatusIcon(
                        Icons.wb_sunny,
                        plantData?['sunlightStatus']?? false,
                        Colors.orange,
                      ), //sunlight
                      _buildStatusIcon(
                        Icons.opacity,
                        plantData?['waterStatus']?? false,
                        Colors.blue,
                      ), //water
                      _buildStatusIcon(
                        Icons.thermostat_outlined,
                        plantData?['temperatureStatus']?? false,
                        Colors.red,
                      ), //temperature
                      _buildStatusIcon(
                        Icons.wind_power_rounded,
                        plantData?['humidityStatus']?? false,
                        Color.fromARGB(255, 40, 56, 163),
                      ), //humidity
                      _buildStatusIcon(
                        Icons.spa,
                        plantData?['fertilizerStatus']?? false,
                        Colors.green,
                      ), //fertilizer
                    ],
                  );
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  return Row(
                    children: <Widget>[
                      _buildStatusIcon(Icons.wb_sunny, false, Colors.grey), //sunlight
                      _buildStatusIcon(Icons.opacity, false, Colors.grey), //water
                      _buildStatusIcon(Icons.thermostat_outlined, false, Colors.grey), //temperature
                      _buildStatusIcon(Icons.wind_power_rounded, false, Colors.grey), //humidity
                      _buildStatusIcon(Icons.spa, false, Colors.grey), //fertilizer
                    ],
                  );
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.delete), 
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(
    IconData icon,
    bool status,
    Color color,
  ) {
    return Icon(
      icon,
      color: status? color : Colors.grey,
    );
  }
}

class GardenModel with ChangeNotifier {
  final List<String> _myGarden = [];

  List<String> get myGarden => List.unmodifiable(_myGarden);

  void addToGarden(String plantId) {
    if (!_myGarden.contains(plantId)) {
      _myGarden.add(plantId);
      notifyListeners();
    }
  }

  void removeFromGarden(String plantId) {
    if (_myGarden.contains(plantId)) {
      _myGarden.remove(plantId);
      notifyListeners();
    }
  }
}
