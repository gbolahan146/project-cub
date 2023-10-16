import 'dart:async';
import 'package:cubex/src/data/datasources/remote/auth/auth_service.dart';
import 'package:cubex/src/data/datasources/remote/transfer/transfer_service.dart';
import 'package:cubex/src/data/models/validate_account_resp.dart';
import 'package:cubex/src/data/repositories/transfer/transfer_service_impl.dart';
// ignore: implementation_imports
import 'package:cubex/src/data/repositories/auth/auth_http_service.dart';
import 'package:cubex/src/core/utils/helpers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class TransferState extends ChangeNotifier {
  static TransferState? _instance;
  static late AuthService authService;
  static late TransferService transferService;

  TransferState() {
    authService = AuthHttpService();
    transferService = TransferServiceImpl();
  }

  static TransferState get instance {
    if (_instance == null) {
      _instance = TransferState();
    }
    return _instance!;
  }

  bool _transferToBankBusy = false;
  bool get transferToBankBusy => _transferToBankBusy;

  bool _validateAccountNumberBusy = false;
  bool get validateAccountNumberBusy => _validateAccountNumberBusy;

  String? _accountName;
  String? get accountName => _accountName;
  bool _transferToCubexBusy = false;
  bool get transferToCubexBusy => _transferToCubexBusy;

  late ValidateAccountResp _validateAcctResp;
  ValidateAccountResp get validateAcctResp => _validateAcctResp;

  Future<void> validateAccountNumber({
    required Map<String, dynamic> data,
    required BuildContext context,
  }) async {
    try {
      _validateAccountNumberBusy = true;
      notifyListeners();

      final res = await transferService.validateAccountNumber(data: data);
      if (res.statusCode == 200 || res.statusCode == 201) {
        // showSuccessToast(message: res.data['message']);
        _validateAcctResp = ValidateAccountResp.fromJson(res.data);
        _accountName = _validateAcctResp.data?.accountName;
      }
      // ignore: unused_catch_clause
    } on DioError catch (e) {
      _accountName = null;
      showErrorToast(message: "Account number verification failed");
    } finally {
      _validateAccountNumberBusy = false;
      notifyListeners();
    }
  }

  Future<void> transferToCubex(
      {required Map<String, dynamic> data,
      required BuildContext context,
      Function()? onSuccess}) async {
    try {
      _transferToCubexBusy = true;
      notifyListeners();

      final res = await transferService.transferToCubex(data: data);

      if (res.statusCode == 200 || res.statusCode == 201) {
        // showSuccessToast(message: res.data['message']);
        onSuccess?.call();
      }
    } on DioError catch (e) {
      showErrorToast(message: e.response?.data['message']);
    } finally {
      _transferToCubexBusy = false;
      notifyListeners();
    }
  }

  Future<void> transferToBank(
      {required Map<String, dynamic> data,
      required BuildContext context,
      Function()? onSuccess}) async {
    try {
      _transferToBankBusy = true;
      notifyListeners();
      final res = await transferService.transferToBank(data: data);
      if (res.statusCode == 200 || res.statusCode == 201) {
        // showSuccessToast(message: res.data['message']);

        onSuccess?.call();
      }
    } on DioError catch (e) {
      showErrorToast(message: e.response?.data['message']);
    } finally {
      _transferToBankBusy = false;
      notifyListeners();
    }
  }
}
