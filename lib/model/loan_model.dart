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
    Payload? payload;

    LoanModel copyWith({
        String? error,
        String? message,
        Payload? payload,
    }) => 
        LoanModel(
            error: error ?? this.error,
            message: message ?? this.message,
            payload: payload ?? this.payload,
        );

    factory LoanModel.fromJson(Map<String, dynamic> json) => LoanModel(
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
        this.inProcess,
        this.current,
        this.liquited,
    });

    List<InProcess>? inProcess;
    List<Current>? current;
    List<Current>? liquited;

    Payload copyWith({
        List<InProcess>? inProcess,
        List<Current>? current,
        List<Current>? liquited,
    }) => 
        Payload(
            inProcess: inProcess ?? this.inProcess,
            current: current ?? this.current,
            liquited: liquited ?? this.liquited,
        );

    factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        inProcess: List<InProcess>.from(json["inProcess"].map((x) => InProcess.fromJson(x))),
        current: List<Current>.from(json["current"].map((x) => Current.fromJson(x))),
        liquited: List<Current>.from(json["liquited"].map((x) => Current.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "inProcess": List<dynamic>.from(inProcess!.map((x) => x.toJson())),
        "current": List<dynamic>.from(current!.map((x) => x.toJson())),
        "liquited": List<dynamic>.from(liquited!.map((x) => x.toJson())),
    };
}

class Current {
    Current({
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
        this.quota,
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
    double? quota;

    Current copyWith({
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
        double? quota,
    }) => 
        Current(
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
            quota: quota ?? this.quota,
        );

    factory Current.fromJson(Map<String, dynamic> json) => Current(
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
        quota: json["quota"].toDouble(),
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
        "quota": quota,
    };
}

class InProcess {
    InProcess({
        this.code,
        this.procedureModalityName,
        this.procedureTypeName,
        this.location,
        this.validated,
        this.stateName,
    });

    String? code;
    String? procedureModalityName;
    String? procedureTypeName;
    String? location;
    bool? validated;
    String? stateName;

    InProcess copyWith({
        String? code,
        String? procedureModalityName,
        String? procedureTypeName,
        String? location,
        bool? validated,
        String? stateName,
    }) => 
        InProcess(
            code: code ?? this.code,
            procedureModalityName: procedureModalityName ?? this.procedureModalityName,
            procedureTypeName: procedureTypeName ?? this.procedureTypeName,
            location: location ?? this.location,
            validated: validated ?? this.validated,
            stateName: stateName ?? this.stateName,
        );

    factory InProcess.fromJson(Map<String, dynamic> json) => InProcess(
        code: json["code"],
        procedureModalityName: json["procedure_modality_name"],
        procedureTypeName: json["procedure_type_name"],
        location: json["location"],
        validated: json["validated"],
        stateName: json["state_name"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "procedure_modality_name": procedureModalityName,
        "procedure_type_name": procedureTypeName,
        "location": location,
        "validated": validated,
        "state_name": stateName,
    };
}
