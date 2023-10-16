import 'package:cubex/src/core/utils/endpoints.dart';
import 'package:cubex/src/data/datasources/remote/base_http.dart';
import 'package:cubex/src/data/datasources/remote/user-account/account_service.dart';

import 'package:dio/dio.dart';

class AccountServiceImpl extends AlsBaseHttpService implements AccountService {
  @override
  Future<Response> createUserAccount(
      {required Map<String, dynamic> data}) async {
    try {
      final res = await http.post(CbEndpoints.createUserAccounts, data: data);

      return res;
    } on DioError catch (e) {
      throw e;
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<Response> deleteUserAccounts({required String id}) async {
    try {
      final res = await http.delete(CbEndpoints.fetchUserAccounts + "/$id");
      return res;
    } on DioError catch (e) {
      throw e;
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<Response> fetchUserAccounts({int? perPage, int? page}) async {
    try {
      final res = await http
          .get(CbEndpoints.fetchUserAccounts + '?perPage=$perPage&page=$page');
      return res;
    } on DioError catch (e) {
      throw e;
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<Response> getCubexSettings() async {
    try {
      final res = await http.get(CbEndpoints.fetchSettings);
      return res;
    } on DioError catch (e) {
      throw e;
    } on Exception catch (e) {
      throw e;
    }
  }
}
