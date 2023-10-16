// ignore_for_file: implementation_imports

import 'dart:async';
import 'dart:io';
import 'package:cubex/src/data/datasources/remote/auth/auth_service.dart';
import 'package:cubex/src/presentation/views/authentication/verify-otp.dart';
import 'package:cubex/src/presentation/widgets/mainscreen/mainscreen.dart';
import 'package:cubex/src/core/state_registry.dart';
import 'package:cubex/src/core/utils/navigator.dart';
import 'package:flutter_riverpod/src/provider.dart';
import 'package:get/get.dart';
import 'package:cubex/src/data/models/fetch_user_response.dart';
import 'package:cubex/src/data/models/login_response.dart';
import 'package:cubex/src/data/repositories/auth/auth_http_service.dart';

import 'package:cubex/src/data/datasources/local/local_storage.dart';
import 'package:cubex/src/core/utils/helpers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthState extends ChangeNotifier {
  static AuthState? _instance;
  static late AuthService service;

  AuthState() {
    service = AuthHttpService();
  }

  static AuthState get instance {
    if (_instance == null) {
      _instance = AuthState();
    }
    return _instance!;
  }

  // GoogleSignIn _googleSignIn = GoogleSignIn(
  //   // Optional clientId
  //   // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  //   scopes: <String>[
  //     'email',
  //   ],
  // );

  bool _loginBusy = false;
  bool get loginBusy => _loginBusy;

  bool _resendBusy = false;
  bool get resendBusy => _resendBusy;

  bool _forgotPassBusy = false;
  bool get forgotPassBusy => _forgotPassBusy;

  bool _verifyBusy = false;
  bool get verifyBusy => _verifyBusy;

  bool _getUserBusy = false;
  bool get getUserBusy => _getUserBusy;

  bool _registerBusy = false;
  bool get registerBusy => _registerBusy;

  bool _changePasswrdBusy = false;
  bool get changePasswrdBusy => _changePasswrdBusy;

  bool _pinBusy = false;
  bool get pinBusy => _pinBusy;

  late LoginResponse _loginResponse;
  LoginResponse get loginResponse => _loginResponse;
  // late ForgotPasswordResponse _forgotPasswordResponse;
  // ForgotPasswordResponse get forgotPasswordResponse => _forgotPasswordResponse;

  // late VerifyEmailResponse _verifyEmailResponse;
  // VerifyEmailResponse get verifyEmailResponse => _verifyEmailResponse;

  // late ResendOtpResponse _reseondOtpResponse;
  // ResendOtpResponse get reseondOtpResponse => _reseondOtpResponse;

  late FetchUserResponse _fetchUserResponse;
  FetchUserResponse get fetchUserResponse => _fetchUserResponse;

  late FetchUserResponse _fetchRecipientUserResponse;
  FetchUserResponse get fetchRecipientUserResponse =>
      _fetchRecipientUserResponse;

  // late ChangePasswordResponse _changePasswordResponse;
  // ChangePasswordResponse get changePasswordResponse => _changePasswordResponse;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  late LoginResponse _registerResponse;
  LoginResponse get registerResponse => _registerResponse;

  Future<void> login(
      {required Map<String, dynamic> data,
      required BuildContext context}) async {
    try {
      _loginBusy = true;
      notifyListeners();

      final res = await service.login(data: data);

      if (res.statusCode == 200 || res.statusCode == 201) {
        _loginResponse = LoginResponse.fromJson(res.data);
        await LocalStorage.setItem("token", _loginResponse.data?.token);
        await LocalStorage.setItem("firstname", _loginResponse.data?.firstName);
        await fetchUser(context: context);
        navigateReplaceTo(context, MainScreen());
      }
    } on DioError catch (e) {
      showErrorToast(message: e.response!.data['message']);
    } finally {
      _loginBusy = false;
      notifyListeners();
    }
  }

  Future<void> googleSignIn({required BuildContext context}) async {
    try {
      _loginBusy = true;
      notifyListeners();
      _googleSignIn.signOut();
      var res = await _googleSignIn.signIn();

      Map<String, dynamic> data = <String, dynamic>{
        "username": res!.email,
        "password": res.id,
      };
      await login(context: context, data: data);
      // ignore: unused_catch_clause
    } on DioError catch (e) {
      showErrorToast(message: 'Failed to sign in with Google');
    } finally {
      _loginBusy = false;
      notifyListeners();
    }
  }

  Future<void> googleSignUp({required BuildContext context}) async {
    try {
      _registerBusy = true;
      notifyListeners();

      var res = await _googleSignIn.signIn();
      Map<String, dynamic> data = {
        'firstName': res!.displayName!.split(' ')[0],
        'lastName': res.displayName!.split(' ')[1],
        'email': res.email,
        'password': res.id,
      };
      register(data: data, context: context);
      // ignore: unused_catch_clause
    } on DioError catch (e) {
      showErrorToast(message: 'Failed to sign up with Google');
      // showErrorToast(message: e.response?.data["message"]);
    } finally {
      _registerBusy = false;
      notifyListeners();
    }
  }

  Future<FetchUserResponse?> fetchUser({required BuildContext context}) async {
    try {
      _getUserBusy = true;
      notifyListeners();

      final res = await service.fetchUser();

      if (res.statusCode == 200 || res.statusCode == 201) {
        _fetchUserResponse = FetchUserResponse.fromJson(res.data);
        await LocalStorage.setItem("loggedIn", true);
        context.read(walletProvider).fetchHistory(context: context);
        context
            .read(userAccountsProvider)
            .fetchUserAccounts(refresh: true, context: context);
        context.read(tradeProvider).getGiftcards(
              context: context,
              refresh: true,
            );
        context.read(tradeProvider).fetchGiftCardTransactions(
              refresh: true,
            );
        context.read(tradeProvider).getCryptos(
              context: context,
              refresh: true,
            );
        context.read(tradeProvider).fetchCrytoRate();
        context.read(tradeProvider).fetchCryptoTransactions(
              refresh: true,
            );
        context.read(userAccountsProvider).getCubexSettings();
      }

      return _fetchUserResponse;
      // ignore: unused_catch_clause
    } on SocketException catch (e) {
      showErrorToast(message: "No internet Connection");
    } on DioError catch (e) {
      showErrorToast(message: e.response!.data['message']);
      return null;
    } finally {
      _getUserBusy = false;
      notifyListeners();
    }
  }

  Future<FetchUserResponse?> fetchOnlyUser(
      {required BuildContext context}) async {
    try {
      _getUserBusy = true;
      notifyListeners();

      final res = await service.fetchUser();

      if (res.statusCode == 200 || res.statusCode == 201) {
        _fetchUserResponse = FetchUserResponse.fromJson(res.data);
      }

      return _fetchUserResponse;
      // ignore: unused_catch_clause
    } on SocketException catch (e) {
      showErrorToast(message: "No internet Connection");
    } on DioError catch (e) {
      showErrorToast(message: e.response!.data['message']);
      return null;
    } finally {
      _getUserBusy = false;
      notifyListeners();
    }
  }

  Future<FetchUserResponse?> fetchUserByUser(
      {required BuildContext context, required String username}) async {
    try {
      _getUserBusy = true;
      notifyListeners();

      final res = await service.fetchUserBy(username: username);
      if (res.statusCode == 200 || res.statusCode == 201) {
        _fetchRecipientUserResponse = FetchUserResponse.fromJson(res.data);
      }
      return _fetchRecipientUserResponse;
      // ignore: unused_catch_clause
    } on SocketException catch (e) {
      showErrorToast(message: "No internet Connection");
    } on DioError catch (e) {
      showErrorToast(message: e.response!.data['message']);
      return null;
    } finally {
      _getUserBusy = false;
      notifyListeners();
    }
  }

  Future<FetchUserResponse?> updateUser(
      {required BuildContext context,
      required Map<String, dynamic> data,
      Function()? onSuccess}) async {
    try {
      _getUserBusy = true;
      notifyListeners();

      final res = await service.updateUser(data: data);

      if (res.statusCode == 200 || res.statusCode == 201) {
        _fetchUserResponse = FetchUserResponse.fromJson(res.data);
        onSuccess?.call();
      }

      return _fetchUserResponse;
      // ignore: unused_catch_clause
    } on SocketException catch (e) {
      showErrorToast(message: "No internet Connection");
    } on DioError catch (e) {
      showErrorToast(message: e.response!.data['message']);
      return null;
    } finally {
      _getUserBusy = false;
      notifyListeners();
    }
  }

  Future<void> register(
      {required Map<String, dynamic> data,
      required BuildContext context}) async {
    try {
      _registerBusy = true;
      notifyListeners();

      final res = await service.register(data: data);

      if (res.statusCode == 200 || res.statusCode == 201) {
        _registerResponse = LoginResponse.fromJson(res.data);
        await LocalStorage.setItem("token", _registerResponse.data?.token);
        await LocalStorage.setItem(
            "firstname", _registerResponse.data?.firstName);

        showSuccessToast(message: _registerResponse.message!.capitalizeFirst);
        navigateReplaceTo(context, VerifyOtpPage());
      }
    } on DioError catch (e) {
      showErrorToast(message: e.response?.data['message']);
    } finally {
      _registerBusy = false;
      notifyListeners();
    }
  }

  Future<void> verifyEmail(
      {required String code, required BuildContext context}) async {
    try {
      _verifyBusy = true;
      notifyListeners();

      final res = await service.verifyEmail(code: code);

      if (res.statusCode == 200 || res.statusCode == 201) {
        await fetchUser(context: context);
        showSuccessToast(message: res.data['message']);
        navigateReplaceTo(context, MainScreen());
        // Future.delayed(Duration(seconds: 2), () {
        //   Navigator.pushReplacement(
        //       context, MaterialPageRoute(builder: (context) => LoginPage()));
        // });
      }
    } on DioError catch (e) {
      showErrorToast(message: e.response!.data['message']!.capitalizeFirst);
    } finally {
      _verifyBusy = false;
      notifyListeners();
    }
  }

  Future<void> resendOtp() async {
    try {
      _resendBusy = true;
      notifyListeners();

      final res = await service.resendEmailCode();

      if (res.statusCode == 200 || res.statusCode == 201) {
        showSuccessToast(message: res.data['message']!.capitalizeFirst);
      }
    } on DioError catch (e) {
      showErrorToast(message: e.response!.data['message']);
    } finally {
      _resendBusy = false;
      notifyListeners();
    }
  }

  Future<void> forgotPassword(
      {required Map<String, dynamic> data, required String email}) async {
    try {
      _forgotPassBusy = true;
      notifyListeners();

      final res = await service.forgotPassword(data: data);

      if (res.statusCode == 200 || res.statusCode == 201) {
        // _forgotPasswordResponse = ForgotPasswordResponse.fromJson(res.data);
        // showSuccessToast(message: _forgotPasswordResponse.title);
        // Future.delayed(Duration(seconds: 4), () {
        //   navigate(ForgotPasswordScreen2(email: email));
        // });
      }
    } on DioError catch (e) {
      showErrorToast(message: e.response!.data['message']);
    } finally {
      _forgotPassBusy = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword({required String code}) async {
    try {
      _forgotPassBusy = true;
      notifyListeners();

      final res = await service.resetPassword(code: code);

      if (res.statusCode == 200 || res.statusCode == 201) {
        // _forgotPasswordResponse = ForgotPasswordResponse.fromJson(res.data);
        // showSuccessToast(message: _forgotPasswordResponse.title);
        // Future.delayed(Duration(seconds: 4), () {
        //   navigate(LoginScreen());
        // });
      }
    } on DioError catch (e) {
      showErrorToast(message: e.response!.data['message']);
    } finally {
      _forgotPassBusy = false;
      notifyListeners();
    }
  }

  Future<void> changePassword(
      {required Map<String, dynamic> data,
      required BuildContext context}) async {
    try {
      _changePasswrdBusy = true;
      notifyListeners();

      final res = await service.changePassword(data: data);

      if (res.statusCode == 200 || res.statusCode == 201) {
        // _changePasswordResponse = ChangePasswordResponse.fromJson(res.data);
        // showSuccessToast(
        //     message: _changePasswordResponse.title!.capitalizeFirst);
        // Timer(Duration(seconds: 5), () {
        //   popView(context);
        // });
      }
    } on DioError catch (e) {
      showErrorToast(message: e.response!.data['message']!.capitalizeFirst);
    } finally {
      _changePasswrdBusy = false;
      notifyListeners();
    }
  }

  Future<void> setupPin({
    required Map<String, dynamic> data,
    required VoidCallback onSuccess,
    required BuildContext context,
  }) async {
    try {
      _pinBusy = true;
      notifyListeners();

      final res = await service.setupPin(data: data);
      if (res.statusCode == 200 || res.statusCode == 201) {
        await fetchUser(context: context);
        onSuccess.call();
      }
    } on DioError catch (e) {
      showErrorToast(message: e.response!.data['message']!.capitalizeFirst);
    } finally {
      _pinBusy = false;
      notifyListeners();
    }
  }

  Future<void> validatePin(
      {required Map<String, dynamic> data,
      required VoidCallback callback,
      required BuildContext context}) async {
    try {
      _pinBusy = true;
      notifyListeners();

      final res = await service.validatePin(data: data);

      if (res.statusCode == 200 || res.statusCode == 201) {
        callback.call();
        _pinBusy = false;
      }
    } on DioError catch (e) {
      _pinBusy = false;
      notifyListeners();
      showErrorToast(
          message: e.response!.data['message'].toString().contains('undefined')
              ? 'Transaction Pin not recognized,\nKindly set your transaction pin before continuing'
              : e.response!.data['message'].toString().capitalizeFirst);
    }
  }
}
