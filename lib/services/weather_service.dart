import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_flutter/models/weather_models.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherService(this.apiKey);

  get latitude => null;

  get longitude => null;

  Future<Weather> getWeather(String cityName) async {
    // Ambil koordinat dari nama kota
    String? city = await getCurrentCity();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if (city != null && city.isNotEmpty) {
      // Ambil cuaca menggunakan koordinat
      return await getWeatherByCoordinates(
          position.latitude, position.longitude);
    } else {
      throw Exception('City name is empty');
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Fetch the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Convert the location into a list of placemark objects
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    // Extract the city name from the first placemark
    String? city = placemarks[0].locality;

    print('Current city: $city');

    return city ?? "";
  }

  Future<Weather> getWeatherByCoordinates(
      double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        '$BASE_URL?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric'));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
