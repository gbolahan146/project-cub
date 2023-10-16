import 'package:dio/dio.dart';

abstract class GiftCardService {
  Future<Response> createCardTransaction({required Map<String, dynamic> data});
  Future<Response> fetchCardTransactions({
    int? perPage,
    int? page,
  });
  Future<Response> createGiftcard({required Map<String, dynamic> data});
  Future<Response> fetchGiftCards(
      {int? perPage,
      int? page,
      String? country,
      String? type,
      String? category});
  Future<Response> fetchSingleGiftCard({required String cardId});
  Future<Response> fetchCryptoRates();
}
