import 'package:cubex/src/data/models/fetch_wallet_history_resp.dart';

class FetchCardTransResp {
  String? message;
  List<GiftTransData>? data;
  Meta? meta;

  FetchCardTransResp({this.message, this.data, this.meta});

  FetchCardTransResp.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <GiftTransData>[];
      json['data'].forEach((v) {
        data!.add(new GiftTransData.fromJson(v));
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

class GiftTransData {
  String? reference;
  String? comment;
  List<String>? image;
  GiftCardMini? giftCard;
  num? amount;
  num? amountExpected;
  num? rate;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? user;
  String? id;

  GiftTransData(
      {this.reference,
      this.comment,
      this.image,
      this.giftCard,
      this.amount,
      this.amountExpected,
      this.status,
      this.rate,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.id});

  GiftTransData.fromJson(Map<String, dynamic> json) {
    reference = json['reference'];
    comment = json['comment'];
    image = json['image'].cast<String>();
    giftCard = json['giftCard'] != null
        ? new GiftCardMini.fromJson(json['giftCard'])
        : null;
    amount = json['amount'];
    amountExpected = json['amountExpected'];
    rate = json['rate'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['user'];
    status = json['status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment'] = this.comment;
    data['reference'] = this.reference;
    data['image'] = this.image;
    if (this.giftCard != null) {
      data['giftCard'] = this.giftCard!.toJson();
    }
    data['amount'] = this.amount;
    data['amountExpected'] = this.amountExpected;
    data['rate'] = this.rate;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['status'] = this.status;
    data['user'] = this.user;
    data['id'] = this.id;
    return data;
  }
}



class GiftCardMini {
  String? id;
  String? name;
  dynamic amount;
  String? type;
  String? country;

  GiftCardMini({this.id, this.name, this.amount, this.type, this.country});

  GiftCardMini.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    amount = json['amount'];
    type = json['type'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['amount'] = this.amount;
    data['type'] = this.type;
    data['country'] = this.country;
    return data;
  }
}