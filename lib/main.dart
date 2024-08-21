import 'package:flutter/material.dart';
import 'package:hearthstone_matches_flutter/view/match_view.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
  //Device orientation
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      themeMode: ThemeMode.light,
      home: const MatchView(),
    );
  }
}


