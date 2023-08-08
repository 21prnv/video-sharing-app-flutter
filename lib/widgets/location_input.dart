import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key, required this.onAddressSelected});
  final void Function(String currentAddress) onAddressSelected;

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String? _currentAddress;
  Position? _currentPosition;
  bool _isGettingLocation = false;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }

    return true;
  }

  Future<void> _getCurrentPosition() async {
    setState(() {
      _isGettingLocation = true;
    });

    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) {
      setState(() {
        _isGettingLocation = false;
      });
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
      });

      await _getAddressFromLatLng(_currentPosition!);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        _isGettingLocation = false;
      });
    }
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    setState(() {
      _isGettingLocation = true;
    });

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress =
            '${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
      widget.onAddressSelected(_currentAddress!);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        _isGettingLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Location:'),
            Container(width: 170, child: Text('${_currentAddress ?? ""}')),
          ],
        ),
        Container(
          height: 50,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.circular(25),
          ),
          child: TextButton(
            onPressed: _getCurrentPosition,
            child: _isGettingLocation == true
                ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Text(
                    "Get Current Location",
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        )
      ],
    );
  }
}
