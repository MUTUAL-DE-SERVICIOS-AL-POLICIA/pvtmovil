// To parse this JSON data, do
//
//     final loanModel = loanModelFromJson(jsonString);

import 'dart:convert';

LoanModel loanModelFromJson(String str) => LoanModel.fromJson(json.decode(str));

String loanModelToJson(LoanModel data) => json.encode(data.toJson());

class LoanModel {
    LoanModel({
        this.error,
        this.message,
        this.payload,
    });

    String? error;
    String? message;
    List<Payload>? payload;

    LoanModel copyWith({
        String? error,
        String? message,
        List<Payload>? payload,
    }) => 
        LoanModel(
            error: error ?? this.error,
            message: message ?? this.message,
            payload: payload ?? this.payload,
        );

    factory LoanModel.fromJson(Map<String, dynamic> json) => LoanModel(
        error: json["error"],
        message: json["message"],
        payload: List<Payload>.from(json["payload"].map((x) => Payload.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "payload": List<dynamic>.from(payload!.map((x) => x.toJson())),
    };
}

class Payload {
    Payload({
        this.id,
        this.code,
        this.procedureModality,
        this.requestDate,
        this.amountRequested,
        this.city,
        this.interest,
        this.state,
        this.amountApproved,
        this.liquidQualificationCalculated,
        this.loanTerm,
        this.refinancingBalance,
        this.paymentType,
        this.destinyId,
        this.affiliateId,
    });

    int? id;
    String? code;
    String? procedureModality;
    DateTime? requestDate;
    String? amountRequested;
    String? city;
    String? interest;
    String? state;
    String? amountApproved;
    String? liquidQualificationCalculated;
    int? loanTerm;
    String? refinancingBalance;
    String? paymentType;
    String? destinyId;
    int? affiliateId;

    Payload copyWith({
        int? id,
        String? code,
        String? procedureModality,
        DateTime? requestDate,
        String? amountRequested,
        String? city,
        String? interest,
        String? state,
        String? amountApproved,
        String? liquidQualificationCalculated,
        int? loanTerm,
        String? refinancingBalance,
        String? paymentType,
        String? destinyId,
        int? affiliateId,
    }) => 
        Payload(
            id: id ?? this.id,
            code: code ?? this.code,
            procedureModality: procedureModality ?? this.procedureModality,
            requestDate: requestDate ?? this.requestDate,
            amountRequested: amountRequested ?? this.amountRequested,
            city: city ?? this.city,
            interest: interest ?? this.interest,
            state: state ?? this.state,
            amountApproved: amountApproved ?? this.amountApproved,
            liquidQualificationCalculated: liquidQualificationCalculated ?? this.liquidQualificationCalculated,
            loanTerm: loanTerm ?? this.loanTerm,
            refinancingBalance: refinancingBalance ?? this.refinancingBalance,
            paymentType: paymentType ?? this.paymentType,
            destinyId: destinyId ?? this.destinyId,
            affiliateId: affiliateId ?? this.affiliateId,
        );

    factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        id: json["id"],
        code: json["code"],
        procedureModality: json["procedure_modality"],
        requestDate: DateTime.parse(json["request_date"]),
        amountRequested: json["amount_requested"],
        city: json["city"],
        interest: json["interest"],
        state: json["state"],
        amountApproved: json["amount_approved"],
        liquidQualificationCalculated: json["liquid_qualification_calculated"],
        loanTerm: json["loan_term"],
        refinancingBalance: json["refinancing_balance"],
        paymentType: json["payment_type"],
        destinyId: json["destiny_id"],
        affiliateId: json["affiliate_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "procedure_modality": procedureModality,
        "request_date": requestDate!.toIso8601String(),
        "amount_requested": amountRequested,
        "city": city,
        "interest": interest,
        "state": state,
        "amount_approved": amountApproved,
        "liquid_qualification_calculated": liquidQualificationCalculated,
        "loan_term": loanTerm,
        "refinancing_balance": refinancingBalance,
        "payment_type": paymentType,
        "destiny_id": destinyId,
        "affiliate_id": affiliateId,
    };
}
