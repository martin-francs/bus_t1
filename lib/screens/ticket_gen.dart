import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import the intl package for DateFormat

class BusTicketScreen extends StatelessWidget {
  final String documentId;
  final String start;
  final String destination;
  final double charge;
  //final int seatNumber;

  BusTicketScreen({
    required this.documentId,
    required this.start,
    required this.destination,
    required this.charge
    //required this.seatNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Ticket'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            generateTicket(context);
          },
          child: Text('Generate Ticket'),
        ),
      ),
    );
  }

  void generateTicket(BuildContext context) async {
    try {
      CollectionReference parentCollection =
          FirebaseFirestore.instance.collection('users');

      DocumentReference documentRef =
          parentCollection.doc(documentId);

      CollectionReference ticketsCollection =
          documentRef.collection('tickets');

      // Create a new ticket document in the subcollection
      final newTicketRef = await ticketsCollection.add({
        'start': start,
        'destination': destination,
        //'seatNumber': seatNumber,
        'bookingDateTime': DateTime.now(),
        'ticketcharge':charge
      });

      // Navigate to the ticket details screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TicketDetailsScreen(ticketRef: newTicketRef),
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to generate ticket. Please try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}

class TicketDetailsScreen extends StatelessWidget {
  final DocumentReference ticketRef;

  TicketDetailsScreen({required this.ticketRef});

  String formatDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket Details'),
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Start: ${ticketData['start']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Destination: ${ticketData['destination']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
/*                SizedBox(height: 10),
                Text(
                  'Seat Number: ${ticketData['seatNumber']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),*/
                SizedBox(height: 10),
                Text(
                  'Booking Date and Time: ${formatDate(bookingDateTime)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  
                ),
                  SizedBox(height: 10),
                Text(
                  'Ticket charge: ${ticketData['ticketcharge']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                
              ],
            );
          } else if (snapshot.hasError) {
            return Text('Failed to load ticket.');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
