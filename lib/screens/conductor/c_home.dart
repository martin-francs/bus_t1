
import 'package:bus_t/screens/conductor/qrcode.dart';
import 'package:bus_t/screens/conductor/routes_management.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../loginsignup/welcome.dart';
import 'liveticket.dart';


class ConductorHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conductor Home'),
         actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
             signout1(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LiveTicketsPage(),
                  ),
                );
              },
              child: Text('Live Tickets'),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.pushReplacement(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => WelcomeScreen(),
            //       ),
            //     );
            //   },
            //   child: Text('Logout'),
            // ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RouteManagementPage(),
                  ),
                );
              },
              child: Text('Route Management'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRCodePage(),
                  ),
                );
              },
              child: Text('QR Code'),
            ),

          ],
        ),
      ),
    floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        backgroundColor: Color.fromARGB(255, 18, 78, 217),
        child: const Icon(Icons.power_settings_new_sharp),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
signout1(BuildContext ctx) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(ctx).pushAndRemoveUntil(
      MaterialPageRoute(builder: (ctx1) => WelcomeScreen()),
      (route) => false,
    );
  }
}