import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tracker_app/core/shared_pref_helper.dart';
import 'package:tracker_app/firebase_options.dart';
import 'package:tracker_app/keys/api_keys.dart';
import 'package:tracker_app/my_app.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (kDebugMode) {
      print('Input Type: $inputData');
    }
    final Dio dio = Dio();
    try {
      final res = await dio.request('https://fcm.googleapis.com/fcm/send',
          options: Options(
              method: 'POST',
              validateStatus: (_) => true,
              contentType: Headers.jsonContentType,
              responseType: ResponseType.json,
              headers: {
                'content-Type': 'application/json',
                'Authorization': 'key=$cloudMessagingKey'
              }),
          data: {
            'priority': 'high',
            'to': inputData?['token'],
            'notification': {
              'title': 'Tracker went Offline',
              'body': 'Tracker device is disconnected'
            },
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          });
      print('Res: $res');
      return Future.value(true);
    } catch (e) {
      print('Error:$e');
      return Future.error(e);
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefHelper.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  runApp(const ProviderScope(child: MyApp()));
}
