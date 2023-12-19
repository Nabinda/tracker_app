# tracker_app

A new Flutter project.

## Getting Started

## Create a new project on the Firebase:
## Reminder use same firebase project for both Tracker and Tracer App
- [Firebase Project Setup Documentation](https://firebase.google.com/docs/flutter/setup?platform=ios)
- Enable Firestore Database
- Enable Cloud Messaging API from the project settings
- After that get the Server Token Key which will be used to send the notification to tracer app.

Once you get the Server Token key, Navigate to base_client.dart

Replace 
```
 options.headers["Authorization"] = "key=$cloudMessagingKey";
```
With
```
 options.headers["Authorization"] = "key=<<<Insert Your Server Token Key Here>>>";
```




We are using Open Weather API to fetch the weather of current location so for that we need to get API key.
- [Follow Guide to generate API Key](https://openweathermap.org/guide)

Once you get the API Key, Navigate to weather_bloc.dart

Replace 
```
WeatherFactory wf =
      WeatherFactory(openWeatherApiKey); //<<< Insert Your Api Key Here  >>>
```
With
```
WeatherFactory wf =
      WeatherFactory( //<<< Insert Your Api Key Here  >>>);
```