import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tracker_app/constants/firestore_constants.dart';
import 'package:tracker_app/features/home_screen/data/model/firebase_lat_long_model.dart';

final firebaseBloc = ChangeNotifierProvider((ref) => FirebaseBloc(ref: ref));

class FirebaseBloc extends ChangeNotifier {
  final Ref ref;
  FirebaseBloc({required this.ref});
  final firestore = FirebaseFirestore.instance;

  bool isLoading = false;

  ///Update the location of user to firebase
  Future<void> updateLocationToDataBase(
      {required double? lat, required double? long}) async {
    if (!isLoading) {
      isLoading = true;
      firestore
          .collection(FirebaseConstants.locationCollection)
          .doc(FirebaseConstants.locationDocument)
          .set(FirebaseLatLongModel(lastLat: lat, lastLong: long).toJson())
          .then((value) {
        isLoading = false;
      }).onError((error, stackTrace) {
        isLoading = false;
        debugPrint('Error: $error, Stack Trace : $stackTrace');
      });
    }
  }
}
