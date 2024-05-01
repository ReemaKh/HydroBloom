import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
  final databaseReference =
      FirebaseDatabase.instance.reference().child('sensor_reading');

  DatabaseEvent event = await databaseReference.once();

  ec = event.snapshot.child("EC").value;
  humidity = event.snapshot.child("Humidity").value;
  lightIntensity = event.snapshot.child("Light_Intensity").value;
  ph = event.snapshot.child("Ph").value;
  tds = event.snapshot.child("TDS").value;
  temperature = event.snapshot.child("Temperature").value;
}

List<String> tmsgList = [];
List<String> submsgList = [];

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
              icon: Icon(
                Icons.notifications_active,
                color: Color.fromRGBO(160, 86, 136, 1),
              ),
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
                Icon(
                  widget.icon,
                  size: 24.0,
                  color: Color.fromRGBO(160, 86, 136, 1),
                ),
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

Future<void> updatePlantStatus(id, String key, bool value) async {
  final DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('userPlant').doc(id).get();

  await FirebaseFirestore.instance
      .collection('userPlant')
      .doc(id)
      .update({key: value});
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final DateTime now = DateTime.now();
    final int currentHour = now.hour;
    final DateTime startTime = DateTime(now.year, now.month, now.day, 6);
    final DateTime endTime = DateTime(now.year, now.month, now.day, 18);
    var data;

    if (currentHour >= 6 && currentHour <= 18) {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('userPlant').snapshots(),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.refresh, color: Color.fromRGBO(160, 86, 136, 1)),
                      SizedBox(width: 100),
                      IconButton(
                        icon: Icon(Icons.delete, color: Color.fromRGBO(160, 86, 136, 1)),
                        onPressed: () {
                          setState(() {
                            tmsgList.clear();
                            submsgList.clear();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      data = snapshot.data!.docs[index];
                      if (data["connected"] == true && data["userId"] == userId) {
                        List<String> tempTmsgList = [];
                        List<String> tempSubmsgList = [];

                        printAllValuesInUserPlantCollection(
                          data["plantId"],
                          data["plantName"],
                          snapshot.data!.docs[index].id,
                        );

                        tempTmsgList.addAll(tmsgList);
                        tempSubmsgList.addAll(submsgList);

                        //tmsgList.clear(); // clear tmsgList
                        //submsgList.clear(); // clear submsgList

                        return Column(
                          children: tempTmsgList.map((title) {
                            return PlantCareCard(
                              title: title,
                              subtitle: tempSubmsgList[tempTmsgList.indexOf(title)],
                              icon: Icons.error_outline,
                              timeAgo: '',
                            );
                          }).toList(),
                        );
                      } else
                        return Container();
                    },
                  ),
                ),
              ],
            );
          }
        },
      );
    } else if (currentHour >= 19 || currentHour <= 5) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.nightlight, color: const Color.fromARGB(255, 251, 231, 54), size: 50),
            Text(
              '\n \t \t  NIGHTY NIGHT \n\n Your plant is sleeping ',
              style: TextStyle(
                  fontSize: 26, color: Color.fromRGBO(160, 86, 136, 1)),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }


  Future<void> printAllValuesInUserPlantCollection(plantId, name, docid) async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('plants').get();

    for (final DocumentSnapshot document in snapshot.docs) {
      if (document.id == plantId) {
        final data = document.data() as Map<String, dynamic>;
        Map<String, dynamic> normalCondition = data['Normal condition'];
        final ecMax = normalCondition['ec']['max'];
        final ecMin = normalCondition['ec']['min'];
        final humidityMax = normalCondition['humidity']['max'];
        final humidityMin = normalCondition['humidity']['min'];
        final lightMax = normalCondition['light']['max'];
        final lightMin = normalCondition['light']['min'];
        final phMax = normalCondition['ph']['max'];
        final phMin = normalCondition['ph']['min'];

        final tdsMax = normalCondition['tds']['max'];
        final tdsMin = normalCondition['tds']['min'];

        final tempMax = normalCondition['temp']['max'];
        final tempMin = normalCondition['temp']['min'];

        // Clear lists
        tmsgList.clear();
        submsgList.clear();

        if (lightIntensity < lightMin) {
          tmsgList.add('light 💡:your $name plant needs lights');
          submsgList.add('move your $name plant closer to the sun');
          updatePlantStatus(docid, 'sunlightStatus', false);
        } else if (lightIntensity > lightMax) {
          tmsgList.add('light 💡:your $name plant has enough of light time');
          submsgList.add('move your $name plant away from the sun');
          updatePlantStatus(docid, 'sunlightStatus', false);
        } else {
          updatePlantStatus(docid, 'sunlightStatus', true);
        }

        if (ph > phMax || ph < phMin) {
          tmsgList.add('water 💧: your $name plant needs water');
          submsgList.add('change the water for your $name plant');
          updatePlantStatus(docid, 'waterStatus', false);
        } else {
          updatePlantStatus(docid, 'waterStatus', true);
        }

        if (ec > ecMax || ec < ecMin || tds > tdsMax || tds < tdsMin) {
          tmsgList.add('Fertilize 🪴: your $name plant is hungry');
          submsgList.add('Fertilize your $name plant');
          updatePlantStatus(docid, 'fertilizerStatus', false);
        } else {
          updatePlantStatus(docid, 'fertilizerStatus', true);
        }

        if (temperature > tempMax) {
          tmsgList.add('Temperature 🌡️ : your $name plant is feeling hot');
          submsgList.add('move your $name plant to a colder place');
          updatePlantStatus(docid, 'temperatureStatus', false);
        } else if (temperature < tempMin) {
          tmsgList.add('Temperature 🌡️ : your $name plant is feeling cold');
          submsgList.add('move your $name plant to a warmer place');
          updatePlantStatus(docid, 'temperatureStatus', false);
        } else {
          updatePlantStatus(docid, 'temperatureStatus', true);
        }

        if (humidity > humidityMax || humidity < humidityMin) {
          tmsgList.add('Humidity 🌪️ :your $name  plant needs some fresh air');
          submsgList.add('open the window so your $name plant can breathe');
          updatePlantStatus(docid, 'humidityStatus', false);
        } else {
          updatePlantStatus(docid, 'humidityStatus', true);
        }
      }
    }
  }
}
