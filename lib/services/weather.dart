import 'dart:convert';
import 'location.dart';
import 'networking.dart';
import '../utilities/constants.dart';

class WeatherModel {

  Future<dynamic> getLocationWeather() async {
    Location location = Location();
    await location.getCurrentLocation();

    if (location.latitude == null || location.longitude == null) {
      return null;
    }

    NetworkHelper networkHelper = NetworkHelper(
      '$kWeatherApiUrl?key=$kWeatherApiKey&q=${location.latitude},${location.longitude}',
    );

    return await networkHelper.getData();
  }

  // ✅ GLOBAL CITY FETCH (FIXED)
  Future<dynamic> getCityWeather(String cityName) async {
    final encodedCity = Uri.encodeComponent(cityName.trim());

    NetworkHelper networkHelper = NetworkHelper(
      '$kWeatherApiUrl?key=$kWeatherApiKey&q=$encodedCity',
    );

    return await networkHelper.getData();
  }

  String getWeatherIcon(int code) {
    if (code == 1000) return '☀️';
    if (code == 1003 || code == 1006) return '🌤️';
    if (code >= 1009 && code <= 1030) return '☁️';
    if (code >= 1063 && code <= 1201) return '🌧️';
    if (code >= 1204 && code <= 1237) return '❄️';
    if (code >= 1273 && code <= 1282) return '⛈️';
    return '';
  }

  String getMessage(double temp) {
    if (temp > 30) return 'It’s ice-cream time 🍦';
    if (temp > 20) return 'Perfect weather 😎';
    if (temp < 10) return 'Brrr… cold 🧥';
    return 'Nice and cool 🌤️';
  }
}
