// To parse this JSON data, do
//
//     final contactsModel = contactsModelFromJson(jsonString);

import 'dart:convert';

ContactsModel contactsModelFromJson(String str) => ContactsModel.fromJson(json.decode(str));

String contactsModelToJson(ContactsModel data) => json.encode(data.toJson());

class ContactsModel {
    ContactsModel({
        this.error,
        this.message,
        this.data,
    });

    bool? error;
    String? message;
    Data? data;

    ContactsModel copyWith({
        bool? error,
        String? message,
        Data? data,
    }) => 
        ContactsModel(
            error: error ?? this.error,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory ContactsModel.fromJson(Map<String, dynamic> json) => ContactsModel(
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
        this.cities,
    });

    List<City>? cities;

    Data copyWith({
        List<City>? cities,
    }) => 
        Data(
            cities: cities ?? this.cities,
        );

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        cities: List<City>.from(json["cities"].map((x) => City.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "cities": List<dynamic>.from(cities!.map((x) => x.toJson())),
    };
}

class City {
    City({
        this.id,
        this.name,
        this.latitude,
        this.longitude,
        this.companyAddress,
        this.phonePrefix,
        this.companyPhones,
        this.companyCellphones,
    });

    int? id;
    String? name;
    double? latitude;
    double? longitude;
    String? companyAddress;
    int? phonePrefix;
    String? companyPhones;
    String? companyCellphones;

    City copyWith({
        int? id,
        String? name,
        double? latitude,
        double? longitude,
        String? companyAddress,
        int? phonePrefix,
        String? companyPhones,
        String? companyCellphones,
    }) => 
        City(
            id: id ?? this.id,
            name: name ?? this.name,
            latitude: latitude ?? this.latitude,
            longitude: longitude ?? this.longitude,
            companyAddress: companyAddress ?? this.companyAddress,
            phonePrefix: phonePrefix ?? this.phonePrefix,
            companyPhones: companyPhones ?? this.companyPhones,
            companyCellphones: companyCellphones ?? this.companyCellphones,
        );

    factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        name: json["name"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        companyAddress: json["company_address"],
        phonePrefix: json["phone_prefix"],
        companyPhones: json["company_phones"],
        companyCellphones: json["company_cellphones"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "latitude": latitude,
        "longitude": longitude,
        "company_address": companyAddress,
        "phone_prefix": phonePrefix,
        "company_phones": companyPhones,
        "company_cellphones": companyCellphones,
    };
}
