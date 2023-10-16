class FetchBanksResponse {
  String? message;
  List<BankData>? data;

  FetchBanksResponse({this.message, this.data});

  FetchBanksResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <BankData>[];
      json['data'].forEach((v) {
        data!.add(BankData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BankData {
  bool? isDeleted;
  String name;
  String code;
  String country;
  String? createdAt;
  String? updatedAt;
  String id;

  BankData(
      {this.isDeleted,
      required this.name,
      required this.code,
      required this.country,
      this.createdAt,
      this.updatedAt,
      required this.id});

  static BankData fromJson(Map<String, dynamic> json) {
    return BankData(
      isDeleted: json['isDeleted'],
      name: json['name'],
      code: json['code'],
      country: json['country'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isDeleted'] = this.isDeleted;
    data['name'] = this.name;
    data['code'] = this.code;
    data['country'] = this.country;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    return data;
  }
}
