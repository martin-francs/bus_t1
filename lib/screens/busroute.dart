import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Busroutescreen extends StatefulWidget {
  final String documentId;
  
  Busroutescreen({required this.documentId});

  @override
  
  _BusroutescreenState createState() => _BusroutescreenState();
}

class _BusroutescreenState extends State<Busroutescreen> {
  String field1 = '';
  //String documentId='KL33N9599';
  String field2 = '';

  @override
  void initState() {
    super.initState();
    fetchDocumentFields(widget.documentId);
  }

  Future<void> fetchDocumentFields(String documentId) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('buses')
          .doc(documentId)
          .get();

      if (snapshot.exists) {
        // Document exists, you can access its fields
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        // Access specific fields
        setState(() {
          field1 = data['BUSNO'];
          field2 = data['BusName'];
         
        });
      } else {
        // Document does not exist
        print('Document does not exist');
      }
    } catch (e) {
      // Error occurred while fetching document
      print('Error fetching document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BUS T'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('BUS no: $field1'),
            Text('BUS NAME: $field2'),
            Text(widget.documentId),
          ],
        ),
      ),
    );
  }
}

// Usage example
