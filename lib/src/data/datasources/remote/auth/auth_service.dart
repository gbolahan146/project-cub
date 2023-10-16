import 'package:dio/dio.dart';

abstract class AuthService {
  Future<Response> login({required Map<String, dynamic> data});
  Future<Response> register({required Map<String, dynamic> data});
  Future<Response> resendEmailCode();
  Future<Response> verifyEmail({required String code});
  Future<Response> resetPassword({required String code});
  Future<Response> changePassword({required Map<String, dynamic> data});
  Future<Response> forgotPassword({required Map<String, dynamic> data});
  Future<Response> validatePin({required Map<String, dynamic> data});
  Future<Response> setupPin({required Map<String, dynamic> data});
  Future<Response> fetchUser();
  Future<Response> fetchUserBy({required String username});
  Future<Response> updateUser({required Map<String, dynamic> data});

  // Future<Response> logout();
}
