import 'package:cubex/src/data/models/fetch_wallet_history_resp.dart';

class FetchGiftCardsResp {
  String? message;
  List<GiftCardsData>? data;
  Meta? meta;

  FetchGiftCardsResp({this.message, this.data, this.meta});

  FetchGiftCardsResp.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <GiftCardsData>[];
      json['data'].forEach((v) {
        data!.add(new GiftCardsData.fromJson(v));
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

class GiftCardsData {
  List<String>? countries;
  List<Categories>? categories;
  List<String>? types;
  bool? isActive;
  String? lastEditedBy;
  String? createdAt;
  String? updatedAt;
  String? id;
  String? icon;
  String? name;

  GiftCardsData(
      {this.countries,
      this.categories,
      this.types,
      this.isActive,
      this.lastEditedBy,
      this.icon,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.id});

  GiftCardsData.fromJson(Map<String, dynamic> json) {
    countries = json['countries'].cast<String>();
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }

    types = json['types'].cast<String>();
    isActive = json['isActive'];
    lastEditedBy = json['lastEditedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
    icon = json['icon'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['countries'] = this.countries;
    data['categories'] = this.categories;
    data['types'] = this.types;
    data['isActive'] = this.isActive;
    data['icon'] = this.icon;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    data['lastEditedBy'] = this.lastEditedBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Categories {
  String? sId;
  String? name;
  num? rate;
  String? startCode;

  Categories({this.sId, this.name, this.rate, this.startCode});

  Categories.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    rate = json['rate'];
    startCode = json['startCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['rate'] = this.rate;
    data['startCode'] = this.startCode;
    return data;
  }
}

class FetchSingleGiftCardResp {
  String? message;
  GiftCardsData? data;

  FetchSingleGiftCardResp({this.message, this.data});

  FetchSingleGiftCardResp.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data =
        json['data'] != null ? new GiftCardsData.fromJson(json['data']) : null;
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
