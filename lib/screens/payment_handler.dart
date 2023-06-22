import 'package:bus_t/screens/ticket_gen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'busroute.dart';
import 'payment_service.dart';



class PaymentHandler {
  
   static void handlePayment(BuildContext context, String userId, double amountToPay,String start,String end) async {
    bool paymentSuccess = await PaymentService.payFromWallet(userId, amountToPay);
    String documentId=userId;
    if (paymentSuccess) {
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
        'destination': end,
        //'seatNumber': seatNumber,
        'bookingDateTime': DateTime.now(),
        'ticketcharge':amountToPay
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
      // Payment successful, navigate to success screen
     /* Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BusTicketScreen(documentId: userId,start:start ,destination:end,charge:amountToPay),
        ),
      );*/
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
