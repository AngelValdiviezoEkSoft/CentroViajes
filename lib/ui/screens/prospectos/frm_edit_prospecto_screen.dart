import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cvs_ec_app/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:local_auth/local_auth.dart';
import 'package:cvs_ec_app/ui/ui.dart';
import 'package:webview_flutter/webview_flutter.dart';

DatumCrmLead? objDatumCrmLeadEdit;
int idProsp = 0;
int tabAccionesEditPrsp = 0;

late TextEditingController nombresEditTxt;
late TextEditingController emailEditTxt;
late TextEditingController direccionEditTxt;
late TextEditingController observacionesEditTxt;
late TextEditingController paisEditTxt;
late TextEditingController probabilityEditTxt;
late TextEditingController telefonoEditTxt;
late TextEditingController sectorEditTxt;
late TextEditingController ingresoEsperadoEditTxt;
late TextEditingController recomendadoPorEditTxt;

DateTime dateEdPrsp = DateTime.now();

String fecEditCierre = '';
String campEditSelect = '';
String mediaEditSelect = '';
String originEditSelect = '';
String actEditSelect = '';
String paisEditSelect = '';
bool prspAsignado = false;

class FrmEditProspectoScreen extends StatefulWidget {
  const FrmEditProspectoScreen({super.key});

  @override
  State<FrmEditProspectoScreen> createState() => _FrmEditProspectoScreenState();
}

class _FrmEditProspectoScreenState extends State<FrmEditProspectoScreen> {
  
  late final WebViewController _wvController;
  final LocalAuthentication auth = LocalAuthentication();  

  String initialCountry = 'EC';
  PhoneNumber number = PhoneNumber(isoCode: 'EC');
  
  @override
  void initState() {
    super.initState();

    nombresEditTxt = TextEditingController();
    emailEditTxt = TextEditingController();
    direccionEditTxt = TextEditingController();
    observacionesEditTxt = TextEditingController();
    paisEditTxt = TextEditingController();
    probabilityEditTxt = TextEditingController();
    ingresoEsperadoEditTxt = TextEditingController();
    recomendadoPorEditTxt = TextEditingController();
    
    telefonoEditTxt = TextEditingController();
    sectorEditTxt = TextEditingController(text: 'Norte');

    if(objDatumCrmLead != null){
      objDatumCrmLeadEdit = objDatumCrmLead;
      nombresEditTxt.text = objDatumCrmLeadEdit!.contactName ?? '';
      emailEditTxt.text = objDatumCrmLeadEdit!.emailFrom;
      direccionEditTxt.text = objDatumCrmLeadEdit!.street ?? '';
      observacionesEditTxt.text = objDatumCrmLeadEdit!.description ?? '';
      probabilityEditTxt.text = objDatumCrmLeadEdit!.probability?.toString() ?? "0";

      String cell = separatePhoneNumber(objDatumCrmLeadEdit!.phone ?? '');

      telefonoEditTxt.text = cell;
      recomendadoPorEditTxt.text = objDatumCrmLeadEdit!.referred ?? '';

      String rutaFinal = objDatumCrmLeadEdit!.description ?? 'https://flutter.dev';

      fecEditCierre = objDatumCrmLeadEdit!.dateClose != null ? DateFormat('dd-MM-yyyy', 'es').format(objDatumCrmLeadEdit!.dateClose!) : '-- No tiene fecha de cierre --';//DateFormat('dd-MM-yyyy', 'es').format(dateEdPrsp);
      
      ingresoEsperadoEditTxt.text = objDatumCrmLeadEdit!.expectedRevenue.toString();

      _wvController = WebViewController();

      _wvController.loadHtmlString(rutaFinal);

      if(objDatumCrmLeadEdit!.userId != null && objDatumCrmLeadEdit!.userId!.name.isNotEmpty){
        prspAsignado = true;
      }

    }

  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number = await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

    setState(() {
      this.number = number;
    });
  }

  //final String phoneNumber = "+123456789012"; // Número de ejemplo

