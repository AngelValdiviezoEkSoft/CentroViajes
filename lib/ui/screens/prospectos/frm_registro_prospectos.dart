
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cvs_ec_app/domain/domain.dart';
import 'package:cvs_ec_app/infraestructure/infraestructure.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:local_auth/local_auth.dart';
import 'package:cvs_ec_app/ui/ui.dart';

int tabAccionesRegPrsp = 0;

late TextEditingController nombresTxt;
late TextEditingController emailTxt;
late TextEditingController direccionTxt;
late TextEditingController observacionesTxt;
late TextEditingController paisTxt;
late TextEditingController probabilityTxt;
late TextEditingController telefonoTxt;
late TextEditingController sectorTxt;
late TextEditingController ingresoEsperadoTxt;
late TextEditingController recomendadoPorTxt;
late TextEditingController fechaCierreContTxt;

String fecCierre = '';
String fecCierreFin = '';
                  

DateTime dateRgPrsp = DateTime.now();

String campSelect = '';
String mediaSelect = '';
String originSelect = '';
String actSelect = '';
String paisSelect = '';
String telefonoPrsp = '';
bool habilitaGuardar = false;
bool celularValido = false;
bool validandoCell = false;

class FrmRegistroProspectoScreen extends StatefulWidget {
  const FrmRegistroProspectoScreen({super.key});

  @override
  State<FrmRegistroProspectoScreen> createState() => _FrmRegistroProspectoScreenState();
}

class _FrmRegistroProspectoScreenState extends State<FrmRegistroProspectoScreen> {

  
  String message = '';
  final LocalAuthentication auth = LocalAuthentication();  

  String initialCountry = 'EC';
  PhoneNumber number = PhoneNumber(isoCode: 'EC');
  final formKeyRegPrp = GlobalKey<FormState>();
  
