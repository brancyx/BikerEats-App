import 'package:bikereats/AllControllers/requestManager.dart';
import 'package:bikereats/AllModels/weather.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Get the weather at the specified point
class WeatherManager {
  static Future<Weather> obtainWeather(LatLng position) async {
  String weatherUrl = "https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=4d2d80c8e41f855b088912a69d72aa51";

  var res = await RequestManager.getRequest(weatherUrl);
  print(res);
  if (res == "failed")
  {
  return null;
  }

  Weather weatherDetails = Weather();

  weatherDetails.date = DateTime.fromMillisecondsSinceEpoch(res['dt'] * 1000, isUtc: false);
  weatherDetails.description = res['weather'][0]['main'];
  weatherDetails.temp = (res['main']['temp'].toDouble() - 273.15).toStringAsFixed(1) + " ";
  weatherDetails.icon = res['weather'][0]['icon'];

  return weatherDetails;
  }
}
