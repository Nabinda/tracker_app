import 'package:dio/dio.dart';

class IsolateParams {
  final String path;
  final dynamic body;
  final Dio dio;

  IsolateParams({required this.path, required this.body, required this.dio});
}
