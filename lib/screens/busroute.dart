import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Busroutescreen extends StatefulWidget {
  final String documentId;
  
  Busroutescreen({required this.documentId});

  @override
  
  _BusroutescreenState createState() => _BusroutescreenState();
}

class _BusroutescreenState extends State<Busroutescreen>  {
  Future<Map<String, dynamic>> _fetchMapFields() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('buses')
          .doc(widget.documentId)
          .get();

      if (snapshot.exists) {
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('BUS T'),
        ),
        body: Column(
          children: [
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
            )],
            
        ),
      ),
    );
  }
}



// Usage example
