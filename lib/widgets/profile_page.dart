import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hydrobloomapp/screens/LogInPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
              label: Text('Support ', style: TextStyle(color: Colors.white)),
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
        title: Text('User Page'),
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
                  MaterialPageRoute(builder: (context) => PasswordResetPage()),
                );
              },
              child: Text('Reset Password'),
            ),
            SizedBox(height: 10.0), 
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LogInPage()),
                  (route) => false, 
                );
              },
              child: Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}


class PasswordResetPage extends StatefulWidget {
  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  TextEditingController _emailController = TextEditingController();
  String _emailErrorText = '';

  Future<void> _recoverPassword() async {
    
    String email = _emailController.text;
    if (email.isEmpty) {
      setState(() {
        _emailErrorText = 'Email cannot be empty';
      });
      return;
    }

    try {
      // Send password reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // Password reset email sent successfully
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Password Reset'),
            content: Text('Password reset email has been sent to $email \n please log in with the new password'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LogInPage()), // Replace LoginPage with your actual login page
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      print('Error sending password reset email: $error');
      // Handle error, show error message to the user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to send password reset email. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Reset'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
              Text(
                'Email',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  errorText: _emailErrorText.isNotEmpty ? _emailErrorText : null,
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: _recoverPassword,
                  child: Text('Reset Password'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SensorsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF009688),
        title: Text(
          'Sensor Settings',
          style: TextStyle(color: Colors.white), // Set the color to white
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'To activate the Bluetooth sensor:',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 30),
              Text(
                '1. Go to the Settings menu on your phone.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 30),
              Text(
                '2. Look for an option like "Connections" or "Bluetooth & WiFi".',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 30),
              Text(
                '3. Select the "Bluetooth" option.',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 30),
              Text(
                '4. Tap/click the option to turn on/activate the Bluetooth sensor/functionality.',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
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
              'If you have any questions or need assistance, please feel free to contact us via email:',
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
