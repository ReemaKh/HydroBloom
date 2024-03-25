import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordRecoveryPage extends StatefulWidget {
  @override
  _PasswordRecoveryPageState createState() => _PasswordRecoveryPageState();
}

class _PasswordRecoveryPageState extends State<PasswordRecoveryPage> {
  TextEditingController _emailController = TextEditingController();
  String _emailErrorText = '';
  Future<void> _recoverPassword() async {
  // Validate email field
  String email = _emailController.text;
  if (email.isEmpty) {
    setState(() {
      _emailErrorText = 'Email cannot be empty';
    });
    return;
  }

  // Check if the password meets the conditions
  if (!isPasswordValid()) {
    // Password doesn't meet requirements
    // Show error message to the user
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(
              'Password must be at least 8 characters long, contain at least one capital letter, and at least one special character.'),
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
          title: Text('Password Recovery'),
          content: Text('Password reset email has been sent to $email'),
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
  } catch (error) {
    print('Error sending password reset email: $error');
    // Handle error, show error message to the user
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content:
              Text('Failed to send password reset email. Please try again.'),
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

bool isPasswordValid() {
  var _passwordController;
  String password = _passwordController.text;
  // Check if password meets the conditions
  return password.length >= 8 &&
      password.contains(new RegExp(r'[A-Z]')) &&
      password.contains(new RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Recovery'),
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
                  errorText:
                      _emailErrorText.isNotEmpty ? _emailErrorText : null,
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: _recoverPassword,
                  child: Text('Recover Password'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
