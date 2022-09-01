import 'package:flutter_dotenv/flutter_dotenv.dart';

String? url = dotenv.env['HOST_URL'];
String? urleo = dotenv.env['HOST_URLEO'];
String? urlbla = dotenv.env['HOST_URLBLA'];
String? urlea = dotenv.env['HOST_URLEA'];

String? reazon = dotenv.env['reazon'];
String? reazonAffiliate = dotenv.env['reazonAffiliate'];
String? reazonQr = dotenv.env['reazonQr'];
//AUTH
serviceAuthSession(int? affiliateId) => '$url/$reazon/auth/${affiliateId??''}';
//CONTACTS
serviceGetContacts() => '$url/$reazon/city';
//PRIVACY POLICY
serviceGetPrivacyPolicy() => '$url/$reazon/policy';
//HISTORY
serviceGetEconomicComplements(int page, bool current) =>
    '$url/$reazon/economic_complement/?page=$page&current=$current';
//GET VERIFIED DOCUMENT
serviceGetMessageFace() => '$url/$reazon/message/verified';
//GET PROCESS ENROLLED
serviceProcessEnrolled() => '$url/$reazon/liveness';
//GET PERMISION PROCEDURE
serviceGetProcessingPermit(int affiliateId) => '$url/$reazon/liveness/$affiliateId';
//SEND IMAGES FOR PROCEDURE
serviceSendImagesProcedure() => '$url/$reazon/economic_complement';
//PRINT ECONOMIC COMPLEMENT
serviceGetPDFEC(int economicComplementId) =>
    '$url/$reazon/economic_complement/print/$economicComplementId';
//GET OBSERVATIONS
serviceGetObservation(int affiliateId) =>
    '$url/$reazon/affiliate/$affiliateId/observation';
serviceEcoComProcedure(int ecoComId) => '$url/$reazon/eco_com_procedure/$ecoComId';
//GET VERSION
servicePostVersion()=>'$url/version';
//////////////////////////////////////////////////
/////////////OFICINA VIRTUAL/////////////////////
////////////////////////////////////////////////
// QR
serviceGetQr(String info)=> '$urlbla/$reazonQr/procedure_qr/$info';
// AUTH
serviceAuthSessionOF()=>'$urlbla/$reazonAffiliate/auth';
// CHANGE PASSWORD
serviceChangePasswordOF()=>'$urlbla/$reazonAffiliate/change_password';