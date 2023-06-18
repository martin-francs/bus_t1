import 'package:flutter/material.dart';

import 'busroute.dart';
import 'payment_service.dart';


class PaymentHandler {
  static void handlePayment(BuildContext context, String userId, double amountToPay) async {
    bool paymentSuccess = await PaymentService.payFromWallet(userId, amountToPay);

    if (paymentSuccess) {
      // Payment successful, navigate to success screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentSuccessPage(),
        ),
      );
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
