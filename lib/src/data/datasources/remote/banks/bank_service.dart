import 'package:dio/dio.dart';

abstract class AccountsService {
  Future<Response> getBanks();
  Future<Response> getCountries();

}
