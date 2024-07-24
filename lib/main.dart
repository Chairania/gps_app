import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Flutter Map Example')),
        body: FlutterMap(
          options: MapOptions(
            minZoom: 5.0,
            maxZoom: 13.0,
            onTap: (tapPosition, point) {
              print("Tapped point: $point");
            },
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            const MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(-6.376853, 106.855381),
                  width: 80.0,
                  height: 80.0,
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}