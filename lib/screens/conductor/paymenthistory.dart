import 'package:bus_t/screens/conductor/paymentDetails.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class paymentHistoryScreen extends StatefulWidget {
  final String documentId;

  const paymentHistoryScreen({super.key, required this.documentId});

  @override
  _paymentHistoryScreenState createState() => _paymentHistoryScreenState();
}

class _paymentHistoryScreenState extends State<paymentHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PAYMENT HISTORY'),
        backgroundColor: Colors.amber,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('conductors')
            .doc(widget.documentId)
            .collection('Payments')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching Payment history'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No Payments found'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ticketSnapshot = snapshot.data!.docs[snapshot.data!.docs.length - index - 1];
              Map<String, dynamic>? ticketData = ticketSnapshot.data()
                  as Map<String, dynamic>?; // Mark ticketData as nullable

              String ticketId = ticketSnapshot.id; // Use fallback value if ID is null
              String start = ticketData?['start'] ?? 'Unknown Start'; // Use fallback value if start is null
              String destination = ticketData?['destination'] ?? 'Unknown Destination'; // Use fallback value if destination is null

              String subtitleText = '$start -> $destination';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => paymentDetailsScreen(ticketRef: ticketSnapshot.reference),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(ticketId),
                  subtitle: Text(subtitleText),
                  trailing: Text(ticketData?['ticketcharge']?.toString() ?? 'Unknown Amount',style: TextStyle(color: Color.fromARGB(255, 1, 148, 70)),), // Use fallback value if amount is null
                ),
              );
            },
          );
        },
      ),
    );
  }
}