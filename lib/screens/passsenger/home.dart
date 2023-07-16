import 'package:bus_t/screens/passsenger/walletaddmoney.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../loginsignup/welcome.dart';
import 'busroute.dart';
import 'ticketshisory.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  _HomescreenState createState() => _HomescreenState();

  Future<String?> _getDocumentIdFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('mobileNumber');
  }
}

class _HomescreenState extends State<Homescreen> {
  String fname = '';
  String result = "Hello World...!";
  late String documentId;

  @override
  void initState() {
    super.initState();
    _retrieveDocumentId();
  }

  Future<void> _retrieveDocumentId() async {
  String? mobileNumber = await widget._getDocumentIdFromSharedPreferences();
  if (mobileNumber != null) {
    setState(() {
      documentId = mobileNumber;
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(documentId)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          fname = snapshot.data()?['Name'] ?? '';
        });
      }
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
             signout(context);
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                '   Welcome,\n   $fname',
                style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(documentId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Error fetching balance');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                double balance = snapshot.data?['walletAmount'] ?? 0.0;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color.fromRGBO(35, 60, 103, 1),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Row(
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
                      const SizedBox(
                        height: 32,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 16,
                            child: Icon(
                              Icons.currency_rupee,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            balance.toString(),
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2.0),
                          ),
                        ],
                      ),
                      const SizedBox(
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
                                      builder: (context) => addmoney(documentId: documentId),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.add_box),
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
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TicketHistoryScreen(
                      documentId: documentId,
                    ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.blue, // Replace with your desired color
                ),
                padding: const EdgeInsets.all(16),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Ticket History",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Icon(
                      Icons.history_outlined,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.camera_alt),
        onPressed: () {
          _scanQR();
        },
        label: const Text("Scan"),
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
          result = cameraScanResult!;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) {
                return Busroutescreen(documentId: result,userId: documentId);
              },
            ),
          );
        });
      } else {
        var isGranted = await Permission.camera.request();
        if (isGranted.isGranted) {
          String? cameraScanResult = await scanner.scan();
          setState(() {
            result = cameraScanResult!;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) {
                  return Busroutescreen(documentId: result,userId: documentId,);
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
  
 signout(BuildContext ctx) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(ctx).pushAndRemoveUntil(
      MaterialPageRoute(builder: (ctx1) => const WelcomeScreen()),
      (route) => false,
    );
  }
}
