import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:qr_flutter/qr_flutter.dart';

import 'login_conductor.dart';

class SignUpConductor extends StatefulWidget {
  @override
  _SignUpConductorState createState() => _SignUpConductorState();
}

class _SignUpConductorState extends State<SignUpConductor> {
  final TextEditingController busIDController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController busnameController =TextEditingController();

  @override
  void dispose() {
    busIDController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    busnameController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void registerConductor(BuildContext context) async {
    try {
      String busID = busIDController.text;
      String phoneNumber = phoneNumberController.text;
      String password = passwordController.text;
      String confirmPassword = confirmPasswordController.text;
      String busname = busnameController.text;

      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Passwords don't match"),
          ),
        );
        return;
      }

      // Generate QR code with busID
      // final qrCode = QrImage(
      //   data: busID,
      //   version: QrVersions.auto,
      //   size: 200.0,
      //   gapless: false,
      // );

      // Convert the QR code to a Uint8List
      // final image = await qrCode.toImage();
      // final qrCodeByteData = await image.toByteData(format: ImageByteFormat.png);
      // final qrCodeImage = qrCodeByteData.buffer.asUint8List();

      // Register the conductor in Firestore
      await FirebaseFirestore.instance.collection('conductors').doc(busID).set({
        'phoneNumber': phoneNumber,
        'busID': busID,
        'busname':busname,
        'password': password,
        //'qrCode': qrCodeImage, // Add the QR code to the Firestore document
      });

      // Registration successful
      // Navigate to the login page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen2(),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed: ${error.toString()}'),
        ),
      );
    }
  }

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
              controller: busnameController,
              decoration: const InputDecoration(
                  labelText: "Bus Name"),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: const InputDecoration(
                  labelText: "Phone Number"),
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
                registerConductor(context);
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}