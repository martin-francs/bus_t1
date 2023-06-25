import 'package:bus_t/screens/walletaddmoney.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'busroute.dart';

class Homescreen extends StatefulWidget {
  Homescreen({Key? key}) : super(key: key);

  final String documentId = '9567867353';

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  String fname = 'Martin';
  String result = "Hello World...!";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              child: Text(
                '   Welcome,\n   $fname',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.documentId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error fetching balance');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                double balance =
                    snapshot.data?['walletAmount'] ?? 0.0;

                return Container(
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
                            child: Icon(
                              Icons.wallet_giftcard_sharp,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          Text(
                            "MAIN BALANCE",
                            style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontSize: 28,
                                color: Colors.white,
                                fontWeight: FontWeight.w900),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 16,
                            child: Icon(
                              Icons.currency_rupee,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            balance.toString(),
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2.0),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "ADD MONEY",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue[100],
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 2.0),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => addmoney(),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.add_box),
                                iconSize: 28,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        onPressed: () {
          _scanQR(); // calling a function when user click on button
        },
        label: Text("Scan"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> _scanQR() async {
    try {
      var cameraStatus = await Permission.camera.status;
      if (cameraStatus.isGranted) {
        String? cameraScanResult = await scanner.scan();
        setState(() {
          result = cameraScanResult!; // setting string result with cameraScanResult
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) {
                return Busroutescreen(documentId: result);
              },
            ),
          );
        });
      } else {
        var isGranted = await Permission.camera.request();
        if (isGranted.isGranted) {
          String? cameraScanResult = await scanner.scan();
          setState(() {
            result = cameraScanResult!; // setting string result with cameraScanResult
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) {
                  return Busroutescreen(documentId: result);
                },
              ),
            );
          });
        }
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
