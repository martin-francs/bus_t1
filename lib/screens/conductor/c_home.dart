import 'package:bus_t/screens/conductor/active_on.dart';
import 'package:bus_t/screens/conductor/qrcode.dart';
import 'package:bus_t/screens/conductor/routes_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../loginsignup/welcome.dart';
import 'active_off.dart';


Future<List<String>> fetchRouteIds(String? busno) async {
  List<String> routeIds = [];
  if (busno != null) {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('buses')
        .doc(busno)
        .collection('routes')
        .get();
    snapshot.docs.forEach((doc) {
      routeIds.add(doc.id);
    });
  }
  return routeIds;
}

class ConductorHomePage extends StatefulWidget {
  @override
  State<ConductorHomePage> createState() => _ConductorHomePageState();

  Future<String?> _getDocumentIdFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('busno');
  }
}

class _ConductorHomePageState extends State<ConductorHomePage> {
  String? busno;

  @override
  void initState() {
    super.initState();
    _getBusNoFromSharedPreferences();
  }

  Future<void> _getBusNoFromSharedPreferences() async {
    String? busNo = await widget._getDocumentIdFromSharedPreferences();
    setState(() {
      busno = busNo;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conductor Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              signout1(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RouteManagementPage(),
                  ),
                );
              },
              child: Text('Route Management'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRCodePage(),
                  ),
                );
              },
              child: Text('QR Code'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? activeRoute =
              await SharedPreferences.getInstance().then((prefs) {
            return prefs.getString('activeRoute');
          });

          if (activeRoute != '') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    activeoffscreen(),
              ),
            );
          } else {
            String? busno = await widget._getDocumentIdFromSharedPreferences();
            List<String> routeIds = await fetchRouteIds(busno);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    activeonscreen(busno: busno, routeIds: routeIds),
              ),
            );
          }
        },
        backgroundColor: Color.fromARGB(255, 18, 78, 217),
        child: const Icon(Icons.power_settings_new_sharp),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  signout1(BuildContext ctx) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(ctx).pushAndRemoveUntil(
      MaterialPageRoute(builder: (ctx1) => WelcomeScreen()),
      (route) => false,
    );
  }
}
