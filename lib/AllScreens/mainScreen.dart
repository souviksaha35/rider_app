import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/AllScreens/Divider.dart';
import 'package:rider_app/Assistant/assistantMethods.dart';
import 'package:rider_app/Assistant/requestAssistant.dart';
import 'package:rider_app/DataHandler/appData.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();

}

class _MainScreenState extends State<MainScreen> {
  Completer<GoogleMapController> _controller = Completer();

  GoogleMapController newGoogleMapController;

  Position currentPosition;

  double bottomPaddingRight = 0;


  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latlngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = new CameraPosition(target: latlngPosition, zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address = await AssistantMethods.searchCoordinateAddress(position, context);
    print("This is your Address :: " + address);


  }
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingRight),
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              newGoogleMapController = controller;
              locatePosition();

              setState(() {
                bottomPaddingRight = 300.0;
              });
            },
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              height: 300.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 16.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 24.0),
                child: Column(
                  children: [
                    SizedBox(height: 6.0),
                    Text("Hi there", style: TextStyle(fontSize: 12.0),),
                    Text("Where, to?", style: TextStyle(fontSize: 20.0, fontFamily: "Brand-Bold"),),
                    SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/search');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 6.0,
                              spreadRadius: 0.5,
                              offset: Offset(0.7, 0.7),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: Colors.blueAccent,),
                              SizedBox(width: 10.0),
                              Text("Search Drop Off"),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 24.0,),
                    Row(
                      children: [
                        Icon(Icons.home, color: Colors.grey),
                        SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Provider.of<AppData>(context).pickupLocation != null ? Provider.of<AppData>(context).pickupLocation.placeName : "Add Home"
                              ),
                              SizedBox(height: 4.0),
                              Text("Your living home address", style: TextStyle(fontSize: 12.0, color: Colors.black54),)
                            ],
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: 10.0),

                    // DividerWidget(),
                    //
                    // SizedBox(height: 16.0,),
                    // Row(
                    //   children: [
                    //     Icon(Icons.home, color: Colors.grey),
                    //     SizedBox(width: 12.0),
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text("Add Work"),
                    //         SizedBox(height: 4.0),
                    //         Text("Your office address", style: TextStyle(fontSize: 12.0, color: Colors.black54)),
                    //       ],
                    //     )
                    //   ],
                    // )
                  ],
                ),
              )
            ),
          )
        ],
      )
    );
  }
}