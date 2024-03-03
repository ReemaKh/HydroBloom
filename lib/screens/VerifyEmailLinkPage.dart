import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyEmailLinkPage extends StatefulWidget {
  final String email;

  VerifyEmailLinkPage({required this.email});

  @override
  _VerifyEmailLinkPageState createState() => _VerifyEmailLinkPageState();
}

class _VerifyEmailLinkPageState extends State<VerifyEmailLinkPage> {
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
  }

  Future<void> _checkEmailVerification() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Check if the user's email is verified
        final bool isEmailVerified = user.emailVerified;
        if (isEmailVerified) {
          // Navigate to the home page
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // Show a message to the user to verify their email
          setState(() {
            _errorText = 'Please verify your email address';
          });
        }
      } else {
        // Handle null user case
        print('Error verifying email: User is null');
      }
    } catch (error) {
      print('Error verifying email: $error');
      // Handle error and display appropriate error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please check your email for a verification link.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'If you haven\'t received the email, check your spam folder or try resending the verification email.',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            if (_errorText != null)
              SizedBox(height: 16),
            if (_errorText != null)
              Text(
                _errorText!,
                style: TextStyle(fontSize: 14, color: Colors.red),
                textAlign: TextAlign.center,
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Resend the verification email
                FirebaseAuth.instance.sendSignInLinkToEmail(email: widget.email, actionCodeSettings: ActionCodeSettings(url: 'https://your-app-domain.com/signup/complete', handleCodeInApp: true));
              },
              child: Text('Resend Verification Email'),
            ),
          ],
        ),
      ),
    );
  }
}