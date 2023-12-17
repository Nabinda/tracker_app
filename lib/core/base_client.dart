import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tracker_app/config/api_config.dart';
import 'package:tracker_app/keys/api_keys.dart';

final baseClient = Provider((ref) => BaseClient(ref));

class BaseClient {
  final Ref ref;
  BaseClient(this.ref) {
    _setupInterceptor();
  }

  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl,
    contentType: Headers.jsonContentType,
    receiveTimeout: const Duration(seconds: 50),
    sendTimeout: const Duration(seconds: 50),
    connectTimeout: const Duration(seconds: 50),
  ));

  _setupInterceptor() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler r) async {
        ///Your Server Cloud Messaging Key Here
        options.headers["Authorization"] = "key=$cloudMessagingKey";
        r.next(options);
      },
      onResponse: (Response response, ResponseInterceptorHandler r) async {
        r.next(response);
      },
      onError: (e, handler) {
        handler.next(e);
      },
    ));
  }

  ///Perform post request to api
  Future<dynamic> post(
    String path, {
    Object? data,
  }) async {
    try {
      final res = await _dio.post(
        path,
        data: data,
      );
      return res.data;
    } on DioException catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
