import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hydrobloomapp/screens/PasswordRecoveryPage.dart';
import 'package:hydrobloomapp/screens/SignUpPage.dart';
import 'package:hydrobloomapp/main_screen.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _emailErrorText = '';
  String _passwordErrorText = '';

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

      if (userCredential.user != null) {
        if (userCredential.user!.emailVerified) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        } else {
          setState(() {
            _emailErrorText = 'Email is not verified';
            _passwordErrorText = '';
          });
        }
      } else {
        setState(() {
          _passwordErrorText = 'Invalid password';
          _emailErrorText = 'Invalid email';
        });
      }
    } catch (error) {
      print('Error logging in: $error');
      if (error is FirebaseAuthException) {
        setState(() {
          if (error.code == 'too-many-requests') {
            _passwordErrorText =
                'Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.';
          } else {
            _passwordErrorText = 'Wrong password, Try again!';
          }
          _emailErrorText = 'Invalid email';
        });
      } else {
        setState(() {
          _passwordErrorText = 'Invalid password';
          _emailErrorText = 'Invalid email';
        });
      }
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
      title: Text('HydroBloom'),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
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
                ],
              ),
              SizedBox(height: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Password',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
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
                  SizedBox(height: 0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _forgotPassword,
                      child: Text('Forgot Password?' , style: TextStyle(color: Color.fromARGB(255, 60, 138, 149)),),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _login,
                child: Text(
                  'Log In',
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
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Or create a new account'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    child: Text('Sign Up' ,style: TextStyle(color: Color.fromARGB(255, 60, 138, 149)),),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}