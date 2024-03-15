import 'package:flutter/material.dart';
class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded( 
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          PlantCareCard(
            title: 'Your Pothos Needs Light',
            subtitle: 'Move your plant closer to the sun',
            icon: Icons.wb_sunny,
            timeAgo: '2h ago',
          ),
        PlantCareCard(
          title: 'Your Bamboo Needs Water',
          subtitle: 'Change the water for your plant',
          icon: Icons.invert_colors,
          timeAgo: '2h ago',
        ),
        PlantCareCard(
          title: 'Your Bamboo Is Hungry',
          subtitle: 'Fertilize your plant',
          icon: Icons.local_florist,
          timeAgo: '4d ago',
        ),
      ],
    ));
  }
}

class PlantCareCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String timeAgo;

  const PlantCareCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.timeAgo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(icon, size: 24.0, color: Colors.black54),
                SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    subtitle,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Text(
              timeAgo,
              style: TextStyle(color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}