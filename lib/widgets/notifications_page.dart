import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

String userId = FirebaseAuth.instance.currentUser!.uid;

class PlantCareCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String timeAgo;
  final VoidCallback? fun;

  const PlantCareCard(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.icon,
      required this.timeAgo,
      this.fun})
      : super(key: key);

  @override
  State<PlantCareCard> createState() => _PlantCareCardState();
}

var ec, humidity, lightIntensity, ph, tds, temperature;
getAllSensorData() async {
  final databaseReference = FirebaseDatabase.instance.ref().child('sensor_reading');

  DatabaseEvent event = await databaseReference.once();

  ec = event.snapshot.child("EC").value;
  humidity = event.snapshot.child("Humidity").value;
  lightIntensity = event.snapshot.child("Light_Intensity").value;
  ph = event.snapshot.child("Ph").value;
  tds = event.snapshot.child("TDS").value;
  temperature = event.snapshot.child("Temperature").value;

  print("------------------------------------\n$temperature");
  print("------------------------------------\n$ec");
  print("------------------------------------\n$tds");
}

class _PlantCareCardState extends State<PlantCareCard> {
  void initState() {
    super.initState();
    getAllSensorData();
  }

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
            IconButton(
              onPressed: () {
                getAllSensorData();
              },
              icon: Icon(Icons.abc),
            ),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(widget.icon, size: 24.0, color: Colors.black54),
                SizedBox(width: 10.0),
                Expanded(
                  child: Text(
                    widget.subtitle,
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Text(
              widget.timeAgo,
              style: TextStyle(color: Colors.black45),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  Future<void> printAllValuesInUserPlantCollection(
      Map<String, dynamic> state) async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('userPlant').get();

    for (final QueryDocumentSnapshot document in snapshot.docs) {
      final Map<String, dynamic> data =
          (document.data() as Map<String, dynamic>);

      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('userPlant')
          .where('userId', isEqualTo: userId)
          .get();

      final WriteBatch batch = FirebaseFirestore.instance.batch();

      for (final DocumentSnapshot document in snapshot.docs) {
        final DocumentReference docRef =
            FirebaseFirestore.instance.collection('userPlant').doc(document.id);
        batch.update(docRef, {'plantStatus': state});
      }

      await batch.commit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('HH:mm');
    final String formattedTime = formatter.format(now);
    final DateTime startTime = formatter.parse('07:00');
    final DateTime endTime = formatter.parse('18:00');
    late String tmsg = '', submsg = '';

    return (now.isAfter(startTime) || now.isBefore(endTime))
        ? StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('plants').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No plants found'),
                );
              } else {
                return Column(
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          await getAllSensorData();
                          setState(() {});
                        },
                        child: Text("ref")),
                    Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final data = snapshot.data!.docs[index];
                            final name = data['Name'];
                            final String documentId =
                                snapshot.data!.docs[index].id;
                            Map<String, dynamic> normalCondition =
                                data['Normal condition'];
                            final ecMax = normalCondition['ec']['max'];
                            final ecMin = normalCondition['ec']['min'];
                            final humidityMax =
                                normalCondition['humidity']['max'];
                            final humidityMin =
                                normalCondition['humidity']['min'];
                            final lightMax = normalCondition['light']['max'];
                            final lightMin = normalCondition['light']['min'];
                            final phMax = normalCondition['ph']['max'];
                            final phMin = normalCondition['ph']['min'];

                            final tdsMax = normalCondition['tds']['max'];
                            final tdsMin = normalCondition['tds']['min'];

                            final tempMax = normalCondition['temp']['max'];
                            final tempMin = normalCondition['temp']['min'];
                            if (lightIntensity < lightMin) {
                              tmsg = "light 💡:your $name   plant needs lights";
                              submsg =
                                  "move your $name plant closer to the sun ";
                            } else if (lightIntensity > lightMax) {
                              tmsg =
                                  "light 💡:your $name plant has enough of light time ";
                              submsg =
                                  "move your $name plant away from the sun ";
                              printAllValuesInUserPlantCollection({
                                'sunlight': true,
                              });
                            } else if (ph > phMax || ph < phMin) {
                              tmsg = "water 💧: your $name plant needs water";
                              submsg = "change the water for your $name plant";
                              printAllValuesInUserPlantCollection({
                                'water': true,
                              });
                            } else if (ec > ecMax ||
                                ec < ecMin ||
                                tds > tdsMax ||
                                tds < tdsMin) {
                              tmsg =
                                  "Fertilize 🪴: your $name plant is hungry ";
                              submsg = "Fertilize your $name plant ";
                              printAllValuesInUserPlantCollection(
                                  {'fertilizer': true});
                            } else if (temperature > tempMax) {
                              tmsg =
                                  "Temperature 🌡️ : your $name plant is felling hot";
                              submsg =
                                  "move your $name plant to a colder place ";
                              printAllValuesInUserPlantCollection({
                                'temperature': true,
                              });
                            } else if (temperature < tempMin) {
                              tmsg =
                                  "Temperature 🌡️ : your $name plant is felling cold";
                              submsg =
                                  "move your $name  plant to a wormer place ";
                              printAllValuesInUserPlantCollection({
                                'temperature': true,
                              });
                            } else if (humidity > humidityMax ||
                                humidity < humidityMin) {
                              tmsg =
                                  "Humidity 🌪️ :  plant needs some fresh air";
                              submsg =
                                  "open the window so your $name plant can breathe";
                              printAllValuesInUserPlantCollection({
                                'temperature': true,
                              });
                            } else {
                              tmsg = "";
                              submsg = "";
                              // Update the "plantState" field in the "userPlant" document
                            }
                            return InkWell(
                              child: PlantCareCard(
                                title: "$tmsg",
                                // ? 'your $name $plantName Needs Water'
                                // : 'hhhh',
                                subtitle: "$submsg",
                                icon: Icons.invert_colors,
                                timeAgo: '2h ago',
                              ),
                              onTap: () {},
                            );
                          }),
                    ),
                  ],
                );
              }
            },
          )
        : Container();
  }
}
