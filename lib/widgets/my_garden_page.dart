import 'package:flutter/material.dart';
import 'package:hydrobloomapp/widgets/discover_page.dart';


class MyGardenPage extends StatefulWidget {
  final List<String> myGarden;

  MyGardenPage({required this.myGarden});

  @override
  _MyGardenPageState createState() => _MyGardenPageState();
}

class _MyGardenPageState extends State<MyGardenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 3,
        ),
        itemCount: widget.myGarden.length,
        itemBuilder: (context, index) {
          String plantName = widget.myGarden[index];
          return PlantGardenCard(
            plantName: plantName,
            onDelete: () => setState(() {
              widget.myGarden.remove(plantName);
            }),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DiscoverPage(onAddToGarden: (String name) {
              setState(() {
                widget.myGarden.add(name);
              });
              Navigator.pop(context);
            })),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF009688),
      ),
    );
  }
}

// PlantGardenCard Widget
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

  void addToGarden(String plantName) {
    if (!_myGarden.contains(plantName)) {
      _myGarden.add(plantName);
      notifyListeners();
    }
  }

  void removeFromGarden(String plantName) {
    if (_myGarden.contains(plantName)) {
      _myGarden.remove(plantName);
      notifyListeners();
    }
  }
}