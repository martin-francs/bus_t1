import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'login_conductor.dart';

class SignUpConductor extends StatefulWidget {
  const SignUpConductor({super.key});

  @override
  _SignUpConductorState createState() => _SignUpConductorState();
}

class _SignUpConductorState extends State<SignUpConductor> {
  final TextEditingController busIDController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController busnameController = TextEditingController();

  Future<void> generateAndUploadQRCode(String busID) async {
    try {
      // Generate the QR code data
      String qrCodeData = busID;

      // Create a QR code image
      final qrCode = QrPainter(
        data: qrCodeData,
        version: QrVersions.auto,
        gapless: true,
      );

      // Render the QR code to an image
      final ui.Image qrCodeImage = await qrCode.toImage(400);

      // Convert the image to bytes
      final ByteData? byteData = await qrCodeImage.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List qrCodeBytes = byteData!.buffer.asUint8List();

      // Upload the QR code image to Firebase Storage
      final storageReference = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('qr_codes')
          .child('$busID.png');

      final uploadTask = storageReference.putData(qrCodeBytes);
      await uploadTask;

      // Get the download URL of the uploaded QR code
      final downloadURL = await storageReference.getDownloadURL();

      // Update the conductor document in Firestore with the QR code download URL
      await FirebaseFirestore.instance.collection('conductors').doc(busID).update({
        'qrCode': downloadURL,
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

      // Register the conductor in Firestore
      await FirebaseFirestore.instance.collection('conductors').doc(busID).set({
        'phoneNumber': phoneNumber,
        'busID': busID,
        'busname': busname,
        'password': password,
        'walletAmount': 5.5,
      });
      await FirebaseFirestore.instance.collection('buses').doc(busID).set({
      'BusName': busname,
      'BUSNO': busID,
      'activeticket': null, // Set activeTicket to null
      'activeroute': null,  // Set activeRoute to null
    });
    await FirebaseFirestore.instance.collection('tickets').doc(busID).set({
      'BusName': busname,
      'BUSNO': busID,
    });
    // CollectionReference ticketsCollection =
    //     FirebaseFirestore.instance.collection('conductors');
    // DocumentReference ticketDocument =
    //     ticketsCollection.doc(busID).collection('Payments').doc('YOUR PAYMENTS');
    // await ticketDocument.set({'BUSNAME': busname});
      // Generate and upload the QR code
      await generateAndUploadQRCode(busID);
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
              decoration: const InputDecoration(labelText: "Bus Name"),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: const InputDecoration(labelText: "Phone Number"),
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
