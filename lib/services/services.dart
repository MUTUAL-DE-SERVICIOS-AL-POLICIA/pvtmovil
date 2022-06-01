import 'package:flutter_dotenv/flutter_dotenv.dart';

String? url = dotenv.env['HOST_URL'];
//AUTH
serviceAuthSession() => '$url/auth';
//CONTACTS
serviceGetContacts() => '$url/city';
//PRIVACY POLICY
serviceGetPrivacyPolicy() => '$url/policy';
//HISTORY
serviceGetEconomicComplements(int page, bool current) =>
    '$url/economic_complement/?page=$page&current=$current';
//GET MESSAGE IN FACE
//serviceGetMessageFace() => '$url/message/before_liveness';
//GET PROCESS ENROLLED
serviceProcessEnrolled() => '$url/liveness';
//GET PERMISION PROCEDURE
serviceGetProcessingPermit(int affiliateId) => '$url/liveness/$affiliateId';
//SEND IMAGES FOR PROCEDURE
serviceSendImagesProcedure() => '$url/economic_complement';
//PRINT ECONOMIC COMPLEMENT
serviceGetPDFEC(int economicComplementId) =>
    '$url/economic_complement/print/$economicComplementId';
//GET INFO AFFILIATE - COMPLEMENT ECONOMIC
serviceGetObservation(int affiliateId) =>
    '$url/affiliate/$affiliateId/observation';
serviceEcoComProcedure(int ecoComId) => '$url/eco_com_procedure/$ecoComId';
