import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_firebase/screens/listing_screen.dart';
import 'package:google_maps_firebase/screens/login_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsScreen extends StatefulWidget {
  const GoogleMapsScreen({super.key, required this.name});

  final String name;

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  Set<Marker> markers = {};

  void setMarker(LatLng position) async {
    await FirebaseFirestore.instance
        .collection('3B')
        .doc(widget.name)
        .collection('markers')
        .add({
          'position': {'lat': position.latitude, 'lng': position.longitude},
        });
    loadMarkers();
  }

  void loadMarkers() async {
    markers.clear();
    var fetchedMarkers =
        await FirebaseFirestore.instance
            .collection('3B')
            .doc(widget.name)
            .collection('markers')
            .get();
    for (var doc in fetchedMarkers.docs) {
      LatLng position = LatLng(doc['position']['lat'], doc['position']['lng']);
      Marker marker = Marker(
        markerId: MarkerId(position.toString()),
        position: position,
      );
      markers.add(marker);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed:
                () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => ListingScreen(name: widget.name),
                  ),
                ),
            icon: Icon(Icons.list),
          ),
          IconButton(
            onPressed:
                () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                ),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(15.987749, 120.573338),
          zoom: 12,
        ),
        markers: markers,
        onTap: (position) => setMarker(position),
      ),
    );
  }
}
