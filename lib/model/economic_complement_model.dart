// To parse this JSON data, do
//
//     final economicComplementModel = economicComplementModelFromJson(jsonString);

import 'dart:convert';

EconomicComplementModel economicComplementModelFromJson(String str) =>
    EconomicComplementModel.fromJson(json.decode(str));

String economicComplementModelToJson(EconomicComplementModel data) =>
    json.encode(data.toJson());

class EconomicComplementModel {
  EconomicComplementModel({
    this.data,
  });

  Data? data;

  EconomicComplementModel copyWith({
    Data? data,
  }) =>
      EconomicComplementModel(
        data: data ?? this.data,
      );

  factory EconomicComplementModel.fromJson(Map<String, dynamic> json) =>
      EconomicComplementModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.id,
    this.title,
    this.subtitle,
    this.display,
  });

  int? id;
  String? title;
  String? subtitle;
  List<Display>? display;

  Data copyWith({
    int? id,
    String? title,
    String? subtitle,
    List<Display>? display,
  }) =>
      Data(
        id: id ?? this.id,
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        display: display ?? this.display,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        title: json["title"],
        subtitle: json["subtitle"],
        display:
            List<Display>.from(json["display"].map((x) => Display.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "subtitle": subtitle,
        "display": List<dynamic>.from(display!.map((x) => x.toJson())),
      };
}

class Display {
  Display({
    this.key,
    this.value,
  });

  String? key;
  String? value;

  Display copyWith({
    String? key,
    String? value,
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
