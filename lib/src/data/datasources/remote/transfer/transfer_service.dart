

import 'package:dio/dio.dart';

abstract class TransferService {
  Future<Response> transferToCubex({required Map<String, dynamic> data});
  Future<Response> transferToBank({required Map<String, dynamic> data});
  Future<Response> validateAccountNumber({required Map<String, dynamic> data});
 
  // Future<Response> logout();
}
