import 'package:cubex/src/core/utils/endpoints.dart';
import 'package:cubex/src/data/datasources/remote/base_http.dart';
import 'package:cubex/src/data/datasources/remote/trade/giftcard_service.dart';
import 'package:dio/dio.dart';

class GiftCardServiceImpl extends AlsBaseHttpService
    implements GiftCardService {
  @override
  Future<Response> createGiftcard({required Map<String, dynamic> data}) async {
    try {
      final res = await http.post(CbEndpoints.fetchGiftCards, data: data);
      return res;
    } on DioError catch (e) {
      throw e;
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<Response> createCardTransaction(
      {required Map<String, dynamic> data}) async {
    try {
      final res = await http.post(CbEndpoints.createGiftcardTrans, data: data);
      return res;
    } on DioError catch (e) {
      throw e;
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<Response> fetchCardTransactions({
    int? perPage,
    int? page,
  }) async {
    try {
      Map queryParams = {
        'page': page,
        'perPage': perPage,
      };

      final res = await http.get(
        CbEndpoints.createGiftcardTrans +
            '?' +
            queryParams.entries.map((e) => '${e.key}=${e.value}').join('&'),
      );

      return res;
    } on DioError catch (e) {
      throw e;
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<Response> fetchSingleGiftCard({required String cardId}) async {
    try {
      final res =
          await http.get(CbEndpoints.fetchSingleGiftCard + '/' + cardId);
      return res;
    } on DioError catch (e) {
      throw e;
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<Response> fetchCryptoRates() async {
    try {
      final res = await http.get(CbEndpoints.fetchCryptoRates);
      return res;
    } on DioError catch (e) {
      throw e;
    } on Exception catch (e) {
      throw e;
    }
  }

  @override
  Future<Response> fetchGiftCards(
      {int? perPage,
      int? page,
      String? country,
      String? type,
      String? category}) async {
    Map queryParams = {
      'limit': perPage,
      'page': page,
      'countries': country,
      'types': type,
      'categories': category
    }..removeWhere((key, value) => value == null);
    try {
      //page=$page&limit=$perPage&countries=$country&types=$type&categories=$category

      final res = await http.get(CbEndpoints.fetchGiftCards +
          '?' +
          queryParams.entries.map((e) => '${e.key}=${e.value}').join('&'));

      return res;
    } on DioError catch (e) {
      throw e;
    } on Exception catch (e) {
      throw e;
    }
  }
}
