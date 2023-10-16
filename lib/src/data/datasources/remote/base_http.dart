import 'package:cubex/main.dart';
import 'package:cubex/src/data/datasources/local/local_storage.dart';
import 'package:cubex/src/core/utils/endpoints.dart';
import 'package:cubex/src/core/utils/helpers.dart';
import 'package:dio/dio.dart';

class AlsTransformer extends DefaultTransformer {
  AlsTransformer() : super(jsonDecodeCallback: parseJson);
}

class AlsBaseHttpService {
  late Dio http;

  AlsBaseHttpService() {
    http = Dio(BaseOptions(
        baseUrl: CbEndpoints.baseUrl,
        connectTimeout: 30 * 1000,
        receiveTimeout: 30 * 1000,
        sendTimeout: 30 * 1000,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        }))
      ..interceptors.add(InterceptorsWrapper(onRequest: (opts, handler) async {
        String? token = await LocalStorage.getItem("token");
        opts.headers.addAll({'Authorization': "Bearer $token"});

        return handler.next(opts);
      }, onError: (err, handler) {
        logger.e(err.response?.data.toString());
        return handler.next(err);
      }, onResponse: (response, handler) {
        // logger.d({"url": response.requestOptions.path, "data": response.data});
        return handler.next(response);
      }));
  }
}
