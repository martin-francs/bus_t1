import 'package:bus_t/screens/passsenger/ticket_gen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // Import this package for accessing colors
import 'payment_service.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

class PaymentHandler {
  static void handlePayment(BuildContext context, String userId, double amountToPay, String start, String end, String busno, String busname, String activeticket) async {
    bool paymentSuccess = await PaymentService.payFromWallet(userId, busno, amountToPay);
    if (paymentSuccess) {
      try {
        CollectionReference parentCollection = FirebaseFirestore.instance.collection('users');
        DocumentReference documentRef = parentCollection.doc(userId);
        CollectionReference ticketsCollection = documentRef.collection('tickets');
        CollectionReference parent1 = FirebaseFirestore.instance.collection('tickets');
        DocumentReference document1 = parent1.doc(busno);
        CollectionReference tickets1 = document1.collection(activeticket);
        CollectionReference parent2 = FirebaseFirestore.instance.collection('conductors');
        DocumentReference document2 = parent2.doc(busno);
        CollectionReference tickets2 = document2.collection('Payments');
        String busnoLast4 = busno.substring(busno.length - 4);
        String ticketCode = const Uuid().v4().substring(0, 3).toUpperCase();
        String ticketId = '$busnoLast4-${DateTime.now().millisecondsSinceEpoch}-$ticketCode';
        final newTicketRef = ticketsCollection.doc(ticketId);
        final newTicketRef1 = tickets1.doc(ticketId);
        final newTicketRef2 = tickets2.doc(ticketId);
        // Generate a random color value
        final randomColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
        
        await newTicketRef.set({
          'busno': busno,
          'busname': busname,
          'start': start,
          'destination': end,
          'bookingDateTime': DateTime.now(),
          'ticketcharge': amountToPay,
          'color': randomColor.value, // Assign the random color value
        });
        
        await newTicketRef1.set({
          'busno': busno,
          'busname': busname,
          'start': start,
          'destination': end,
          'bookingDateTime': DateTime.now(),
          'ticketcharge': amountToPay,
          'color': randomColor.value, // Assign the random color value
        });
        await newTicketRef2.set({
          'busno': busno,
          'busname': busname,
          'start': start,
          'destination': end,
          'bookingDateTime': DateTime.now(),
          'ticketcharge': amountToPay,
          'color': randomColor.value, 
        });


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
