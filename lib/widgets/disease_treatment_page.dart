import 'package:flutter/material.dart';

class PlantSelectionPage extends StatefulWidget {
  @override
  _PlantSelectionPageState createState() => _PlantSelectionPageState();
}

class _PlantSelectionPageState extends State<PlantSelectionPage> {
  String selectedPlant = 'Bamboo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Plant disease and treatment')),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Select Plant:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              DropdownButton<String>(
                value: selectedPlant,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPlant = newValue!;
                  });
                },
                items: <String>['Bamboo', 'Sansevieria', 'Pothos', 'Peace Lily']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 160, 86, 136),
                  padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 14.0),
                  textStyle: TextStyle(fontSize: 16.0),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SymptomSelectionPage(selectedPlant: selectedPlant),
                    ),
                  );
                },
                child: Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SymptomSelectionPage extends StatefulWidget {
  final String selectedPlant;

  const SymptomSelectionPage({Key? key, required this.selectedPlant}) : super(key: key);

  @override
  _SymptomSelectionPageState createState() => _SymptomSelectionPageState();
}

class _SymptomSelectionPageState extends State<SymptomSelectionPage> {
  String selectedSymptom = '';
  List<String> symptoms = [];

  @override
  void initState() {
    super.initState();
    updateSymptoms(widget.selectedPlant);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Symptoms')),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Select Symptom:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              DropdownButton<String>(
                value: selectedSymptom,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSymptom = newValue!;
                  });
                },
                items: symptoms
                    .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })
                    .toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 160, 86, 136),
                  padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 14.0),
                  textStyle: TextStyle(fontSize: 16.0),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsPage(
                        selectedPlant: widget.selectedPlant,
                        selectedSymptom: selectedSymptom,
                        treatment: getTreatment(widget.selectedPlant, selectedSymptom),
                      ),
                    ),
                  );
                },
                child: Text('Find Treatment'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateSymptoms(String plant) {
    switch (plant) {
      case 'Bamboo':
        symptoms = [
          'Yellow leaves and black or brown roots.',
          'Brown leaf tips.',
          'Leaf yellowing and stunted growth.',
          'Leaf curling and wilting.',
          'Root rot.',
          'Pale new leaves'
        ];
        break;
      case 'Sansevieria':
        symptoms = [
          'Brown leaf tips.',
          'Yellow leaves.',
          'Black spots on leaves.',
          'Root rot.',
          'Leaf drooping.',
          'Stunted growth'
        ];
        break;
      case 'Pothos':
        symptoms = [
          'Yellow leaves.',
          'Yellow leaves and brown spots on leaves.',
          'Brown leaf tips.',
          'Root rot.',
          'Leaf wilting.',
          'Leaf curling'
        ];
        break;
      case 'Peace Lily':
        symptoms = [
          'Yellow leaves and brown spots on leaves.',
          'Brown leaf tips.',
          'Leaf drooping.',
          'Stunted growth.',
          'Leaf yellowing.',
          'Pale new leaves'
        ];
        break;
    }
    setState(() {
      selectedSymptom = symptoms.isNotEmpty ? symptoms[0] : '';
    });
  }

  String getTreatment(String plant, String symptom) {
    switch (plant) {
      case 'Bamboo':
        return _getBambooTreatment(symptom);
      case 'Sansevieria':
        return _getSansevieriaTreatment(symptom);
      case 'Pothos':
        return _getPothosTreatment(symptom);
      case 'Peace Lily':
        return _getPeaceLilyTreatment(symptom);
      default:
        return 'No specific treatment available.';
    }
  }

  String _getBambooTreatment(String symptom) {
    switch (symptom) {
      case 'Yellow leaves and black or brown roots.':
        return 'Use distilled water, change it regularly, and trim damaged roots.';
      case 'Brown leaf tips.':
        return 'Prune the affected leaves, provide adequate light, and ensure proper drainage.';
      case 'Leaf yellowing and stunted growth.':
        return 'Provide nitrogen-rich fertilizer and ensure adequate sunlight.';
      case 'Leaf curling and wilting.':
        return 'Ensure proper watering, avoid over-fertilizing, and maintain adequate humidity.';
      case 'Root rot.':
        return 'Trim affected roots, replant in fresh soil, and avoid over-watering.';
      case 'Pale new leaves':
        return 'Provide adequate light and nutrients, avoid over-watering.';
      default:
        return 'No specific treatment available.';
    }
  }

  String _getSansevieriaTreatment(String symptom) {
    switch (symptom) {
      case 'Brown leaf tips.':
        return 'Trim the brown tips, increase humidity, and provide filtered light.';
      case 'Yellow leaves.':
        return 'Adjust watering, ensure proper drainage, and provide indirect sunlight.';
      case 'Black spots on leaves.':
        return 'Trim affected leaves, increase air circulation, and avoid over-watering.';
      case 'Root rot.':
        return 'Trim affected roots, replant in fresh soil, and avoid over-watering.';
      case 'Leaf drooping.':
        return 'Ensure proper watering, provide adequate light, and avoid over-fertilizing.';
      case 'Stunted growth':
        return 'Provide well-draining soil, fertilize during the growing season, and ensure adequate sunlight.';
      default:
        return 'No specific treatment available.';
    }
  }

  String _getPothosTreatment(String symptom) {
    switch (symptom) {
      case 'Yellow leaves.':
        return 'Adjust watering, provide indirect sunlight, and avoid over-fertilizing.';
      case 'Yellow leaves and brown spots on leaves.':
        return 'Improve air circulation, avoid over-watering, and trim affected leaves.';
      case 'Brown leaf tips.':
        return 'Increase humidity, provide indirect sunlight, and avoid over-watering.';
      case 'Root rot.':
        return 'Trim affected roots, replant in fresh soil, and avoid over-watering.';
      case 'Leaf wilting.':
        return 'Adjust watering schedule, provide indirect sunlight, and increase humidity.';
      case 'Leaf curling':
        return 'Ensure proper watering, increase humidity, and provide indirect sunlight.';
      default:
        return 'No specific treatment available.';
    }
  }

  String _getPeaceLilyTreatment(String symptom) {
    switch (symptom) {
      case 'Yellow leaves and brown spots on leaves.':
        return 'Adjust watering, provide indirect sunlight, and improve air circulation.';
      case 'Brown leaf tips.':
        return 'Trim affected leaves, increase humidity, and ensure proper watering.';
      case 'Leaf drooping.':
        return 'Adjust watering, provide indirect sunlight, and increase humidity.';
      case 'Stunted growth.':
        return 'Provide well-draining soil, fertilize during the growing season, and ensure adequate sunlight.';
      case 'Leaf yellowing.':
        return 'Improve air circulation, adjust watering, and provide indirect sunlight.';
      case 'Pale new leaves':
        return 'Provide adequate light and nutrients, avoid over-watering.';
      default:
        return 'No specific treatment available.';
    }
  }
}

class DetailsPage extends StatelessWidget {
  final String selectedPlant;
  final String selectedSymptom;
  final String treatment;

  const DetailsPage({
    Key? key,
    required this.selectedPlant,
    required this.selectedSymptom,
    required this.treatment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Symptoms & Treatment'),
       
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailCard(
                title: 'Plant:',
                value: selectedPlant,
                icon: Icons.nature,
                iconColor: Colors.green,
              ),
              SizedBox(height: 16),
              _DetailCard(
                title: 'Symptom:',
                value: selectedSymptom,
                icon: Icons.warning,
                iconColor: Colors.orange,
              ),
              SizedBox(height: 16),
              _DetailCard(
                title: 'Treatment:',
                value: treatment,
                icon: Icons.medical_services,
                iconColor: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  _DetailCard({required this.title, required this.value, required this.icon, required this.iconColor});

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
                  Text(value, style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
