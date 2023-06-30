import 'package:bus_t/screens/loginsignup/forgootpassword.dart';
import 'package:bus_t/screens/loginsignup/signup_passenger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../passsenger/home.dart';
import 'homescreen.dart';

class LoginScreen1 extends StatelessWidget {
  LoginScreen1({Key? key}) : super(key: key);

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _storeDocumentIdInSharedPreferences(String documentId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('documentId', documentId);
  }

  Future<void> _storeMobileNumberInSharedPreferences(String mobileNumber) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('mobileNumber', mobileNumber);
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

 Future<String?> getMobileNumberFromFirestore(String documentId) async {
  final DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('usermap').doc(documentId).get();
  if (snapshot.exists) {
    final data = snapshot.data() as Map<String, dynamic>?; // Explicitly cast to Map<String, dynamic>
    if (data != null) {
      return data['Phone Number'] as String?;
    }
  }
  return null;
}


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
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
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
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // Navigate to signup page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpPassenger(),
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
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // Navigate to forgot password page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgotPasswordScreen(),
                    ),
                  );
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text)
                      .then((value) async {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      final documentId = user.uid;
                      final mobileNumber =
                          await getMobileNumberFromFirestore(documentId);
                      if (mobileNumber != null) {
                        _storeDocumentIdInSharedPreferences(documentId);
                        _storeMobileNumberInSharedPreferences(mobileNumber);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Homescreen()),
                        );
                      } else {
                        _showSnackBar(context, 'Mobile number not found.');
                      }
                    }
                  }).catchError((error) {
                    _showSnackBar(context, 'Password does not match.');
                    print("Error ${error.toString()}");
                  });
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
}
