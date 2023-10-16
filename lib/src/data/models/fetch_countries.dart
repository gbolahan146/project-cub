class FetchCountriesResponse {
  String? message;
  List<CountriesData>? countriesdata;

  FetchCountriesResponse({this.message, this.countriesdata});

  FetchCountriesResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['countriesdata'] != null) {
      countriesdata = <CountriesData>[];
      json['countriesdata'].forEach((v) {
        countriesdata!.add(new CountriesData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> countriesdata = new Map<String, dynamic>();
    countriesdata['message'] = this.message;
    if (this.countriesdata != null) {
      countriesdata['countriesdata'] = this.countriesdata!.map((v) => v.toJson()).toList();
    }
    return countriesdata;
  }
}

class CountriesData {
  bool? isActive;
  String? imageUrl;
  String? areaCodes;
  String? name;
  String? iso2;
  String? dialCode;
  String? symbol;
  String? code;
  String? lastEditedBy;
  String? createdAt;
  String? updatedAt;
  String? id;

  CountriesData(
      {this.isActive,
      this.imageUrl,
      this.areaCodes,
      this.name,
      this.iso2,
      this.dialCode,
      this.symbol,
      this.code,
      this.lastEditedBy,
      this.createdAt,
      this.updatedAt,
      this.id});

  CountriesData.fromJson(Map<String, dynamic> json) {
    isActive = json['isActive'];
    imageUrl = json['imageUrl'];
    areaCodes = json['areaCodes'];
    name = json['name'];
    iso2 = json['iso2'];
    dialCode = json['dialCode'];
    symbol = json['symbol'];
    code = json['code'];
    lastEditedBy = json['lastEditedBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> countriesdata = new Map<String, dynamic>();
    countriesdata['isActive'] = this.isActive;
    countriesdata['imageUrl'] = this.imageUrl;
    countriesdata['areaCodes'] = this.areaCodes;
    countriesdata['name'] = this.name;
    countriesdata['iso2'] = this.iso2;
    countriesdata['dialCode'] = this.dialCode;
    countriesdata['symbol'] = this.symbol;
    countriesdata['code'] = this.code;
    countriesdata['lastEditedBy'] = this.lastEditedBy;
    countriesdata['createdAt'] = this.createdAt;
    countriesdata['updatedAt'] = this.updatedAt;
    countriesdata['id'] = this.id;
    return countriesdata;
  }
}

