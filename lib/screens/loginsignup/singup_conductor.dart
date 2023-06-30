//import 'package:busti007/screens/login_conductor.dart';
import 'package:flutter/material.dart';

import 'login_conductor.dart';


class SignUpConductor extends StatelessWidget {
  final TextEditingController busIDController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conductor Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: busIDController,
              decoration: const InputDecoration(labelText: 'Bus ID'),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: const InputDecoration(labelText: "Conductor's Phone Number"),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                // Perform registration logic here

                // After registration, navigate to the login page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen2()),
                );
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

