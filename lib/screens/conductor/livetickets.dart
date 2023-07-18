import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  final String id;
  final int color; // Add a color field

  Ticket({
    required this.id,
    required this.color,
  });

  factory Ticket.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Ticket(
      id: doc.id,
      color: data['color'] ?? Color.fromARGB(0, 255, 255, 255).value, // Fetch the color value from Firestore
    );
  }
}

class TicketService {
  final String documentId;
  final String collectionName;

  TicketService({required this.documentId, required this.collectionName});

  Stream<List<Ticket>> getTicketsStream() {
    return FirebaseFirestore.instance
        .collection('tickets')
        .doc(documentId)
        .collection(collectionName)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Ticket.fromFirestore(doc)).toList());
  }
}

class TicketScreen extends StatelessWidget {
  final String documentId;
  final String collectionName;

  TicketScreen({required this.documentId, required this.collectionName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tickets'),
      ),
      body: StreamBuilder<List<Ticket>>(
        stream: TicketService(documentId: documentId, collectionName: collectionName).getTicketsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching tickets'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tickets found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var ticket = snapshot.data![snapshot.data!.length - index - 1];
                return Container(
                  color: Color(ticket.color), // Use the color value fetched from Firestore
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(ticket.id),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
