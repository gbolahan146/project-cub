import 'package:cubex/src/core/utils/helpers.dart';
import 'package:cubex/src/data/datasources/remote/trade/crypto_service.dart';
import 'package:cubex/src/data/datasources/remote/trade/giftcard_service.dart';
import 'package:cubex/src/data/models/fetch_cards_trans.dart';
import 'package:cubex/src/data/models/fetch_crypto_rate.dart';
import 'package:cubex/src/data/models/fetch_crypto_trans.dart';
import 'package:cubex/src/data/models/fetch_cryptos.dart';
import 'package:cubex/src/data/models/fetch_giftcard.dart';
import 'package:cubex/src/data/models/fetch_wallet_history_resp.dart';
import 'package:cubex/src/data/repositories/trade/cryptos_service_impl.dart';
import 'package:cubex/src/data/repositories/trade/giftcard_service_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TradeState extends ChangeNotifier {
  static TradeState? _instance;
  static late GiftCardService giftCardService;
  static late CryptoService cryptoService;
  Meta giftCardsmeta = Meta(page: 1, perPage: 10);
  Meta giftCardsTransMeta = Meta(page: 1, perPage: 10);
  Meta cryptoMeta = Meta(page: 1, perPage: 10);
  Meta cryptoTransMeta = Meta(page: 1, perPage: 10);

  TradeState() {
    giftCardService = GiftCardServiceImpl();
    cryptoService = CryptoServiceImpl();
  }

  static TradeState get instance {
    if (_instance == null) {
      _instance = TradeState();
    }
    return _instance!;
  }

  bool _getGiftCardBusy = false;
  bool get getGiftCardBusy => _getGiftCardBusy;

  bool _createCardTransBusy = false;
  bool get createCardTransBusy => _createCardTransBusy;

  bool _getCryptoBusy = false;
  bool get getCryptoBusy => _getCryptoBusy;

  bool _createCryptoTransBusy = false;
  bool get createCryptoTransBusy => _createCryptoTransBusy;

  late FetchGiftCardsResp _getGiftCardResp;
  FetchGiftCardsResp get getGiftCardResp => _getGiftCardResp;

  late FetchSingleGiftCardResp _getSingleGiftCardResp;
  FetchSingleGiftCardResp get getSingleGiftCardResp => _getSingleGiftCardResp;

  late FetchCardTransResp _getCardTransResp;
  FetchCardTransResp get getCardTransResp => _getCardTransResp;
  GiftCardsData? selectedGiftCard;
  Categories? selectedCategory;

  List<GiftCardsData> _giftCardData = [];
  List<GiftCardsData> get giftCardData => _giftCardData;

  List<GiftTransData> _giftCardTransData = [];
  List<GiftTransData> get giftCardTransData => _giftCardTransData;
  num totalCardTraded = 0;
  num totalCryptoTraded = 0;

  RefreshController cardRefreshController = RefreshController();
  RefreshController cardRefreshTransController = RefreshController();

