//import 'package:busti007/screens/login_conductor.dart';
//import 'package:busti007/screens/login_passenger.dart';
import 'package:flutter/material.dart';

import 'login_conductor.dart';
import 'login_passenger.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Select your role:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen1()),
                );
                selectOption('passenger');
              },
              child: const Text('Passenger'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen2()),
                );
                selectOption('conductor');
                

              },
              child: const Text('Conductor'),
            ),
            const SizedBox(height: 20),
            Text(
              'Selected option: $selectedOption',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void selectOption(String option) {
    setState(() {
      selectedOption = option;
    });
  }
}

