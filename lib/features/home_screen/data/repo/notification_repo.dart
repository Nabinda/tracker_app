import 'dart:developer';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tracker_app/config/api_config.dart';
import 'package:tracker_app/core/base_client.dart';

final notificationRepo = Provider((ref) => NotificationRepo(ref: ref));

class NotificationRepo {
  final Ref ref;
  NotificationRepo({required this.ref});

  void sendNotification({required String token, required bool isOffline}) {
    log('Token: $token');
    ref.read(baseClient).post(ApiConfig.path, data: {
      'priority': 'high',
      'to': token,
      'notification': {
        'title': isOffline ? 'Tracker went Offline' : 'Tracker is Online',
        'body': isOffline
            ? 'Tracker device is disconnected'
            : 'Tracker device is broadcasting the location'
      },
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
    });
  }
}
