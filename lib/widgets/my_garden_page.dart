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

  void fetchGardenData() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('userGarden').doc(widget.userId).get();

    if (snapshot.exists) {
      setState(() {
        myGarden = List<String>.from(snapshot.data()!['plantIds'] ?? []);
      });

      await fetchPlantNames();
    }
  }

  Future<void> fetchPlantNames() async {
    // Fetching plant names based on IDs stored in myGarden
    for (String plantId in myGarden) {
      DocumentSnapshot<Map<String, dynamic>> plantSnapshot =
          await FirebaseFirestore.instance.collection('plants').doc(plantId).get();

      if (plantSnapshot.exists) {
        setState(() {
          plantNames[plantId] = plantSnapshot.data()!['Name'];
        });
      }
    }
  }

  void removeFromGarden(String plantId) async {
    if (myGarden.contains(plantId)) {
      setState(() {
        myGarden.remove(plantId);
      });

      await FirebaseFirestore.instance.collection('userGarden').doc(widget.userId).update(
        {'plantIds': FieldValue.arrayRemove([plantId])},
      );

      await fetchPlantNames(); // Refresh plant names after removing a plant
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
          String plantId = myGarden[index];
          String plantName = plantNames[plantId] ?? 'Unknown';
          return PlantGardenCard(
            plantName: plantName,
            onDelete: () => removeFromGarden(plantId),
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

  const PlantGardenCard({
    Key? key,
    required this.plantName,
    required this.onDelete,
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
            Row(
              children: <Widget>[
                Icon(Icons.wb_sunny, color: Colors.orange),
                Icon(Icons.opacity, color: Colors.blue),
                Icon(Icons.thermostat_outlined, color: Colors.red),
                Icon(Icons.spa, color: Colors.green),
              ],
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
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
