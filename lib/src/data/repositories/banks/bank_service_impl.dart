
import 'package:cubex/src/core/utils/endpoints.dart';
import 'package:cubex/src/data/datasources/remote/banks/bank_service.dart';
import 'package:cubex/src/data/datasources/remote/base_http.dart';
import 'package:dio/dio.dart';

class AccountsServiceImpl extends AlsBaseHttpService
    implements AccountsService {
  @override
  Future<Response> getCountries() async {
    try {
      final res = await http.get(CbEndpoints.fetchCountries);
      return res;
    } on DioError catch (e) {
      throw e;
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<Response> getBanks() async {
    try {
      final res = await http.get(CbEndpoints.fetchBanks);
      return res;
    } on DioError catch (e) {
      throw e;
    } on Exception catch (e) {
      throw e;
    }
  }
}
