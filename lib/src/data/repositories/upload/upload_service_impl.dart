import 'package:cubex/src/core/utils/endpoints.dart';
import 'package:cubex/src/data/datasources/remote/base_http.dart';
import 'package:cubex/src/data/datasources/remote/upload/upload_service.dart';
import 'package:dio/dio.dart';

class UploadServiceImpl extends AlsBaseHttpService implements UploadService {
  @override
  Future<Response> uploadFile({required FormData data}) async {
    try {
      final res = await http.post(CbEndpoints.upload, data: data);
      return res;
    } on DioError catch (e) {
      throw e;
    } on Exception catch (e) {
      throw e;
    }
  }
}
