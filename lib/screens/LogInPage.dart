import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hydrobloomapp/screens/PasswordRecoveryPage.dart';
import 'package:hydrobloomapp/screens/SignUpPage.dart';
import 'package:hydrobloomapp/widgets/notifications_page.dart';
import 'package:hydrobloomapp/main_screen.dart'; 

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _emailErrorText = 'This email is wrong, Try again! or sign up';
  String _passwordErrorText = 'Wrong password, Try again!';
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void _login() async {
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

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate to mainscreen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } catch (error) {
      print('Error logging in: $error');
      setState(() {
        _passwordErrorText = 'Invalid email or password';
      });
    }
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
                    errorText:
                        _emailErrorText.isNotEmpty ? _emailErrorText : null,
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
                    errorText: _passwordErrorText.isNotEmpty
                        ? _passwordErrorText
                        : null,
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Log In'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 80, 205, 205),
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
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
