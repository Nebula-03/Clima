import 'package:flutter/material.dart';
import 'screens/loading_screen.dart';

void main() {
  runApp(const ClimaApp());
}

class ClimaApp extends StatelessWidget {
  const ClimaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clima',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: LoadingScreen(),
    );
  }
}
