import 'package:dio/dio.dart';

abstract class UploadService {
   Future<Response> uploadFile({required FormData data});

  // Future<Response> logout();
}
