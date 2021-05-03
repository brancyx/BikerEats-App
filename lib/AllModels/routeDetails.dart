/// Models the details of a route where [distanceValue] is the integer length of the route in meters,
/// and [distanceText] is the String equivalent. [durationValue] is the integer time taken to complete
/// the route in minutes and [durationText] is the String equivalent. [encodedPoints] are the points
/// used to plot the cycling route on the map.
class RouteDetails
{
  int distanceValue;
  int durationValue;
  String distanceText;
  String durationText;
  String encodedPoints;

  RouteDetails({this.distanceValue, this.durationValue, this.distanceText, this.durationText, this.encodedPoints});
}