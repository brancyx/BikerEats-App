import 'package:firebase_database/firebase_database.dart';

final databaseReference = FirebaseDatabase.instance.reference();

void create() {
  databaseReference.child("trending").set({});
}

void createRecord() {
  databaseReference.child("trending").child("1").set({
    "gmapsImage": "images/macs.jpg",
    "startPoint": "Jurong Point",
    "startPointLatLng": [1.3397, 103.7067],
    "endPoint": "Regent Park",
    "endPointLatLng": [1.3173, 103.7615],
    "ratings": "4.9",
    "ratingNo": "Rated by 381"
  });
  databaseReference.child("trending").child("2").set({
    "gmapsImage": "images/macs.jpg",
    "startPoint": "Choa Chu Kang Park",
    "startPointLatLng": [1.3869, 103.7473],
    "endPoint": "Singapore Zoo",
    "endPointLatLng": [1.4043, 103.7930],
    "ratings": "4.8",
    "ratingNo": "Rated by 363"
  });
  databaseReference.child("trending").child("3").set({
    "gmapsImage": "images/macs.jpg",
    "startPoint": "Bukit Timah Hill",
    "startPointLatLng": [1.3548, 103.7763],
    //"checkpoint 1":
    "endPoint": "Singapore Zoo",
    "endPointLatLng": [1.4043, 103.7930],
    "ratings": "4.8",
    "ratingNo": "Rated by 323"
  });
  databaseReference.child("trending").child("4").set({
    "gmapsImage": "images/macs.jpg",
    "startPoint": "Treetop Walk",
    "startPointLatLng": [1.3595, 103.8270],
    //"checkpoint 1": "Bukit Timah Road",
    "endPoint": "Singapore Zoo",
    "endPointLatLng": [1.4043, 103.7930],
    "ratings": "4.7",
    "ratingNo": "Rated by 297"
  });
  databaseReference.child("trending").child("5").set({
    "gmapsImage": "images/macs.jpg",
    "startPoint": "Jurong Point",
    "startPointLatLng": [1.3404, 103.7090],
    //"checkpoint 1": "Bukit Timah Road",
    "endPoint": "Jurong Bird Park",
    "endPointLatLng": [1.3187, 103.7064],
    "ratings": "4.7",
    "ratingNo": "Rated by 286"
  });
  databaseReference.child("trending").child("6").set({
    "gmapsImage": "images/macs.jpg",
    "startPoint": "Admiralty Park",
    "startPointLatLng": [1.4484, 103.7790],
    //"checkpoint 1": "Bukit Timah Road",
    "endPoint": "East Coast Park",
    "endPointLatLng": [1.3008, 103.9122],
    "ratings": "4.7",
    "ratingNo": "Rated by 261"
  });
}
