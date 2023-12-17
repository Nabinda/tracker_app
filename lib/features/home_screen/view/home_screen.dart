import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tracker_app/features/home_screen/bloc/notification_bloc.dart';
import 'package:tracker_app/features/home_screen/bloc/weather_bloc.dart';
import 'package:tracker_app/features/home_screen/view/widget/weather_text.dart';
import 'package:weather/weather.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  sendActiveNotification() async {
    ref.read(notificationBloc).getFirebaseData().then((value) {
      ref.read(notificationBloc).sendNotification(isOffline: false);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    sendActiveNotification();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    //When App is terminated
    if (state == AppLifecycleState.detached) {
      ref.read(notificationBloc).sendNotification(isOffline: true);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weatherStream = ref.read(weatherBloc).getLocationStream;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracker App'),
      ),
      body: StreamBuilder<Weather>(
          stream: weatherStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.hasData) {
              final weatherData = snapshot.data;
              if (weatherData != null) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WeatherText(text: 'Location: ${weatherData.areaName}'),
                    WeatherText(
                        text:
                            'Current Temperature: ${weatherData.tempFeelsLike}'),
                    WeatherText(
                        text: 'Weather: ${weatherData.weatherDescription}'),
                    WeatherText(text: 'Wind Speed: ${weatherData.windSpeed}'),
                  ],
                );
              } else {
                return const Center(
                  child: Text('Location is Null'),
                );
              }
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
