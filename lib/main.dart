import 'package:bus_t/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
String userId='9567867353';
void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Bust());
  
}

class Bust
 extends StatelessWidget {
  const Bust
  ({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      theme:ThemeData(primaryColor: Colors.indigo),
      home:Homescreen(),
    );
  }
}