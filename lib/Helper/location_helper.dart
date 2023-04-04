import 'dart:convert';
import 'package:http/http.dart' as http;

const GOOGLE_KEY_API = 'AIzaSyCO-9PLirHeO7jX5llA7ksx3MraKQSo-Wg';


class LocationHelper {
  static String  generateLocation({double? latitude, double? longitude}){
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$GOOGLE_KEY_API';
  }

// to get address of a place decode
  static Future<String> getPlaceAddress(double lat, double lng)async {
    final url =  Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyCO-9PLirHeO7jX5llA7ksx3MraKQSo-Wg');
    final response = await http.get(url);
    return json.decode(response.body)['results'][0]['formatted_address'];
   }
}