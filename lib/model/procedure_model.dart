// To parse this JSON data, do
//
//     final procedureModel = procedureModelFromJson(jsonString);

import 'dart:convert';

ProcedureModel procedureModelFromJson(String str) =>
    ProcedureModel.fromJson(json.decode(str));

String procedureModelToJson(ProcedureModel data) => json.encode(data.toJson());

class ProcedureModel {
  ProcedureModel({
    this.error,
    this.message,
    this.data,
  });

  bool? error;
  String? message;
  Data? data;

  ProcedureModel copyWith({
    bool? error,
    String? message,
    Data? data,
  }) =>
      ProcedureModel(
        error: error ?? this.error,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory ProcedureModel.fromJson(Map<String, dynamic> json) => ProcedureModel(
        error: json["error"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int? currentPage;
  List<Datum>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Data copyWith({
    int? currentPage,
    List<Datum>? data,
    String? firstPageUrl,
    int? from,
    int? lastPage,
    String? lastPageUrl,
    String? nextPageUrl,
    String? path,
    int? perPage,
    dynamic prevPageUrl,
    int? to,
    int? total,
  }) =>
      Data(
        currentPage: currentPage ?? this.currentPage,
        data: data ?? this.data,
        firstPageUrl: firstPageUrl ?? this.firstPageUrl,
        from: from ?? this.from,
        lastPage: lastPage ?? this.lastPage,
        lastPageUrl: lastPageUrl ?? this.lastPageUrl,
        nextPageUrl: nextPageUrl ?? this.nextPageUrl,
        path: path ?? this.path,
        perPage: perPage ?? this.perPage,
        prevPageUrl: prevPageUrl ?? this.prevPageUrl,
        to: to ?? this.to,
        total: total ?? this.total,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Datum {
  Datum({
    this.id,
    this.title,
    this.subtitle,
    this.printable,
    this.display,
  });

  int? id;
  String? title;
  String? subtitle;
  bool? printable;
  List<Display>? display;

  Datum copyWith({
    int? id,
    String? title,
    String? subtitle,
    bool? printable,
    List<Display>? display,
  }) =>
      Datum(
        id: id ?? this.id,
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        printable: printable ?? this.printable,
        display: display ?? this.display,
      );

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        subtitle: json["subtitle"],
        printable: json["printable"],
        display:
            List<Display>.from(json["display"].map((x) => Display.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "subtitle": subtitle,
        "printable": printable,
        "display": List<dynamic>.from(display!.map((x) => x.toJson())),
      };
}

class Display {
  Display({
    this.key,
    this.value,
  });

  String? key;
  dynamic value;

  Display copyWith({
    String? key,
    dynamic value,
  }) =>
      Display(
        key: key ?? this.key,
        value: value ?? this.value,
      );

  factory Display.fromJson(Map<String, dynamic> json) => Display(
        key: json["key"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
      };
}
