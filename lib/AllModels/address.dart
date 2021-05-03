/// Models an address called [placeName], at [latitude]
/// and [longitude]. [placeId] is an identifier for Google API to obtain location details,
/// [placeFormattedAddress] is a formatted address from Google API
class Address
{
  String placeFormattedAddress;
  String placeName;
  String placeId;
  double latitude;
  double longitude;
}