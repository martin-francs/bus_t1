
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'routes_management.dart';

class AddRoutePage extends StatefulWidget {
  final String busID;

  const AddRoutePage({super.key, required this.busID});

  @override
  _AddRoutePageState createState() => _AddRoutePageState();
}

class _AddRoutePageState extends State<AddRoutePage> {
  final TextEditingController _routeNameController = TextEditingController();
  final TextEditingController _pricePerKmController = TextEditingController();
  final TextEditingController _startRouteController = TextEditingController(text: '0');
  final TextEditingController _stopNameController = TextEditingController();
  final TextEditingController _stopDistanceController = TextEditingController();
  List<Map<String, dynamic>> stops = [];
  bool _isEditing = true;
  bool _isFirstSaveVisible = true;
  bool _isSecondSaveVisible = false;
  int stopCount = 0;

  void _saveRoute() {
    setState(() {
      _isEditing = false;
      _isFirstSaveVisible = false;
      _isSecondSaveVisible = true;
    });
  }

  void _addStop() {
  String stopName = _stopNameController.text;
  double stopDistance = double.tryParse(_stopDistanceController.text) ?? 0.0;

  if (stopName.isNotEmpty && stopDistance >= 0) {
    setState(() {
      stopCount++;
      stops.add({
        'stop$stopCount': stopName,
        'distance': stopDistance,
      });
      _stopNameController.clear();
      _stopDistanceController.clear();
    });
  }
}


void _saveRouteAgain() async {
  String routeName = _routeNameController.text;
  String startRoute = _startRouteController.text;
  double pricePerKm = double.tryParse(_pricePerKmController.text) ?? 0.0;

  if (routeName.isEmpty || startRoute.isEmpty || pricePerKm <= 0) {
    return;
  }

  try {
    Map<String, dynamic> stopsMap = {};
    Map<String, double> kmMap = {};
    // Create a shared preferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save the route details to shared preferences
    await prefs.setString('routeName', routeName);
    await prefs.setString('startRoute', startRoute);
    await prefs.setDouble('pricePerKm', pricePerKm);


    // Add start route to stopsMap and kmMap
    stopsMap['stop0'] = startRoute;
    kmMap[startRoute] = 0.0;

    for (int i = 0; i < stops.length; i++) {
      String stopName = stops[i]['stop${i + 1}'];
      double stopDistance = stops[i]['distance'];
      stopsMap['stop${i + 1}'] = stopName;
      kmMap[stopName] = stopDistance;
    }

    DocumentReference routeDocRef = FirebaseFirestore.instance
        .collection('buses')
        .doc(widget.busID)
        .collection('routes')
        .doc(routeName);

    await routeDocRef.set({
      'routeName': routeName,
      'startRoute': startRoute,
      'stops': stopsMap,
      'km': kmMap,
      'priceperkm': pricePerKm,
    });

    // Show success message or navigate to another screen
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Route added successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RouteManagement(busID: widget.busID),
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  } catch (error) {
    print('Error adding route: $error');
    // Show error message or handle the error accordingly
  }
}



  @override
  void dispose() {
    _routeNameController.dispose();
    _pricePerKmController.dispose();
    _startRouteController.dispose();
    _stopNameController.dispose();
    _stopDistanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Route'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _routeNameController,
                enabled: _isEditing,
                decoration: const InputDecoration(
                  labelText: 'Route Name',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _pricePerKmController,
                enabled: _isEditing,
                decoration: const InputDecoration(
                  labelText: 'Price per KM',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              if (!_isEditing)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _startRouteController,
                      enabled: !_isEditing,
                      decoration: const InputDecoration(
                        labelText: 'Start Route',
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Stops:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: stops.map((stop) {
                        return Row(
                          children: [
                            Expanded(
                              child: Text('${stop['name']}'),
                            ),
                            const SizedBox(width: 10),
                            Text('Distance: ${stop['distance']} km'),
                          ],
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _stopNameController,
                            decoration: const InputDecoration(
                              labelText: 'New Stop Name',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _stopDistanceController,
                            decoration: const InputDecoration(
                              labelText: 'Distance from Start (km)',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        IconButton(
                          onPressed: _addStop,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              Visibility(
                visible: _isFirstSaveVisible,
                child: ElevatedButton(
                  onPressed: _saveRoute,
                  child: const Text('Save'),
                ),
              ),
              Visibility(
                visible: _isSecondSaveVisible,
                child: ElevatedButton(
                  onPressed: _saveRouteAgain,
                  child: const Text('Save Again'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}