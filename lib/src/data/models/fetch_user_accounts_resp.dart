import 'package:cubex/src/data/models/fetch_banks.dart';
import 'package:cubex/src/data/models/fetch_wallet_history_resp.dart';

class FetchUserAccountsResp {
  String? message;
  List<UserAccountData>? data;
  Meta? meta;

  FetchUserAccountsResp({this.message, this.data, this.meta});

  FetchUserAccountsResp.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <UserAccountData>[];
      json['data'].forEach((v) {
        data!.add(new UserAccountData.fromJson(v));
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

class UserAccountData {
  bool? isDeleted;
  bool? isDefault;
  String? accountNumber;
  String? accountName;
  BankData? bank;
  String? user;
  String? createdAt;
  String? updatedAt;
  String? id;

  UserAccountData(
      {this.isDeleted,
      this.isDefault,
      this.accountNumber,
      this.accountName,
      this.bank,
      this.user,
      this.createdAt,
      this.updatedAt,
      this.id});

  UserAccountData.fromJson(Map<String, dynamic> json) {
    isDeleted = json['isDeleted'];
    isDefault = json['isDefault'];
    accountNumber = json['accountNumber'];
    accountName = json['accountName'];
    bank = json['bank'] != null ? BankData.fromJson(json['bank']) : null;
    user = json['user'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isDeleted'] = this.isDeleted;
    data['isDefault'] = this.isDefault;
    data['accountNumber'] = this.accountNumber;
    data['accountName'] = this.accountName;
    if (this.bank != null) {
      data['bank'] = this.bank!.toJson();
    }
    data['user'] = this.user;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    return data;
  }
}
