import 'package:flutter/material.dart';
import '../services/weather.dart';
import '../utilities/constants.dart';
import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  final dynamic weatherData;
  const LocationScreen({super.key, required this.weatherData});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen>
    with SingleTickerProviderStateMixin {

  WeatherModel weather = WeatherModel();

  late double temp;
  late String city;
  late String icon;
  late String message;

  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    updateUI(widget.weatherData);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();
  }

  void updateUI(dynamic data) {
    if (data == null) return;

    temp = data['current']['temp_c'];
    city = data['location']['name'];
    icon = weather.getWeatherIcon(
      data['current']['condition']['code'],
    );
    message = weather.getMessage(temp);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1E3C72),
                Color(0xFF2A5298),
                Color(0xFF000428),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  // 🔝 TOP ACTION BUTTONS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.near_me, size: 34),
                        color: Colors.white,
                        onPressed: () async {
                          _controller.reset();
                          var data = await weather.getLocationWeather();
                          setState(() => updateUI(data));
                          _controller.forward();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.location_city, size: 34),
                        color: Colors.white,
                        onPressed: () async {
                          var typedCity = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CityScreen()),
                          );

                          if (typedCity != null) {
                            _controller.reset();
                            var data = await weather.getCityWeather(typedCity);
                            setState(() => updateUI(data));
                            _controller.forward();
                          }
                        },
                      ),
                    ],
                  ),

                  // 🌡 WEATHER CARD
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: ScaleTransition(
                      scale: _scaleAnim,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 30,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${temp.toInt()}°',
                              style: kTempTextStyle.copyWith(
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              '$message in $city',
                              textAlign: TextAlign.center,
                              style: kMessageTextStyle.copyWith(
                                color: Colors.white70,
                              ),
                            ),

                            const SizedBox(height: 20),

                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 0001),
                              transitionBuilder: (child, animation) =>
                                  ScaleTransition(scale: animation, child: child),
                              child: Text(
                                icon,
                                key: ValueKey(icon),
                                style: kConditionTextStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
