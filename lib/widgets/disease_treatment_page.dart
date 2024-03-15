import 'package:flutter/material.dart';
class DiseaseTreatmentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Disease Treatment')),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          DiseaseInfoCard(
            plantName: ' Bamboo',
            symptoms: 'Yellow leaves and black or brown roots.',
            treatment: 'Use distilled water, change it regularly, and trim damaged roots.',
          ),
          DiseaseInfoCard(
            plantName: 'sansevieria',
            symptoms: 'Brown leaf tips.',
            treatment: 'Use distilled water and increase humidity.',
          ),
          DiseaseInfoCard(
            plantName: 'Pothos',
            symptoms: 'Yellow leaves.',
            treatment: 'Provide ample indirect light and change the water regularly.',
          ),
          DiseaseInfoCard(
            plantName: 'Peace Lily',
            symptoms: 'Yellow leaves and brown spots on leaves.',
            treatment: 'Adjust watering, ensure indirect light, and mist leaves to increase humidity.',
          ),
        ],
      ),
    );
  }
}

class DiseaseInfoCard extends StatelessWidget {
  final String plantName;
  final String symptoms;
  final String treatment;

  const DiseaseInfoCard({
    Key? key,
    required this.plantName,
    required this.symptoms,
    required this.treatment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(plantName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Symptoms: $symptoms', style: TextStyle(fontSize: 16)),
            SizedBox(height: 4),
            Text('Treatment: $treatment', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}