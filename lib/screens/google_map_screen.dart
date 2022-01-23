import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../globals.dart';

class MyMapView extends StatefulWidget {
 String location="0,0";
 double cur_lat=0;
 double cur_lon=0;
  MyMapView(String location,double cur_lat,double cur_lon){
    this.location=location;
    this.cur_lat=cur_lat;
    this.cur_lon=cur_lon;
  }

  @override
  _MapViewState createState() => _MapViewState(location,cur_lat,cur_lon);
}

class _MapViewState extends State<MyMapView> {
  double cur_lat=32.7768;
   double cur_lon=35.0231;
   double dest_lat=0;
   double dest_lon=0;
   final startAddressController = TextEditingController();
   final destinationAddressController = TextEditingController();
   String _currentAddress="";
   //String _startAddress="";
   String _destinationAddress="";
   Set<Marker> markers = {};

  _MapViewState(String location,double cur_lat,double cur_lon){
    this.cur_lat=cur_lat;
    this.cur_lon=cur_lon;
    this.dest_lat=double.parse(location.split(",")[0]);
    this.dest_lon=double.parse(location.split(",")[1]);
  }
  @override
  void initState() {
    super.initState();
    //_getCurrentLocation();
    _getAddress();
    _getDestAddress();
    //_prepareCordinates();
  }
  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        // Store the position in the variables
        cur_lat = position.latitude;
        cur_lon=position.longitude;
        //print('CURRENT POS: $cur_lat,$cur_lon');
      });
      //await _getAddress();
    }).catchError((e) {
      //print(e);
    });
  }
  _getAddress() async {
    try {
      // Places are retrieved using the coordinates
      List<Placemark> p = await placemarkFromCoordinates(
          cur_lat, cur_lon);

      // Taking the most probable result
      Placemark place = p[0];

      setState(() {

        // Structuring the address
         _currentAddress = "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";

        // Update the text of the TextField
        startAddressController.text = _currentAddress;

        // Setting the user's present location as the starting address
        //_startAddress = _currentAddress;
      });
    } catch (e) {
      //print(e);
    }
  }
  _getDestAddress() async {
    try {
      // Places are retrieved using the coordinates
      List<Placemark> p = await placemarkFromCoordinates(
          dest_lat, dest_lon);

      // Taking the most probable result
      Placemark place = p[0];
      setState(() {
        // Structuring the address
        _destinationAddress = "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";

        // Update the text of the TextField
        destinationAddressController.text = _destinationAddress;

      });
    } catch (e) {
      //print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determining the screen width & height
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    //print("********location in map build$dest_lat,$dest_lon");
    CameraPosition _initialLocation = CameraPosition(target: LatLng(double.parse(dest_lat.toString()),double.parse(dest_lon.toString())));
    late GoogleMapController mapController;
    String startCoordinatesString = '($cur_lat, $cur_lon)';
    String destinationCoordinatesString = '($dest_lat, $dest_lon)';

// Start Location Marker
    Marker startMarker = Marker(
      markerId: MarkerId(startCoordinatesString),
      position: LatLng(cur_lat, cur_lon),
      infoWindow: InfoWindow(
        title: 'Start $startCoordinatesString',
        snippet: _currentAddress,
      ),
      icon: BitmapDescriptor.defaultMarker,
    );

// Destination Location Marker
    Marker destinationMarker = Marker(
      markerId: MarkerId(destinationCoordinatesString),
      position: LatLng(dest_lat, dest_lon),
      infoWindow: InfoWindow(
        title: 'Destination $destinationCoordinatesString',
        snippet: _destinationAddress,
      ),
      icon: BitmapDescriptor.defaultMarker,
    );
    markers.add(startMarker);
    markers.add(destinationMarker);
    Widget _textField({
      required TextEditingController controller,
      required String label,
      required String hint,
      required double width,
      Widget? suffixIcon,
    }) {
      return Container(
        width: width * 0.8,
        child: TextField(
          controller: controller,
          decoration: new InputDecoration(
            suffixIcon: suffixIcon,
            labelText: label,
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              borderSide: BorderSide(
                color: Colors.grey.shade400,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              borderSide: BorderSide(
                color: Colors.blue.shade300,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.all(15),
            hintText: hint,
          ),
        ),
      );
    }
    return Container(
      height: height,
      width: width,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              markers: Set<Marker>.from(markers),
              initialCameraPosition: _initialLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
                double miny = (cur_lat <= dest_lat)
                    ? cur_lat
                    : dest_lat;
                double minx = (cur_lon <= dest_lon)
                    ? cur_lon
                    : dest_lon;
                double maxy = (cur_lat <= dest_lat)
                    ? dest_lat
                    : cur_lat;
                double maxx = (cur_lon <= dest_lon)
                    ? dest_lon
                    : cur_lon;

                double southWestLatitude = miny;
                double southWestLongitude = minx;

                double northEastLatitude = maxy;
                double northEastLongitude = maxx;

                // For moving the camera to destination location
                mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(dest_lat, dest_lon),
                      zoom: 18.0,
                    ),
                  ),
                );
                // Zoom In action
                mapController.animateCamera(
                  CameraUpdate.zoomIn(),
                );

                // Zoom Out action
                mapController.animateCamera(
                  CameraUpdate.zoomOut(),
                );
                mapController.animateCamera(
                  CameraUpdate.newLatLngBounds(
                    LatLngBounds(
                      northeast: LatLng(northEastLatitude, northEastLongitude),
                      southwest: LatLng(southWestLatitude, southWestLongitude),
                    ),
                    100.0,
                  ),
                );



              },
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    width: width * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[

                          SizedBox(height: 10),
                          _textField(
                              label: 'Start',
                              hint: 'Choose starting point',
                              controller: startAddressController,
                              width: width,
                             ),
                          SizedBox(height: 10),
                          _textField(
                              label: 'Destination',
                              hint: 'Choose destination',
                              controller: destinationAddressController,
                              //focusNode: destinationAddressFocusNode,
                              width: width,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

