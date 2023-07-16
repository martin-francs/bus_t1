import 'package:flutter/material.dart';

class RouteDetailsPage extends StatelessWidget {
  final String routeName;

  const RouteDetailsPage({super.key, required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Route Name: $routeName',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Start Route: ...', // Replace with actual start route details
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              'Stop Route: ...', // Replace with actual stop route details
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
