import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentService {
  static Future<bool> payFromWallet(String userId, String busno, double amountToPay) async {
    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;
        DocumentSnapshot documentSnapshot1 =
             await FirebaseFirestore.instance.collection('conductors').doc(busno).get();
             Map<String, dynamic>? data1 = documentSnapshot1.data() as Map<String, dynamic>?;
             double currentbusWalletAmount = data1!['walletAmount'] ?? 0.0;

        if (data != null) {
          double currentWalletAmount = data['walletAmount'] ?? 0.0;

          if (currentWalletAmount >= amountToPay) {
            print("hiii");
            double newWalletAmount = currentWalletAmount - amountToPay;
             double newWalletAmount1 = currentbusWalletAmount + amountToPay;
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .update({'walletAmount': newWalletAmount});
            await FirebaseFirestore.instance
                .collection('conductors')
                .doc(busno)
                .update({'walletAmount': newWalletAmount1});

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
