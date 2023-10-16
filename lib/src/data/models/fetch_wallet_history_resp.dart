class FetchWalletHistoryResp {
  String? message;
  List<WalletHistoryData>? data;
  Meta? meta;

  FetchWalletHistoryResp({this.message, this.data, this.meta});

  FetchWalletHistoryResp.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <WalletHistoryData>[];
      json['data'].forEach((v) {
        data!.add(new WalletHistoryData.fromJson(v));
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

class WalletHistoryData {
  String? status;
  Amount? amount;
  String? wallet;
  Amount? previousBalance;
  String? reason;
  String? action;
  String? reference;
  HistoryMeta? meta;
  String? createdAt;
  String? updatedAt;
  String? id;

  WalletHistoryData(
      {this.status,
      this.amount,
      this.wallet,
      this.previousBalance,
      this.reason,
      this.action,
      this.reference,
      this.meta,
      this.createdAt,
      this.updatedAt,
      this.id});

  WalletHistoryData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    amount =
        json['amount'] != null ? new Amount.fromJson(json['amount']) : null;
    wallet = json['wallet'];
    previousBalance = json['previousBalance'] != null
        ? new Amount.fromJson(json['previousBalance'])
        : null;
    reason = json['reason'];
    action = json['action'];
    reference = json['reference'];
    meta = json['meta'] != null ? new HistoryMeta.fromJson(json['meta']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.amount != null) {
      data['amount'] = this.amount!.toJson();
    }
    data['wallet'] = this.wallet;
    if (this.previousBalance != null) {
      data['previousBalance'] = this.previousBalance!.toJson();
    }
    data['reason'] = this.reason;
    data['action'] = this.action;
    data['reference'] = this.reference;
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    return data;
  }
}

class Amount {
  num? value;
  String? currency;

  Amount({this.value, this.currency});

  Amount.fromJson(Map<String, dynamic> json) {
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

class HistoryMeta {
  String? name;
  String? account;
  bool? isCubexTransfer;
  String? bankName;

  HistoryMeta({this.name, this.account, this.isCubexTransfer});

  HistoryMeta.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    account = json['account'];
    isCubexTransfer = json['isCubexTransfer'];
    bankName = json['bankName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['account'] = this.account;
    data['isCubexTransfer'] = this.isCubexTransfer;
    data['bankName'] = this.bankName;
    return data;
  }
}

class Meta {
  int? page;
  int? perPage;
  int? total;
  int? pageCount;
  int? nextPage;
  bool? hasPrevPage;
  bool? hasNextPage;

  Meta(
      {this.page,
      this.perPage,
      this.total,
      this.pageCount,
      this.nextPage,
      this.hasPrevPage,
      this.hasNextPage});

  Meta.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    perPage = json['perPage'];
    total = json['total'];
    pageCount = json['pageCount'];
    nextPage = json['nextPage'];
    hasPrevPage = json['hasPrevPage'];
    hasNextPage = json['hasNextPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['perPage'] = this.perPage;
    data['total'] = this.total;
    data['pageCount'] = this.pageCount;
    data['nextPage'] = this.nextPage;
    data['hasPrevPage'] = this.hasPrevPage;
    data['hasNextPage'] = this.hasNextPage;
    return data;
  }
}
