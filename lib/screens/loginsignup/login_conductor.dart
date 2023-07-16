//import 'package:busti007/screens/singup_conductor.dart';
import 'package:bus_t/screens/loginsignup/singup_conductor.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../conductor/c_home.dart';

//import 'c_home.dart';

class LoginScreen2 extends StatelessWidget {
  final TextEditingController busIDController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen2({super.key});
  Future<void> _storeDocumentIdInSharedPreferences(String documentId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('busno', documentId);
     await prefs.setString('activeRoute', '');
    await prefs.setString('time', '');
  }
  void login(BuildContext context) async {
    try {
      String busID = busIDController.text;
      String password = passwordController.text;
        
      // Check if the provided bus ID exists in Firestore
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('conductors')
          .where('busID', isEqualTo: busID)
          .get();

      if (querySnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid bus ID or password'),
          ),
        );
        return;
      }

      // Get the first document from the query result
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot = querySnapshot.docs.first;

      // Verify the password
      String storedPassword = documentSnapshot.get('password');
      if (password != storedPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid bus ID or password'),
          ),
        );
        return;
      }
       final busno = busID;
       _storeDocumentIdInSharedPreferences(busno);
      // Login successful
      // Perform additional actions if needed

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ConductorHomePage(busID: busno,)),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: ${error.toString()}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conductor Login'),
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
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                login(context);
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpConductor()),
                );
              },
              child: const Text(
                'Don\'t have an account? Sign up',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}