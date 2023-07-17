import 'package:bus_t/screens/conductor/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class activeoffscreen extends StatefulWidget {
  const activeoffscreen({super.key});

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
      await busDocument.update({'activeticket': null});
    }
    
    // Clear activeRoute and time value in shared preferences
    await prefs.setString('activeRoute', '');
    await prefs.setString('time', '');
    await prefs.setBool('active',false);
    printSharedPreferences();
    // Navigate back to the previous screen or perform any other action
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DEACTIVATE ROUTE'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Active Route: ${activeRoute ?? ''}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            const Icon(
              Icons.power_off,
              size: 100,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _deactivateRoute();
              },
              child: const Text(
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
