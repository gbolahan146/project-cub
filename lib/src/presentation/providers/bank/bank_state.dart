import 'package:cubex/src/data/datasources/remote/banks/bank_service.dart';
import 'package:cubex/src/data/models/fetch_banks.dart';
import 'package:cubex/src/data/models/fetch_countries.dart';

import 'package:cubex/src/data/repositories/banks/bank_service_impl.dart';
import 'package:cubex/src/core/utils/helpers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AccountState extends ChangeNotifier {
  static AccountState? _instance;
  static late AccountsService service;

  AccountState() {
    service = AccountsServiceImpl();
  }

  static AccountState get instance {
    if (_instance == null) {
      _instance = AccountState();
    }
    return _instance!;
  }

  List<CountriesData>? _countries = [];
  List<BankData>? _banks = [];
  List<BankData> get banks => _banks ?? [];
  List<CountriesData> get countries => _countries ?? [];
  // List<SellerBank>? _banks = [];
  // List<SellerBank>? get banks => _banks;

  bool _addbankBusy = false;
  bool get addbankBusy => _addbankBusy;

  bool _getbankBusy = false;
  bool get getbankBusy => _getbankBusy;

  late FetchBanksResponse _fetchBanksResponse;
  FetchBanksResponse get fetchBanksResponse => _fetchBanksResponse;
  // Future addBankDetails(
  //     {required Map<String, dynamic> data,
  //     required BuildContext context}) async {
  //   try {
  //     _addbankBusy = true;
  //     notifyListeners();

  //     final res = await service.addBankDetails(data: data);

  //     if (res.statusCode == 200 || res.statusCode == 201) {
  //       showSuccessToast(message: res.data['message'].toString().toUpperCase());
  //       Future.delayed(Duration(seconds: 2), () => popView(context));
  //     }
  //     return null;
  //   } on DioError catch (e) {
  //     showErrorToast(message: e.response?.data['message']);
  //     return null;
  //   } finally {
  //     _addbankBusy = false;
  //     notifyListeners();
  //   }
  // }

  Future fetchCountries() async {
    try {
      final res = await service.getCountries();
      FetchCountriesResponse.fromJson(res.data);

      _countries = FetchCountriesResponse.fromJson(res.data).countriesdata;

      return _countries;
    } on DioError catch (e) {
      showErrorToast(message: e.response?.data);
      return null;
    }
  }

  Future fetchBanks() async {
    try {
      final res = await service.getBanks();
      _fetchBanksResponse = FetchBanksResponse.fromJson(res.data);
      _banks = _fetchBanksResponse.data;
      return _banks;
    } on DioError catch (e) {
      showErrorToast(message: e.response?.data['message']);
      return null;
    }
  }
}
