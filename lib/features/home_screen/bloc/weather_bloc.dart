import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map_math/flutter_geo_math.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location/location.dart';
import 'package:tracker_app/features/home_screen/bloc/location_bloc.dart';
import 'package:tracker_app/keys/api_keys.dart';
import 'package:weather/weather.dart';

final weatherBloc = ChangeNotifierProvider((ref) => WeatherBloc(ref: ref));

class WeatherBloc extends ChangeNotifier {
  final Ref ref;
  WeatherBloc({required this.ref}) {
    getWeatherByLocation();
  }
  WeatherFactory wf =
      WeatherFactory(openWeatherApiKey); //<<< Insert Your Api Key Here  >>>

  FlutterMapMath mapMath = FlutterMapMath();

  //Making the StreamController to update the weather as per user location data
  final StreamController<Weather> _controller = StreamController();

  ///Making Stream listenable only
  Stream<Weather> get getLocationStream => _controller.stream;

  /// Storing this so that open weather Api call gets less
  LocationData? previousLocation;

  /// Change this as per requirement to fetch the weather report as distance Travelled
  int distanceInMeters = 20;

  ///Fetch the weather location using Open Weather
  void getWeatherByLocation() {
    final userLocationStream = ref.read(locationBloc).getLocationStream;
    userLocationStream.listen((event) async {
      ///Calculating distance between 2 co-ordinates
      double distanceBetweenCoorinates = mapMath.distanceBetween(
          event.latitude ?? 0,
          event.longitude ?? 0,
          previousLocation?.latitude ?? event.latitude ?? 0,
          previousLocation?.longitude ?? event.longitude ?? 0,
          "meters");
      if (distanceBetweenCoorinates >= distanceInMeters ||
          previousLocation == null) {
        try {
          final weather = await wf.currentWeatherByLocation(
              event.latitude!, event.longitude!);
          previousLocation = event;
          _controller.sink.add(weather);
        } catch (e) {
          _controller.sink.addError(e);
        }
      }
    });
  }
}
