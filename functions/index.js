const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.compareValues = functions.https.onRequest(async (req, res) => {
  try {
    const userPlantSnapshot = await admin.firestore().collection('userPlant').where('connected', '==', true).get();

    userPlantSnapshot.forEach(async (doc) => {
      const plantId = doc.data().plantId;

      const plantSnapshot = await admin.firestore().collection('plants').doc(plantId).get();
      const plantData = plantSnapshot.data();

      const realtimeDbRef = admin.database().ref('sensor_reading');

      realtimeDbRef.on('value', (snapshot) => {
        const sensorData = snapshot.val();

        // Compare EC
        const ec = sensorData.EC;
        const ecMin = plantData.NormalCondition.ec.min;
        const ecMax = plantData.NormalCondition.ec.max;

        if (ec < ecMin || ec > ecMax) {
          console.log('Change water');
        }

        // Compare Temperature
        const temperature = sensorData.Temperature;
        const tempMin = plantData.NormalCondition.temp.min;
        const tempMax = plantData.NormalCondition.temp.max;

        if (temperature < tempMin || temperature > tempMax) {
          console.log('Temperature problem');
        }
      });
    });

    res.status(200).send('Comparison completed');
  } catch (error) {
    console.error(error);
    res.status(500).send('Internal Server Error');
  }
});