import 'package:bus_t/screens/conductor/shared_preferences_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'c_home.dart';

class activeonscreen extends StatefulWidget {
  final String? busno;
  final List<String> routeIds;

  const activeonscreen({Key? key, required this.busno, required this.routeIds})
      : super(key: key);

  @override
  _activeonscreenState createState() => _activeonscreenState();
}

class _activeonscreenState extends State<activeonscreen> {
  String? selectedRouteId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ACTIVATE ROUTE'),
      ),
      body: Center(
        child: widget.routeIds.isEmpty
            ? const Text('No routes to show')
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.routeIds.length,
                      itemBuilder: (context, index) {
                        return RadioListTile<String>(
                          title: Text(widget.routeIds[index]),
                          value: widget.routeIds[index],
                          groupValue: selectedRouteId,
                          onChanged: (value) {
                            setState(() {
                              selectedRouteId = value;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedRouteId != null) {
                        saveActiveRoute(selectedRouteId!);
                      } else {
                        // No route selected
                        print('Please select a route');
                      }
                    },
                    child: const Text('Activate'),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> saveActiveRoute(String routeId) async {
  if (widget.busno != null) {
     // Save the timestamp in shared preferences
    DateTime now = DateTime.now();
    String timestamp = now.toIso8601String();
  
    CollectionReference busesCollection =
        FirebaseFirestore.instance.collection('buses');
    DocumentReference busDocument = busesCollection.doc(widget.busno);
    await busDocument.update({'activeroute': routeId});
    await busDocument.update({'activeticket': timestamp});
    print('Active route saved: $routeId');

    // Save the active route in shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('time', timestamp);
    await prefs.setBool('active',true);
    


    // DateTime now = DateTime.now();
    // String timestamp = now.toIso8601String();
    // await prefs.setString('time', timestamp);

    // Create a collection with the collection ID as timestamp
    // and a document with the document ID as 'dummyticket' in the tickets collection
    CollectionReference ticketsCollection =
        FirebaseFirestore.instance.collection('tickets');
    DocumentReference ticketDocument =
        ticketsCollection.doc(widget.busno).collection(timestamp).doc('dummyticket');
    await ticketDocument.set({'routeId': routeId});
    // Save the timestamp in shared preferences
    await prefs.setString('activeRoute', routeId);
    printSharedPreferences();
    // Show success dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Activation Status'),
          content: const Text('Route activated successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog
                navigateToHomeScreen(); // Navigate to home screen
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}void navigateToHomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ConductorHomePage(busID: '',),
      ),
    );
  }
}
