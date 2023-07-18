import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


import 'payment_handler.dart';

class Busroutescreen extends StatefulWidget {
  final String documentId;
   final String userId;
   
  const Busroutescreen({super.key, required this.documentId,required this.userId});

  @override
  
  _BusroutescreenState createState() => _BusroutescreenState();
}

class _BusroutescreenState extends State<Busroutescreen>  {

  String field1 = '';
  String field2 = '';
  String busno = '';
  String busname = '';
  String activeroute = '';
  String activeticket = '';
  bool flag=false;
  Future<Map<String, dynamic>> _fetchMapFields() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('buses')
          .doc(widget.documentId)
          .collection('routes')
          .doc(activeroute)
          .get();
      if (snapshot.exists) {
        final Map<String, dynamic> mapFields = snapshot.data()!['stops'];
        return mapFields;
      } else {
        throw Exception('Document does not exist');
      }
    } catch (e) {
      throw Exception('Failed to fetch document: $e');
    }
  }
  String _selectedOption = 'Placid';
  String _selectedOption1 = 'Placid';
  String start = '';
  String end = '';
   double _result = 0.0;
   double _finalresult = 0.0;
   bool _showResult = false;
  List<DropdownMenuItem<String>> _dropdownItems = [];
  List<DropdownMenuItem<String>> _dropdownItems1 = [];
  @override
  void initState() {
    super.initState();
    _fetchDataAndInitializeVariables();
  }
  Future<void> _fetchDataAndInitializeVariables() async {
  try {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection('buses')
            .doc(widget.documentId)
            .get();

    if (snapshot.exists) {
      final Map<String, dynamic> data = snapshot.data()!;
      setState(() {
        busno = data['BUSNO'];
        busname = data['BusName'];
        activeroute = data['activeroute'];
        activeticket= data['activeticket'];
      });
      // print(busno);
      // print(busname);
      // print(activeroute);
      if(flag==false)
      {
      _fetchDropdownItems();
      flag=true;
      }
    } else {
      throw Exception('Document does not exist');
    }
  } catch (e) {
    print('Error: $e');
  }
}

  void _fetchDropdownItems() async {
    _fetchDataAndInitializeVariables();
    final mapFields = await _fetchMapFields();
    final List<String> options = mapFields.values.cast<String>().toList();
    final List<String> options1 = mapFields.values.cast<String>().toList();
    _selectedOption=options.first;
     _selectedOption1=options1[1];
    final List<DropdownMenuItem<String>> items = options
        .map<DropdownMenuItem<String>>((value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            ))
        .toList();
    final List<DropdownMenuItem<String>> items1 = options1
        .map<DropdownMenuItem<String>>((value) => DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            ))
        .toList();    

    setState(() {
      _dropdownItems = items;
      _dropdownItems1 = items1;
      
    });
  }
  void  _submitOption(BuildContext context) async {
    if(_selectedOption==_selectedOption1)
    {
      showDialog(context:(context), builder: (ctx)
    {
        return AlertDialog(title: const Text('Error'),
        content:const Text('Select different destination'),
        actions: [
          TextButton(onPressed: (){Navigator.of(ctx).pop();}, child: const Text('close'))
          ]);
      });  }
    else{
  final DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance
            .collection('buses')
          .doc(widget.documentId)
          .collection('routes')
          .doc(activeroute)
          .get();

  if (snapshot.exists) {
    final Map<String, dynamic> mapFields = snapshot.data()!['km'];
    final double priceperkm =
        double.tryParse(snapshot.data()!['priceperkm']) ?? 0.0;
    final double valueA = double.tryParse(mapFields[_selectedOption])  ?? 0.0;
    final double valueB = double.tryParse(mapFields[_selectedOption1])  ?? 0.0;
    double result = valueA - valueB;
    if(result<=0){
      result=result*-1;
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select valid end location!!")));
    }
    final double finalResult = result * priceperkm;
    setState(() 
    {
        _result = result;
         _finalresult = finalResult.roundToDouble();
        _showResult = true;
        start=_selectedOption;
        end=_selectedOption1;
      });
    } else {
      print('Document does not exist');
    }
  }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('BUS NAME: $busname'),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Text('BUS no: $busno'),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text("Starting Location"),
                const SizedBox(width: 50),
                _dropdownItems.isEmpty
                ? const CircularProgressIndicator()
                : DropdownButton<String>(
                    value: _selectedOption,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedOption = newValue!;
                      });
                    },
                    items: _dropdownItems,
                  ),
              ]
            ),
            
          Row(
              children: [
                const Text("Ending Location"),
                const SizedBox(width: 50),
                _dropdownItems1.isEmpty
                ? const CircularProgressIndicator()
                : DropdownButton<String>(
                    value: _selectedOption1,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedOption1 = newValue!;
                      });
                    },
                    items: _dropdownItems1,
                  ),
              ]
            ),
            ElevatedButton(
                onPressed: () => _submitOption(context),
                child: const Text('Submit'),
              ),
              const SizedBox(height: 20),
               if (_showResult)
      Container(
        height: 100,
        color: Colors.cyan,
        child: Center(
          child: Row(
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50,0,10,10),
                    child: Text('$start-->$end',
                      style: const TextStyle(fontSize: 18),),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(40,0,0,0),
                      child: Text(
                        'Total Distance(KM): $_result',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
       if (_showResult)
      Container(
        width: 300,
        height: 100,
        color: Colors.yellowAccent,
        child: Center(
          child: Text(
            'Amount: $_finalresult',
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
       if (_showResult)
      ElevatedButton(onPressed: () => PaymentHandler.handlePayment(context, widget.userId, _finalresult,_selectedOption,_selectedOption1,busno,busname,activeticket), child: const Text("PAY")),
            ],
            
        ),
      ),
    );
  }
}
class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Success'),
      ),
      body: const Center(
        child: Text('Payment successful!'),
      ),
    );
  }
}