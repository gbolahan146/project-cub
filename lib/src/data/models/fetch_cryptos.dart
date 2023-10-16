import 'package:cubex/src/data/models/fetch_wallet_history_resp.dart';

class FetchCryptosResp {
  String? message;
  List<CryptosData>? data;
  Meta? meta;

  FetchCryptosResp({this.message, this.data, this.meta});

  FetchCryptosResp.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <CryptosData>[];
      json['data'].forEach((v) {
        data!.add(new CryptosData.fromJson(v));
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

class CryptosData {
  String? name;
  List<Networks>? networks;
  Rate? rate;
  String? icon;
  String? createdAt;
  bool? isDeleted;
  String? updatedAt;
  String? id;

  CryptosData(
      {this.name,
      this.networks,
      this.rate,
      this.icon,
      this.createdAt,
      this.isDeleted,
      this.updatedAt,
      this.id});

  CryptosData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['networks'] != null) {
      networks = <Networks>[];
      json['networks'].forEach((v) {
        networks!.add(new Networks.fromJson(v));
      });
    }
    rate = json['rate'] != null ? new Rate.fromJson(json['rate']) : null;
    icon = json['icon'];
    createdAt = json['createdAt'];
    isDeleted = json['isDeleted'];
    updatedAt = json['updatedAt'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.networks != null) {
      data['networks'] = this.networks!.map((v) => v.toJson()).toList();
    }
    if (this.rate != null) {
      data['rate'] = this.rate!.toJson();
    }
    data['icon'] = this.icon;
    data['createdAt'] = this.createdAt;
    data['isDeleted'] = this.isDeleted;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    return data;
  }
}

class Networks {
  String? name;
  String? address;
  String? barcode;

  Networks({this.name, this.address, this.barcode});

  Networks.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    barcode = json['barcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['address'] = this.address;
    data['barcode'] = this.barcode;
    return data;
  }
}

class Rate {
  num? mark;
  num? below;
  num? above;

  Rate({this.mark, this.below, this.above});

  Rate.fromJson(Map<String, dynamic> json) {
    mark = json['mark'];
    below = json['below'];
    above = json['above'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mark'] = this.mark;
    data['below'] = this.below;
    data['above'] = this.above;
    return data;
  }
}


class FetchSingleCryptoResp {
  String? message;
  CryptosData? data;

  FetchSingleCryptoResp({this.message, this.data});

  FetchSingleCryptoResp.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new CryptosData.fromJson(json['data']) : null;
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
