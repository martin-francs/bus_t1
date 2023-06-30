import 'package:bus_t/screens/loginsignup/welcome.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  Future<String?> getMobileNumberFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('mobileNumber');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<String?>(
              future: getMobileNumberFromSharedPreferences(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  return Text(
                    'Mobile Number: ${snapshot.data}',
                    style: TextStyle(fontSize: 18),
                  );
                } else {
                  return Text(
                    'Mobile Number not found',
                    style: TextStyle(fontSize: 18),
                  );
                }
              },
            ),
            ElevatedButton(
              child: Text('Logout'),
              onPressed: () {
                signout(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  signout(BuildContext ctx) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(ctx).pushAndRemoveUntil(
      MaterialPageRoute(builder: (ctx1) => WelcomeScreen()),
      (route) => false,
    );
  }
}
