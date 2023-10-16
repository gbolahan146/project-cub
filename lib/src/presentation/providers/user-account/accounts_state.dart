import 'dart:async';
import 'package:cubex/src/data/datasources/remote/auth/auth_service.dart';
import 'package:cubex/src/data/datasources/remote/user-account/account_service.dart';
import 'package:cubex/src/data/models/fetch-cubex-settings.dart';
import 'package:cubex/src/data/models/fetch_user_accounts_resp.dart';
import 'package:cubex/src/data/models/fetch_wallet_history_resp.dart';
// ignore: implementation_imports
import 'package:cubex/src/data/repositories/auth/auth_http_service.dart';
import 'package:cubex/src/data/repositories/user-account/account_service_impl.dart';
import 'package:cubex/src/core/utils/helpers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserAccountState extends ChangeNotifier {
  static UserAccountState? _instance;
  static late AuthService authService;
  static late AccountService accountService;

  UserAccountState() {
    authService = AuthHttpService();
    accountService = AccountServiceImpl();
  }

  static UserAccountState get instance {
    if (_instance == null) {
      _instance = UserAccountState();
    }
    return _instance!;
  }

  bool _createAccountBusy = false;
  bool get createAccountBusy => _createAccountBusy;

  bool _fetchAccountBusy = false;
  bool get validateAccountNumberBusy => _fetchAccountBusy;

  bool _deleteAccountBusy = false;
  bool get deleteAccountBusy => _deleteAccountBusy;

  bool _fetchSettingsBusy = false;
  bool get fetchSettingsBusy => _fetchSettingsBusy;

  RefreshController _refreshControllerHistory = RefreshController();
  late FetchUserAccountsResp _fetchUserAccountsResp;
  FetchUserAccountsResp get fetchUserAccountsResp => _fetchUserAccountsResp;

  late CubexSettingsResponse _cubexSettingsResponse;
  CubexSettingsResponse get cubexSettingsResponse => _cubexSettingsResponse;

  List<UserAccountData> _userAccounts = [];
  List<UserAccountData> get userAccounts => _userAccounts;

  Meta meta = Meta(page: 0, perPage: 10);

  Future<void> fetchUserAccounts(
      {refresh = false,
      required BuildContext context,
      Function()? onSuccess}) async {
    try {
      _fetchAccountBusy = true;
      notifyListeners();

      final res = await accountService.fetchUserAccounts(
        page: refresh ? 1 : meta.page! + 1,
        perPage: meta.perPage!,
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        _fetchUserAccountsResp = FetchUserAccountsResp.fromJson(res.data);
        if (refresh) {
          _userAccounts = _fetchUserAccountsResp.data ?? [];
          _refreshControllerHistory.loadComplete();
        } else {
          _userAccounts.addAll(_fetchUserAccountsResp.data ?? []);
        }

        if (_fetchUserAccountsResp.meta?.hasNextPage == false) {
          _refreshControllerHistory.loadNoData();
        } else {
          meta = _fetchUserAccountsResp.meta!;
          _refreshControllerHistory.loadComplete();
        }
        // context.read(authProvider).fetchUser(context: context);
        onSuccess?.call();
      }
      // ignore: unused_catch_clause
    } on DioError catch (e) {
      showErrorToast(message: e.response?.data['message']);
    } finally {
      _fetchAccountBusy = false;
      notifyListeners();
    }
  }

  Future<void> createUserAccount(
      {required Map<String, dynamic> data,
      required BuildContext context,
      Function()? onSuccess}) async {
    try {
      _createAccountBusy = true;
      notifyListeners();

      final res = await accountService.createUserAccount(data: data);

      if (res.statusCode == 200 || res.statusCode == 201) {
        // showSuccessToast(message: res.data['message']);
        fetchUserAccounts(context: context, refresh: true);
        onSuccess?.call();
      }
    } on DioError catch (e) {
      showErrorToast(message: e.response?.data['message']);
    } finally {
      _createAccountBusy = false;
      notifyListeners();
    }
  }

  Future<void> deleteUserAccount(
      {required String id,
      required BuildContext context,
      Function()? onSuccess}) async {
    try {
      _deleteAccountBusy = true;
      notifyListeners();
      final res = await accountService.deleteUserAccounts(id: id);
      if (res.statusCode == 200 || res.statusCode == 201) {
        showSuccessToast(message: res.data['message']);

        onSuccess?.call();
      }
    } on DioError catch (e) {
      showErrorToast(message: e.response?.data['message']);
    } finally {
      _deleteAccountBusy = false;
      notifyListeners();
    }
  }

  Future<void> getCubexSettings() async {
    try {
      _fetchSettingsBusy = true;
      notifyListeners();
      final res = await accountService.getCubexSettings();
      if (res.statusCode == 200 || res.statusCode == 201) {
        _cubexSettingsResponse = CubexSettingsResponse.fromJson(res.data);
      }
    } on DioError catch (e) {
      showErrorToast(message: e.response?.data['message']);
    } finally {
      _fetchSettingsBusy = false;
      notifyListeners();
    }
  }
}
