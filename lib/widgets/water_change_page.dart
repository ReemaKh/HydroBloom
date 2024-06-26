import 'package:flutter/material.dart';

class WaterChangePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Water Change'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                'Changing water for your plants is crucial to their health. Here’s how to do it correctly for various types:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              _WaterChangeCard(
                title: 'Bamboo',
                icon: Icons.water_drop,
                iconColor: const Color.fromARGB(255, 94, 180, 250),
                instructions: [
                  'Change the water every 2 to 4 weeks.',
                  'Use distilled or rainwater to avoid salt buildup.',
                  'Gently rinse the roots under running water, clean the container, then refill it with fresh water.',
                ],
              ),
              SizedBox(height: 16),
              _WaterChangeCard(
                title: 'Sansevieria',
                icon: Icons.water_drop,
                iconColor: const Color.fromARGB(255, 68, 129, 234),
                instructions: [
                  'Sansevieria is typically grown in soil, but if using water culture, change the water every 2 weeks.',
                  'Use room temperature distilled water to avoid shock and chemical buildup.',
                  'Ensure the container is cleaned before refilling to prevent bacterial growth.',
                ],
              ),
              SizedBox(height: 16),
              _WaterChangeCard(
                title: 'Pothos',
                icon: Icons.water_drop,
                iconColor: const Color.fromARGB(255, 35, 107, 143),
                instructions: [
                  'Change the water every 1 to 2 weeks.',
                  'Use distilled water or aired tap water to avoid chlorine and other chemicals.',
                ],
              ),
              SizedBox(height: 16),
              _WaterChangeCard(
                title: 'Peace Lily',
                icon: Icons.water_drop,
                iconColor: Color.fromARGB(255, 9, 69, 98),
                instructions: [
                  'Change the water weekly, especially if grown in water only.',
                  'Distilled water is preferred to avoid mineral buildup.',
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WaterChangeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<String> instructions;

  _WaterChangeCard({required this.title, required this.icon, required this.iconColor, required this.instructions});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 24, color: iconColor),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ...instructions.map((instruction) => Text('• $instruction', style: TextStyle(fontSize: 16))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}