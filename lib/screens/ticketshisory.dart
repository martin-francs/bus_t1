import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'ticket_gen.dart';

class TicketHistoryScreen extends StatefulWidget {
  final String documentId;

  TicketHistoryScreen({required this.documentId});

  @override
  _TicketHistoryScreenState createState() => _TicketHistoryScreenState();
}

class _TicketHistoryScreenState extends State<TicketHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.documentId)
            .collection('tickets')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching ticket history'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No tickets found'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ticketSnapshot = snapshot.data!.docs[index];
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
                      builder: (context) => TicketDetailsScreen(ticketRef: ticketSnapshot.reference),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(ticketId),
                  subtitle: Text(subtitleText),
                  trailing: Text(ticketData?['ticketcharge']?.toString() ?? 'Unknown Amount'), // Use fallback value if amount is null
                ),
              );
            },
          );
        },
      ),
    );
  }
}