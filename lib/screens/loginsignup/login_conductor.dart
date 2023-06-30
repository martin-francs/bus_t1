import 'package:bus_t/screens/loginsignup/singup_conductor.dart';
import 'package:flutter/material.dart';

class LoginScreen2 extends StatelessWidget {
  LoginScreen2({Key? key}) : super(key: key);

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 150,
              ),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ), //text field for username
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ), //text field for password
              const SizedBox(height: 20),
              const Text(
                'Existing User? Login',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // Navigate to signup page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpConductor(),
                    ),
                  );
                },
                child: RichText(
                  text: const TextSpan(
                    text: 'New User? ',
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Signup',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  checkLogin(context);
                },
                icon: const Icon(Icons.check),
                label: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void checkLogin(BuildContext ctx) {
    final _username = _usernameController.text;
    final _password = _passwordController.text;
    if (_username.isNotEmpty && _password.isNotEmpty) {
      if (_username == _password) {
        // Go to homepage
      } else {
        final _errorMessage = 'User not registered';
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(10),
            content: Text(_errorMessage),
          ),
        );
      }
    }
  }
}
