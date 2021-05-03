import 'dart:convert';
import 'package:http/http.dart' as http;

/// Handles HTTP requests
class RequestManager {
  static Future<dynamic> getRequest(String url) async {
    http.Response response = await http.get(url); // get data from the URL

    try {
      if(response.statusCode == 200 ) { // if valid code returned
      String jSonData = response.body;
      var decodeData = jsonDecode(jSonData); // convert JSON data to readable format
      return decodeData; // send data back 
    }
    else {
      return "failed";
    }
    }
    catch(exp) {
      return "failed";
    }
  }
}