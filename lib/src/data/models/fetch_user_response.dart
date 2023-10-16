import 'package:cubex/src/data/models/fetch_user_accounts_resp.dart';
import 'package:cubex/src/data/models/login_response.dart';

class FetchUserResponse {
  String? message;
  late Data data;

  FetchUserResponse({this.message, required this.data});

  FetchUserResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['data'] = this.data.toJson();
    return data;
  }
}

class Data {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? phoneNumber;
  String? password;
  String? firstName;
  String? lastName;
  List<UserAccountData>? accounts;
  String? gender;
  String? paymentProvider;
  String? email;
  dynamic country;
  String? dob;
  String? bvn;
  String? bvnStatus;
  bool? isDeleted;
  String? deletedAt;
  String? idCardUrl;
  String? profilePhoto;
  List<dynamic>? roles;
  Wallet? wallet;
  bool? isVerified;
  String? verificationCode;
  String? forgotToken;

  Data(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.phoneNumber,
      this.password,
      this.firstName,
      this.lastName,
      this.accounts,
      this.gender,
      this.paymentProvider,
      this.email,
      this.country,
      this.dob,
      this.bvn,
      this.bvnStatus,
      this.isDeleted,
      this.deletedAt,
      this.idCardUrl,
      this.profilePhoto,
      this.roles,
      this.wallet,
      this.isVerified,
      this.verificationCode,
      this.forgotToken});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    phoneNumber = json['phoneNumber'];
    password = json['password'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    if (json['accounts'] != null) {
      accounts = <UserAccountData>[];
      json['accounts'].forEach((v) {
        accounts!.add(UserAccountData.fromJson(v));
      });
    }
    gender = json['gender'];
    paymentProvider = json['paymentProvider'];
    email = json['email'];
    country = json['country'];
    dob = json['dob'];
    bvn = json['bvn'];
    bvnStatus = json['bvnStatus'];
    isDeleted = json['isDeleted'];
    deletedAt = json['deletedAt'];
    idCardUrl = json['idCardUrl'];
    profilePhoto = json['profilePhoto'];
    roles = json['roles'];
    wallet =
        json['wallet'] != null ? new Wallet.fromJson(json['wallet']) : null;

    isVerified = json['isVerified'];
    verificationCode = json['verificationCode'];
    forgotToken = json['forgotToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['phoneNumber'] = this.phoneNumber;
    data['password'] = this.password;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    if (this.accounts != null) {
      data['accounts'] = this.accounts!.map((v) => v.toJson()).toList();
    }
    data['gender'] = this.gender;
    data['paymentProvider'] = this.paymentProvider;
    data['email'] = this.email;
    data['country'] = this.country;

    data['dob'] = this.dob;
    data['bvn'] = this.bvn;
    data['bvnStatus'] = this.bvnStatus;
    data['isDeleted'] = this.isDeleted;
    data['deletedAt'] = this.deletedAt;
    data['idCardUrl'] = this.idCardUrl;
    data['profilePhoto'] = this.profilePhoto;
    data['roles'] = this.roles;

    if (this.wallet != null) {
      data['wallet'] = this.wallet!.toJson();
    }

    data['isVerified'] = this.isVerified;
    data['verificationCode'] = this.verificationCode;
    data['forgotToken'] = this.forgotToken;
    return data;
  }
}