//crypto variables
  late FetchCryptoRate _getCryptoRate;
  FetchCryptoRate? get getCryptoRate => _getCryptoRate;

  late FetchCryptosResp _getCryptoResp;
  FetchCryptosResp get getCryptoResp => _getCryptoResp;

  late FetchSingleCryptoResp _getSingleCryptoResp;
  FetchSingleCryptoResp get getSingleCryptoResp => _getSingleCryptoResp;

  late FetchCryptoTransResp _getCryptoTransResp;
  FetchCryptoTransResp get getCryptoTransResp => _getCryptoTransResp;

  CryptosData? selectedCrypto;
  Networks? selectedCryptoNetwork;

  List<CryptosData> _cryptoData = [];
  List<CryptosData> get cryptoData => _cryptoData;

  List<CryptoTransData> _cryptoTransData = [];
  List<CryptoTransData> get cryptoTransData => _cryptoTransData;

  RefreshController cryptoRefreshController = RefreshController();
  RefreshController cryptoRefreshTransController = RefreshController();

  Future<void> getGiftcards({
    refresh = false,
    required BuildContext context,
  }) async {
    try {
      _getGiftCardBusy = true;
      final res = await giftCardService.fetchGiftCards(
        category: null,
        country: null,
        type: null,
        page: refresh ? 1 : giftCardsmeta.page! + 1,
        perPage: 0,
        // perPage: giftCardsmeta.perPage!,
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        _getGiftCardResp = FetchGiftCardsResp.fromJson(res.data);
        if (refresh) {
          _giftCardData = _getGiftCardResp.data ?? [];
          cardRefreshController.loadComplete();
        } else {
          _giftCardData.addAll(_getGiftCardResp.data ?? []);
        }
        if (_getGiftCardResp.meta?.hasNextPage == false) {
          cardRefreshController.loadNoData();
        } else {
          giftCardsmeta = _getGiftCardResp.meta ??
              Meta(
                  page: _getGiftCardResp.meta?.page ?? 1,
                  perPage: _getGiftCardResp.meta?.perPage ?? 0);
          cardRefreshController.loadComplete();
        }
      }
      return null;
    } on DioError catch (e) {
      showErrorToast(message: e.response?.data['message']);
      return null;
    } finally {
      _getGiftCardBusy = false;
      notifyListeners();
    }
  }

  Future<GiftCardsData?> fetchSingleGiftcard({
    refresh = false,
    required String id,
  }) async {
    try {
      _getGiftCardBusy = true;
      final res = await giftCardService.fetchSingleGiftCard(cardId: id);
      if (res.statusCode == 200 || res.statusCode == 201) {
        _getSingleGiftCardResp = FetchSingleGiftCardResp.fromJson(res.data);
        return _getSingleGiftCardResp.data;
      }
      return null;
    } on DioError catch (e) {
      showErrorToast(message: e.response?.data['message']);
      return null;
    } finally {
      _getGiftCardBusy = false;
      notifyListeners();
    }
  }

  Future<Rate?> fetchCrytoRate() async {
    try {
      _getGiftCardBusy = true;
      final res = await giftCardService.fetchCryptoRates();
      if (res.statusCode == 200 || res.statusCode == 201) {
        _getCryptoRate = FetchCryptoRate.fromJson(res.data);
        return _getCryptoRate.data;
      }
      return null;
    } on DioError catch (e) {
      showErrorToast(message: e.response?.data['message']);
      return null;
    } finally {
      _getGiftCardBusy = false;
      notifyListeners();
    }
  }

  Future createGiftCardTransaction(
      {required Map<String, dynamic> data, Function()? onSuccess}) async {
    _createCardTransBusy = true;
    notifyListeners();
    try {
      final res = await giftCardService.createCardTransaction(data: data);
      if (res.statusCode == 200 || res.statusCode == 201) {
        onSuccess?.call();
      }
    } on DioError catch (e) {
      showErrorToast(message: e.response?.data['message']);
    } finally {
      _createCardTransBusy = false;
      notifyListeners();
    }
  }

  Future fetchGiftCardTransactions({
    refresh = false,
  }) async {
    _createCardTransBusy = true;
    notifyListeners();
    try {
      final res = await giftCardService.fetchCardTransactions(
        page: refresh ? 1 : giftCardsTransMeta.page! + 1,
        perPage: giftCardsTransMeta.perPage!,
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        _getCardTransResp = FetchCardTransResp.fromJson(res.data);
        if (refresh) {
          _giftCardTransData = _getCardTransResp.data ?? [];
          cardRefreshTransController.loadComplete();
        } else {
          _giftCardTransData.addAll(_getCardTransResp.data ?? []);
        }

        if (_getCardTransResp.meta?.hasNextPage == false) {
          cardRefreshTransController.loadNoData();
        } else {
          giftCardsTransMeta = _getCardTransResp.meta ??
              Meta(
                  page: _getCardTransResp.meta?.page ?? 1,
                  perPage: _getCardTransResp.meta?.perPage ?? 0);
          cardRefreshTransController.loadComplete();
        }
        for (GiftTransData e in _giftCardTransData) {
          if (e.status!.toLowerCase().contains('success')) {
            totalCardTraded += e.amount ?? 0;
          }
        }
      }
    // ignore: unused_catch_clause
    } on DioError catch (e) {
      // showErrorToast(message: e.response?.data['message']);
    } finally {
      _createCardTransBusy = false;
      notifyListeners();
    }
  }

  //crypto

  Future<void> getCryptos({
    refresh = false,
    required BuildContext context,
  }) async {
    try {
      _getCryptoBusy = true;
      final res = await cryptoService.fetchCryptos(
        page: refresh ? 1 : cryptoMeta.page! + 1,
        perPage: cryptoMeta.perPage!,
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        _getCryptoResp = FetchCryptosResp.fromJson(res.data);
        if (refresh) {
          _cryptoData = _getCryptoResp.data ?? [];
          cryptoRefreshController.loadComplete();
        } else {
          _cryptoData.addAll(_getCryptoResp.data ?? []);
        }
        if (_getCryptoResp.meta?.hasNextPage == false) {
          cryptoRefreshController.loadNoData();
        } else {
          cryptoMeta = _getCryptoResp.meta ??
              Meta(
                  page: _getCryptoResp.meta?.page ?? 1,
                  perPage: _getCryptoResp.meta?.perPage ?? 0);
          cryptoRefreshController.loadComplete();
        }
      }
      return null;
    } on DioError catch (e) {

      showErrorToast(message: e.response?.data['message']);
      return null;
    } finally {
      _getCryptoBusy = false;
      notifyListeners();
    }
  }

  Future<CryptosData?> fetchSingleCrypto({
    refresh = false,
    required String id,
  }) async {
    try {
      _getCryptoBusy = true;
      final res = await cryptoService.fetchSingleCrypto(cryptoId: id);
      if (res.statusCode == 200 || res.statusCode == 201) {
        _getSingleCryptoResp = FetchSingleCryptoResp.fromJson(res.data);
        return _getSingleCryptoResp.data;
      }
      return null;
    } on DioError catch (e) {
      showErrorToast(message: e.response?.data['message']);
      return null;
    } finally {
      _getCryptoBusy = false;
      notifyListeners();
    }
  }

  Future createCryptoTransaction(
      {required Map<String, dynamic> data, Function()? onSuccess}) async {
    _createCryptoTransBusy = true;
    notifyListeners();
    try {
      final res = await cryptoService.createCryptoTransaction(data: data);
      if (res.statusCode == 200 || res.statusCode == 201) {
        onSuccess?.call();
      }
    } on DioError catch (e) {
      showErrorToast(message: e.response?.data['message']);
    } finally {
      _createCryptoTransBusy = false;
      notifyListeners();
    }
  }

  Future fetchCryptoTransactions({
    refresh = false,
  }) async {
    _createCryptoTransBusy = true;
    notifyListeners();
    try {
      final res = await cryptoService.fetchCryptoTransactions(
        page: refresh ? 1 : cryptoTransMeta.page! + 1,
        perPage: cryptoTransMeta.perPage!,
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        _getCryptoTransResp = FetchCryptoTransResp.fromJson(res.data);
        if (refresh) {
          _cryptoTransData = _getCryptoTransResp.data ?? [];
          cryptoRefreshTransController.loadComplete();
        } else {
          _cryptoTransData.addAll(_getCryptoTransResp.data ?? []);
        }

        if (_getCryptoTransResp.meta?.hasNextPage == false) {
          cryptoRefreshTransController.loadNoData();
        } else {
          cryptoTransMeta = _getCryptoTransResp.meta ??
              Meta(
                  page: _getCryptoTransResp.meta?.page ?? 1,
                  perPage: _getCryptoTransResp.meta?.perPage ?? 0);
          cryptoRefreshTransController.loadComplete();
        }
        for (CryptoTransData e in _cryptoTransData) {
          if (e.status!.toLowerCase().contains('success')) {
            totalCryptoTraded += e.amount ?? 0;
          }
        }
      }
    // ignore: unused_catch_clause
    } on DioError catch (e) {
      // showErrorToast(message: e.response?.data['message']);
    } finally {
      _createCryptoTransBusy = false;
      notifyListeners();
    }
  }
}
