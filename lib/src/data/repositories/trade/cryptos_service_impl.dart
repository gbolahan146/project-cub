import 'package:cubex/src/core/utils/endpoints.dart';
import 'package:cubex/src/data/datasources/remote/base_http.dart';
import 'package:cubex/src/data/datasources/remote/trade/crypto_service.dart';
import 'package:dio/dio.dart';

class CryptoServiceImpl extends AlsBaseHttpService implements CryptoService {
  @override
  Future<Response> createCryptos({required Map<String, dynamic> data}) async {
    try {
      final res = await http.post(CbEndpoints.fetchCryptos, data: data);
      return res;
    } on DioError catch (e) {
      throw e;
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<Response> createCryptoTransaction(
      {required Map<String, dynamic> data}) async {
    try {
      final res = await http.post(CbEndpoints.createCryptosTrans, data: data);
      return res;
    } on DioError catch (e) {
      throw e;
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<Response> fetchCryptoTransactions({
    int? perPage,
    int? page,
  }) async {
    try {
      // ignore: unused_local_variable
      Map queryParams = {
        'page': page,
        'perPage': perPage,
      };
      final res = await http.get(
        CbEndpoints.createCryptosTrans +
            '?' +
            queryParams.entries.map((e) => '${e.key}=${e.value}').join('&'),
      );

      return res;
    } on DioError catch (e) {
      throw e;
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<Response> fetchSingleCrypto({required String cryptoId}) async {
    try {
      final res =
          await http.get(CbEndpoints.fetchSingleCryptos + '/' + cryptoId);
      return res;
    } on DioError catch (e) {
      throw e;
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<Response> fetchCryptos({int? perPage, int? page}) async {
    Map queryParams = {
      'limit': perPage,
      'page': page,
    }..removeWhere((key, value) => value == null);
    try {
      final res = await http.get(CbEndpoints.fetchCryptos +
          '?' +
          queryParams.entries.map((e) => '${e.key}=${e.value}').join('&'));

      return res;
    } on DioError catch (e) {
      throw e;
    } on Exception catch (e) {
      throw e;
    }
  }
}
