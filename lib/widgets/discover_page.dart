import 'package:flutter/material.dart';
class DiscoverPage extends StatelessWidget {
  final Function(String) onAddToGarden;

  DiscoverPage({required this.onAddToGarden});

  @override
  Widget build(BuildContext context) {
    
    final plants = [
      {'name': 'Pothos', 'image': 'images/pothos.png'},
      {'name': 'Bamboo', 'image': 'images/bamboo.png'},
      {'name': 'Sansevieria', 'image': 'images/sansevieria.png'},
      {'name': 'Peace Lily', 'image': 'images/peace_lily.png'},
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
      ),
      itemCount: plants.length,
      itemBuilder: (context, index) {
        return PlantCard(
          plantName: plants[index]['name']!,
          plantImage: plants[index]['image']!,
          onAddToGarden: () => onAddToGarden(plants[index]['name']!),
        );
      },
    );
  }
}

class PlantCard extends StatelessWidget {
  final String plantName;
  final String plantImage;
  final VoidCallback onAddToGarden;

  const PlantCard({
    Key? key,
    required this.plantName,
    required this.plantImage,
    required this.onAddToGarden,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            plantImage,
            height: 100,
            fit: BoxFit.contain,
          ),
          Text(
            plantName,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: Colors.green),
            onPressed: onAddToGarden,
          ),
        ],
      ),
    );
  }
}