  String separatePhoneNumber(String phone) {
    // Expresión regular para dividir el prefijo y el número
    //final regExp = RegExp(r'^\+?(\d{1,4})(\d+)$');
    final regExp = RegExp(r'^\+?(\d{1,3})(\d+)$');
    final match = regExp.firstMatch(phone);

    if (match != null) {
      //final countryCode = match.group(1); // Código de país
      final localNumber = match.group(2); // Número local
      return localNumber ?? '';
      /*
      return {
        "countryCode": countryCode ?? "",
        "localNumber": localNumber ?? "",
      };
      */
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {

    //ColorsApp objColorsApp = ColorsApp();

    //ScrollController scrollListaClt = ScrollController();

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
          title: const Text('Edición de Prospecto'),
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

                  if(campEditSelect.isEmpty && objDatumCrmLeadEdit!.campaignId != null){                      
                    //campEditSelect = lstCampanias.first;
                    campEditSelect = objDatumCrmLeadEdit!.campaignId!.name.isNotEmpty ? objDatumCrmLeadEdit!.campaignId!.name : lstCampanias.first;
                  }

                  if(mediaEditSelect.isEmpty){
                    mediaEditSelect = objDatumCrmLeadEdit!.mediumId.name.isNotEmpty ? objDatumCrmLeadEdit!.mediumId.name : lstMedias.first;
                  }

                  if(originEditSelect.isEmpty){
                    //originEditSelect = lstOrigenes.first;
                    originEditSelect = objDatumCrmLeadEdit!.sourceId.name.isNotEmpty ? objDatumCrmLeadEdit!.sourceId.name : lstOrigenes.first;
                  }

                  if(actEditSelect.isEmpty){
                    actEditSelect = objDatumCrmLeadEdit!.activityIds.isNotEmpty ? objDatumCrmLeadEdit!.activityIds.first.name : lstActividades.first;
                  }

                  if(paisEditSelect.isEmpty){
                    //paisEditSelect = lstPaises.first;
                    paisEditSelect = objDatumCrmLeadEdit!.countryId.name.isNotEmpty ? objDatumCrmLeadEdit!.countryId.name : lstPaises.first;
                  }

                  return Stack(
                    children: [
                      Container(
                        color: Colors.transparent,
                        width: size.width * 0.99,
                        height: size.height * 0.91,
                        alignment: Alignment.topCenter,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [    
                          
                              Container(
                                //color: const Color(0xffF6F6F6),
                                color: Colors.transparent,
                                width: size.width,
                                height: size.height * 0.86,
                                alignment: Alignment.topCenter,
                                child: Column(
                                  children: [
                                
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
                                                  color: tabAccionesEditPrsp == 0
                                                      ? Colors.white
                                                      : Colors.blue.shade800,
                                                  child: Center(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        tabAccionesEditPrsp = 0;
                                                        setState(() {});
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Icon(
                                                            Icons.info_outline,
                                                            color: tabAccionesEditPrsp == 0
                                                                ? Colors.blue.shade800
                                                                : Colors.white,
                                                          ),
                                                          Text(
                                                            'Inf. general',
                                                            style: TextStyle(
                                                              color: tabAccionesEditPrsp == 0
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
                                                  color: tabAccionesEditPrsp == 1
                                                      ? Colors.white
                                                      : Colors.blue.shade800,
                                                  child: Center(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        tabAccionesEditPrsp = 1;
                                                        setState(() {});
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Icon(
                                                            Icons.grid_on_outlined,
                                                            color: tabAccionesEditPrsp == 1
                                                                ? Colors.blue.shade800
                                                                : Colors.white,
                                                          ),
                                                          Text(
                                                            'Inf. Adicional',
                                                            style: TextStyle(
                                                              //color: Colors.purple.shade700,
                                                              color: tabAccionesEditPrsp == 1
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
                                                  color: tabAccionesEditPrsp == 2
                                                      ? Colors.white
                                                      : Colors.blue.shade800,
                                                  child: Center(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        tabAccionesEditPrsp = 2;
                                                        setState(() {});
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Icon(
                                                            Icons.add_business_rounded,
                                                            color: tabAccionesEditPrsp == 2
                                                                ? Colors.blue.shade800
                                                                : Colors.white,
                                                          ),
                                                          Text(
                                                            'Notas Int.',
                                                            style: TextStyle(
                                                              //color: Colors.purple.shade700,
                                                              color: tabAccionesEditPrsp == 2
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
                                        isEnabled: false,
                                      onInputChanged: (PhoneNumber phoneNumber) async {
                                        
                                      },
                                      onInputValidated: (bool isValid) async {
                                        //print("¿Es válido?: $isValid");                                      
                                      },
                                      selectorConfig: const SelectorConfig(
                                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET, // Tipo de selector
                                      ),
                                      ignoreBlank: false,
                                      autoValidateMode: AutovalidateMode.onUserInteraction,
                                      initialValue: number,
                                      textFieldController: telefonoEditTxt,
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
                                      //isEnabled: false,
                                      maxLength: 11,
                                      errorMessage: 'Teléfono no válido',
                                    ),
                                    ),
                                    
                                    SizedBox(
                                      height: size.height * 0.02,
                                    ),
                                
                                    if(tabAccionesEditPrsp == 0)
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
                                                cursorColor: AppLightColors().primary,
                                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                                /*
                                                inputFormatters: [
                                                  //FilteringTextInputFormatter.deny(regexToRemoveEmoji)
                                                ],
                                                */
                                                style: AppTextStyles.bodyRegular(width: size.width),
                                                decoration: InputDecorationCvs.formsDecoration(
                                                  labelText: 'Nombres',
                                                  hintTetx: 'Ej: Juan Valdez',
                                                  size: size
                                                ),
                                                enabled: false,
                                                controller: nombresEditTxt,
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
                                        height: size.height * 0.02,
                                      ),
                          
                                      Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.92,
                                        child: DropdownButtonFormField<String>(
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Seleccione el país...',
                                            ),
                                            value: paisEditSelect,
                                            items: lstPaises
                                                .map((activityPrsp) =>
                                                    DropdownMenuItem(
                                                      value: activityPrsp,
                                                      child: AutoSizeText(activityPrsp, maxLines: 1, minFontSize: 1, maxFontSize: 12,),
                                                    ))
                                                .toList(),
                                            onChanged: (value) {
                                              
                                              setState(() {
                                                paisEditSelect = value ?? '';
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
                                          controller: sectorEditTxt,
                                          //initialValue: 'Norte',
                                          enabled: false,
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
                                      /*
                                      Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.92,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text('Asignado', style: TextStyle(fontSize: 20),),
                                            
                                            Checkbox(
                                              value: prspAsignado,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  prspAsignado = value ?? false;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      */
                                                                        
                                      Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.94,
                                        child: DropdownButtonFormField<String>(
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Seleccione la campaña',
                                          ),
                                          value: campEditSelect,
                                          items: lstCampanias.map((activityPrsp) =>
                                            DropdownMenuItem(
                                              value: activityPrsp,
                                              child: AutoSizeText(activityPrsp, maxLines: 1, minFontSize: 2, maxFontSize: 13,),
                                            )
                                          )
                                          .toList(),
                                          onChanged: (String? newValue) {                        
                                            setState(() {
                                              campEditSelect = newValue ?? '';
                                            });
                                          },
                                        ),
                                      ),
                                                                      
                                      SizedBox(
                                        height: size.height * 0.03,
                                      ),
                          
                                      Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.94,
                                        child: DropdownButtonFormField<String>(
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText:
                                                'Seleccione el origen',
                                          ),
                                          value: originEditSelect,
                                          items: lstOrigenes
                                              .map((activityPrsp) =>
                                                  DropdownMenuItem(
                                                    value: activityPrsp,
                                                    //child: Text(activityPrsp),
                                                    child: AutoSizeText(activityPrsp, maxLines: 1, minFontSize: 2, maxFontSize: 13,),
                                                  ))
                                              .toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              originEditSelect = newValue ?? '';
                                            });
                                          },
                                        ),
                                        ),
                                                                          
                                      SizedBox(
                                        height: size.height * 0.03,
                                      ),
                                            
                                      Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.94,
                                        child: DropdownButtonFormField<String>(
                                                      decoration: const InputDecoration(
                                                        border: OutlineInputBorder(),
                                                        labelText:
                                                            'Seleccione la media',
                                                      ),
                                                      value: mediaEditSelect,
                                                      items: lstMedias
                                                          .map((activityPrsp) =>
                                                              DropdownMenuItem(
                                                                value: activityPrsp,
                                                                //child: Text(activityPrsp),
                                                                child: AutoSizeText(activityPrsp, maxLines: 1, minFontSize: 2, maxFontSize: 13,),
                                                              ))
                                                          .toList(),
                                                      onChanged: (newValue) {
                                                        setState(() {
                                              mediaEditSelect = newValue ?? '';
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
                                        child: TextFormField(
                                          cursorColor: AppLightColors().primary,
                                          autovalidateMode: AutovalidateMode.onUserInteraction,                                        
                                          style: AppTextStyles.bodyRegular(width: size.width),
                                          decoration: InputDecorationCvs.formsDecoration(
                                            labelText: 'Recomendado por',
                                            hintTetx: 'Ej: Norte',
                                            size: size
                                          ),
                                          controller: recomendadoPorEditTxt,
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
                                        height: size.height * 0.025,
                                      ),
                                                                
                                    ],
                                  ),
                                ),
                              ),
                                
                                    if(tabAccionesEditPrsp == 1)
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
                                                  hintText: "100%",
                                                  suffixText: '%',
                                                  labelText: 'Probabilidad'
                                                ),
                                                controller: probabilityEditTxt,
                                                autocorrect: false,
                                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                minLines: 1,
                                                maxLines: 1,
                                                autofocus: false,
                                                maxLength: 5,
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
                                            
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.92,
                                              child: TextFormField(
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
                                                labelText: 'Ingreso esperado en dólares',
                                                hintText: "0.00",
                                                suffixText: '\$',
                                              ),
                                              controller: ingresoEsperadoEditTxt,
                                              autocorrect: false,
                                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                              minLines: 1,
                                              maxLines: 1,
                                              autofocus: false,
                                              maxLength: 7,
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
                                            
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.92,
                                              child: TextFormField(
                                              //initialValue: 'Ecuador',
                                              //initialValue: '',
                                              cursorColor: AppLightColors().primary,
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              
                                              style: AppTextStyles.bodyRegular(width: size.width),
                                              decoration: InputDecorationCvs.formsDecoration(
                                                labelText: 'Correo',
                                                hintTetx: 'Ej: correo@ejemplo.com',
                                                size: size
                                              ),
                                              controller: emailEditTxt,
                                              autocorrect: false,
                                              keyboardType: TextInputType.emailAddress,
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
                                              height: size.height * 0.04,
                                            ),
                                            
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.92,
                                              child: TextFormField(
                          initialValue: fecEditCierre,//DateFormat('dd-MM-yyyy', 'es').format(dateEdPrsp),
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Cierre esperado',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: () async {
                            DateTime? pickedDate =
                                await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              
                              setState(() {
                                //dateEdPrsp = pickedDate;
                                fecEditCierre = DateFormat('dd-MM-yyyy', 'es').format(pickedDate);
                              });
                                    
                            }
                          },
                                              ),
                                                                    
                                            ),
                                            
                                            SizedBox(
                                              height: size.height * 0.02,
                                            ),
                          
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.92,
                                              height: size.height * 0.15,
                                              child: TextFormField(
                          controller: direccionEditTxt,
                                              //initialValue: 'Yordani Oliva',
                                              //initialValue: '',
                                              cursorColor: AppLightColors().primary,
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              inputFormatters: [
                          FilteringTextInputFormatter.deny(regexToRemoveEmoji)
                                              ],
                                              style: AppTextStyles.bodyRegular(width: size.width),
                                              decoration: InputDecorationCvs.formsDecoration(
                          labelText: 'Dirección',
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
                                        height: size.height * 0.025,
                                      ),
                                                                      
                                          ],
                                        ),
                                      ),
                                    ),
                                
                                    if(tabAccionesEditPrsp == 2)
                                    Container(
                                      color: Colors.transparent,
                                      height: size.height * 0.55,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                        
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.92,
                                              height: size.height * 0.22,
                                              child: WebViewWidget(controller: _wvController)
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
                      ),
                  
                      Positioned(
                        left: size.width * 0.042,
                        top: size.height * 0.82,
                        child: Container(
                          color: Colors.transparent,
                          width: size.width * 0.92,
                          alignment: Alignment.topCenter,
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

                                  String gifRespuesta = 'assets/gifs/exito.gif';
                    
                                    if(nombresEditTxt.text.isEmpty){
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

                                    if(direccionEditTxt.text.isEmpty){
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
                    
                                    if(probabilityEditTxt.text.isEmpty){
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
                                    }

                                    if(ingresoEsperadoEditTxt.text.isEmpty){
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
                                            mensajeAlerta: 'Ingrese el monto en dólares.'
                                          );
                                        },
                                      );
                    
                                      return;
                                    }

                                    if(emailEditTxt.text.isEmpty){
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
                                      
                                      if(!regExp.hasMatch(emailEditTxt.text)){
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

                                  /*
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => SimpleDialog(
                                      alignment: Alignment.center,
                                      children: [
                                        SimpleDialogCargando(
                                          null,
                                          mensajeMostrar: 'Estamos editando',
                                          mensajeMostrarDialogCargando: 'los datos del prospecto.',
                                        ),
                                      ]
                                    ),
                                  );

                                  DatumCrmLead objProsp = DatumCrmLead(                                    
                                    
                                    dayClose: double.parse(dateEdPrsp.day.toString()),
                                    id: 0,
                                    name: nombresEditTxt.text,
                                    emailCc: emailEditTxt.text,
                                    priority: '',
                                    type: '',
                                    city: '',
                                    contactName: nombresEditTxt.text,
                                    description: observacionesEditTxt.text,
                                    emailFrom: emailEditTxt.text,
                                    street: direccionEditTxt.text,
                                    phone: telefonoEditTxt.text,
                                    partnerName: nombresEditTxt.text,
                                    mobile: '',
                                    dateOpen: DateTime.now(),
                                    dateDeadline: DateTime.now(),
                                    probability: double.parse(probabilityEditTxt.text),

                                    activityIds: [
                                      StructCombos(id: 2, name: actEditSelect)
                                    ],
                                    campaignId: CampaignId(
                                      id: 2,
                                      name: ''
                                    ),
                                    countryId: StructCombos (
                                      id: 2,
                                      name: paisEditTxt.text
                                    ),
                                    lostReasonId: CampaignId(
                                      id: 2,
                                      name: ''
                                    ),
                                    mediumId: StructCombos (
                                      id: 3,
                                      name: ''
                                    ),
                                    partnerId: StructCombos (
                                      id: 2,
                                      name: ''
                                    ),
                                    sourceId: StructCombos (
                                      id: 2,
                                      name: ''
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
                                    expectedRevenue: double.parse(ingresoEsperadoEditTxt.text),
                                    referred: recomendadoPorEditTxt.text
                                  );

                                  ProspectoRegistroResponseModel objRsp = await ProspectoTypeService().registraProspecto(objProsp);

                                  String respuestaReg = objRsp.result.mensaje;
                                  int estado = objRsp.result.estado;
                                  

                                  if(estado == 200){
                                    gifRespuesta = 'assets/gifs/exito.gif';
                                  } else {
                                    gifRespuesta = 'assets/gifs/gifErrorBlanco.gif';
                                  }

                                  if(objRsp.mensaje.isEmpty){
                                    
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
                                  */

                                  context.pop();
                                  context.pop();
                                  //context.pop();

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
                                                //child: Image.asset(gifRespuesta),
                                                child: Image.asset(gifRespuesta),
                                              ),

                                              Container(
                                                color: Colors.transparent,
                                                width: size.width * 0.95,
                                                height: size.height * 0.08,
                                                alignment: Alignment.center,
                                                child: const AutoSizeText(
                                                  //respuestaReg,
                                                  'Prospecto editado con éxito',
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
                                  text: 'Actualizar',
                                  textStyle: AppTextStyles.h3Bold(
                                      width: size.width,
                                      color: AppLightColors().white),
                                )),
                              ),
                            ],
                          ),
                        ),
                      ),
                            
                    ]
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
