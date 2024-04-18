import 'package:flutter/material.dart';
import 'disease_treatment_page.dart';
import 'water_change_page.dart';
import 'fertilizer_page.dart';
import 'fertilizing_page.dart';

class GuidePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16.0),
        childAspectRatio: 8.0 / 9.0,
        children: <Widget>[
          GuideItem(
            title: 'Find out your plant disease and treatment',
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiseaseTreatmentPage())),
          ),
          GuideItem(
            title: 'The correct way to change water',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => WaterChangePage())),
          ),
          GuideItem(
            title: 'DIY Fertilizer at your home',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => FertilizerPage())),
          ),
          GuideItem(
            title: 'The correct way to fertilizing',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => FertilizingPage())),
          ),
        ],
      ),
    );
  }
}

class GuideItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  GuideItem({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.filter_vintage_outlined),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
