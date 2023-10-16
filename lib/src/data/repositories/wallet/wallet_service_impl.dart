
import 'package:cubex/src/core/utils/endpoints.dart';
import 'package:cubex/src/data/datasources/remote/base_http.dart';
import 'package:cubex/src/data/datasources/remote/wallet/wallet_service.dart';

import 'package:dio/dio.dart';

class WalletServiceImpl extends AlsBaseHttpService implements WalletService {
  @override
  Future<Response> fetchWalletHistory({int? perPage, int? page}) async {
    try {
      final res = await http
          .get(CbEndpoints.fetchWalletHistory + '?perPage=$perPage&page=$page');
      return res;
    } on DioError catch (e) {
      throw e;
    } on Exception catch (e) {
      throw e;
    }
  }
}
