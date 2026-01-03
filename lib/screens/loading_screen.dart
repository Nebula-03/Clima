import 'package:flutter/material.dart';
import '../services/weather.dart';
import 'location_screen.dart';

class LoadingScreen extends StatefulWidget {
  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  void loadWeather() async {
    var weatherData = await WeatherModel().getLocationWeather();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LocationScreen(weatherData: weatherData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
