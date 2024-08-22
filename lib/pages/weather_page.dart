import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app_flutter/models/weather_models.dart';
import 'package:weather_app_flutter/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // API Key
  final _weatherService = WeatherService('28b04a4bd6a357a40e7c0b13ff692c80');
  Weather? _weather;

  // Fetch Weather
  _fetchWeather() async {
    try {
      String cityName = await _weatherService.getCurrentCity();
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print('Error fetching weather: $e');
      setState(() {
        _weather = Weather(
          cityName: "Error",
          temperature: 0.0,
          mainCondition: "N/A",
        );
      });
    }
  }

  // Weather Animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/clouds.json';
      case 'rain':
      case 'drizzle':
      case 'shower Rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  // Init state
  @override
  void initState() {
    super.initState();

    // Fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Icon(
                  CupertinoIcons.map_pin,
                  color: Colors.grey[350],
                  size: 30,
                ),
                const SizedBox(height: 5),
                // City Name
                Text(
                  _weather?.cityName ?? "Loading City..".toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[350],
                    fontSize: 18,
                  ),
                ),
              ],
            ),

            // Animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            // Temperature
            Column(
              children: [
                Text(
                  '${_weather?.temperature.round()}°C',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[350],
                      fontSize: 18),
                ),
                const SizedBox(height: 5),
                Text(
                  _weather?.mainCondition ?? " ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[350],
                      fontSize: 18),
                )
              ],
            ),

            // Weather condition
          ],
        ),
      ),
    );
  }
}
