import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:get/get.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import 'busroute.dart';


class Homescreen
 extends StatefulWidget {
   Homescreen
  ({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
String fname ='Martin';
String result = "Hello World...!";

  Future _scanQR() async {
    try {
      String? cameraScanResult = await scanner.scan();
      setState(() {
        result = cameraScanResult!; // setting string result with cameraScanResult
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx){return busroutescreen(id:result);}));
      });
    } on PlatformException catch (e) {
      print(e);
    }
  

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      body:SafeArea(child: Column(children:[Column(children:[ Text('Welcome home,\n'+fname,style: TextStyle(fontSize:35,fontWeight:FontWeight.bold )
      ),
      Text(result),// Here the scanned result will be shown
      ]
      ),
      ])
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.camera_alt),
          onPressed: () {
           _scanQR(); // calling a function when user click on button
          },
          label: Text("Scan")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}