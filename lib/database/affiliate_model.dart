// To parse this JSON data, do
//
//     final affiliateModel = affiliateModelFromJson(jsonString);

import 'dart:convert';

AffiliateModel affiliateModelFromJson(String str) => AffiliateModel.fromJson(json.decode(str));

String affiliateModelToJson(AffiliateModel data) => json.encode(data.toJson());

class AffiliateModel {
    AffiliateModel({
        this.id,
        required this.idAffiliate,
    });

    int? id;
    int idAffiliate;

    AffiliateModel copyWith({
        int? id,
        int? idAffiliate,
    }) => 
        AffiliateModel(
            id: id ?? this.id,
            idAffiliate: idAffiliate ?? this.idAffiliate,
        );

    factory AffiliateModel.fromJson(Map<String, dynamic> json) => AffiliateModel(
        id: json["id"],
        idAffiliate: json["idAffiliate"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idAffiliate": idAffiliate,
    };
}
