import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class addmoney extends StatefulWidget {
  final String documentId;

  addmoney({required this.documentId});
  @override
  _addmoneyState createState() => _addmoneyState();
}

class _addmoneyState extends State<addmoney> {
  TextEditingController _amountController = TextEditingController();
  String _displayedAmount = '';
  Razorpay? _razorpay;

  void _handlePaymentSucess(PaymentSuccessResponse response) {
    String? paymentId = response.paymentId;
    double paidAmount = double.tryParse(_amountController.text) ?? 0.0;

    // Update Firestore document
    FirebaseFirestore.instance
        .collection('users') 
        .doc(widget.documentId) 
        .update({'walletAmount': FieldValue.increment(paidAmount)})
        .then((value) {
      // Firestore update successful
      Fluttertoast.showToast(
          msg: "SUCCESS PAYMENT: $paymentId", timeInSecForIosWeb: 4);
    }).catchError((error) {
      // Firestore update failed
      Fluttertoast.showToast(
          msg: "Error updating wallet amount", timeInSecForIosWeb: 4);
    });
  }

  void _handlePaymentFailure(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: ${response.code}", timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "External wallet is: ${response.walletName}", timeInSecForIosWeb: 4);
  }

  void makePayment() async {
    double amount = double.tryParse(_amountController.text) ?? 0.0;

    if (amount <= 0) {
      Fluttertoast.showToast(
          msg: "Please enter a valid amount", timeInSecForIosWeb: 4);
      return;
    }

    var options = {
      'key': 'rzp_test_EtRlJjbLp1Snpr',
      'amount': (amount * 100).toInt(),
      'name': "Martin",
      'description': 'hello test',
      'prefill': {
        'Contact': "+919567867353",
        'email': "francismartin0078@gmail.com"
      }
    };

    try {
      _razorpay?.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

@override
void initState() {
  super.initState();
  _razorpay = Razorpay();
  _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSucess);
  _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentFailure);
  _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
}

@override
void dispose() {
  _razorpay?.clear();
  super.dispose();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADD TO WALLET'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Enter Amount to Pay:',
            ),
            const SizedBox(height: 10),
            Container(
              width: 200,
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: '0.00',
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: makePayment,
              child: const Text('Add to wallet'),
            ),
            const SizedBox(height: 10),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.documentId) 
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error fetching wallet amount');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                double walletAmount = snapshot.data?['walletAmount'] ?? 0.0;

                return Column(
                  children: [
                    Text(
                      'Wallet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      walletAmount.toString(),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
