import 'package:firebase_database/firebase_database.dart';

class Favourites {
  String key;
  String startpoint;
  double startlat;
  double startlong;
  String endpoint;
  double endlat;
  double endlong;

  Favourites(startPoint, startLat, startLong, endpoint, endLat, endLong) {
    this.startpoint = startPoint;
    this.startlat = startLat;
    this.startlong = startLong;
    this.endpoint = endpoint;
    this.endlat = endLat;
    this.endlong = endLong;
  }

  Favourites.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        startpoint = snapshot.value["startpoint"],
        startlat = snapshot.value["startlat"],
        startlong = snapshot.value["startlong"],
        endpoint = snapshot.value["endpoint"],
        endlat = snapshot.value["endlat"],
        endlong = snapshot.value["endlong"];

  toJson() {
    return {
      "startpoint": startpoint,
      "startlat": startlat,
      "startlong": startlong,
      "endpoint": endpoint,
      "endlat": endlat,
      "endlong": endlong,
    };
  }
}
