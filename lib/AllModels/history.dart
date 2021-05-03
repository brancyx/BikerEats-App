import 'package:firebase_database/firebase_database.dart';

class History {
  String key;
  String startpoint;
  String endpoint;
  double ratings;

  History(startpoint, endpoint, ratings) {
    this.startpoint = startpoint;
    this.endpoint = endpoint;
    this.ratings = ratings;
  }

  History.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        startpoint = snapshot.value["startpoint"],
        endpoint = snapshot.value["endpoint"],
        ratings = snapshot.value["ratings"];

  toJson() {
    return {
      "startpoint": startpoint,
      "endpoint": endpoint,
      "ratings": ratings,
    };
  }
}
