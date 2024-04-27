import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hydrobloomapp/screens/LogInPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hydrobloomapp/widgets/sensor_connect.dart';
import 'package:hydrobloomapp/screens/PasswordRecoveryPage.dart';

import 'package:hydrobloomapp/screens/ChangeEmailPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String firstName = '';
  String lastName = '';
  String email = '';


  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      setState(() {
        firstName = snapshot['first_name'];
        lastName = snapshot['last_name'];
        email = snapshot['email'];
      });
    } catch (error) {
      print('Error finding user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
              backgroundColor: Color.fromARGB(255, 145, 184, 187),
            ),
            SizedBox(height: 16),
            Text(
              '$firstName $lastName',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 60, 138, 149),
              ),
            ),
            SizedBox(height: 8),
            Text(
              email,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton.icon(
              icon: Icon(Icons.account_circle, color: Colors.white),
              label: Text('User Settings', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 48),
                backgroundColor: Color(0xFF009688),
                alignment: Alignment.centerLeft,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.settings, color: Colors.white),
              label: Text('Sensor Settings', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SensorsPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 48),
                backgroundColor: Color(0xFF009688),
                alignment: Alignment.centerLeft,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.support, color: Colors.white),
              label: Text('Support', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SupportPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 48),
                backgroundColor: Color(0xFF009688),
                alignment: Alignment.centerLeft,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.lock, color: Colors.white),
              label: Text('Privacy Policy', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 48),
                backgroundColor: Color(0xFF009688),
                alignment: Alignment.centerLeft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangeEmailPage()),
                );
              },
              child: Text(
                '  Change Email  ',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF009688),
                padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 14.0),
                textStyle: TextStyle(fontSize: 16.0),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PasswordRecoveryPage()),
                );
              },
              child: Text(
                'Reset Password',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF009688),
                padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 14.0),
                textStyle: TextStyle(fontSize: 16.0),
              ),
            ),
            SizedBox(height: 45.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LogInPage()),
                  (route) => false,
                );
              },
              child: Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 214, 63, 63),
                padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 14.0),
                textStyle: TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Support',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF009688),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to our support page!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'If you have any questions or need \n assistance, please feel free to \n contact us via email:',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF009688),
              ),
              child: Text(
                'Contact Support: hydrobloom9@gmail.com',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              onPressed: () {
                launch('mailto:hydrobloom9@gmail.com');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PrivacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF009688),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            'We care about the privacy of our hydroponic home plant users. We do not collect any personally identifiable information such as names or email addresses.\n\nInformation we collect:\n\n- Application usage data such as login/logout times and features used. This is to improve the user experience.\n\n- Technical information such as device type and phone number. This is to ensure that the application is working properly.\n\nWe will not share any information with third parties. All data will be stored securely.\n\nIf you have any questions about our privacy policy, please contact us via email.',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
