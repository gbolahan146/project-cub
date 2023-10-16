
import 'package:cubex/src/core/utils/endpoints.dart';
import 'package:cubex/src/data/datasources/remote/base_http.dart';
import 'package:cubex/src/data/datasources/remote/transfer/transfer_service.dart';

import 'package:dio/dio.dart';

class TransferServiceImpl extends AlsBaseHttpService
    implements TransferService {
  @override
  Future<Response> transferToCubex({required Map<String, dynamic> data}) async {
    try {
      final res = await http.post(CbEndpoints.transferCubex, data: data);

      return res;
    } on DioError catch (e) {
      throw e;
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<Response> transferToBank({required Map<String, dynamic> data}) async {
    try {
      final res = await http.post(CbEndpoints.transferAccount, data: data);
      return res;
    } on DioError catch (e) {
      throw e;
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<Response> validateAccountNumber(
      {required Map<String, dynamic> data}) async {
    try {
      final res =
          await http.post(CbEndpoints.validateAccountNumber, data: data);
      return res;
    } on DioError catch (e) {
      throw e;
    } on Exception catch (e) {
      throw e;
    }
  }
}
