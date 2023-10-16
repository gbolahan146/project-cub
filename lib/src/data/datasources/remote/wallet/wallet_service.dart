

import 'package:dio/dio.dart';

abstract class WalletService {
  Future<Response> fetchWalletHistory({int? perPage, int? page});
 
}