  @override
  void initState() {
    super.initState();

    fechaCierreContTxt = TextEditingController();
    nombresTxt = TextEditingController();
    emailTxt = TextEditingController();
    direccionTxt = TextEditingController();
    observacionesTxt = TextEditingController();
    paisTxt = TextEditingController();
    probabilityTxt = TextEditingController();    
    telefonoTxt = TextEditingController();
    ingresoEsperadoTxt = TextEditingController();
    sectorTxt = TextEditingController(text: 'Norte');
    recomendadoPorTxt = TextEditingController();

    fecCierre = DateFormat('yyyy-MM-dd', 'es').format(dateRgPrsp);
    fecCierreFin = DateFormat('yyyy-MM-dd', 'es').format(dateRgPrsp);
    fechaCierreContTxt.text = fecCierre;
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    //ignore: unnecessary_string_escapes
    var regexToRemoveEmoji = '   /\uD83C\uDFF4\uDB40\uDC67\uDB40\uDC62(?:\uDB40\uDC77\uDB40\uDC6C\uDB40\uDC73|\uDB40\uDC73\uDB40\uDC63\uDB40\uDC74|\uDB40\uDC65\uDB40\uDC6E\uDB40\uDC67)\uDB40\uDC7F|\uD83D\uDC69\u200D\uD83D\uDC69\u200D(?:\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67]))|\uD83D\uDC68(?:\uD83C\uDFFF\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB-\uDFFE])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFE\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB-\uDFFD\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFD\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB\uDFFC\uDFFE\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFC\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB\uDFFD-\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFB\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFC-\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\u200D(?:\u2764\uFE0F\u200D(?:\uD83D\uDC8B\u200D)?\uD83D\uDC68|(?:\uD83D[\uDC68\uDC69])\u200D(?:\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67]))|\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67])|(?:\uD83D[\uDC68\uDC69])\u200D(?:\uD83D[\uDC66\uDC67])|[\u2695\u2696\u2708]\uFE0F|\uD83D[\uDC66\uDC67]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|(?:\uD83C\uDFFF\u200D[\u2695\u2696\u2708]|\uD83C\uDFFE\u200D[\u2695\u2696\u2708]|\uD83C\uDFFD\u200D[\u2695\u2696\u2708]|\uD83C\uDFFC\u200D[\u2695\u2696\u2708]|\uD83C\uDFFB\u200D[\u2695\u2696\u2708])\uFE0F|\uD83C\uDFFF|\uD83C\uDFFE|\uD83C\uDFFD|\uD83C\uDFFC|\uD83C\uDFFB)?|\uD83E\uDDD1(?:(?:\uD83C[\uDFFB-\uDFFF])\u200D(?:\uD83E\uDD1D\u200D\uD83E\uDDD1(?:\uD83C[\uDFFB-\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\u200D(?:\uD83E\uDD1D\u200D\uD83E\uDDD1|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD]))|\uD83D\uDC69(?:\u200D(?:\u2764\uFE0F\u200D(?:\uD83D\uDC8B\u200D(?:\uD83D[\uDC68\uDC69])|\uD83D[\uDC68\uDC69])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFF\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFE\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFD\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFC\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFB\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD]))|\uD83D\uDC69\uD83C\uDFFF\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB-\uDFFE])|\uD83D\uDC69\uD83C\uDFFE\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB-\uDFFD\uDFFF])|\uD83D\uDC69\uD83C\uDFFD\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB\uDFFC\uDFFE\uDFFF])|\uD83D\uDC69\uD83C\uDFFC\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB\uDFFD-\uDFFF])|\uD83D\uDC69\uD83C\uDFFB\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFC-\uDFFF])|\uD83D\uDC69\u200D\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC69\u200D\uD83D\uDC69\u200D(?:\uD83D[\uDC66\uDC67])|(?:\uD83D\uDC41\uFE0F\u200D\uD83D\uDDE8|\uD83D\uDC69(?:\uD83C\uDFFF\u200D[\u2695\u2696\u2708]|\uD83C\uDFFE\u200D[\u2695\u2696\u2708]|\uD83C\uDFFD\u200D[\u2695\u2696\u2708]|\uD83C\uDFFC\u200D[\u2695\u2696\u2708]|\uD83C\uDFFB\u200D[\u2695\u2696\u2708]|\u200D[\u2695\u2696\u2708])|\uD83C\uDFF3\uFE0F\u200D\u26A7|\uD83E\uDDD1(?:(?:\uD83C[\uDFFB-\uDFFF])\u200D[\u2695\u2696\u2708]|\u200D[\u2695\u2696\u2708])|\uD83D\uDC3B\u200D\u2744|(?:(?:\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD])(?:\uD83C[\uDFFB-\uDFFF])|\uD83D\uDC6F|\uD83E[\uDD3C\uDDDE\uDDDF])\u200D[\u2640\u2642]|(?:\u26F9|\uD83C[\uDFCB\uDFCC]|\uD83D\uDD75)(?:\uFE0F|\uD83C[\uDFFB-\uDFFF])\u200D[\u2640\u2642]|\uD83C\uDFF4\u200D\u2620|(?:\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD])\u200D[\u2640\u2642]|[\xA9\xAE\u203C\u2049\u2122\u2139\u2194-\u2199\u21A9\u21AA\u2328\u23CF\u23ED-\u23EF\u23F1\u23F2\u23F8-\u23FA\u24C2\u25AA\u25AB\u25B6\u25C0\u25FB\u25FC\u2600-\u2604\u260E\u2611\u2618\u2620\u2622\u2623\u2626\u262A\u262E\u262F\u2638-\u263A\u2640\u2642\u265F\u2660\u2663\u2665\u2666\u2668\u267B\u267E\u2692\u2694-\u2697\u2699\u269B\u269C\u26A0\u26A7\u26B0\u26B1\u26C8\u26CF\u26D1\u26D3\u26E9\u26F0\u26F1\u26F4\u26F7\u26F8\u2702\u2708\u2709\u270F\u2712\u2714\u2716\u271D\u2721\u2733\u2734\u2744\u2747\u2763\u2764\u27A1\u2934\u2935\u2B05-\u2B07\u3030\u303D\u3297\u3299]|\uD83C[\uDD70\uDD71\uDD7E\uDD7F\uDE02\uDE37\uDF21\uDF24-\uDF2C\uDF36\uDF7D\uDF96\uDF97\uDF99-\uDF9B\uDF9E\uDF9F\uDFCD\uDFCE\uDFD4-\uDFDF\uDFF5\uDFF7]|\uD83D[\uDC3F\uDCFD\uDD49\uDD4A\uDD6F\uDD70\uDD73\uDD76-\uDD79\uDD87\uDD8A-\uDD8D\uDDA5\uDDA8\uDDB1\uDDB2\uDDBC\uDDC2-\uDDC4\uDDD1-\uDDD3\uDDDC-\uDDDE\uDDE1\uDDE3\uDDE8\uDDEF\uDDF3\uDDFA\uDECB\uDECD-\uDECF\uDEE0-\uDEE5\uDEE9\uDEF0\uDEF3])\uFE0F|\uD83D\uDC69\u200D\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67])|\uD83C\uDFF3\uFE0F\u200D\uD83C\uDF08|\uD83D\uDC69\u200D\uD83D\uDC67|\uD83D\uDC69\u200D\uD83D\uDC66|\uD83D\uDC15\u200D\uD83E\uDDBA|\uD83D\uDC69(?:\uD83C\uDFFF|\uD83C\uDFFE|\uD83C\uDFFD|\uD83C\uDFFC|\uD83C\uDFFB)?|\uD83C\uDDFD\uD83C\uDDF0|\uD83C\uDDF6\uD83C\uDDE6|\uD83C\uDDF4\uD83C\uDDF2|\uD83D\uDC08\u200D\u2B1B|\uD83D\uDC41\uFE0F|\uD83C\uDFF3\uFE0F|\uD83E\uDDD1(?:\uD83C[\uDFFB-\uDFFF])?|\uD83C\uDDFF(?:\uD83C[\uDDE6\uDDF2\uDDFC])|\uD83C\uDDFE(?:\uD83C[\uDDEA\uDDF9])|\uD83C\uDDFC(?:\uD83C[\uDDEB\uDDF8])|\uD83C\uDDFB(?:\uD83C[\uDDE6\uDDE8\uDDEA\uDDEC\uDDEE\uDDF3\uDDFA])|\uD83C\uDDFA(?:\uD83C[\uDDE6\uDDEC\uDDF2\uDDF3\uDDF8\uDDFE\uDDFF])|\uD83C\uDDF9(?:\uD83C[\uDDE6\uDDE8\uDDE9\uDDEB-\uDDED\uDDEF-\uDDF4\uDDF7\uDDF9\uDDFB\uDDFC\uDDFF])|\uD83C\uDDF8(?:\uD83C[\uDDE6-\uDDEA\uDDEC-\uDDF4\uDDF7-\uDDF9\uDDFB\uDDFD-\uDDFF])|\uD83C\uDDF7(?:\uD83C[\uDDEA\uDDF4\uDDF8\uDDFA\uDDFC])|\uD83C\uDDF5(?:\uD83C[\uDDE6\uDDEA-\uDDED\uDDF0-\uDDF3\uDDF7-\uDDF9\uDDFC\uDDFE])|\uD83C\uDDF3(?:\uD83C[\uDDE6\uDDE8\uDDEA-\uDDEC\uDDEE\uDDF1\uDDF4\uDDF5\uDDF7\uDDFA\uDDFF])|\uD83C\uDDF2(?:\uD83C[\uDDE6\uDDE8-\uDDED\uDDF0-\uDDFF])|\uD83C\uDDF1(?:\uD83C[\uDDE6-\uDDE8\uDDEE\uDDF0\uDDF7-\uDDFB\uDDFE])|\uD83C\uDDF0(?:\uD83C[\uDDEA\uDDEC-\uDDEE\uDDF2\uDDF3\uDDF5\uDDF7\uDDFC\uDDFE\uDDFF])|\uD83C\uDDEF(?:\uD83C[\uDDEA\uDDF2\uDDF4\uDDF5])|\uD83C\uDDEE(?:\uD83C[\uDDE8-\uDDEA\uDDF1-\uDDF4\uDDF6-\uDDF9])|\uD83C\uDDED(?:\uD83C[\uDDF0\uDDF2\uDDF3\uDDF7\uDDF9\uDDFA])|\uD83C\uDDEC(?:\uD83C[\uDDE6\uDDE7\uDDE9-\uDDEE\uDDF1-\uDDF3\uDDF5-\uDDFA\uDDFC\uDDFE])|\uD83C\uDDEB(?:\uD83C[\uDDEE-\uDDF0\uDDF2\uDDF4\uDDF7])|\uD83C\uDDEA(?:\uD83C[\uDDE6\uDDE8\uDDEA\uDDEC\uDDED\uDDF7-\uDDFA])|\uD83C\uDDE9(?:\uD83C[\uDDEA\uDDEC\uDDEF\uDDF0\uDDF2\uDDF4\uDDFF])|\uD83C\uDDE8(?:\uD83C[\uDDE6\uDDE8\uDDE9\uDDEB-\uDDEE\uDDF0-\uDDF5\uDDF7\uDDFA-\uDDFF])|\uD83C\uDDE7(?:\uD83C[\uDDE6\uDDE7\uDDE9-\uDDEF\uDDF1-\uDDF4\uDDF6-\uDDF9\uDDFB\uDDFC\uDDFE\uDDFF])|\uD83C\uDDE6(?:\uD83C[\uDDE8-\uDDEC\uDDEE\uDDF1\uDDF2\uDDF4\uDDF6-\uDDFA\uDDFC\uDDFD\uDDFF])|[#\*0-9]\uFE0F\u20E3|(?:\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD])(?:\uD83C[\uDFFB-\uDFFF])|(?:\u26F9|\uD83C[\uDFCB\uDFCC]|\uD83D\uDD75)(?:\uFE0F|\uD83C[\uDFFB-\uDFFF])|\uD83C\uDFF4|(?:[\u270A\u270B]|\uD83C[\uDF85\uDFC2\uDFC7]|\uD83D[\uDC42\uDC43\uDC46-\uDC50\uDC66\uDC67\uDC6B-\uDC6D\uDC72\uDC74-\uDC76\uDC78\uDC7C\uDC83\uDC85\uDCAA\uDD7A\uDD95\uDD96\uDE4C\uDE4F\uDEC0\uDECC]|\uD83E[\uDD0C\uDD0F\uDD18-\uDD1C\uDD1E\uDD1F\uDD30-\uDD34\uDD36\uDD77\uDDB5\uDDB6\uDDBB\uDDD2-\uDDD5])(?:\uD83C[\uDFFB-\uDFFF])|(?:[\u261D\u270C\u270D]|\uD83D[\uDD74\uDD90])(?:\uFE0F|\uD83C[\uDFFB-\uDFFF])|[\u270A\u270B]|\uD83C[\uDF85\uDFC2\uDFC7]|\uD83D[\uDC08\uDC15\uDC3B\uDC42\uDC43\uDC46-\uDC50\uDC66\uDC67\uDC6B-\uDC6D\uDC72\uDC74-\uDC76\uDC78\uDC7C\uDC83\uDC85\uDCAA\uDD7A\uDD95\uDD96\uDE4C\uDE4F\uDEC0\uDECC]|\uD83E[\uDD0C\uDD0F\uDD18-\uDD1C\uDD1E\uDD1F\uDD30-\uDD34\uDD36\uDD77\uDDB5\uDDB6\uDDBB\uDDD2-\uDDD5]|\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD]|\uD83D\uDC6F|\uD83E[\uDD3C\uDDDE\uDDDF]|[\u231A\u231B\u23E9-\u23EC\u23F0\u23F3\u25FD\u25FE\u2614\u2615\u2648-\u2653\u267F\u2693\u26A1\u26AA\u26AB\u26BD\u26BE\u26C4\u26C5\u26CE\u26D4\u26EA\u26F2\u26F3\u26F5\u26FA\u26FD\u2705\u2728\u274C\u274E\u2753-\u2755\u2757\u2795-\u2797\u27B0\u27BF\u2B1B\u2B1C\u2B50\u2B55]|\uD83C[\uDC04\uDCCF\uDD8E\uDD91-\uDD9A\uDE01\uDE1A\uDE2F\uDE32-\uDE36\uDE38-\uDE3A\uDE50\uDE51\uDF00-\uDF20\uDF2D-\uDF35\uDF37-\uDF7C\uDF7E-\uDF84\uDF86-\uDF93\uDFA0-\uDFC1\uDFC5\uDFC6\uDFC8\uDFC9\uDFCF-\uDFD3\uDFE0-\uDFF0\uDFF8-\uDFFF]|\uD83D[\uDC00-\uDC07\uDC09-\uDC14\uDC16-\uDC3A\uDC3C-\uDC3E\uDC40\uDC44\uDC45\uDC51-\uDC65\uDC6A\uDC79-\uDC7B\uDC7D-\uDC80\uDC84\uDC88-\uDCA9\uDCAB-\uDCFC\uDCFF-\uDD3D\uDD4B-\uDD4E\uDD50-\uDD67\uDDA4\uDDFB-\uDE44\uDE48-\uDE4A\uDE80-\uDEA2\uDEA4-\uDEB3\uDEB7-\uDEBF\uDEC1-\uDEC5\uDED0-\uDED2\uDED5-\uDED7\uDEEB\uDEEC\uDEF4-\uDEFC\uDFE0-\uDFEB]|\uD83E[\uDD0D\uDD0E\uDD10-\uDD17\uDD1D\uDD20-\uDD25\uDD27-\uDD2F\uDD3A\uDD3F-\uDD45\uDD47-\uDD76\uDD78\uDD7A-\uDDB4\uDDB7\uDDBA\uDDBC-\uDDCB\uDDD0\uDDE0-\uDDFF\uDE70-\uDE74\uDE78-\uDE7A\uDE80-\uDE86\uDE90-\uDEA8\uDEB0-\uDEB6\uDEC0-\uDEC2\uDED0-\uDED6]|(?:[\u231A\u231B\u23E9-\u23EC\u23F0\u23F3\u25FD\u25FE\u2614\u2615\u2648-\u2653\u267F\u2693\u26A1\u26AA\u26AB\u26BD\u26BE\u26C4\u26C5\u26CE\u26D4\u26EA\u26F2\u26F3\u26F5\u26FA\u26FD\u2705\u270A\u270B\u2728\u274C\u274E\u2753-\u2755\u2757\u2795-\u2797\u27B0\u27BF\u2B1B\u2B1C\u2B50\u2B55]|\uD83C[\uDC04\uDCCF\uDD8E\uDD91-\uDD9A\uDDE6-\uDDFF\uDE01\uDE1A\uDE2F\uDE32-\uDE36\uDE38-\uDE3A\uDE50\uDE51\uDF00-\uDF20\uDF2D-\uDF35\uDF37-\uDF7C\uDF7E-\uDF93\uDFA0-\uDFCA\uDFCF-\uDFD3\uDFE0-\uDFF0\uDFF4\uDFF8-\uDFFF]|\uD83D[\uDC00-\uDC3E\uDC40\uDC42-\uDCFC\uDCFF-\uDD3D\uDD4B-\uDD4E\uDD50-\uDD67\uDD7A\uDD95\uDD96\uDDA4\uDDFB-\uDE4F\uDE80-\uDEC5\uDECC\uDED0-\uDED2\uDED5-\uDED7\uDEEB\uDEEC\uDEF4-\uDEFC\uDFE0-\uDFEB]|\uD83E[\uDD0C-\uDD3A\uDD3C-\uDD45\uDD47-\uDD78\uDD7A-\uDDCB\uDDCD-\uDDFF\uDE70-\uDE74\uDE78-\uDE7A\uDE80-\uDE86\uDE90-\uDEA8\uDEB0-\uDEB6\uDEC0-\uDEC2\uDED0-\uDED6])|(?:[#\*0-9\xA9\xAE\u203C\u2049\u2122\u2139\u2194-\u2199\u21A9\u21AA\u231A\u231B\u2328\u23CF\u23E9-\u23F3\u23F8-\u23FA\u24C2\u25AA\u25AB\u25B6\u25C0\u25FB-\u25FE\u2600-\u2604\u260E\u2611\u2614\u2615\u2618\u261D\u2620\u2622\u2623\u2626\u262A\u262E\u262F\u2638-\u263A\u2640\u2642\u2648-\u2653\u265F\u2660\u2663\u2665\u2666\u2668\u267B\u267E\u267F\u2692-\u2697\u2699\u269B\u269C\u26A0\u26A1\u26A7\u26AA\u26AB\u26B0\u26B1\u26BD\u26BE\u26C4\u26C5\u26C8\u26CE\u26CF\u26D1\u26D3\u26D4\u26E9\u26EA\u26F0-\u26F5\u26F7-\u26FA\u26FD\u2702\u2705\u2708-\u270D\u270F\u2712\u2714\u2716\u271D\u2721\u2728\u2733\u2734\u2744\u2747\u274C\u274E\u2753-\u2755\u2757\u2763\u2764\u2795-\u2797\u27A1\u27B0\u27BF\u2934\u2935\u2B05-\u2B07\u2B1B\u2B1C\u2B50\u2B55\u3030\u303D\u3297\u3299]|\uD83C[\uDC04\uDCCF\uDD70\uDD71\uDD7E\uDD7F\uDD8E\uDD91-\uDD9A\uDDE6-\uDDFF\uDE01\uDE02\uDE1A\uDE2F\uDE32-\uDE3A\uDE50\uDE51\uDF00-\uDF21\uDF24-\uDF93\uDF96\uDF97\uDF99-\uDF9B\uDF9E-\uDFF0\uDFF3-\uDFF5\uDFF7-\uDFFF]|\uD83D[\uDC00-\uDCFD\uDCFF-\uDD3D\uDD49-\uDD4E\uDD50-\uDD67\uDD6F\uDD70\uDD73-\uDD7A\uDD87\uDD8A-\uDD8D\uDD90\uDD95\uDD96\uDDA4\uDDA5\uDDA8\uDDB1\uDDB2\uDDBC\uDDC2-\uDDC4\uDDD1-\uDDD3\uDDDC-\uDDDE\uDDE1\uDDE3\uDDE8\uDDEF\uDDF3\uDDFA-\uDE4F\uDE80-\uDEC5\uDECB-\uDED2\uDED5-\uDED7\uDEE0-\uDEE5\uDEE9\uDEEB\uDEEC\uDEF0\uDEF3-\uDEFC\uDFE0-\uDFEB]|\uD83E[\uDD0C-\uDD3A\uDD3C-\uDD45\uDD47-\uDD78\uDD7A-\uDDCB\uDDCD-\uDDFF\uDE70-\uDE74\uDE78-\uDE7A\uDE80-\uDE86\uDE90-\uDEA8\uDEB0-\uDEB6\uDEC0-\uDEC2\uDED0-\uDED6])\uFE0F|(?:[\u261D\u26F9\u270A-\u270D]|\uD83C[\uDF85\uDFC2-\uDFC4\uDFC7\uDFCA-\uDFCC]|\uD83D[\uDC42\uDC43\uDC46-\uDC50\uDC66-\uDC78\uDC7C\uDC81-\uDC83\uDC85-\uDC87\uDC8F\uDC91\uDCAA\uDD74\uDD75\uDD7A\uDD90\uDD95\uDD96\uDE45-\uDE47\uDE4B-\uDE4F\uDEA3\uDEB4-\uDEB6\uDEC0\uDECC]|\uD83E[\uDD0C\uDD0F\uDD18-\uDD1F\uDD26\uDD30-\uDD39\uDD3C-\uDD3E\uDD77\uDDB5\uDDB6\uDDB8\uDDB9\uDDBB\uDDCD-\uDDCF\uDDD1-\uDDDD])/';

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              context.pop();
            },
          ),
          title: const Text('Prospectos'),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
      body: BlocBuilder<GenericBloc, GenericState>(
        builder: (context,state) {
          
          return FutureBuilder(
            future: state.readCombosCreateProspectos(),
            builder: (context, snapshot) {
              
              if(!snapshot.hasData) {
                return Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: Image.asset(
                      "assets/gifs/gif_carga.gif",
                      height: size.width * 0.85,//150.0,
                      width: size.width * 0.85,//150.0,
                    ),
                  ),
                );
              }
              else{
                if(snapshot.data != null) {

                  //ProspectoCombosModel objTmp = snapshot.data as ProspectoCombosModel;

                  String rspCombos = snapshot.data as String;

                  ProspectoCombosModel objTmp = ProspectoCombosModel(
                    campanias: rspCombos.split('---')[0],
                    origen: rspCombos.split('---')[1],
                    medias: rspCombos.split('---')[2],
                    actividades: rspCombos.split('---')[3],
                    paises: rspCombos.split('---')[4]
                  );

                  var objCamp = json.decode(objTmp.campanias);
                  var objCamp2 = json.decode(objCamp);

                  var objMedia = json.decode(objTmp.medias);
                  var objMedia2 = json.decode(objMedia);

                  var objOrigen = json.decode(objTmp.origen);
                  var objOrigen2 = json.decode(objOrigen);

                  var objAct = json.decode(objTmp.actividades);
                  var objAct2 = json.decode(objAct);

                  var objPais = json.decode(objTmp.paises);
                  var objPai2 = json.decode(objPais);

                  var objCamp3 = objCamp2['result']['data']['utm.campaign']['data'];
                  var objMedia3 = objMedia2['result']['data']['utm.medium']['data'];
                  var objOrigen3 = objOrigen2['result']['data']['utm.source']['data'];
                  var objAct3 = objAct2['result']['data']['mail.activity.type']['data'];
                  var objPai3 = objPai2['result']['data']['res.country']['data'];

                  List<Map<String, dynamic>> mappedObjCamp3 = List<Map<String, dynamic>>.from(objCamp3);

                  List<String> lstCampanias = mappedObjCamp3
                  .map((item) => item["name"]?.toString() ?? '')
                  .toList();

                  List<Map<String, dynamic>> mappedObjMed3 = List<Map<String, dynamic>>.from(objMedia3);

                  List<String> lstMedias = mappedObjMed3
                      .map((item) => item["name"]?.toString() ?? '')
                      .toList();

                  List<Map<String, dynamic>> mappedObjOrig3 = List<Map<String, dynamic>>.from(objOrigen3);

                  List<String> lstOrigenes = mappedObjOrig3
                      .map((item) => item["name"]?.toString() ?? '')
                      .toList();

                  List<Map<String, dynamic>> mappedObjAct3 = List<Map<String, dynamic>>.from(objAct3);

                  List<String> lstActividades = mappedObjAct3
                      .map((item) => item["name"]?.toString() ?? '')
                      .toList();

                  List<Map<String, dynamic>> mappedObjPais3 = List<Map<String, dynamic>>.from(objPai3);

                  List<String> lstPaises = mappedObjPais3
                      .map((item) => item["name"]?.toString() ?? '')
                      .toList();

                  if(campSelect.isEmpty){                      
                    campSelect = lstCampanias.first;
                  }

                  if(mediaSelect.isEmpty){
                    mediaSelect = lstMedias.first;
                  }

                  if(originSelect.isEmpty){
                    originSelect = lstOrigenes.first;
                  }

                  if(actSelect.isEmpty){
                    actSelect = lstActividades.first;
                  }

                  if(paisSelect.isEmpty){
                    paisSelect = lstPaises.first;
                  }

                  return Form(
                    key: formKeyRegPrp,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [                
                              Container(
                                color: Colors.transparent,
                                width: size.width * 0.95, //- 100,
                                height: size.height * 0.045, //40,
                                alignment: Alignment.centerLeft,
                                child: const AutoSizeText(
                                  'Registre nuevo prospecto',  
                                  presetFontSizes: [30,28,26,24,22,20,18,16,14,12,10],                          
                                ),
                              ),
                          
                              Container(
                                //color: const Color(0xffF6F6F6),
                                color: Colors.transparent,
                                width: size.width,
                                height: size.height * 0.86,
                                alignment: Alignment.topCenter,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                
                                    Container(
                                      color: Colors.blue.shade800,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  color: tabAccionesRegPrsp == 0
                                                      ? Colors.white
                                                      : Colors.blue.shade800,
                                                  child: Center(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        tabAccionesRegPrsp = 0;
                                                        setState(() {});
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Icon(
                                                            Icons.info_outline,
                                                            color: tabAccionesRegPrsp == 0
                                                                ? Colors.blue.shade800
                                                                : Colors.white,
                                                          ),
                                                          Text(
                                                            'Inf. general',
                                                            style: TextStyle(
                                                              color: tabAccionesRegPrsp == 0
                                                                  ? Colors.blue.shade800
                                                                  : Colors.white,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  color: tabAccionesRegPrsp == 1
                                                      ? Colors.white
                                                      : Colors.blue.shade800,
                                                  child: Center(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        tabAccionesRegPrsp = 1;
                                                        setState(() {});
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Icon(
                                                            Icons.grid_on_outlined,
                                                            color: tabAccionesRegPrsp == 1
                                                                ? Colors.blue.shade800
                                                                : Colors.white,
                                                          ),
                                                          Text(
                                                            'Inf. Adicional',
                                                            style: TextStyle(
                                                              //color: Colors.purple.shade700,
                                                              color: tabAccionesRegPrsp == 1
                                                                  ? Colors.blue.shade800
                                                                  : Colors.white,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  color: tabAccionesRegPrsp == 2
                                                      ? Colors.white
                                                      : Colors.blue.shade800,
                                                  child: Center(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        tabAccionesRegPrsp = 2;
                                                        setState(() {});
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Icon(
                                                            Icons.add_business_rounded,
                                                            color: tabAccionesRegPrsp == 2
                                                                ? Colors.blue.shade800
                                                                : Colors.white,
                                                          ),
                                                          Text(
                                                            'Notas Int.',
                                                            style: TextStyle(
                                                              //color: Colors.purple.shade700,
                                                              color: tabAccionesRegPrsp == 2
                                                                  ? Colors.blue.shade800
                                                                  : Colors.white,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                          
                                    Container(
                                      color: Colors.transparent,
                                      width: size.width * 0.92,
                                      child: InternationalPhoneNumberInput(
                                        isEnabled: !validandoCell,
                                        onInputChanged: (PhoneNumber phoneNumber) async {
                                          telefonoPrsp = phoneNumber.phoneNumber ?? '';
                                          setState(() {});
                                        },
                                        onInputValidated: (bool isValid) async {
                                          validandoCell = true;
                                          celularValido = isValid;
                                          if(isValid){
                                            
                                            String resInt = await ValidacionesUtils().validaInternet();

                                            if(resInt.isEmpty){

                                              showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) => SimpleDialog(
                                                alignment: Alignment.center,
                                                children: [
                                                  SimpleDialogCargando(
                                                    null,
                                                    mensajeMostrar: 'Estamos consultando',
                                                    mensajeMostrarDialogCargando: 'los datos del prospecto',
                                                  ),
                                                ]
                                              ),
                                            );
                                              

                                              var resp = await ProspectoTypeService().getProspectoRegistrado(telefonoPrsp);
                      
                                              var objResp = json.decode(resp);

                                              if(objResp['result']['create_date'] == null){
                                                habilitaGuardar = true;
                                              } else {
                                                habilitaGuardar = false;
                                              }
                        
                                              //ignore: use_build_context_synchronously
                                              FocusScope.of(context).unfocus();

                                              context.pop();
                        
                                              showDialog(
                                                barrierDismissible: false,
                                                //ignore: use_build_context_synchronously
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return ContentAlertDialog(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    onPressedCont: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    tipoAlerta: TipoAlerta().alertAccion,
                                                    numLineasTitulo: 2,
                                                    numLineasMensaje: 3,
                                                    titulo: 'Atención',
                                                    mensajeAlerta: objResp['result']['mensaje']
                                                  );
                                                },
                                              );
                                            
                                            } else {
                                              habilitaGuardar = false;
                                            }
                      
                                          }

                                          validandoCell = false;
                                          setState(() {
                                            
                                          });
                                        },
                                        selectorConfig: const SelectorConfig(
                                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET, // Tipo de selector
                                        ),
                                        ignoreBlank: false,
                                        autoValidateMode: AutovalidateMode.onUserInteraction,
                                        initialValue: number,
                                        textFieldController: telefonoTxt,
                                        formatInput: true,
                                        keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                                        inputDecoration: InputDecoration(
                                          hintText: "Ingrese su número",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        onSaved: (PhoneNumber phoneNumber) {
                                          //print('Número guardado: ${phoneNumber.phoneNumber}');
                                        },
                                        maxLength: 11,
                                        errorMessage: 'Teléfono no válido',
                                      ),
                                    ),
                                    
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                
                                    if(tabAccionesRegPrsp == 0)
                                    Container(
                                      color: Colors.transparent,
                                      height: size.height * 0.55,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            
                                            Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.92,
                                        child: TextFormField(
                                          textCapitalization: TextCapitalization.sentences,
                                          cursorColor: AppLightColors().primary,
                                          //autovalidateMode: AutovalidateMode.onUserInteraction,                                          
                                          inputFormatters: [
                                            FilteringTextInputFormatter.deny(regexToRemoveEmoji)
                                          ],
                                          style: AppTextStyles.bodyRegular(width: size.width),
                                          decoration: InputDecorationCvs.formsDecoration(
                                            labelText: '* Nombres',
                                            hintTetx: 'Ej: Juan Valdez',
                                            size: size
                                          ),
                                          enabled: habilitaGuardar,
                                          controller: nombresTxt,
                                          autocorrect: false,
                                          keyboardType: TextInputType.text,
                                          minLines: 1,
                                          maxLines: 2,
                                          autofocus: false,
                                          maxLength: 50,
                                          textAlign: TextAlign.left,
                                          onEditingComplete: () {
                                            FocusScope.of(context).unfocus();
                                            //FocusScope.of(context).requestFocus(numTelfAfilAkiNode);
                                          },
                                          onChanged: (value) {
                                            
                                          },
                                          onTapOutside: (event) {
                                            FocusScope.of(context).unfocus();
                                          },
                                        ),
                                      ),
                                      
                                      SizedBox(
                                        height: size.height * 0.04,
                                      ),
                                      
                                      /*
                                      Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.92,
                                        child: TextFormField(                                    
                                          cursorColor: AppLightColors().primary,
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.deny(regexToRemoveEmoji)
                                          ],
                                          //enabled: false,
                                          style: AppTextStyles.bodyRegular(width: size.width),
                                          decoration: InputDecorationCvs.formsDecoration(
                                            labelText: 'Producto de interés',
                                            hintTetx: 'Ej: Terreno',
                                            size: size
                                          ),
                                          //controller: emailAkiTxt,
                                          autocorrect: false,
                                          keyboardType: TextInputType.text,
                                          minLines: 1,
                                          maxLines: 2,
                                          autofocus: false,
                                          maxLength: 50,
                                          textAlign: TextAlign.left,
                                          onEditingComplete: () {
                                            FocusScope.of(context).unfocus();
                                          },
                                          onChanged: (value) {
                                            
                                          },
                                          onTapOutside: (event) {
                                            FocusScope.of(context).unfocus();
                                          },
                                        ),
                                      ),
                                     
                                      SizedBox(
                                        height: size.height * 0.04,
                                      ),
                                      */
                          
                                      Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.92,
                                        child: DropdownButtonFormField<String>(
                                          
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Seleccione el país...',
                                          ),
                                          value: paisSelect,
                                          items: lstPaises
                                            .map(
                                              (activityPrsp) =>
                                                DropdownMenuItem(
                                                  value: activityPrsp,
                                                  child: Text(activityPrsp, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(fontSize: 12),),
                                                  //child: AutoSizeText(activityPrsp, maxLines: 1, minFontSize: 1, maxFontSize: 12,),
                                                )
                                              )
                                            .toList(),
                                          onChanged: (value) {
                                            
                                            setState(() {
                                              paisSelect = value ?? '';
                                            });
                                                                    
                                          },
                                        ),
                                      ),
                                        
                                      SizedBox(
                                        height: size.height * 0.03,
                                      ),
                    
                                      /*
                                      Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.92,
                                        child: TextFormField(
                                          controller: sectorTxt,
                                          //initialValue: 'Norte',
                                          //enabled: false,
                                          cursorColor: AppLightColors().primary,
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          style: AppTextStyles.bodyRegular(width: size.width),
                                          decoration: InputDecorationCvs.formsDecoration(
                                            labelText: 'Sector',
                                            hintTetx: 'Ej: Norte',
                                            size: size
                                          ),
                                          //controller: emailAkiTxt,
                                          autocorrect: false,
                                          keyboardType: TextInputType.text,
                                          minLines: 1,
                                          maxLines: 2,
                                          autofocus: false,
                                          maxLength: 50,
                                          textAlign: TextAlign.left,
                                          onEditingComplete: () {
                                            FocusScope.of(context).unfocus();
                                            //FocusScope.of(context).requestFocus(numTelfAfilAkiNode);
                                          },
                                          onChanged: (value) {
                                            
                                          },
                                          onTapOutside: (event) {
                                            FocusScope.of(context).unfocus();
                                          },
                                        ),
                                      ),
                                      
                                      SizedBox(
                                        height: size.height * 0.03,
                                      ),
                                      */
                                                                          
                                      Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.92,
                                        child: DropdownButtonFormField<String>(
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText:
                                                'Seleccione la campaña',
                                          ),
                                          value: campSelect,
                                          //value: selectedActivityType,
                                          items: lstCampanias.map((activityPrsp) =>
                                                  DropdownMenuItem(
                                                    value: activityPrsp,
                                                    child: Text(activityPrsp, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(fontSize: 12),),
                                                    //child: AutoSizeText(activityPrsp, maxLines: 1, minFontSize: 2, maxFontSize: 13,),
                                                  ))
                                              .toList(),
                                          onChanged: (String? newValue) {                        
                                            setState(() {
                                              campSelect = newValue ?? '';
                                            });
                                          },
                                        ),
                                      ),
                                                                      
                                      SizedBox(
                                        height: size.height * 0.03,
                                      ),
                          
                                      Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.92,
                                        child: DropdownButtonFormField<String>(
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText:
                                                'Seleccione el origen',
                                          ),
                                          value: originSelect,
                                          items: lstOrigenes
                                              .map((activityPrsp) =>
                                                  DropdownMenuItem(
                                                    value: activityPrsp,
                                                    child: Text(activityPrsp, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(fontSize: 12),),
                                                    //child: AutoSizeText(activityPrsp, maxLines: 1, minFontSize: 2, maxFontSize: 13,),
                                                  ))
                                              .toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              originSelect = newValue ?? '';
                                            });
                                          },
                                        ),
                                        ),
                                                                          
                                      SizedBox(
                                        height: size.height * 0.03,
                                      ),
                                            
                                      Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.92,
                                        child: DropdownButtonFormField<String>(
                                                      decoration: const InputDecoration(
                                                        border: OutlineInputBorder(),
                                                        labelText:
                                                            'Seleccione el medio',
                                                      ),
                                                      value: mediaSelect,
                                                      items: lstMedias
                                                          .map((activityPrsp) =>
                                                              DropdownMenuItem(
                                                                value: activityPrsp,
                                                                child: Text(activityPrsp, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(fontSize: 12),),
                                                                //child: AutoSizeText(activityPrsp, maxLines: 1, minFontSize: 2, maxFontSize: 13,),
                                                              ))
                                                          .toList(),
                                                      onChanged: (newValue) {
                                                        setState(() {
                                              mediaSelect = newValue ?? '';
                                            });
                                                      },
                                                    ),
                                      ),
                                                                          
                                      SizedBox(
                                        height: size.height * 0.02,
                                      ),
                                                                          
                                      Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.92,
                                        child: TextFormField(
                                          enabled: habilitaGuardar,
                                          textCapitalization: TextCapitalization.sentences,
                                          cursorColor: AppLightColors().primary,
                                          autovalidateMode: AutovalidateMode.onUserInteraction,                                        
                                          style: AppTextStyles.bodyRegular(width: size.width),
                                          decoration: InputDecorationCvs.formsDecoration(
                                            labelText: 'Recomendado por',
                                            hintTetx: 'Ej: Majo Piguave',
                                            size: size
                                          ),
                                          controller: recomendadoPorTxt,
                                          autocorrect: false,
                                          keyboardType: TextInputType.text,
                                          minLines: 1,
                                          maxLines: 2,
                                          autofocus: false,
                                          maxLength: 50,
                                          textAlign: TextAlign.left,
                                          onEditingComplete: () {
                                            FocusScope.of(context).unfocus();
                                          },
                                          onChanged: (value) {
                                            
                                          },
                                          onTapOutside: (event) {
                                            FocusScope.of(context).unfocus();
                                          },
                                        ),
                                      ),
                                      
                                      SizedBox(
                                        height: size.height * 0.025,
                                            ),
                                                                      
                                          ],
                                        ),
                                      ),
                                    ),
                                
                                    if(tabAccionesRegPrsp == 1)
                                    Container(
                                      color: Colors.transparent,
                                      height: size.height * 0.55,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.92,
                                              child: TextFormField(            
                                                enabled: habilitaGuardar,                        
                                                cursorColor: AppLightColors().primary,
                                                autovalidateMode: AutovalidateMode.onUserInteraction,                                              
                                                style: AppTextStyles.bodyRegular(width: size.width),
                                                decoration: InputDecoration(
                                                  labelText: '* Probabilidad',
                                                  hintStyle: SafeGoogleFont(
                                                      GoogleFontsApp().fontMulish,
                                                      fontSize: size.width * 0.0025 * 18,
                                                      fontWeight: FontWeight.w700,
                                                      color:
                                                          AppLightColors().gray800SecondaryText,
                                                      letterSpacing: 0),
                                                      
                                                  hintText: "100%",
                                                  suffixText: '%',
                                                ),
                                                controller: probabilityTxt,
                                                autocorrect: false,
                                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                minLines: 1,
                                                maxLines: 1,
                                                autofocus: false,
                                                maxLength: 5,
                                                textAlign: TextAlign.left,
                                                onEditingComplete: () {
                                                  FocusScope.of(context).unfocus();

                                                  setState(() {
                                                      
                                                  });
                                                },
                                                onChanged: (value) {
                                                  
                                                },
                                                onTapOutside: (event) {
                                                  FocusScope.of(context).unfocus();

                                                  setState(() {
                                                      
                                                  });
                                                },
                                              ),
                                            ),
                                                                          
                                            SizedBox(
                                              height: size.height * 0.02,
                                            ),
                                            
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.92,
                                              child: TextFormField(
                                                enabled: habilitaGuardar,
                                                cursorColor: AppLightColors().primary,
                                                autovalidateMode: AutovalidateMode.onUserInteraction,                    
                                                style: AppTextStyles.bodyRegular(width: size.width),
                                                decoration: InputDecoration(
                                                  hintStyle: SafeGoogleFont(
                                                    GoogleFontsApp().fontMulish,
                                                    fontSize: size.width * 0.0025 * 18,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppLightColors().gray800SecondaryText,
                                                    letterSpacing: 0
                                                  ),
                                                  labelText: '* Ingreso esperado en dólares',
                                                  hintText: "0.00",
                                                  suffixText: '\$',
                                                ),
                                                controller: ingresoEsperadoTxt,
                                                autocorrect: false,
                                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                minLines: 1,
                                                maxLines: 1,
                                                autofocus: false,
                                                maxLength: 7,
                                                textAlign: TextAlign.left,
                                                onEditingComplete: () {
                                                  FocusScope.of(context).unfocus();

                                                  setState(() {
                                                      
                                                  });
                                                },
                                                onChanged: (value) {
                            
                                                },
                                                onTapOutside: (event) {
                                                  FocusScope.of(context).unfocus();

                                                  setState(() {
                                                      
                                                  });
                                                },
                                              ),
                                            ),
                                            
                                            SizedBox(
                                              height: size.height * 0.02,
                                            ),
                                            
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.92,
                                              child: TextFormField(
                                              inputFormatters: [
                                                FilteringTextInputFormatter.deny(regexToRemoveEmoji)
                                              ],
                                              enabled: habilitaGuardar,
                                              cursorColor: AppLightColors().primary,
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              
                                              style: AppTextStyles.bodyRegular(width: size.width),
                                              decoration: InputDecorationCvs.formsDecoration(
                                                labelText: '* Correo',
                                                hintTetx: 'Ej: correo@ejemplo.com',
                                                size: size
                                              ),
                                              controller: emailTxt,
                                              autocorrect: false,
                                              keyboardType: TextInputType.emailAddress,
                                              minLines: 1,
                                              maxLines: 2,
                                              autofocus: false,
                                              maxLength: 50,
                                              textAlign: TextAlign.left,
                                              onEditingComplete: () {
                                                FocusScope.of(context).unfocus();

                                                setState(() {
                                                      
                                                  });
                                              },
                                              onChanged: (value) {
                          
                                              },
                                              onTapOutside: (event) {
                                                FocusScope.of(context).unfocus();
                                                setState(() {
                                                      
                                                  });
                                              },
                                              validator: (value) {                          
                                                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                                RegExp regExp = RegExp(pattern);
                                                return regExp.hasMatch(value ?? '')
                                                  ? null
                                                  : 'Correo inválido';
                                              },
                                              ),
                                            ),
                                            
                                            SizedBox(
                                              height: size.height * 0.03,
                                            ),
                                            
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.92,
                                              child: TextFormField(
                                                onTapOutside: (event) {
                                                  setState(() {
                                                      
                                                  });
                                                },
                                                controller: fechaCierreContTxt,
                                                enabled: habilitaGuardar,
                                                //initialValue: fecCierre,//DateFormat('dd-MM-yyyy', 'es').format(dateRgPrsp),
                                                readOnly: true,
                                                decoration: const InputDecoration(
                                                  labelText: '* Cierre esperado',
                                                  border: OutlineInputBorder(),
                                                  suffixIcon: Icon(Icons.calendar_today),
                                                ),
                                                onTap: () async {
                                                  DateTime? fecCambio =
                                                      await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(2020),
                                                    lastDate: DateTime(2100),
                                                  );
                                                  if (fecCambio != null) {
                                                    
                                                    //tabAccionesRegPrsp = 2;
                                                    fecCierre = DateFormat('yyyy-MM-dd', 'es').format(fecCambio);
                                                    fecCierreFin = DateFormat('yyyy-MM-dd', 'es').format(fecCambio);
                                                    //tabAccionesRegPrsp = 1;
                                                    fechaCierreContTxt.text = fecCierreFin;
    
                                                  }

                                                  setState(() {
                                                      
                                                  });
                                                },
                                              ),
                                                                    
                                            ),
                                            
                                            SizedBox(
                                              height: size.height * 0.01,
                                            ),
                          
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.92,
                                              height: size.height * 0.15,
                                              child: TextFormField(
                                                enabled: habilitaGuardar,
                                              controller: direccionTxt,
                                              cursorColor: AppLightColors().primary,
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.deny(regexToRemoveEmoji)
                                              ],
                                              style: AppTextStyles.bodyRegular(width: size.width),
                                              decoration: InputDecorationCvs.formsDecoration(
                                                labelText: '* Dirección',
                                                hintTetx: '',
                                                size: size
                                              ),
                                              autocorrect: false,
                                              keyboardType: TextInputType.text,
                                              minLines: 3,
                                              maxLines: 6,
                                              autofocus: false,
                                              maxLength: 150,
                                              textAlign: TextAlign.left,
                                              onEditingComplete: () {
                                                FocusScope.of(context).unfocus();

                                                setState(() {
                                                      
                                                  });
                                              },
                                              onChanged: (value) {
                          
                                              },
                                              onTapOutside: (event) {
                                                FocusScope.of(context).unfocus();
                                                setState(() {
                                                      
                                                  });
                                              },
                                            ),
                                            ),
                                            
                                            SizedBox(
                                              height: size.height * 0.025,
                                            ),
                                                                      
                                          ],
                                        ),
                                      ),
                                    ),
                                
                                    if(tabAccionesRegPrsp == 2)
                                    Container(
                                      color: Colors.transparent,
                                      height: size.height * 0.55,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.92,
                                              child: TextFormField(
                                                enabled: habilitaGuardar,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.deny(regexToRemoveEmoji)
                                                ],
                                                cursorColor: AppLightColors().primary,
                                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                                style: AppTextStyles.bodyRegular(width: size.width),
                                                decoration: InputDecorationCvs.formsDecoration(
                                                  labelText: 'Observaciones',
                                                  hintTetx: 'Ej: Interesado en casa pero no tiene trabajo estable',
                                                  size: size
                                                ),
                                                controller: observacionesTxt,
                                                autocorrect: false,
                                                keyboardType: TextInputType.text,
                                                minLines: 1,
                                                maxLines: 4,
                                                autofocus: false,
                                                maxLength: 150,
                                                textAlign: TextAlign.left,
                                                onEditingComplete: () {
                                                  FocusScope.of(context).unfocus();
                                                },
                                                onChanged: (value) {
                                                  
                                                },
                                                onTapOutside: (event) {
                                                  FocusScope.of(context).unfocus();
                                                },
                                              ),
                                            ),
                                            
                                            SizedBox(
                                              height: size.height * 0.02,
                                            ),
                                                                          
                                                                      
                                          ],
                                        ),
                                      ),
                                    ),
                                
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    
                        if(habilitaGuardar)
                        Positioned(
                          left: size.width * 0.042,
                          top: size.height * 0.82,
                          child: Container(
                            color: Colors.transparent,
                            width: size.width * 0.92,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: size.width * 0.38,
                                  color: Colors.transparent,
                                  child: GestureDetector(
                                  onTap: () async {
                                    //context.push(Rutas().rutaHome);
                                    context.pop();
                                  },
                                  child: ButtonCvsWidget(
                                    text: 'Cerrar',
                                    textStyle: AppTextStyles.h3Bold(
                                        width: size.width,
                                        color: AppLightColors().white),
                                  )),
                                ),
                    
                                Container(
                                  width: size.width * 0.5,
                                  color: Colors.transparent,
                                  child: GestureDetector(
                                  onTap: () async {

                                    FocusScope.of(context).requestFocus(FocusNode());

                                    //print('Test form: ${formKeyRegPrp.currentState!.validate()}');
                                    /*
                                    if (!formKeyRegPrp.currentState!.validate()) {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ContentAlertDialog(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            onPressedCont: () {
                                              Navigator.of(context).pop();
                                            },
                                            tipoAlerta: TipoAlerta().alertAccion,
                                            numLineasTitulo: 2,
                                            numLineasMensaje: 2,
                                            titulo: 'Error',
                                            mensajeAlerta: 'Error... Ingrese todos los datos del formulario.'
                                          );
                                        },
                                      );
                    
                                      return;
                                    }
                                    */
                    
                                    if(!celularValido){
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ContentAlertDialog(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            onPressedCont: () {
                                              Navigator.of(context).pop();
                                            },
                                            tipoAlerta: TipoAlerta().alertAccion,
                                            numLineasTitulo: 2,
                                            numLineasMensaje: 2,
                                            titulo: 'Error',
                                            mensajeAlerta: 'Número celular inválido, por favor corregir.'
                                          );
                                        },
                                      );
                    
                                      return;
                                    }
                    
                                    if(nombresTxt.text.isEmpty){
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ContentAlertDialog(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            onPressedCont: () {
                                              Navigator.of(context).pop();
                                            },
                                            tipoAlerta: TipoAlerta().alertAccion,
                                            numLineasTitulo: 2,
                                            numLineasMensaje: 2,
                                            titulo: 'Error',
                                            mensajeAlerta: 'Ingrese los nombres del prospecto.'
                                          );
                                        },
                                      );
                    
                                      return;
                                    }

                                    if(probabilityTxt.text.isEmpty){
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ContentAlertDialog(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            onPressedCont: () {
                                              Navigator.of(context).pop();
                                            },
                                            tipoAlerta: TipoAlerta().alertAccion,
                                            numLineasTitulo: 2,
                                            numLineasMensaje: 2,
                                            titulo: 'Error',
                                            mensajeAlerta: 'Ingrese la probabilidad.'
                                          );
                                        },
                                      );
                    
                                      return;
                                    } else {
                                      if(probabilityTxt.text.isNotEmpty){
                                        double probNeg = double.parse(probabilityTxt.text);

                                        if(probNeg < 0) {
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ContentAlertDialog(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                onPressedCont: () {
                                                  Navigator.of(context).pop();
                                                },
                                                tipoAlerta: TipoAlerta().alertAccion,
                                                numLineasTitulo: 1,
                                                numLineasMensaje: 2,
                                                titulo: 'Error',
                                                mensajeAlerta: 'La probabilidad no puede ser un valor negativo.'
                                              );
                                            },
                                          );
                        
                                          return;
                                        }

                                      }
                                    }

                                    if(ingresoEsperadoTxt.text.isEmpty){
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ContentAlertDialog(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            onPressedCont: () {
                                              Navigator.of(context).pop();
                                            },
                                            tipoAlerta: TipoAlerta().alertAccion,
                                            numLineasTitulo: 2,
                                            numLineasMensaje: 2,
                                            titulo: 'Error',
                                            mensajeAlerta: 'Ingrese el monto esperado.'
                                          );
                                        },
                                      );
                    
                                      return;
                                    } else {
                                      if(ingresoEsperadoTxt.text.isNotEmpty){
                                        double ingNeg = double.parse(ingresoEsperadoTxt.text);

                                        if(ingNeg < 0) {
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ContentAlertDialog(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                onPressedCont: () {
                                                  Navigator.of(context).pop();
                                                },
                                                tipoAlerta: TipoAlerta().alertAccion,
                                                numLineasTitulo: 1,
                                                numLineasMensaje: 2,
                                                titulo: 'Error',
                                                mensajeAlerta: 'El ingreso esperado no puede ser un valor negativo.'
                                              );
                                            },
                                          );
                        
                                          return;
                                        }

                                      }
                                    }

                                    if(emailTxt.text.isEmpty){
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ContentAlertDialog(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            onPressedCont: () {
                                              Navigator.of(context).pop();
                                            },
                                            tipoAlerta: TipoAlerta().alertAccion,
                                            numLineasTitulo: 2,
                                            numLineasMensaje: 2,
                                            titulo: 'Error',
                                            mensajeAlerta: 'Ingrese el correo.'
                                          );
                                        },
                                      );
                    
                                      return;
                                    } else {
                                      String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                      RegExp regExp = RegExp(pattern);
                                      
                                      if(!regExp.hasMatch(emailTxt.text)){
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ContentAlertDialog(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              onPressedCont: () {
                                                Navigator.of(context).pop();
                                              },
                                              tipoAlerta: TipoAlerta().alertAccion,
                                              numLineasTitulo: 2,
                                              numLineasMensaje: 2,
                                              titulo: 'Error',
                                              mensajeAlerta: 'Correo inválido.'
                                            );
                                          },
                                        );
                      
                                        return;
                                      }
                                    }

                                    if(fecCierreFin.isEmpty){
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ContentAlertDialog(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            onPressedCont: () {
                                              Navigator.of(context).pop();
                                            },
                                            tipoAlerta: TipoAlerta().alertAccion,
                                            numLineasTitulo: 2,
                                            numLineasMensaje: 2,
                                            titulo: 'Error',
                                            mensajeAlerta: 'Ingrese la fecha de cierre.'
                                          );
                                        },
                                      );
                    
                                      return;
                                    }

                                    if(direccionTxt.text.isEmpty){
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ContentAlertDialog(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            onPressedCont: () {
                                              Navigator.of(context).pop();
                                            },
                                            tipoAlerta: TipoAlerta().alertAccion,
                                            numLineasTitulo: 2,
                                            numLineasMensaje: 2,
                                            titulo: 'Error',
                                            mensajeAlerta: 'Ingrese la dirección del prospecto.'
                                          );
                                        },
                                      );
                    
                                      return;
                                    }
                    
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => SimpleDialog(
                                        alignment: Alignment.center,
                                        children: [
                                          SimpleDialogCargando(
                                            null,
                                            mensajeMostrar: 'Estamos registrando',
                                            mensajeMostrarDialogCargando: 'al nuevo prospecto.',
                                          ),
                                        ]
                                      ),
                                    );
                    
                                    int idPais = 0;
                                    int idCamp = 0;
                                    int idMedia = 0;
                                    int idOrigen = 0;
                    
                                    for (var elemento in mappedObjPais3) {
                                      if (elemento['name'] == paisSelect) {
                                        idPais = elemento['id'];
                                      }
                                    }
                    
                                    for (var elemento in mappedObjCamp3) {
                                      if (elemento['name'] == campSelect) {
                                        idCamp = elemento['id'];
                                      }
                                    }
                    
                                    for (var elemento in mappedObjOrig3) {
                                      if (elemento['name'] == originSelect) {
                                        idOrigen = elemento['id'];
                                      }
                                    }
                    
                                    for (var elemento in mappedObjMed3) {
                                      if (elemento['name'] == mediaSelect) {
                                        idMedia = elemento['id'];
                                      }
                                    }
                    
                                    DatumCrmLead objProsp = DatumCrmLead(                                    
                                      expectedRevenue: double.parse(ingresoEsperadoTxt.text),
                                      dayClose: double.parse(dateRgPrsp.day.toString()),
                                      id: 0,
                                      name: nombresTxt.text,
                                      emailCc: emailTxt.text,
                                      priority: '',
                                      type: '',
                                      city: '',
                                      contactName: nombresTxt.text,
                                      description: observacionesTxt.text,
                                      emailFrom: emailTxt.text,
                                      street: direccionTxt.text,
                                      phone: telefonoPrsp,
                                      partnerName: nombresTxt.text,
                                      mobile: telefonoPrsp,
                                      dateOpen: DateTime.now(),
                                      dateDeadline: DateTime.now(),
                                      probability: double.parse(probabilityTxt.text),
                                      activityIds: [
                                        StructCombos(id: 2, name: actSelect)
                                      ],
                                      campaignId: CampaignId(
                                        id: idCamp,
                                        name: campSelect
                                      ),
                                      countryId: StructCombos (
                                        id: idPais,
                                        name: paisTxt.text
                                      ),
                                      lostReasonId: CampaignId(
                                        id: 2,
                                        name: ''
                                      ),
                                      mediumId: StructCombos (
                                        id: idMedia,
                                        name: ''
                                      ),
                                      partnerId: StructCombos (
                                        id: 2,
                                        name: ''
                                      ),
                                      sourceId: StructCombos (
                                        id: idOrigen,
                                        name: originSelect
                                      ),
                                      stageId: StructCombos (
                                        id: 2,
                                        name: ''
                                      ),
                                      stateId: StructCombos (
                                        id: 2,
                                        name: ''
                                      ),
                                      title: CampaignId(
                                        id: 2,
                                        name: ''
                                      ),
                                      tagIds: [],
                                      referred: recomendadoPorTxt.text,
                                      dateClose: DateTime.parse(fecCierreFin)                                    
                                    );
                    
                                    ProspectoRegistroResponseModel objRsp = await ProspectoTypeService().registraProspecto(objProsp);
                                    
                                    String respuestaReg = objRsp.result.mensaje;
                                    int estado = objRsp.result.estado;
                                    String gifRespuesta = 'assets/gifs/exito.gif';
                    
                                    context.pop();
                    
                                    if(objRsp.mensaje.isNotEmpty){
                                
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Container(
                                              color: Colors.transparent,
                                              height: size.height * 0.17,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  
                                                  Container(
                                                    color: Colors.transparent,
                                                    height: size.height * 0.09,
                                                    child: Image.asset(gifRespuesta),
                                                  ),
                    
                                                  Container(
                                                    color: Colors.transparent,
                                                    width: size.width * 0.95,
                                                    height: size.height * 0.08,
                                                    alignment: Alignment.center,
                                                    child: AutoSizeText(
                                                      objRsp.mensaje,
                                                      maxLines: 2,
                                                      minFontSize: 2,
                                                    ),
                                                  )
                                                ],
                                              )
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    
                                      return;
                                    }
                    
                                    if(estado == 200){
                                      gifRespuesta = 'assets/gifs/exito.gif';
                                    } else {
                                      gifRespuesta = 'assets/gifs/gifErrorBlanco.gif';
                                    }
                    
                                    
                                    context.pop();
                                    context.pop();
                    
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Container(
                                            color: Colors.transparent,
                                            height: size.height * 0.17,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                
                                                Container(
                                                  color: Colors.transparent,
                                                  height: size.height * 0.09,
                                                  child: Image.asset(gifRespuesta),
                                                ),
                    
                                                Container(
                                                  color: Colors.transparent,
                                                  width: size.width * 0.95,
                                                  height: size.height * 0.08,
                                                  alignment: Alignment.center,
                                                  child: AutoSizeText(
                                                    respuestaReg,
                                                    maxLines: 2,
                                                    minFontSize: 2,
                                                  ),
                                                )
                                              ],
                                            )
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  
                                  },
                                  child: ButtonCvsWidget(
                                    //text: 'Crear',
                                    text: 'Crear Prospecto',
                                    textStyle: AppTextStyles.h3Bold(
                                      width: size.width,
                                      color: AppLightColors().white
                                    ),
                                  )),
                                ),
                              ],
                            ),
                          ),
                        ),
                              
                        if(!habilitaGuardar)
                        Positioned(
                          //left: size.width * 0.06,
                          right: size.width * 0.29,
                          top: size.height * 0.82,
                          child: Container(
                            width: size.width * 0.38,
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: GestureDetector(
                            onTap: () async {
                              context.pop();
                            },
                            child: ButtonCvsWidget(
                              text: 'Cerrar',
                              textStyle: AppTextStyles.h3Bold(
                                  width: size.width,
                                  color: AppLightColors().white),
                            )
                          ),
                        ),
                    
                        ),
                        
                      ]
                    ),
                  );
                
                }
              }

              return Container();
            }
          );
          
        }
      ),
        
    );
  }

}
