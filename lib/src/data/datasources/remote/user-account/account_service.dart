

import 'package:dio/dio.dart';

abstract class AccountService {
  Future<Response> fetchUserAccounts({int? perPage, int? page});
  Future<Response> createUserAccount({required Map<String, dynamic> data});
  Future<Response> deleteUserAccounts({required String id});
  Future<Response> getCubexSettings();
 
  // Future<Response> logout();
}
