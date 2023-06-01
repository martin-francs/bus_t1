import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class busroutescreen extends StatefulWidget {
    String id; 
busroutescreen({required this.id});

  @override
  State<busroutescreen> createState() => _busroutescreenState();
}

class _busroutescreenState extends State<busroutescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: Text(widget.id)),);
  }
}