import 'package:flutter_dotenv/flutter_dotenv.dart';

// String? url = dotenv.env['HOST_URL'];
String? urleo = dotenv.env['HOST_URLLEO'];
String? urlea = dotenv.env['HOST_URLLEA'];
String? urlbla = dotenv.env['HOST_URLBLA'];
//AUTH
serviceAuthSession(int? affiliateId) => '$urleo/auth/${affiliateId??''}';

//CONTACTS
serviceGetContacts() => '$urleo/city';
//PRIVACY POLICY
serviceGetPrivacyPolicy() => '$urleo/policy';
//HISTORY
serviceGetEconomicComplements(int page, bool current) =>
    '$urleo/economic_complement/?page=$page&current=$current';
//GET VERIFIED DOCUMENT
serviceGetMessageFace() => '$urleo/message/verified';
//GET PROCESS ENROLLED
serviceProcessEnrolled() => '$urleo/liveness';
//GET PERMISION PROCEDURE
serviceGetProcessingPermit(int affiliateId) => '$urleo/liveness/$affiliateId';
//SEND IMAGES FOR PROCEDURE
serviceSendImagesProcedure() => '$urleo/economic_complement';
//PRINT ECONOMIC COMPLEMENT
serviceGetPDFEC(int economicComplementId) =>
    '$urleo/economic_complement/print/$economicComplementId';
//GET OBSERVATIONS
serviceGetObservation(int affiliateId) =>
    '$urleo/affiliate/$affiliateId/observation';
serviceEcoComProcedure(int ecoComId) => '$urleo/eco_com_procedure/$ecoComId';
//GET VERSION
serviceGetVersion()=>'$urleo/version';
//GET APP PLAY STORE
serviceGetPlayStore()=>'https://play.google.com/store/apps/details?id=com.muserpol.pvt';// Android app bundle package name
//GET APP APP STORE
serviceGetAppStore()=>'https://apps.apple.com/app/id284815942'; // AppStore id of your app
//////////////////////////////////////////////////
/////////////OFICINA VIRTUAL/////////////////////
////////////////////////////////////////////////
// QR
serviceGetQr(String info)=> '$urlbla/procedure_qr/$info';
// AUTH
serviceAuthSessionOF()=>'$urlea/auth';
// CHANGE PASSWORD
serviceChangePasswordOF()=>'$urlea/change_password';