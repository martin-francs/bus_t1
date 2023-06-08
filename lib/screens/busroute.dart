import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Busroutescreen extends StatefulWidget {
  final String documentId;
  
  Busroutescreen({required this.documentId});

  @override
  
  _BusroutescreenState createState() => _BusroutescreenState();
}

class _BusroutescreenState extends State<Busroutescreen>  {
  String field1 = '';
  //String documentId='KL33N9599';
  String field2 = '';
  
  Future<Map<String, dynamic>> _fetchMapFields() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('buses')
          .doc(widget.documentId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        field1 = data['BUSNO'];
        field2 = data['BusName'];
        final Map<String, dynamic> mapFields = snapshot.data()!['STOPS'];
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
   double _result = 0.0;
   bool _showResult = false;
  List<DropdownMenuItem<String>> _dropdownItems = [];
  List<DropdownMenuItem<String>> _dropdownItems1 = [];

  @override
  void initState() {
    super.initState();
    _fetchDropdownItems();
  }

  void _fetchDropdownItems() async {
    final mapFields = await _fetchMapFields();
    final List<String> options = mapFields.values.cast<String>().toList();
    final List<String> options1 = mapFields.values.cast<String>().toList();
    _selectedOption=options.first;
    _selectedOption1=options1.first;
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
  void _submitOption() async {
  final DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance
          .collection('buses')
          .doc(widget.documentId)
          .get();

  if (snapshot.exists) {
    final Map<String, dynamic> mapFields = snapshot.data()!['km'];

    final double valueA = double.tryParse(mapFields[_selectedOption])  ?? 0.0;
    final double valueB = double.tryParse(mapFields[_selectedOption1])  ?? 0.0;
    double result = valueA - valueB;
    if(result<0){
      result=result*-1;
    }

    setState(() 
    {
        _result = result;
        _showResult = true;
      });
    } else {
      print('Document does not exist');
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('BUS NAME: $field2'),
        ),
        body: Column(
          children: [
            SizedBox(height: 20),
            Text('BUS no: $field1'),
            SizedBox(height: 20),
            Row(
              children: [
                Text("Starting Location"),
                SizedBox(width: 50),
                _dropdownItems.isEmpty
                ? CircularProgressIndicator()
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
                Text("Ending Location"),
                SizedBox(width: 50),
                _dropdownItems1.isEmpty
                ? CircularProgressIndicator()
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
                onPressed: _submitOption,
                child: Text('Submit'),
              ),
              SizedBox(height: 20),
               if (_showResult)
      Container(
        width: 300,
        height: 100,
        color: Colors.cyan,
        child: Center(
          child: Text(
            'Total Distance(KM): $_result',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
            ],
            
        ),
      ),
    );
  }
}



// Usage example
