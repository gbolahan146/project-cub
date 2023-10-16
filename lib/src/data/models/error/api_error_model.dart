// To parse this JSON data, do
//
//     final apiErrorModel = apiErrorModelFromJson(jsonString);

import 'dart:convert';

ApiErrorModel apiErrorModelFromJson(String str) =>
    ApiErrorModel.fromJson(json.decode(str));

String apiErrorModelToJson(ApiErrorModel data) => json.encode(data.toJson());

class ApiErrorModel {
  dynamic error;

  ApiErrorModel({
    this.error,
  });

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) => ApiErrorModel(
        error: json["errors"] ?? json["message"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
      };
}

class ApiErrorResponse {
  List<Errors>? errors;

  ApiErrorResponse({this.errors});

  ApiErrorResponse.fromJson(Map<String, dynamic> json) {
    if (json['errors'] != null) {
      errors = <Errors>[];
      json['errors'].forEach((v) {
        errors!.add(new Errors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.errors != null) {
      data['errors'] = this.errors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Errors {
  int? status;
  String? code;
  String? title;
  dynamic source;

  Errors({this.status, this.code, this.title, this.source});

  Errors.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    title = json['title'];
    source = json['source'] != null ? json['source'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['title'] = this.title;
    if (this.source != null) {
      data['source'] = this.source;
    }
    return data;
  }
}


// class Source {
//   String? email;

//   Source({this.email});

//   Source.fromJson(Map<String, dynamic> json) {
//     email = json['email'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['email'] = this.email;
//     return data;
//   }
// }
