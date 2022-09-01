// To parse this JSON data, do
//
//     final qrModel = qrModelFromJson(jsonString);
import 'dart:convert';
QrModel qrModelFromJson(String str) => QrModel.fromJson(json.decode(str));
String qrModelToJson(QrModel data) => json.encode(data.toJson());
class QrModel {
    QrModel({
        this.message,
        this.payload,
    });
    String? message;
    Payload? payload;
    QrModel copyWith({
        String? message,
        Payload? payload,
    }) =>
        QrModel(
            message: message ?? this.message,
            payload: payload ?? this.payload,
        );
    factory QrModel.fromJson(Map<String, dynamic> json) => QrModel(
        message: json["message"],
        payload: Payload.fromJson(json["payload"]),
    );
    Map<String, dynamic> toJson() => {
        "message": message,
        "payload": payload!.toJson(),
    };
}
class Payload {
    Payload({
        this.moduleDisplayName,
        this.title,
        this.person,
        this.code,
        this.procedureModalityName,
        this.procedureTypeName,
        this.location,
        this.validated,
        this.stateName,
        this.porcentage,
    });
    String? moduleDisplayName;
    String? title;
    List<Person>? person;
    String? code;
    String? procedureModalityName;
    String? procedureTypeName;
    String? location;
    bool? validated;
    String? stateName;
    double? porcentage;
    Payload copyWith({
        String? moduleDisplayName,
        String? title,
        List<Person>? person,
        String? code,
        String? procedureModalityName,
        String? procedureTypeName,
        String? location,
        bool? validated,
        String? stateName,
        double? porcentage,
    }) =>
        Payload(
            moduleDisplayName: moduleDisplayName ?? this.moduleDisplayName,
            title: title ?? this.title,
            person: person ?? this.person,
            code: code ?? this.code,
            procedureModalityName: procedureModalityName ?? this.procedureModalityName,
            procedureTypeName: procedureTypeName ?? this.procedureTypeName,
            location: location ?? this.location,
            validated: validated ?? this.validated,
            stateName: stateName ?? this.stateName,
            porcentage: porcentage ?? this.porcentage,
        );
    factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        moduleDisplayName: json["module_display_name"],
        title: json["title"],
        person: List<Person>.from(json["person"].map((x) => Person.fromJson(x))),
        code: json["code"],
        procedureModalityName: json["procedure_modality_name"],
        procedureTypeName: json["procedure_type_name"],
        location: json["location"],
        validated: json["validated"],
        stateName: json["state_name"],
        porcentage: json["porcentage"].toDouble(),
    );
    Map<String, dynamic> toJson() => {
        "module_display_name": moduleDisplayName,
        "title": title,
        "person": List<dynamic>.from(person!.map((x) => x.toJson())),
        "code": code,
        "procedure_modality_name": procedureModalityName,
        "procedure_type_name": procedureTypeName,
        "location": location,
        "validated": validated,
        "state_name": stateName,
        "porcentage": porcentage,
    };
}
class Person {
    Person({
        this.fullName,
        this.identityCard,
    });
    String? fullName;
    String? identityCard;
    Person copyWith({
        String? fullName,
        String? identityCard,
    }) =>
        Person(
            fullName: fullName ?? this.fullName,
            identityCard: identityCard ?? this.identityCard,
        );
    factory Person.fromJson(Map<String, dynamic> json) => Person(
        fullName: json["full_name"],
        identityCard: json["identity_card"],
    );
    Map<String, dynamic> toJson() => {
        "full_name": fullName,
        "identity_card": identityCard,
    };
}