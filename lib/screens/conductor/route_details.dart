import 'package:flutter/material.dart';

class RouteDetailsPage extends StatelessWidget {
  final String routeName;

  RouteDetailsPage({required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Route Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Route Name: $routeName',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Start Route: ...', // Replace with actual start route details
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Stop Route: ...', // Replace with actual stop route details
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
