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
      var camerastatus = await Permission.camera.status;
      if(camerastatus.isGranted)
      {
      String? cameraScanResult = await scanner.scan();
      setState(() {
        result = cameraScanResult!; // setting string result with cameraScanResult
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx){return Busroutescreen(documentId:result);}));
      });
      }
      else{
        var isgrant =await Permission.camera.request();
        if(isgrant.isGranted){
          String? cameraScanResult = await scanner.scan();
      setState(() {
        result = cameraScanResult!; // setting string result with cameraScanResult
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx){return Busroutescreen(documentId:result);}));
      });
        }
      }
      
    } on PlatformException catch (e) {
      print(e);
    }
  

}
  @override
  Widget build(BuildContext context) {
    String bal="1";
    return Scaffold(
      backgroundColor:Colors.white,
      body:SafeArea(child: Column(children:[ SizedBox(
      height: 30, // <-- SEE HERE
    ),
    Container(width:double.infinity,
        child: Text('   Welcome,\n   '+fname,style: TextStyle(fontSize:35,fontWeight:FontWeight.bold ),textAlign: TextAlign.left,
        ),
      ),
      SizedBox(
      height:30, // <-- SEE HERE
    ),
      //Text(result),// Here the scanned result will be shown
      Container(
                    margin: EdgeInsets.symmetric(horizontal: 32),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color.fromRGBO(35, 60, 103, 1),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          
                          children: <Widget>[
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Color.fromRGBO(50, 172, 121, 1),
                              child: Icon(Icons.wallet_giftcard_sharp, color: Colors.white, size: 24,),
                            ),
                            
                            
                            Text("MAIN BALANCE", style: TextStyle(fontStyle: FontStyle.normal, fontSize: 28, color: Colors.white, fontWeight: FontWeight.w900),)
                          ],
                        ),
                        SizedBox(height: 32,),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [CircleAvatar(radius: 16,child: Icon(Icons.currency_rupee,color: Colors.white,),),
                            Text(bal, style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: 2.0),),
                          ],
                        ),

                        SizedBox(height: 32,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("ADD MONEY", style: TextStyle(fontSize: 12, color: Colors.blue[100], fontWeight: FontWeight.w700, letterSpacing: 2.0),),
                                IconButton(onPressed: (){}, icon: Icon(Icons.add_box),iconSize: 28,color: Colors.white,)
                                //Text("Maaz Aftab", style: TextStyle(fontSize: 16, color: Colors.grey[100], fontWeight: FontWeight.w700, letterSpacing: 2.0),),
                              ],
                            ),
                          ],
                        )

                      ],
                    )
                  ),]
      )
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