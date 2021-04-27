import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/Assistant/assistantMethods.dart';
import 'package:rider_app/DataHandler/appData.dart';
import 'package:http/http.dart' as http;
import 'package:rider_app/configMaps.dart';


class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();

}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickupTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();

  _getTokens() async {
    final response = await http.post(
        Uri.parse("https://outpost.mapmyindia.com/api/security/oauth/token"),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "accept": "application/json",
        },
        body: {
          "grant_type": "client_credentials",
          "client_id": "33OkryzDZsKr5Aswd9Pwz-jnGF9Fna3BH73WGGwLZv7w2dBOnJgn8OQ_PmYoqQvpa9Xd2JXQ4AnvTx1AumMruvH0MX1WZIT3j-Wbekfm68razut4Rmu6Cw==",
          "client_secret": "lrFxI-iSEg9_Nb6FC6xMyH8bFJUVZY-CRtpmjGVF80hxs9LE4-nwUQVchGT-jv_YkDNs08K8lEpWp4rHv2_2LeSoM_b2UOOIUnjf26CJTaDDRETKclyCSxGhxhDqZ70j"
        }
    );

    var decodeToken = jsonDecode(response.body);

    return decodeToken;
  }


  @override
  Widget build(BuildContext context) {
    String placeAddress = Provider.of<AppData>(context).pickupLocation.placeName ?? "";
    pickupTextEditingController.text = placeAddress;
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 255.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                )
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 25.0, top: 25.0, right: 25.0, bottom: 20.0),
              child: Column(
                children: [
                  SizedBox(height: 5.0,),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap:() {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back
                        ),
                      ),
                      Center(
                        child: Text("Set Drop Off", style: TextStyle(fontSize: 18.0, fontFamily: 'Brand-Bold'),),
                      )
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    children: [
                      Image.asset('images/pickicon.png', height: 16.0, width: 16.0,),

                      SizedBox(width: 18.0,),

                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              decoration: InputDecoration(
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                hintText: "PickUp Address",
                                contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                              ),
                              controller: pickupTextEditingController,
                            ),
                          )
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Image.asset('images/desticon.png', height: 16.0, width: 16.0,),

                      SizedBox(width: 18.0,),

                      Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3.0),
                              child: TextField(
                                controller: dropOffTextEditingController,
                                onChanged: (val)  async {
                                  final response = await _getTokens();

                                   await http.get(Uri.parse(
                                         ('https://atlas.mapmyindia.com/api/places/search/json?query=${dropOffTextEditingController.text}&region=IND&pod=CITY')),
                                     headers: {
                                       "accept": "application/json",
                                       "Authorization": 'Bearer ${response.access_token}'
                                   });
                                },
                                decoration: InputDecoration(
                                  fillColor: Colors.grey[400],
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  hintText: "DropOff Address",
                                  contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                                ),
                              ),
                            )
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}