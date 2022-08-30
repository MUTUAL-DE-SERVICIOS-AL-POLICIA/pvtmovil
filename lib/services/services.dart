import 'package:flutter_dotenv/flutter_dotenv.dart';

String? url = dotenv.env['HOST_URL'];
String? urleo = dotenv.env['HOST_URLEO'];
String? urlbla = dotenv.env['HOST_URLBLA'];
String? urlea = dotenv.env['HOST_URLEA'];
//AUTH
serviceAuthSession(int? affiliateId) => '$url/auth/${affiliateId??''}';
//CONTACTS
serviceGetContacts() => '$url/city';
//PRIVACY POLICY
serviceGetPrivacyPolicy() => '$url/policy';
//HISTORY
serviceGetEconomicComplements(int page, bool current) =>
    '$url/economic_complement/?page=$page&current=$current';
//GET VERIFIED DOCUMENT
serviceGetMessageFace() => '$url/message/verified';
//GET PROCESS ENROLLED
serviceProcessEnrolled() => '$url/liveness';
//GET PERMISION PROCEDURE
serviceGetProcessingPermit(int affiliateId) => '$url/liveness/$affiliateId';
//SEND IMAGES FOR PROCEDURE
serviceSendImagesProcedure() => '$url/economic_complement';
//PRINT ECONOMIC COMPLEMENT
serviceGetPDFEC(int economicComplementId) =>
    '$url/economic_complement/print/$economicComplementId';
//GET OBSERVATIONS
serviceGetObservation(int affiliateId) =>
    '$url/affiliate/$affiliateId/observation';
serviceEcoComProcedure(int ecoComId) => '$url/eco_com_procedure/$ecoComId';
//GET VERSION
servicePostVersion()=>'$url/version';
//////////////////////////////////////////////////
/////////////OFICINA VIRTUAL/////////////////////
////////////////////////////////////////////////
// QR
serviceGetQr(String info)=> '$urlbla/procedure_qr/$info';
// AUTH
serviceAuthSessionOF()=>'$urlbla/auth';
// CHANGE PASSWORD
serviceChangePasswordOF()=>'$urlbla/change_password';