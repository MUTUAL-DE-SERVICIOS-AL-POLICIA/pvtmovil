import 'package:flutter_dotenv/flutter_dotenv.dart';

String? url = dotenv.env['HOST_URL'];
String? urlPrueba = dotenv.env['HOST_URL_PVT_PRUEBA'];
String? urlbla = dotenv.env['HOST_URLBLA'];
String? urllea = dotenv.env['HOST_URLLEA'];
String? reazon = dotenv.env['reazon'];//vi
String? reazonAffiliate = dotenv.env['reazonAffiliate'];//affiliate
String? reazonQr = dotenv.env['reazonQr'];//global




//AUTH
String serviceAuthSession(int? affiliateId) => '$url/$reazon/auth/${affiliateId??''}';
//CONTACTS
String serviceGetContacts() => '$url/$reazon/city';
//PRIVACY POLICY
String serviceGetPrivacyPolicy() => '$url/$reazon/policy';
//HISTORY
String serviceGetEconomicComplements(int page, bool current) =>
    '$url/$reazon/economic_complement/?page=$page&current=$current';
//GET VERIFIED DOCUMENT
String serviceGetMessageFace() => '$url/$reazon/message/verified';
//GET PROCESS ENROLLED
String serviceProcessEnrolled(String? deviceId) => '$url/$reazon/liveness/${deviceId!=null?'?device_id=$deviceId':''}';
//GET PERMISION PROCEDURE
String serviceGetProcessingPermit(int affiliateId) => '$url/$reazon/liveness/$affiliateId';
//SEND IMAGES FOR PROCEDURE
String serviceSendImagesProcedure() => '$url/$reazon/economic_complement';
//PRINT ECONOMIC COMPLEMENT
String serviceGetPDFEC(int economicComplementId) =>
    '$url/$reazon/economic_complement/print/$economicComplementId';
//GET OBSERVATIONS
String serviceGetObservation(int affiliateId) =>
    '$url/$reazon/affiliate/$affiliateId/observation';
String serviceEcoComProcedure(int ecoComId) => '$url/$reazon/eco_com_procedure/$ecoComId';
//GET VERSION
String servicePostVersion()=>'$urlPrueba/$reazon/version';
//////////////////////////////////////////////////
/////////////OFICINA VIRTUAL/////////////////////
////////////////////////////////////////////////
// QR
String serviceGetQr(String info)=> '$urlbla/$reazonQr/procedure_qr/$info';
// AUTH
String serviceAuthSessionOF()=>'$urlbla/$reazonAffiliate/auth';
// CHANGE PASSWORD
String serviceChangePasswordOF()=>'$urlbla/$reazonAffiliate/change_password';
// APORTES
String serviceContributions(int affiliateId,int year)=>'$urlbla/app/all_contributions/$affiliateId/$year';
//PRESTAMOS
String serviceLoans(int affiliateId)=> '$urllea/get_information_loan?id_affiliate=$affiliateId';