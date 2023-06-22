import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
class addmoney extends StatefulWidget {
  @override
  _addmoneyState createState() => _addmoneyState();
}

class _addmoneyState extends State<addmoney> {
  TextEditingController _amountController = TextEditingController();
  String _displayedAmount = '';
   Razorpay ? _razorpay;
   void _handlePaymentSucess(PaymentSuccessResponse response)
   {
    Fluttertoast.showToast(msg: "SUCESS PAYMENT:${response.paymentId}",timeInSecForIosWeb: 4);
   }
    void _handlePaymentFailure(PaymentFailureResponse response)
   {
    Fluttertoast.showToast(msg: "ERROR :${response.code}",timeInSecForIosWeb: 4);
   }
   void _handleExternalWallet(ExternalWalletResponse response)
   {
    Fluttertoast.showToast(msg: "External_wallet is :${response.walletName}",timeInSecForIosWeb: 4);
   }

   void makePayment() async{
    var options={
      'key':'rzp_test_EtRlJjbLp1Snpr',
      'amount':200000,
     'name':"Martin",
     'description':'hello test',
    'prefill':{'Contact':"+919567867353",'email':"francismartin0078@gmail.com"}
    };
    try{
        _razorpay?.open(options);
    }
    catch(e){
      debugPrint(e.toString());
    }
   }
   @override
   void initState(){
    super.initState();
    _razorpay=Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS,_handlePaymentSucess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR,_handlePaymentFailure);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET,_handleExternalWallet);
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
              onPressed: () {
                makePayment();
              },
              child: const Text('Add to wallet'),
            ),
            const SizedBox(height: 10),
            Text(
              'Amount to Pay: $_displayedAmount',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}