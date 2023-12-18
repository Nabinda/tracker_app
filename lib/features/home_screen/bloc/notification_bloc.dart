import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tracker_app/constants/firestore_constants.dart';
import 'package:tracker_app/features/home_screen/data/model/firebase_lat_long_model.dart';
import 'package:tracker_app/features/home_screen/data/repo/notification_repo.dart';

final notificationBloc =
    ChangeNotifierProvider((ref) => NotificationBloc(ref: ref));

class NotificationBloc extends ChangeNotifier {
  final Ref ref;
  NotificationBloc({required this.ref});
  final firestore = FirebaseFirestore.instance;

  FirebaseLatLongModel? data;

  ///Fetch the tracer device token key to send the notification
  Future<void> getFirebaseData() async {
    await firestore
        .collection(FirebaseConstants.locationCollection)
        .doc(FirebaseConstants.locationDocument)
        .withConverter(
            fromFirestore: (snapshot, _) =>
                FirebaseLatLongModel.fromJson(snapshot.data()!),
            toFirestore: (data, _) => data.toJson())
        .get()
        .then((value) {
      if (data?.tracerToken != value.data()?.tracerToken) {
        //Update previous token
        data = value.data();
      }
    }).onError((error, stackTrace) {
      debugPrint('Error: $error, Stack Trace : $stackTrace');
    });
  }

  ///Send notification using google cloud console
  Future<void> sendNotification({required bool isOffline}) async {
    if (data?.tracerToken != null && (data?.tracerToken?.isNotEmpty ?? false)) {
      ref.read(notificationRepo).sendNotification(
          token: data?.tracerToken ?? '', isOffline: isOffline);
    }
  }
}
