import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart'; // Import the geocoding package

class LocationPickerScreen extends StatefulWidget {
  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng? _pickupLocation;
  LatLng? _dropLocation;

  List<Marker> _markers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Pickup and Drop Location'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(23.267212, 77.412970), 
          minZoom: 13.0,
          onTap: _handleMapTap,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: _markers,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (_pickupLocation != null && _dropLocation != null) {
            String pickupAddress = await _getAddressFromLatLng(_pickupLocation!);
            String dropAddress = await _getAddressFromLatLng(_dropLocation!);

            Navigator.pop(
              context,
              {'pickup': pickupAddress, 'drop': dropAddress},
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Please select both pickup and drop locations.')));
          }
        },
        label: Text('Confirm Locations'),
        icon: Icon(Icons.check),
      ),
    );
  }

  void _handleMapTap(TapPosition tapPosition, LatLng tappedPoint) {
    setState(() {
      if (_pickupLocation == null) {
        _pickupLocation = tappedPoint;
        _markers.add(
          Marker(
            point: tappedPoint,
            child: Icon(Icons.location_on, color: Colors.green, size: 40),
          ),
        );
      } else if (_dropLocation == null) {
        _dropLocation = tappedPoint;
        _markers.add(
          Marker(
            point: tappedPoint,
            child: Icon(Icons.location_on, color: Colors.red, size: 40),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Both locations already selected.')));
      }
    });
  }

  Future<String> _getAddressFromLatLng(LatLng position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    return " ${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
  }
}