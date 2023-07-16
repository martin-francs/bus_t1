
import 'package:bus_t/screens/conductor/route_adding.dart';
import 'package:bus_t/screens/conductor/route_details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RouteManagement extends StatefulWidget {
  final String busID;

  const RouteManagement({super.key, required this.busID});

  @override
  _RouteManagementState createState() => _RouteManagementState();
}

class _RouteManagementState extends State<RouteManagement> {
  Future<String?> _getRouteNameFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('routeName');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Management'),
        actions: [
          FloatingActionButton(
            onPressed: _addRoute,
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<String?>(
        future: _getRouteNameFromSharedPreferences(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            String? routeName = snapshot.data;

            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('buses')
                  .doc(widget.busID)
                  .collection('routes')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final routes = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: routes.length,
                    itemBuilder: (context, index) {
                      final routeData = routes[index].data() as Map<String, dynamic>;
                      final routeId = routes[index].id;
                      final routeName = routeData['routeName'] as String? ?? 'Unknown Route';

                      return ListTile(
                        title: Text(routeName),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteRoute(routeId),
                        ),
                        onTap: () => _viewRouteDetails(routeName),
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

  void _addRoute() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddRoutePage(busID: widget.busID)),
    );
  }

  void _deleteRoute(String routeId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this route?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('buses')
                  .doc(widget.busID)
                  .collection('routes')
                  .doc(routeId)
                  .delete();
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _viewRouteDetails(String routeName) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RouteDetailsPage(routeName: routeName)),
    );
  }
}
