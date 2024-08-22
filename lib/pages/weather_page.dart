import 'package:flutter/material.dart';
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // City Name
            Text(_weather?.cityName ?? "Loading City.."),

            // Temperature
            Text('${_weather?.temperature.round()}°C')
          ],
        ),
      ),
    );
  }
}
