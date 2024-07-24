import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Location App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? _latitude;
  double? _longitude;
  String? _address;
  MapboxMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
    });
    _getAddressFromLatLng();
  }

  Future<void> _getAddressFromLatLng() async {
    if (_latitude != null && _longitude != null) {
      final url = Uri.https('nominatim.openstreetmap.org', '/reverse', {
        'format': 'jsonv2',
        'lat': '$_latitude',
        'lon': '$_longitude',
      });

      final response = await http.get(url);
      final json = jsonDecode(response.body);
      setState(() {
        _address = json['display_name'];
      });
    }
  }

  void _onMapCreated(MapboxMapController controller) {
    _mapController = controller;
    if (_latitude != null && _longitude != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLng(
        LatLng(_latitude!, _longitude!),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Location App'),
      ),
      body: Center(
        child: _latitude == null || _longitude == null
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: MapboxMap(
                      accessToken: 'YOUR_MAPBOX_ACCESS_TOKEN',
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(_latitude!, _longitude!),
                        zoom: 15.0,
                      ),
                      myLocationEnabled: true,
                      myLocationTrackingMode: MyLocationTrackingMode.Tracking,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'Latitude: $_latitude',
                          style: TextStyle(fontSize: 22.0),
                        ),
                        Text(
                          'Longitude: $_longitude',
                          style: TextStyle(fontSize: 22.0),
                        ),
                        if (_address != null)
                          Text(
                            'Address: $_address',
                            style: TextStyle(fontSize: 22.0),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
