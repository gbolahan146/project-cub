import 'dart:async';
import 'package:cubex/src/data/datasources/remote/auth/auth_service.dart';
import 'package:cubex/src/data/datasources/remote/wallet/wallet_service.dart';
import 'package:cubex/src/data/models/fetch_wallet_history_resp.dart';
import 'package:cubex/src/data/repositories/wallet/wallet_service_impl.dart';
// ignore: implementation_imports
import 'package:cubex/src/data/repositories/auth/auth_http_service.dart';
import 'package:cubex/src/core/utils/helpers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WalletState extends ChangeNotifier {
  static WalletState? _instance;
  static late AuthService authService;
  static late WalletService walletService;

  WalletState() {
    authService = AuthHttpService();
    walletService = WalletServiceImpl();
  }

  static WalletState get instance {
    if (_instance == null) {
      _instance = WalletState();
    }
    return _instance!;
  }

  bool _fetchWalletHistoryBusy = false;
  bool get fetchWalletHistoryBusy => _fetchWalletHistoryBusy;
  late FetchWalletHistoryResp _fetchWalletHistoryResp;
  FetchWalletHistoryResp get fetchWalletHistoryResp => _fetchWalletHistoryResp;
  RefreshController _refreshControllerHistory = RefreshController();
  RefreshController get refreshControllerHistory => _refreshControllerHistory;
  List<WalletHistoryData> _walletHistoryData = [];
  List<WalletHistoryData> get walletHistoryData => _walletHistoryData;

  Meta meta = Meta(page: 0, perPage: 10);

  Future<void> fetchHistory(
      {refresh = false,
      required BuildContext context,
      Function()? onSuccess}) async {
    try {
      _fetchWalletHistoryBusy = true;
      notifyListeners();

      final res = await walletService.fetchWalletHistory(
        page: refresh ? 1 : meta.page! + 1,
        perPage: meta.perPage!,
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        _fetchWalletHistoryResp = FetchWalletHistoryResp.fromJson(res.data);
        if (refresh) {
          _walletHistoryData = _fetchWalletHistoryResp.data ?? [];
          _refreshControllerHistory.loadComplete();
        } else {
          _walletHistoryData.addAll(_fetchWalletHistoryResp.data ?? []);
        }

        if (_fetchWalletHistoryResp.meta?.hasNextPage == false) {
          _refreshControllerHistory.loadNoData();
        } else {
          meta = _fetchWalletHistoryResp.meta!;
          _refreshControllerHistory.loadComplete();
        }
      
        onSuccess?.call();
        
      }
    } on DioError catch (e) {
      showErrorToast(message: (e.response!.data['message']??'Something happened')?.capitalizeFirst);
    } finally {
      _fetchWalletHistoryBusy = false;
      notifyListeners();
    }
  }
}
