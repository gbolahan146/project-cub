import 'package:cubex/src/data/models/fetch_wallet_history_resp.dart';

class FetchCryptoTransResp {
  String? message;
  List<CryptoTransData>? data;
  Meta? meta;

  FetchCryptoTransResp({this.message, this.data, this.meta});

  FetchCryptoTransResp.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <CryptoTransData>[];
      json['data'].forEach((v) {
        data!.add(new CryptoTransData.fromJson(v));
      });
    }
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}

class CryptoTransData {
  String? status;
  String? reference;
  List<String>? image;
  CryptoMini? crypto;
  num? amount;
  num? amountExpected;
  num? rate;
  String? user;
  String? comment;
  String? createdAt;
  String? updatedAt;
  String? id;

  CryptoTransData(
      {this.status,
      this.reference,
      this.comment,
      this.image,
      this.crypto,
      this.amount,
      this.amountExpected,
      this.rate,
      this.user,
      this.createdAt,
      this.updatedAt,
      this.id});

  CryptoTransData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    reference = json['reference'];
    comment = json['comment'];
    image = json['image'].cast<String>();
    crypto =
        json['crypto'] != null ? new CryptoMini.fromJson(json['crypto']) : null;
    amount = json['amount'];
    amountExpected = json['amountExpected'];
    rate = json['rate'];
    user = json['user'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['comment'] = this.comment;
    data['reference'] = this.reference;
    data['image'] = this.image;
    if (this.crypto != null) {
      data['crypto'] = this.crypto!.toJson();
    }
    data['amount'] = this.amount;
    data['amountExpected'] = this.amountExpected;
    data['rate'] = this.rate;
    data['user'] = this.user;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    return data;
  }
}

class CryptoMini {
  String? id;
  String? name;
  String? network;
  String? address;

  CryptoMini({this.id, this.name, this.network, this.address});

  CryptoMini.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    network = json['network'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['network'] = this.network;
    data['address'] = this.address;
    return data;
  }
}