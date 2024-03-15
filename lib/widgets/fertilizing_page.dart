import 'package:flutter/material.dart';
import 'package:hydrobloomapp/widgets/water_change_page.dart';
class FertilizingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fertilizing Methods')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'To ensure your aquatic plants thrive, use the right fertilization methods. Here’s a guide:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            PlantCareInstruction(
              plantName: ' Bamboo',
              instructions: [
                'Requires very little fertilization. Use a diluted liquid fertilizer every 2-3 months.',
                'Ensure the fertilizer has a low nitrogen content.',
              ],
            ),
            PlantCareInstruction(
              plantName: 'Sansevieria',
              instructions: [
                'Fertilize sparingly, no more than once a month during the growing season.',
                'Use a balanced, water-soluble fertilizer, diluted to half the recommended strength.',
              ],
            ),
            PlantCareInstruction(
              plantName: 'Pothos',
              instructions: [
                'Fertilize every 4-6 weeks with a diluted liquid fertilizer.',
                'Choose a balanced fertilizer and use it at half the dose recommended for soil-grown plants.',
              ],
            ),
            PlantCareInstruction(
              plantName: 'Peace Lily',
              instructions: [
                'Use a diluted liquid fertilizer once a month during spring and summer.',
                'Opt for a fertilizer with higher phosphorus content to encourage blooming.',
              ],
            ),
          ],
        ),
      ),
    );
  }
}