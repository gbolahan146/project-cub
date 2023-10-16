class LoginResponse {
  String? message;
  LoginData? data;

  LoginResponse({this.message, this.data});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new LoginData.fromJson(json['data']) : null;
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

class LoginData {
  bool? isVerified;
  bool? isDeleted;
  String? paymentProvider;
  String? phoneNumber;
  String? sId;
  String? password;
  String? firstName;
  String? lastName;
  String? email;
  String? verificationCode;
  String? createdAt;
  String? updatedAt;
  int? iV;
  List<dynamic>? roles;
  List<dynamic>? accounts;
  Wallet? wallet;
  dynamic country;
  String? id;
  String? token;

  LoginData(
      {this.isVerified,
      this.isDeleted,
      this.paymentProvider,
      this.phoneNumber,
      this.sId,
      this.password,
      this.firstName,
      this.lastName,
      this.email,
      this.verificationCode,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.roles,
      this.accounts,
      this.wallet,
      this.country,
      this.id,
      this.token});

  LoginData.fromJson(Map<String, dynamic> json) {
    isVerified = json['isVerified'];
    isDeleted = json['isDeleted'];
    paymentProvider = json['paymentProvider'];
    phoneNumber = json['phoneNumber'];
    sId = json['_id'];
    password = json['password'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    verificationCode = json['verificationCode'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    roles = json['roles'];
    accounts = json['accounts'];
    wallet =
        json['wallet'] != null ? new Wallet.fromJson(json['wallet']) : null;
    country = json['country'];
    id = json['id'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isVerified'] = this.isVerified;
    data['isDeleted'] = this.isDeleted;
    data['paymentProvider'] = this.paymentProvider;
    data['phoneNumber'] = this.phoneNumber;
    data['_id'] = this.sId;
    data['password'] = this.password;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['verificationCode'] = this.verificationCode;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.roles != null) {
      data['roles'] = this.roles!.map((v) => v.toJson()).toList();
    }
    if (this.accounts != null) {
      data['accounts'] = this.accounts!.map((v) => v.toJson()).toList();
    }
    if (this.wallet != null) {
      data['wallet'] = this.wallet!.toJson();
    }
    data['country'] = this.country;
    data['id'] = this.id;
    data['token'] = this.token;
    return data;
  }
}

class Wallet {
  bool? isDeleted;
  Balance? balance;
  String? sId;
  String? user;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? id;

  Wallet(
      {this.isDeleted,
      this.balance,
      this.sId,
      this.user,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.id});

  Wallet.fromJson(Map<String, dynamic> json) {
    isDeleted = json['isDeleted'];
    balance =
        json['balance'] != null ? new Balance.fromJson(json['balance']) : null;
    sId = json['_id'];
    user = json['user'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isDeleted'] = this.isDeleted;
    if (this.balance != null) {
      data['balance'] = this.balance!.toJson();
    }
    data['_id'] = this.sId;
    data['user'] = this.user;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['id'] = this.id;
    return data;
  }
}

class Balance {
  num? value;
  String? currency;

  Balance({this.value, this.currency});

  Balance.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['currency'] = this.currency;
    return data;
  }
}
