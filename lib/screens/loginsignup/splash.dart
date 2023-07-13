import 'dart:ffi';

//import 'package:busti007/main.dart';
//import 'package:busti007/screens/homescreen.dart';
//import 'package:busti007/screens/login_conductor.dart';
//import 'package:busti007/screens/welcome.dart';
import 'package:bus_t/screens/loginsignup/welcome.dart';
import 'package:bus_t/screens/passsenger/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../conductor/c_home.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

@override
  void initState() {   // splash screen initial 
    checkUserLoggedin();// TODO: implement initState
    super.initState();
  }

@override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/image1.png',
        height: 250,),
      ),
      );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> gotoLogin() async{
    await Future.delayed(Duration(seconds: 3));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (ctx) => WelcomeScreen(),
      ),
      );
  }

  Future<void> checkUserLoggedin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? documentId = prefs.getString('mobileNumber');
    final String? busno = prefs.getString('busno');
    if (documentId == null && busno == null) {
      gotoLogin();
    } 
    // else if(busno == null){
    //    gotoLogin();
    // }
    else if(documentId != null){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx1) => Homescreen()),);
    }
    else
    {
       Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx1) => ConductorHomePage()),);
    }
  }
}