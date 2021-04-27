import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/Assistant/requestAssistant.dart';
import 'package:rider_app/DataHandler/appData.dart';
import 'package:rider_app/Models/address.dart';
import 'package:rider_app/configMaps.dart';
import 'package:http/http.dart' as http;


class AssistantMethods {
  static Future<String> searchCoordinateAddress(Position position, context) async {
    String placeAddress = "";
    var url = Uri.parse("https://apis.mapmyindia.com/advancedmaps/v1/hxb6nqtvi43wfjj1m8m4vszn3bl9ma1g/rev_geocode?lat=${position.latitude}&lng=${position.longitude}");

    var response = await http.get(url);

    try {
      if (response.statusCode == 200) {
        String jsonData = response.body;
        var decodedData = jsonDecode(jsonData);

        if (decodedData != "Failed, No Response") {
          print(response);
          placeAddress = decodedData["results"][0]["formatted_address"];

          Address userPickupAddress = new Address();

          userPickupAddress.longitude = position.longitude;
          userPickupAddress.latitude = position.latitude;

          userPickupAddress.placeName = placeAddress;

          Provider.of<AppData>(context, listen: false).updatePickUpLocationAddress(userPickupAddress);
        }
        return decodedData;

      } else {
        print("Failed, No Response");
      }
    } catch (err) {
      print("An exception will ocuured¬");
    }


    return placeAddress;
  }

  static void findPlace(String placeName) async {
    var response = await http.post(
      Uri.parse("https://outpost.mapmyindia.com/api/security/oauth/token"),
      headers: {
        'Content-Type': "application/x-www-form-url-encoded"
      },
      body: {
        "grant_type": "client_credentials",
        "client_id": client_Id,
        "client_secret": client_secret
      }
    );

    if (response.statusCode == 200) {
      var searchResponse = await http.get(Uri.parse("https://atlas.mapmyindia.com/api/places/search/json?query=$placeName&region=IND&pod=CITY"));

      print(searchResponse);
    }

  }
}

// {"responseCode":200,"version":"261.191","results":[{"houseNumber":"","houseName":"","poi":"","poi_dist":"","street":"Ghosh Para Road","street_dist":"9","subSubLocality":"","subLocality":"","locality":"Ichapur Bidhanpally","village":"","district":"North Twenty Four Parganas District","subDistrict":"Barrackpur 1","city":"Ichhapur Defence Estate Civil Township","state":"West Bengal","pincode":"743144","lat":"22.809070","lng":"88.372120","area":"India","formatted_address":"Ghosh Para Road, Ichapur Bidhanpally, Ichhapur Defence Estate Civil Township, West Bengal pin-743144 (India)"}]}