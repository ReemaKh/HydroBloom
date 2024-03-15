import 'package:flutter/material.dart';
import 'package:hydrobloomapp/widgets/water_change_page.dart';
class FertilizerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('DIY Fertilizer')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Making DIY fertilizers is a sustainable way to provide nutrients to your plants. Here are some methods:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            PlantCareInstruction(
              plantName: 'Fish Tank Water',
              instructions: [
                'Contains nitrogen and other beneficial nutrients.',
                'Use it when changing the water instead of disposing of it.',
              ],
            ),
            PlantCareInstruction(
              plantName: 'Compost Tea',
              instructions: [
                'Provides balanced nutrients and enhances soil health.',
                'Soak compost in water for 1-3 days, then dilute and use.',
              ],
            ),
            PlantCareInstruction(
              plantName: 'Eggshell Solution',
              instructions: [
                'Rich in calcium and other minerals.',
                'Soak clean eggshells in water for 2-3 days, then use the water for plants.',
              ],
            ),
            PlantCareInstruction(
              plantName: 'Diluted Coffee Solution',
              instructions: [
                'Contains nitrogen and other nutrients.',
                'Use leftover water from making coffee, diluted for plants.',
              ],
            ),
          ],
        ),
      ),
    );
  }
}