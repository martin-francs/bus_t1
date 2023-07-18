import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import the intl package for DateFormat
class TicketDetailsScreen extends StatelessWidget {
  final DocumentReference ticketRef;

  const TicketDetailsScreen({super.key, required this.ticketRef});

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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ticket ID: ${snapshot.data!.id}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
