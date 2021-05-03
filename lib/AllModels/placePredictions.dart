/// Models suggestions given to user when they enter a start or end point
class PlacePredictions
{
  String secondaryText;
  String mainText;
  String placeId;

  PlacePredictions({this.secondaryText, this.mainText, this.placeId});

  PlacePredictions.fromJson(Map<String, dynamic> json)
  {
    placeId = json["place_id"];
    mainText = json["structured_formatting"]["main_text"];
    secondaryText = json["structured_formatting"]["secondary_text"];
  }
}