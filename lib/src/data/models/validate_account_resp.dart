class ValidateAccountResp {
  String? message;
  ValidateAccountData? data;

  ValidateAccountResp({this.message, this.data});

  ValidateAccountResp.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new ValidateAccountData.fromJson(json['data']) : null;
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

class ValidateAccountData {
  String? accountNumber;
  String? accountName;

  ValidateAccountData({this.accountNumber, this.accountName});

  ValidateAccountData.fromJson(Map<String, dynamic> json) {
    accountNumber = json['account_number'];
    accountName = json['account_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account_number'] = this.accountNumber;
    data['account_name'] = this.accountName;
    return data;
  }
}

