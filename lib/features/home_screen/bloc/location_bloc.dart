import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location/location.dart';

final locationBloc = ChangeNotifierProvider((ref) => LocationBloc());

class LocationBloc extends ChangeNotifier {
  LocationBloc() {
    getUserLocation();
  }
  Location location = Location();

  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;

  //Making the StreamController to update the user location data
  final StreamController<LocationData> _controller = StreamController();

  ///Making Stream listenable only
  Stream<LocationData> get getLocationStream => _controller.stream;

//Check if service and permission both is enable to run the location service
  Future<bool> checkIfAllPermissionGranted() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        _controller.sink
            .addError('Location Service is Required for app functionality');
        return false;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        _controller.sink
            .addError('Location Permission is Required for app functionality');
        return false;
      }
    }
    return true;
  }

//Get Location
  Future<void> getUserLocation() async {
    if (await checkIfAllPermissionGranted()) {
      //Stream the location
      location.onLocationChanged.handleError((onError) {
        //Handle Errors Here
      }).listen((locationData) {
        _controller.sink.add(locationData);
      });
      //Run the location in background mode if not enabled
      if (!(await location.isBackgroundModeEnabled())) {
        ///Show dialog the permission is required all the time to run in background mode
        await location.enableBackgroundMode();
      }
    }
  }
}
