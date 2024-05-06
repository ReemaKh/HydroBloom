import 'package:flutter/material.dart';
import 'package:hydrobloomapp/widgets/water_change_page.dart';

class FertilizerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('DIY Fertilizer')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                'Making DIY fertilizers is a sustainable way to provide nutrients to your plants. Here are some methods:',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              _FertilizerCard(
                title: 'Fish Tank Water',
                icon: Icons.water_drop,
                iconColor: Colors.blue,
                instructions: [
                  'Contains nitrogen and other beneficial nutrients.',
                  'Use it when changing the water instead of disposing of it.',
                ],
              ),
              SizedBox(height: 16),
              _FertilizerCard(
                title: 'Compost Tea',
                icon: Icons.eco,
                iconColor: Colors.green,
                instructions: [
                  'Provides balanced nutrients and enhances soil health.',
                  'Soak compost in water for 1-3 days, then dilute and use.',
                ],
              ),
              SizedBox(height: 16),
              _FertilizerCard(
                title: 'Eggshell Solution',
                icon: Icons.egg,
                iconColor: Colors.brown,
                instructions: [
                  'Rich in calcium and other minerals.',
                  'Soak clean eggshells in water for 2-3 days, then use the water for plants.',
                ],
              ),
              SizedBox(height: 16),
              _FertilizerCard(
                title: 'Diluted Coffee Solution',
                icon: Icons.coffee,
                iconColor: Colors.brown,
                instructions: [
                  'Contains nitrogen and other nutrients.',
                  'Use leftover water from making coffee, diluted for plants.',
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FertilizerCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<String> instructions;

  _FertilizerCard({required this.title, required this.icon, required this.iconColor, required this.instructions});

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
                 ...instructions.map((instruction) => Text(instruction, style: TextStyle(fontSize: 16))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}