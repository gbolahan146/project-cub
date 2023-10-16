import 'dart:async';
import 'package:cubex/src/data/datasources/remote/auth/auth_service.dart';
import 'package:cubex/src/presentation/views/authentication/login.dart';
import 'package:cubex/src/presentation/views/forgotpassword/new_password.dart';
import 'package:cubex/src/presentation/views/forgotpassword/reset_password.dart';
import 'package:cubex/src/core/utils/navigator.dart';
import 'package:cubex/src/data/models/login_response.dart';
import 'package:cubex/src/data/repositories/auth/auth_http_service.dart';

import 'package:cubex/src/core/utils/helpers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ForgotPasswordState extends ChangeNotifier {
  static ForgotPasswordState? _instance;
  static late AuthService service;

  ForgotPasswordState() {
    service = AuthHttpService();
  }

  static ForgotPasswordState get instance {
    if (_instance == null) {
      _instance = ForgotPasswordState();
    }
    return _instance!;
  }

  bool _forgotPassBusy = false;
  bool get forgotPassBusy => _forgotPassBusy;

  bool _validateBusy = false;
  bool get validateBusy => _validateBusy;

  bool _changePasswrdBusy = false;
  bool get changePasswrdBusy => _changePasswrdBusy;

  late LoginResponse _loginResponse;
  LoginResponse get loginResponse => _loginResponse;

  // late FetchUserResponse _fetchUserResponse;
  // FetchUserResponse get fetchUserResponse => _fetchUserResponse;

  // // late ChangePasswordResponse _changePasswordResponse;
  // // ChangePasswordResponse get changePasswordResponse => _changePasswordResponse;

  // late LoginResponse _registerResponse;
  // LoginResponse get registerResponse => _registerResponse;

  Future<void> forgotPAssword(
      {required Map<String, dynamic> data,
      String? username,
      required BuildContext context}) async {
    try {
      _forgotPassBusy = true;
      notifyListeners();

      final res = await service.forgotPassword(data: data);

      if (res.statusCode == 200 || res.statusCode == 201) {
        showSuccessToast(message: res.data['message']);
        navigate(ResetPasswordPage(
          username: username,
        ));
      }
    } on DioError catch (e) {
      showErrorToast(message: e.response!.data['message']);
    } finally {
      _forgotPassBusy = false;
      notifyListeners();
    }
  }

  Future<void> validateResetCode(
      {String code = '',
      String? username,
      required BuildContext context}) async {
    try {
      _validateBusy = true;
      notifyListeners();
      final res = await service.resetPassword(code: code);

      if (res.statusCode == 200 || res.statusCode == 201) {
        showSuccessToast(message: res.data['message']);

        navigateReplaceTo(context, NewPasswordPage(id: res.data['data']['id']));
      }
    } on DioError catch (e) {
      showErrorToast(message: e.response!.data['message']);
    } finally {
      _validateBusy = false;
      notifyListeners();
    }
  }

  Future<void> changePAssword(
      {required Map<String, dynamic> data,
      required BuildContext context}) async {
    try {
      _changePasswrdBusy = true;
      notifyListeners();

      final res = await service.changePassword(data: data);

      if (res.statusCode == 200 || res.statusCode == 201) {
        showSuccessToast(message: res.data['message']);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return LoginPage();
        }));
      }
    } on DioError catch (e) {
      showErrorToast(message: e.response!.data['message']);
    } finally {
      _changePasswrdBusy = false;
      notifyListeners();
    }
  }
}
