import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hydrobloomapp/screens/PasswordRecoveryPage.dart';
import 'package:hydrobloomapp/screens/SignUpPage.dart';
import 'package:hydrobloomapp/screens/NotificationsPage.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String _emailErrorText = 'This email is wrong, Try again! or sign up';
  String _passwordErrorText = 'Wrong password, Try again!';

  int _wrongPasswordAttempts = 0;
  bool _accountLocked = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void _login() async {
    if (_accountLocked) {
      return;
    }

    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty) {
      setState(() {
        _emailErrorText = 'Email cannot be empty';
      });
      return;
    }

    if (!email.contains('@')) {
      setState(() {
        _emailErrorText = 'Invalid email format';
      });
      return;
    }

    if (password.isEmpty) {
      setState(() {
        _passwordErrorText = 'Password cannot be empty';
      });
      return;
    }

    bool otpCorrect = await _sendOTP(email);

    if (otpCorrect) {
      // Navigate to NotificationsPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NotificationsPage()),
      );
    } else {
      _wrongPasswordAttempts++;

      if (_wrongPasswordAttempts >= 3) {
        _accountLocked = true;
      }
    }
  }

  Future<bool> _sendOTP(String email) async {
    // Generate OTP
    String otp = _generateOTP();

    final Email emailMessage = Email(
      body: 'Your OTP is $otp',
      subject: 'OTP Verification',
      recipients: [email],
      isHTML: false,
    );

    bool isEmailAvailable = await canLaunch('mailto:');

    if (!isEmailAvailable) {
      print('No email clients found!');
      return false;
    }

    try {
      await FlutterEmailSender.send(emailMessage);
      // Prompt user to enter OTP
      String enteredOTP = await _showOTPDialog();

      // Verify OTP
      if (enteredOTP == otp) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print('Error sending email: $error');
      return false;
    }
  }

  String _generateOTP() {
    // Generate a random 6-digit OTP
    Random random = Random();
    int otp = random.nextInt(900000) + 100000;
    return otp.toString();
  }

  Future<String> _showOTPDialog() async {
    String enteredOTP = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter OTP'),
          content: TextField(
            onChanged: (value) {
              enteredOTP = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, enteredOTP);
              },
              child: Text('Verify'),
            ),
          ],
        );
      },
    );

    return enteredOTP;
  }

  void _forgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PasswordRecoveryPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log In'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'images/logo-2.png',
                  height: 200,
                ),
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
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Password',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    errorText: _passwordErrorText.isNotEmpty ? _passwordErrorText : null,
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Log In'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 80, 205, 205),
                    padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
                  ),
                ),
                SizedBox(height: 10.0),
                TextButton(
                  onPressed: _forgotPassword,
                  child: Text('Forgot Password?'),
                ),
                SizedBox(height: 10.0),
                Text('Or create a new account'),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
