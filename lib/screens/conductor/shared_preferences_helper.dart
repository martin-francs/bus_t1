import 'package:shared_preferences/shared_preferences.dart';

Future<void> printSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, dynamic> allPrefs = prefs.getKeys().fold<Map<String, dynamic>>(
    {},
    (map, key) {
      map[key] = prefs.get(key);
      return map;
    },
  );

  print(allPrefs);
}
