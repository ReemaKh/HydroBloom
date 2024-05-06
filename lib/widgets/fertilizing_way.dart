import 'package:flutter/material.dart';
import 'package:hydrobloomapp/widgets/water_change_page.dart';

class FertilizingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fertilizing Methods')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                'To ensure your aquatic plants thrive, use the right fertilization methods. Here’s a guide:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              _FertilizingCard(
                title: 'Bamboo',
                icon: Icons.local_florist,
                iconColor: Color.fromARGB(255, 233, 198, 41),
                instructions: [
                  'Requires very little fertilization. Use a diluted liquid fertilizer every 2-3 months.',
                  'Ensure the fertilizer has a low nitrogen content.',
                ],
              ),
              SizedBox(height: 16),
              _FertilizingCard(
                title: 'Sansevieria',
                icon: Icons.local_florist,
                iconColor:Color.fromARGB(255, 181, 84, 84),
                instructions: [
                  'Fertilize sparingly, no more than once a month during the growing season.',
                  'Use a balanced, water-soluble fertilizer, diluted to half the recommended strength.',
                ],
              ),
              SizedBox(height: 16),
              _FertilizingCard(
                title: 'Pothos',
                icon: Icons.local_florist,
                iconColor: Color.fromARGB(255, 204, 91, 170),
                instructions: [
                  'Fertilize every 4-6 weeks with a diluted liquid fertilizer.',
                  'Choose a balanced fertilizer and use it at half the dose recommended for soil-grown plants.',
                ],
              ),
              SizedBox(height: 16),
              _FertilizingCard(
                title: 'Peace Lily',
                icon: Icons.local_florist,
                iconColor: Color.fromARGB(255, 136, 48, 184),
                instructions: [
                  'Use a diluted liquid fertilizer once a month during spring and summer.',
                  'Opt for a fertilizer with higher phosphorus content to encourage blooming.',
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FertilizingCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<String> instructions;

  _FertilizingCard({required this.title, required this.icon, required this.iconColor, required this.instructions});

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