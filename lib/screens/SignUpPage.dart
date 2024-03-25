import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hydrobloomapp/screens/LogInPage.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  String _emailErrorText = '';
  String _passwordErrorText = '';

  void _signUp() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;

    if (email.isEmpty || !email.contains('@')) {
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
    if (password.length < 8 ||
      !password.contains(RegExp(r'[A-Z]')) ||
      !password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    setState(() {
      _passwordErrorText =
          'Password must be at least 8 characters long, \n contain at least one capital letter,\n and at least one special character \n (!@#\$%^&*(),.?":{}|<>)';
    });
    return;}
    if (password != confirmPassword) {
      setState(() {
        _passwordErrorText = 'Passwords do not match';
      });
      return;
    }
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Generate a unique user ID
        String userId = userCredential.user!.uid;

        // Store user information in Firestore
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'email': email,
          'first_name': firstName,
          'last_name': lastName,
          'user_type': 'user', // Set the default user type
        });

        // Send email verification
        await userCredential.user!.sendEmailVerification(
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VerifyEmailPage()),
        );
      } else {
        // Handle null user case
        print('Error signing up: User is null');
      }
    } catch (error) {
      print('Error signing up: $error');
      // Handle error and display appropriate error message
      if (error is FirebaseAuthException) {
        setState(() {
          _emailErrorText = error.message ?? 'An error occurred';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: _emailErrorText.isNotEmpty ? _emailErrorText : null,
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText:
                    _passwordErrorText.isNotEmpty ? _passwordErrorText : null,
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _signUp,
              child: Text('Sign Up'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                textStyle: TextStyle(fontSize: 14.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VerifyEmailPage extends StatelessWidget {
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
              'An email verification link has been sent to your email address. Please verify your email, then LogIn.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to the login page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LogInPage()),
                );
              },
              child: Text('Continue to Login'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                textStyle: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 