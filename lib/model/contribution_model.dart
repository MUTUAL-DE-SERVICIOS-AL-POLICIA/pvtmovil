// To parse this JSON data, do
//
//     final contributionModel = contributionModelFromJson(jsonString);

import 'dart:convert';

ContributionModel contributionModelFromJson(String str) => ContributionModel.fromJson(json.decode(str));

String contributionModelToJson(ContributionModel data) => json.encode(data.toJson());

class ContributionModel {
    ContributionModel({
        this.error,
        this.message,
        this.payload,
    });

    bool? error;
    String? message;
    Payload? payload;

    ContributionModel copyWith({
        bool? error,
        String? message,
        Payload? payload,
    }) => 
        ContributionModel(
            error: error ?? this.error,
            message: message ?? this.message,
            payload: payload ?? this.payload,
        );

    factory ContributionModel.fromJson(Map<String, dynamic> json) => ContributionModel(
        error: json["error"],
        message: json["message"],
        payload: Payload.fromJson(json["payload"]),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "payload": payload!.toJson(),
    };
}

class Payload {
    Payload({
        this.degree,
        this.firstName,
        this.secondName,
        this.lastName,
        this.mothersLastName,
        this.surnameHusband,
        this.identityCard,
        this.cityIdentityCard,
        this.contributionsTotal,
    });

    String? degree;
    String? firstName;
    String? secondName;
    String? lastName;
    String? mothersLastName;
    String? surnameHusband;
    String? identityCard;
    String? cityIdentityCard;
    List<ContributionsTotal>? contributionsTotal;

    Payload copyWith({
        String? degree,
        String? firstName,
        String? secondName,
        String? lastName,
        String? mothersLastName,
        String? surnameHusband,
        String? identityCard,
        String? cityIdentityCard,
        List<ContributionsTotal>? contributionsTotal,
    }) => 
        Payload(
            degree: degree ?? this.degree,
            firstName: firstName ?? this.firstName,
            secondName: secondName ?? this.secondName,
            lastName: lastName ?? this.lastName,
            mothersLastName: mothersLastName ?? this.mothersLastName,
            surnameHusband: surnameHusband ?? this.surnameHusband,
            identityCard: identityCard ?? this.identityCard,
            cityIdentityCard: cityIdentityCard ?? this.cityIdentityCard,
            contributionsTotal: contributionsTotal ?? this.contributionsTotal,
        );

    factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        degree: json["degree"],
        firstName: json["first_name"],
        secondName: json["second_name"],
        lastName: json["last_name"],
        mothersLastName: json["mothers_last_name"],
        surnameHusband: json["surname_husband"],
        identityCard: json["identity_card"],
        cityIdentityCard: json["city_identity_card"],
        contributionsTotal: List<ContributionsTotal>.from(json["contributions_total"].map((x) => ContributionsTotal.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "degree": degree,
        "first_name": firstName,
        "second_name": secondName,
        "last_name": lastName,
        "mothers_last_name": mothersLastName,
        "surname_husband": surnameHusband,
        "identity_card": identityCard,
        "city_identity_card": cityIdentityCard,
        "contributions_total": List<dynamic>.from(contributionsTotal!.map((x) => x.toJson())),
    };
}

class ContributionsTotal {
    ContributionsTotal({
        this.year,
        this.contributions,
    });

    String? year;
    List<Contribution>? contributions;

    ContributionsTotal copyWith({
        String? year,
        List<Contribution>? contributions,
    }) => 
        ContributionsTotal(
            year: year ?? this.year,
            contributions: contributions ?? this.contributions,
        );

    factory ContributionsTotal.fromJson(Map<String, dynamic> json) => ContributionsTotal(
        year: json["year"],
        contributions: List<Contribution>.from(json["contributions"].map((x) => Contribution.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "year": year,
        "contributions": List<dynamic>.from(contributions!.map((x) => x.toJson())),
    };
}

class Contribution {
    Contribution({
        this.state,
        this.id,
        this.monthYear,
        this.description,
        this.quotable,
        this.retirementFund,
        this.mortuaryQuota,
        this.total,
        this.type,
    });

    String? state;
    int? id;
    DateTime? monthYear;
    String? description;
    String? quotable;
    String? retirementFund;
    String? mortuaryQuota;
    String? total;
    String? type;

    Contribution copyWith({
        String? state,
        int? id,
        DateTime? monthYear,
        String? description,
        String? quotable,
        String? retirementFund,
        String? mortuaryQuota,
        String? total,
        String? type,
    }) => 
        Contribution(
            state: state ?? this.state,
            id: id ?? this.id,
            monthYear: monthYear ?? this.monthYear,
            description: description ?? this.description,
            quotable: quotable ?? this.quotable,
            retirementFund: retirementFund ?? this.retirementFund,
            mortuaryQuota: mortuaryQuota ?? this.mortuaryQuota,
            total: total ?? this.total,
            type: type ?? this.type,
        );

    factory Contribution.fromJson(Map<String, dynamic> json) => Contribution(
        state: json["state"],
        id: json["id"],
        monthYear: DateTime.parse(json["month_year"]),
        description: json["description"],
        quotable: json["quotable"],
        retirementFund: json["retirement_fund"],
        mortuaryQuota: json["mortuary_quota"],
        total: json["total"],
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "state": state,
        "id": id,
        "month_year": "${monthYear!.year.toString().padLeft(4, '0')}-${monthYear!.month.toString().padLeft(2, '0')}-${monthYear!.day.toString().padLeft(2, '0')}",
        "description": description,
        "quotable": quotable,
        "retirement_fund": retirementFund,
        "mortuary_quota": mortuaryQuota,
        "total": total,
        "type": type,
    };
}
