import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentService {
  static Future<bool> payFromWallet(String userId, double amountToPay) async {
    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          double currentWalletAmount = data['walletAmount'] ?? 0.0;

          if (currentWalletAmount >= amountToPay) {
            double newWalletAmount = currentWalletAmount - amountToPay;

            await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .update({'walletAmount': newWalletAmount});

            return true; // Payment successful
          } else {
            return false; // Insufficient funds in the wallet
          }
        } else {
          return false; // User document does not exist
        }
      } else {
        return false; // User document does not exist
      }
    } catch (error) {
      print('Payment failed: $error');
      return false; // Payment failed
    }
  }
}
