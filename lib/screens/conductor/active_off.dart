import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class activeoffscreen extends StatefulWidget {
  @override
  _activeoffscreenState createState() => _activeoffscreenState();
}

class _activeoffscreenState extends State<activeoffscreen> {
  String activeRoute = '';
  late String busno;

  @override
  void initState() {
    super.initState();
    _fetchActiveRoute();
    _fetchBusNo();
  }

  Future<void> _fetchActiveRoute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? route = prefs.getString('activeRoute');
    setState(() {
      activeRoute = route ?? '';
    });
  }

  Future<void> _fetchBusNo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? busNo = prefs.getString('busno');
    setState(() {
      busno = busNo ?? '';
    });
  }

  Future<void> _deactivateRoute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    
    // Update activeroute field in Firestore document
    if (busno.isNotEmpty) {
      DocumentReference busDocument =
          firestore.collection('buses').doc(busno);
      await busDocument.update({'activeroute': null});
    }
    
    // Clear activeRoute value in shared preferences
    await prefs.setString('activeRoute', '');

    // Navigate back to the previous screen or perform any other action
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DEACTIVATE ROUTE'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Active Route: ${activeRoute ?? ''}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Icon(
              Icons.power_off,
              size: 100,
              color: Colors.red,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _deactivateRoute();
              },
              child: Text(
                'Deactivate',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
