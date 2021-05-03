import 'package:firebase_database/firebase_database.dart';

class Trending {
  String key;
  String endPoint;
  List endPointLatLng;
  String gmapsImage;
  String ratingNo;
  String ratings;
  String startPoint;
  List startPointLatLng;

  Trending(endPoint, endPointLatLng, gmapsImage, ratingNo, ratings, startPoint,
      startPointLatLng) {
    this.endPoint = endPoint;
    this.endPointLatLng = endPointLatLng;
    this.gmapsImage = gmapsImage;
    this.ratingNo = ratingNo;
    this.ratings = ratings;
    this.startPoint = startPoint;
    this.startPointLatLng = startPointLatLng;
  }

  Trending.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        endPoint = snapshot.value["endPoint"],
        endPointLatLng = snapshot.value["endPointLatLng"],
        gmapsImage = snapshot.value["gmapsImage"],
        ratingNo = snapshot.value["ratingNo"],
        ratings = snapshot.value["ratings"],
        startPoint = snapshot.value["startPoint"],
        startPointLatLng = snapshot.value["startPointLatLng"];

  toJson() {
    return {
      "endPoint": endPoint,
      "endPointLatLng": endPointLatLng,
      "gmapsImage": gmapsImage,
      "ratingNo": ratingNo,
      "ratings": ratings,
      "startPoint": startPoint,
      "startPointLatLng": startPointLatLng,
    };
  }
}
