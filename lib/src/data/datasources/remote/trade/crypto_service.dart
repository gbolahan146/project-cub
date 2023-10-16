import 'package:dio/dio.dart';

abstract class CryptoService {
  Future<Response> createCryptoTransaction(
      {required Map<String, dynamic> data});
  Future<Response> fetchCryptoTransactions({
    int? perPage,
    int? page,
  });
  Future<Response> createCryptos({required Map<String, dynamic> data});
  Future<Response> fetchCryptos({int? perPage, int? page});
  Future<Response> fetchSingleCrypto({required String cryptoId});
}
