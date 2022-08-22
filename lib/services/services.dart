import 'package:flutter_dotenv/flutter_dotenv.dart';

String? url = dotenv.env['HOST_URL'];
String? urleo = dotenv.env['HOST_URLLEO'];
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
serviceGetVersion()=>'$urleo/version';
//GET APP PLAY STORE
serviceGetPlayStore()=>'https://play.google.com/store/apps/details?id=com.muserpol.pvt';// Android app bundle package name
//GET APP APP STORE
serviceGetAppStore()=>'https://apps.apple.com/app/id284815942'; // AppStore id of your app
