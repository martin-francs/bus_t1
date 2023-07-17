import 'dart:io';
import 'package:bus_t/screens/conductor/active_off.dart';
import 'package:bus_t/screens/conductor/active_on.dart';
import 'package:bus_t/screens/conductor/routes_management.dart';
import 'package:bus_t/screens/loginsignup/welcome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'livetickets.dart';





Future<List<String>> fetchRouteIds(String? busno) async {
  List<String> routeIds = [];
  if (busno != null) {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('buses')
        .doc(busno)
        .collection('routes')
        .get();
    for (var doc in snapshot.docs) {
      routeIds.add(doc.id);
    }
  }
  return routeIds;
}
class ConductorHomePage extends StatefulWidget {
  final String busID;

  const ConductorHomePage({super.key, required this.busID});
Future<String?> _getDocumentIdFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('busno');
  }
  @override
  _ConductorHomePageState createState() => _ConductorHomePageState();
}

class _ConductorHomePageState extends State<ConductorHomePage> {
  String qrCodeImageUrl = '';
  String? documentId;
  bool active = false;
  String? collectionName;
  @override
  void initState() {
    super.initState();
    loadQRCodeImage();
     _loadSharedPrefs(); // Load the QR code image when the home page is initialized
  }
  _loadSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      documentId = prefs.getString('busno');
      collectionName = prefs.getString('time');
      active= prefs.getBool('active')!;
    });
  }

  Future<void> loadQRCodeImage() async {
    try {
      // Retrieve the QR code image URL from Firebase Storage
      final storageReference = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('qr_codes')
          .child('${widget.busID}.png');
      final downloadURL = await storageReference.getDownloadURL();

      // Update the state with the QR code image URL
      setState(() {
        qrCodeImageUrl = downloadURL;
      });
    } catch (error) {
      print('Error loading QR code image: $error');
    }
  }

void downloadQRCodeAsPDF() async {
  try {
    // Retrieve the QR code image bytes from the network
    final response = await http.get(Uri.parse(qrCodeImageUrl));
    final qrCodeImageBytes = response.bodyBytes;

    // Create a PDF document
    final pdf = pw.Document();

    // Add a page to the PDF document
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Image(
            pw.MemoryImage(qrCodeImageBytes),
            fit: pw.BoxFit.contain,
          );
        },
      ),
    );

    // Get the temporary directory path
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;

    // Save the PDF document to a temporary file
    final filePath = File('$tempPath/${widget.busID}_qr_code.pdf');
    await filePath.writeAsBytes(await pdf.save());

    // Open the PDF file with the default PDF viewer
    OpenFile.open(filePath.path);
  } catch (error) {
    print('Error downloading QR code as PDF: $error');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conductor Home'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.orange,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (qrCodeImageUrl.isNotEmpty)
                      Image.network(
                        qrCodeImageUrl,
                        width: 200, // Adjust the width to make the image larger
                        height: 80, // Adjust the height to make the image larger
                        fit: BoxFit.contain,
                      ),
                    ElevatedButton(
                      onPressed: downloadQRCodeAsPDF,
                      child: const Text('Download QR as PDF'),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                  signout1(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _loadSharedPrefs();
            print(documentId);
            print(collectionName);
            if (active!=false) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TicketScreen(
                    documentId: documentId!,
                    collectionName: collectionName!,
                  ),
                ),
              );
            } else {
              // Handle case where shared preferences are not set
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Error'),
                  content: Text('SET A ROUTE ACTIVE BY CLICKING POWERON ICON .'),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            }
          },
              
              child: const Text('Live Tickets'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RouteManagement(busID: widget.busID,),
                  ),
                );
              },
              child: const Text('Route Management'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? activeRoute =
              await SharedPreferences.getInstance().then((prefs) {
            return prefs.getString('activeRoute');
          });

          if (activeRoute != '') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const activeoffscreen(),
              ),
            );
          } else {
            String? busno = await widget._getDocumentIdFromSharedPreferences();
            List<String> routeIds = await fetchRouteIds(busno);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    activeonscreen(busno: busno, routeIds: routeIds),
              ),
            );
          }
        },
        backgroundColor: const Color.fromARGB(255, 18, 78, 217),
        child: const Icon(Icons.power_settings_new_sharp),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
  signout1(BuildContext ctx) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(ctx).pushAndRemoveUntil(
      MaterialPageRoute(builder: (ctx1) => const WelcomeScreen()),
      (route) => false,
    );
  }
}
