import 'package:cubex/src/data/models/fetch_cryptos.dart';

class FetchCryptoRate {
  String? message;
  Rate? data;

  FetchCryptoRate({this.message, this.data});

  FetchCryptoRate.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Rate.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

