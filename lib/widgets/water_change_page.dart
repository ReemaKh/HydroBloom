import 'package:flutter/material.dart';
class WaterChangePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Water Change'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Changing water for your plants is crucial to their health. Here’s how to do it correctly for various types:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            PlantCareInstruction(
              plantName: 'Lucky Bamboo',
              instructions: [
                'Change the water every 2 to 4 weeks.',
                'Use distilled or rainwater to avoid salt buildup.',
                'Gently rinse the roots under running water, clean the container, then refill it with fresh water.',
              ],
            ),
            PlantCareInstruction(
              plantName: 'Sansevieria',
              instructions: [
                'Sansevieria is typically grown in soil, but if using water culture, change the water every 2 weeks.',
                'Use room temperature distilled water to avoid shock and chemical buildup.',
                'Ensure the container is cleaned before refilling to prevent bacterial growth.',
              ],
            ),
            PlantCareInstruction(
              plantName: 'Pothos',
              instructions: [
                'Change the water every 1 to 2 weeks.',
                'Use distilled water or aired tap water to avoid chlorine and other chemicals.',
              ],
            ),
            PlantCareInstruction(
              plantName: 'Peace Lily',
              instructions: [
                'Change the water weekly, especially if grown in water only.',
                'Distilled water is preferred to avoid mineral buildup.',
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PlantCareInstruction extends StatelessWidget {
  final String plantName;
  final List<String> instructions;

  const PlantCareInstruction({
    Key? key,
    required this.plantName,
    required this.instructions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              plantName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            for (var instruction in instructions)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('• $instruction', style: TextStyle(fontSize: 16)),
              ),
          ],
        ),
      ),
    );
  }
}