import 'package:bus_t/screens/passsenger/ticket_gen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'payment_service.dart';
import 'package:uuid/uuid.dart';

class PaymentHandler {
  static void handlePayment(BuildContext context, String userId, double amountToPay, String start, String end, String busno, String busname,String activeticket) async {
    bool paymentSuccess = await PaymentService.payFromWallet(userId, amountToPay);
    //String documentId = userId;
    if (paymentSuccess) {
      try {
        print(activeticket);
        CollectionReference parentCollection = FirebaseFirestore.instance.collection('users');
           
        DocumentReference documentRef = parentCollection.doc(userId);
          
        CollectionReference ticketsCollection = documentRef.collection('tickets');
        //for adding ticket in live ticket
        CollectionReference parent1 = FirebaseFirestore.instance.collection('tickets');
           
        DocumentReference document1 = parent1.doc(busno);
          
        CollectionReference tickets1 = document1.collection(activeticket);
        // Extract the last 4 characters of the bus number
       String busnoLast4 = busno.substring(busno.length - 4);

        // Generate a unique 3-digit alphanumeric code
        String ticketCode = const Uuid().v4().substring(0, 3).toUpperCase();

        // Create the document ID using the unique combination
        String ticketId = '$busnoLast4-${DateTime.now().millisecondsSinceEpoch}-$ticketCode';
        //String time=DateTime.now() as String;
        // Create a new ticket document in the subcollection
        final newTicketRef = ticketsCollection.doc(ticketId);
        // print('$busno  $busname');
        await newTicketRef.set({
          'busno': busno,
          'busname': busname,
          'start': start,
          'destination': end,
          'bookingDateTime': DateTime.now(),
          'ticketcharge': amountToPay,
        });
        final newTicketRef1 = tickets1.doc(ticketId);
        // print('$busno  $busname');
        await newTicketRef1.set({
          'busno': busno,
          'busname': busname,
          'start': start,
          'destination': end,
          'bookingDateTime':DateTime.now(),
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
              title: const Text('Error'),
              content: const Text('Failed to generate ticket. Please try again.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
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
            title: const Text('Payment Failed'),
            content: const Text('Payment failed or insufficient funds.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
