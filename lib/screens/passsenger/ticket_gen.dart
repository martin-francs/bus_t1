import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TicketDetailsScreen extends StatelessWidget {
  final DocumentReference ticketRef;

  const TicketDetailsScreen({Key? key, required this.ticketRef}) : super(key: key);

  String formatDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Details'),
      ),
      body: StreamBuilder(
        stream: ticketRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final ticketData = snapshot.data!.data() as Map<String, dynamic>;
            final bookingDateTime = ticketData['bookingDateTime'];
            final colorValue = ticketData['color'];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Color(colorValue), // Use the color value fetched from the collection
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Ticket ID: ${snapshot.data!.id}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Bus-No: ${ticketData['busno']}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Bus-Name: ${ticketData['busname']}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Start: ${ticketData['start']}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Destination: ${ticketData['destination']}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Booking Date and Time: ${formatDate(bookingDateTime)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Ticket charge: ${ticketData['ticketcharge']}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return const Text('Failed to load ticket.');
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
