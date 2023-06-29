import 'package:bus_t/screens/ticket_gen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'busroute.dart';
import 'payment_service.dart';
import 'package:uuid/uuid.dart';

class PaymentHandler {
  static void handlePayment(BuildContext context, String userId, double amountToPay, String start, String end, String busno, String busname) async {
    bool paymentSuccess = await PaymentService.payFromWallet(userId, amountToPay);
    String documentId = userId;
    if (paymentSuccess) {
      try {
        CollectionReference parentCollection = FirebaseFirestore.instance.collection('users');

        DocumentReference documentRef = parentCollection.doc(documentId);

        CollectionReference ticketsCollection = documentRef.collection('tickets');

        // Extract the last 4 characters of the bus number
        String busnoLast4 = busno.substring(busno.length - 4);

        // Generate a unique 3-digit alphanumeric code
        String ticketCode = Uuid().v4().substring(0, 3).toUpperCase();

        // Create the document ID using the unique combination
        String ticketId = '$busnoLast4-${DateTime.now().millisecondsSinceEpoch}-$ticketCode';

        // Create a new ticket document in the subcollection
        final newTicketRef = ticketsCollection.doc(ticketId);

        await newTicketRef.set({
          'busno': busno,
          'busname': busname,
          'start': start,
          'destination': end,
          'bookingDateTime': DateTime.now(),
          'ticketcharge': amountToPay,
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
    } else {
      // Payment failed or insufficient funds, show appropriate message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Payment Failed'),
            content: Text('Payment failed or insufficient funds.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
