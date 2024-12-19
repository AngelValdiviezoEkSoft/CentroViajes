

import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cvs_ec_app/domain/domain.dart';
import 'package:cvs_ec_app/infraestructure/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:cvs_ec_app/ui/ui.dart';
import 'package:provider/provider.dart';

int tabAccEdit = 0;
late TextEditingController montoN_Txt;
late TextEditingController nombreT_Txt;
DateTime datRegPrs = DateTime.now();
String rutaNuevaFotoPerfil = '';
MemoryImage? nuevaFotoPerfilGen;
String primerNombre = "";
bool validandoFoto = false;
bool tieneMayuscula = false;
  bool tieneMinuscula = false;
  bool tieneNumero = false;
  bool tieneCaracterEspecial = false;
  bool tieneDiezCaracteres = false;
  bool hideIcon = false;
  bool nivelBajo = false;
  bool nivelIntermedioBajoMedioCuartaParte = false;
  bool nivelIntermedioBajoMedio = false;
  bool nivelMedio = false;
  bool nivelIntermedioMedioAlto = false;
  bool nivelAlto = false;
  bool verValidaciones = false;
  
Color coloresTextoRepuesta = Colors.transparent;
Color coloresFondoRepuesta = Colors.transparent;

late TextEditingController passwordAntTxt;
late TextEditingController passwordTxt;
late TextEditingController passwordConfTxt;

String emailUser = '';

class FrmEditPerfilScreen extends StatefulWidget {
  const FrmEditPerfilScreen({super.key});

  @override
  State<FrmEditPerfilScreen> createState() => _FrmEditPerfilScreenState();
}

class _FrmEditPerfilScreenState extends State<FrmEditPerfilScreen> {

  final LocalAuthentication auth = LocalAuthentication();  
  
  @override
  void initState() {
    super.initState();

    passwordAntTxt = TextEditingController();
    passwordTxt = TextEditingController();
    passwordConfTxt = TextEditingController();

    montoN_Txt = TextEditingController();
    nombreT_Txt = TextEditingController();
  }

  
  Future<void> llenaFotoPerfil() async {
    if(nuevaFotoPerfilGen != null) {
      Uint8List bodyBytes = nuevaFotoPerfilGen!.bytes;
      final objFoto = await File(rutaFotoPerfil).writeAsBytes(bodyBytes);

      //print('Bytes vista: $bodyBytes');
      
      final bytes = File(objFoto.path).readAsBytesSync();
      String fotoTmp = base64Encode(bytes);

      //print('Base 64 de la foto: $fotoTmp');

      primerNombre = "Angel";//objPrspValido?.nombres.split(' ')[0] ?? '';
      
      rutaNuevaFotoPerfil = objFoto.path;
      
      FotoPerfilModel objFotoPerfilNueva = FotoPerfilModel(
        base64: fotoTmp,
        extension: rutaFotoPerfil.split('.')[rutaFotoPerfil.split('.').length - 1],//'png',
        nombre: 'foto_perfil_$primerNombre'
      );
      
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {

    final planAct = BlocProvider.of<GenericBloc>(context);

    ColorsApp objColorsApp = ColorsApp();

    //ScrollController scrollListaClt = ScrollController();

    final size = MediaQuery.of(context).size;

    //ignore: unnecessary_string_escapes
    var regexToRemoveEmoji = '   /\uD83C\uDFF4\uDB40\uDC67\uDB40\uDC62(?:\uDB40\uDC77\uDB40\uDC6C\uDB40\uDC73|\uDB40\uDC73\uDB40\uDC63\uDB40\uDC74|\uDB40\uDC65\uDB40\uDC6E\uDB40\uDC67)\uDB40\uDC7F|\uD83D\uDC69\u200D\uD83D\uDC69\u200D(?:\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67]))|\uD83D\uDC68(?:\uD83C\uDFFF\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB-\uDFFE])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFE\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB-\uDFFD\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFD\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB\uDFFC\uDFFE\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFC\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFB\uDFFD-\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFB\u200D(?:\uD83E\uDD1D\u200D\uD83D\uDC68(?:\uD83C[\uDFFC-\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\u200D(?:\u2764\uFE0F\u200D(?:\uD83D\uDC8B\u200D)?\uD83D\uDC68|(?:\uD83D[\uDC68\uDC69])\u200D(?:\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67]))|\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67])|(?:\uD83D[\uDC68\uDC69])\u200D(?:\uD83D[\uDC66\uDC67])|[\u2695\u2696\u2708]\uFE0F|\uD83D[\uDC66\uDC67]|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|(?:\uD83C\uDFFF\u200D[\u2695\u2696\u2708]|\uD83C\uDFFE\u200D[\u2695\u2696\u2708]|\uD83C\uDFFD\u200D[\u2695\u2696\u2708]|\uD83C\uDFFC\u200D[\u2695\u2696\u2708]|\uD83C\uDFFB\u200D[\u2695\u2696\u2708])\uFE0F|\uD83C\uDFFF|\uD83C\uDFFE|\uD83C\uDFFD|\uD83C\uDFFC|\uD83C\uDFFB)?|\uD83E\uDDD1(?:(?:\uD83C[\uDFFB-\uDFFF])\u200D(?:\uD83E\uDD1D\u200D\uD83E\uDDD1(?:\uD83C[\uDFFB-\uDFFF])|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\u200D(?:\uD83E\uDD1D\u200D\uD83E\uDDD1|\uD83C[\uDF3E\uDF73\uDF7C\uDF84\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD]))|\uD83D\uDC69(?:\u200D(?:\u2764\uFE0F\u200D(?:\uD83D\uDC8B\u200D(?:\uD83D[\uDC68\uDC69])|\uD83D[\uDC68\uDC69])|\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFF\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFE\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFD\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFC\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD])|\uD83C\uDFFB\u200D(?:\uD83C[\uDF3E\uDF73\uDF7C\uDF93\uDFA4\uDFA8\uDFEB\uDFED]|\uD83D[\uDCBB\uDCBC\uDD27\uDD2C\uDE80\uDE92]|\uD83E[\uDDAF-\uDDB3\uDDBC\uDDBD]))|\uD83D\uDC69\uD83C\uDFFF\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB-\uDFFE])|\uD83D\uDC69\uD83C\uDFFE\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB-\uDFFD\uDFFF])|\uD83D\uDC69\uD83C\uDFFD\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB\uDFFC\uDFFE\uDFFF])|\uD83D\uDC69\uD83C\uDFFC\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFB\uDFFD-\uDFFF])|\uD83D\uDC69\uD83C\uDFFB\u200D\uD83E\uDD1D\u200D(?:\uD83D[\uDC68\uDC69])(?:\uD83C[\uDFFC-\uDFFF])|\uD83D\uDC69\u200D\uD83D\uDC66\u200D\uD83D\uDC66|\uD83D\uDC69\u200D\uD83D\uDC69\u200D(?:\uD83D[\uDC66\uDC67])|(?:\uD83D\uDC41\uFE0F\u200D\uD83D\uDDE8|\uD83D\uDC69(?:\uD83C\uDFFF\u200D[\u2695\u2696\u2708]|\uD83C\uDFFE\u200D[\u2695\u2696\u2708]|\uD83C\uDFFD\u200D[\u2695\u2696\u2708]|\uD83C\uDFFC\u200D[\u2695\u2696\u2708]|\uD83C\uDFFB\u200D[\u2695\u2696\u2708]|\u200D[\u2695\u2696\u2708])|\uD83C\uDFF3\uFE0F\u200D\u26A7|\uD83E\uDDD1(?:(?:\uD83C[\uDFFB-\uDFFF])\u200D[\u2695\u2696\u2708]|\u200D[\u2695\u2696\u2708])|\uD83D\uDC3B\u200D\u2744|(?:(?:\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD])(?:\uD83C[\uDFFB-\uDFFF])|\uD83D\uDC6F|\uD83E[\uDD3C\uDDDE\uDDDF])\u200D[\u2640\u2642]|(?:\u26F9|\uD83C[\uDFCB\uDFCC]|\uD83D\uDD75)(?:\uFE0F|\uD83C[\uDFFB-\uDFFF])\u200D[\u2640\u2642]|\uD83C\uDFF4\u200D\u2620|(?:\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD])\u200D[\u2640\u2642]|[\xA9\xAE\u203C\u2049\u2122\u2139\u2194-\u2199\u21A9\u21AA\u2328\u23CF\u23ED-\u23EF\u23F1\u23F2\u23F8-\u23FA\u24C2\u25AA\u25AB\u25B6\u25C0\u25FB\u25FC\u2600-\u2604\u260E\u2611\u2618\u2620\u2622\u2623\u2626\u262A\u262E\u262F\u2638-\u263A\u2640\u2642\u265F\u2660\u2663\u2665\u2666\u2668\u267B\u267E\u2692\u2694-\u2697\u2699\u269B\u269C\u26A0\u26A7\u26B0\u26B1\u26C8\u26CF\u26D1\u26D3\u26E9\u26F0\u26F1\u26F4\u26F7\u26F8\u2702\u2708\u2709\u270F\u2712\u2714\u2716\u271D\u2721\u2733\u2734\u2744\u2747\u2763\u2764\u27A1\u2934\u2935\u2B05-\u2B07\u3030\u303D\u3297\u3299]|\uD83C[\uDD70\uDD71\uDD7E\uDD7F\uDE02\uDE37\uDF21\uDF24-\uDF2C\uDF36\uDF7D\uDF96\uDF97\uDF99-\uDF9B\uDF9E\uDF9F\uDFCD\uDFCE\uDFD4-\uDFDF\uDFF5\uDFF7]|\uD83D[\uDC3F\uDCFD\uDD49\uDD4A\uDD6F\uDD70\uDD73\uDD76-\uDD79\uDD87\uDD8A-\uDD8D\uDDA5\uDDA8\uDDB1\uDDB2\uDDBC\uDDC2-\uDDC4\uDDD1-\uDDD3\uDDDC-\uDDDE\uDDE1\uDDE3\uDDE8\uDDEF\uDDF3\uDDFA\uDECB\uDECD-\uDECF\uDEE0-\uDEE5\uDEE9\uDEF0\uDEF3])\uFE0F|\uD83D\uDC69\u200D\uD83D\uDC67\u200D(?:\uD83D[\uDC66\uDC67])|\uD83C\uDFF3\uFE0F\u200D\uD83C\uDF08|\uD83D\uDC69\u200D\uD83D\uDC67|\uD83D\uDC69\u200D\uD83D\uDC66|\uD83D\uDC15\u200D\uD83E\uDDBA|\uD83D\uDC69(?:\uD83C\uDFFF|\uD83C\uDFFE|\uD83C\uDFFD|\uD83C\uDFFC|\uD83C\uDFFB)?|\uD83C\uDDFD\uD83C\uDDF0|\uD83C\uDDF6\uD83C\uDDE6|\uD83C\uDDF4\uD83C\uDDF2|\uD83D\uDC08\u200D\u2B1B|\uD83D\uDC41\uFE0F|\uD83C\uDFF3\uFE0F|\uD83E\uDDD1(?:\uD83C[\uDFFB-\uDFFF])?|\uD83C\uDDFF(?:\uD83C[\uDDE6\uDDF2\uDDFC])|\uD83C\uDDFE(?:\uD83C[\uDDEA\uDDF9])|\uD83C\uDDFC(?:\uD83C[\uDDEB\uDDF8])|\uD83C\uDDFB(?:\uD83C[\uDDE6\uDDE8\uDDEA\uDDEC\uDDEE\uDDF3\uDDFA])|\uD83C\uDDFA(?:\uD83C[\uDDE6\uDDEC\uDDF2\uDDF3\uDDF8\uDDFE\uDDFF])|\uD83C\uDDF9(?:\uD83C[\uDDE6\uDDE8\uDDE9\uDDEB-\uDDED\uDDEF-\uDDF4\uDDF7\uDDF9\uDDFB\uDDFC\uDDFF])|\uD83C\uDDF8(?:\uD83C[\uDDE6-\uDDEA\uDDEC-\uDDF4\uDDF7-\uDDF9\uDDFB\uDDFD-\uDDFF])|\uD83C\uDDF7(?:\uD83C[\uDDEA\uDDF4\uDDF8\uDDFA\uDDFC])|\uD83C\uDDF5(?:\uD83C[\uDDE6\uDDEA-\uDDED\uDDF0-\uDDF3\uDDF7-\uDDF9\uDDFC\uDDFE])|\uD83C\uDDF3(?:\uD83C[\uDDE6\uDDE8\uDDEA-\uDDEC\uDDEE\uDDF1\uDDF4\uDDF5\uDDF7\uDDFA\uDDFF])|\uD83C\uDDF2(?:\uD83C[\uDDE6\uDDE8-\uDDED\uDDF0-\uDDFF])|\uD83C\uDDF1(?:\uD83C[\uDDE6-\uDDE8\uDDEE\uDDF0\uDDF7-\uDDFB\uDDFE])|\uD83C\uDDF0(?:\uD83C[\uDDEA\uDDEC-\uDDEE\uDDF2\uDDF3\uDDF5\uDDF7\uDDFC\uDDFE\uDDFF])|\uD83C\uDDEF(?:\uD83C[\uDDEA\uDDF2\uDDF4\uDDF5])|\uD83C\uDDEE(?:\uD83C[\uDDE8-\uDDEA\uDDF1-\uDDF4\uDDF6-\uDDF9])|\uD83C\uDDED(?:\uD83C[\uDDF0\uDDF2\uDDF3\uDDF7\uDDF9\uDDFA])|\uD83C\uDDEC(?:\uD83C[\uDDE6\uDDE7\uDDE9-\uDDEE\uDDF1-\uDDF3\uDDF5-\uDDFA\uDDFC\uDDFE])|\uD83C\uDDEB(?:\uD83C[\uDDEE-\uDDF0\uDDF2\uDDF4\uDDF7])|\uD83C\uDDEA(?:\uD83C[\uDDE6\uDDE8\uDDEA\uDDEC\uDDED\uDDF7-\uDDFA])|\uD83C\uDDE9(?:\uD83C[\uDDEA\uDDEC\uDDEF\uDDF0\uDDF2\uDDF4\uDDFF])|\uD83C\uDDE8(?:\uD83C[\uDDE6\uDDE8\uDDE9\uDDEB-\uDDEE\uDDF0-\uDDF5\uDDF7\uDDFA-\uDDFF])|\uD83C\uDDE7(?:\uD83C[\uDDE6\uDDE7\uDDE9-\uDDEF\uDDF1-\uDDF4\uDDF6-\uDDF9\uDDFB\uDDFC\uDDFE\uDDFF])|\uD83C\uDDE6(?:\uD83C[\uDDE8-\uDDEC\uDDEE\uDDF1\uDDF2\uDDF4\uDDF6-\uDDFA\uDDFC\uDDFD\uDDFF])|[#\*0-9]\uFE0F\u20E3|(?:\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD])(?:\uD83C[\uDFFB-\uDFFF])|(?:\u26F9|\uD83C[\uDFCB\uDFCC]|\uD83D\uDD75)(?:\uFE0F|\uD83C[\uDFFB-\uDFFF])|\uD83C\uDFF4|(?:[\u270A\u270B]|\uD83C[\uDF85\uDFC2\uDFC7]|\uD83D[\uDC42\uDC43\uDC46-\uDC50\uDC66\uDC67\uDC6B-\uDC6D\uDC72\uDC74-\uDC76\uDC78\uDC7C\uDC83\uDC85\uDCAA\uDD7A\uDD95\uDD96\uDE4C\uDE4F\uDEC0\uDECC]|\uD83E[\uDD0C\uDD0F\uDD18-\uDD1C\uDD1E\uDD1F\uDD30-\uDD34\uDD36\uDD77\uDDB5\uDDB6\uDDBB\uDDD2-\uDDD5])(?:\uD83C[\uDFFB-\uDFFF])|(?:[\u261D\u270C\u270D]|\uD83D[\uDD74\uDD90])(?:\uFE0F|\uD83C[\uDFFB-\uDFFF])|[\u270A\u270B]|\uD83C[\uDF85\uDFC2\uDFC7]|\uD83D[\uDC08\uDC15\uDC3B\uDC42\uDC43\uDC46-\uDC50\uDC66\uDC67\uDC6B-\uDC6D\uDC72\uDC74-\uDC76\uDC78\uDC7C\uDC83\uDC85\uDCAA\uDD7A\uDD95\uDD96\uDE4C\uDE4F\uDEC0\uDECC]|\uD83E[\uDD0C\uDD0F\uDD18-\uDD1C\uDD1E\uDD1F\uDD30-\uDD34\uDD36\uDD77\uDDB5\uDDB6\uDDBB\uDDD2-\uDDD5]|\uD83C[\uDFC3\uDFC4\uDFCA]|\uD83D[\uDC6E\uDC70\uDC71\uDC73\uDC77\uDC81\uDC82\uDC86\uDC87\uDE45-\uDE47\uDE4B\uDE4D\uDE4E\uDEA3\uDEB4-\uDEB6]|\uD83E[\uDD26\uDD35\uDD37-\uDD39\uDD3D\uDD3E\uDDB8\uDDB9\uDDCD-\uDDCF\uDDD6-\uDDDD]|\uD83D\uDC6F|\uD83E[\uDD3C\uDDDE\uDDDF]|[\u231A\u231B\u23E9-\u23EC\u23F0\u23F3\u25FD\u25FE\u2614\u2615\u2648-\u2653\u267F\u2693\u26A1\u26AA\u26AB\u26BD\u26BE\u26C4\u26C5\u26CE\u26D4\u26EA\u26F2\u26F3\u26F5\u26FA\u26FD\u2705\u2728\u274C\u274E\u2753-\u2755\u2757\u2795-\u2797\u27B0\u27BF\u2B1B\u2B1C\u2B50\u2B55]|\uD83C[\uDC04\uDCCF\uDD8E\uDD91-\uDD9A\uDE01\uDE1A\uDE2F\uDE32-\uDE36\uDE38-\uDE3A\uDE50\uDE51\uDF00-\uDF20\uDF2D-\uDF35\uDF37-\uDF7C\uDF7E-\uDF84\uDF86-\uDF93\uDFA0-\uDFC1\uDFC5\uDFC6\uDFC8\uDFC9\uDFCF-\uDFD3\uDFE0-\uDFF0\uDFF8-\uDFFF]|\uD83D[\uDC00-\uDC07\uDC09-\uDC14\uDC16-\uDC3A\uDC3C-\uDC3E\uDC40\uDC44\uDC45\uDC51-\uDC65\uDC6A\uDC79-\uDC7B\uDC7D-\uDC80\uDC84\uDC88-\uDCA9\uDCAB-\uDCFC\uDCFF-\uDD3D\uDD4B-\uDD4E\uDD50-\uDD67\uDDA4\uDDFB-\uDE44\uDE48-\uDE4A\uDE80-\uDEA2\uDEA4-\uDEB3\uDEB7-\uDEBF\uDEC1-\uDEC5\uDED0-\uDED2\uDED5-\uDED7\uDEEB\uDEEC\uDEF4-\uDEFC\uDFE0-\uDFEB]|\uD83E[\uDD0D\uDD0E\uDD10-\uDD17\uDD1D\uDD20-\uDD25\uDD27-\uDD2F\uDD3A\uDD3F-\uDD45\uDD47-\uDD76\uDD78\uDD7A-\uDDB4\uDDB7\uDDBA\uDDBC-\uDDCB\uDDD0\uDDE0-\uDDFF\uDE70-\uDE74\uDE78-\uDE7A\uDE80-\uDE86\uDE90-\uDEA8\uDEB0-\uDEB6\uDEC0-\uDEC2\uDED0-\uDED6]|(?:[\u231A\u231B\u23E9-\u23EC\u23F0\u23F3\u25FD\u25FE\u2614\u2615\u2648-\u2653\u267F\u2693\u26A1\u26AA\u26AB\u26BD\u26BE\u26C4\u26C5\u26CE\u26D4\u26EA\u26F2\u26F3\u26F5\u26FA\u26FD\u2705\u270A\u270B\u2728\u274C\u274E\u2753-\u2755\u2757\u2795-\u2797\u27B0\u27BF\u2B1B\u2B1C\u2B50\u2B55]|\uD83C[\uDC04\uDCCF\uDD8E\uDD91-\uDD9A\uDDE6-\uDDFF\uDE01\uDE1A\uDE2F\uDE32-\uDE36\uDE38-\uDE3A\uDE50\uDE51\uDF00-\uDF20\uDF2D-\uDF35\uDF37-\uDF7C\uDF7E-\uDF93\uDFA0-\uDFCA\uDFCF-\uDFD3\uDFE0-\uDFF0\uDFF4\uDFF8-\uDFFF]|\uD83D[\uDC00-\uDC3E\uDC40\uDC42-\uDCFC\uDCFF-\uDD3D\uDD4B-\uDD4E\uDD50-\uDD67\uDD7A\uDD95\uDD96\uDDA4\uDDFB-\uDE4F\uDE80-\uDEC5\uDECC\uDED0-\uDED2\uDED5-\uDED7\uDEEB\uDEEC\uDEF4-\uDEFC\uDFE0-\uDFEB]|\uD83E[\uDD0C-\uDD3A\uDD3C-\uDD45\uDD47-\uDD78\uDD7A-\uDDCB\uDDCD-\uDDFF\uDE70-\uDE74\uDE78-\uDE7A\uDE80-\uDE86\uDE90-\uDEA8\uDEB0-\uDEB6\uDEC0-\uDEC2\uDED0-\uDED6])|(?:[#\*0-9\xA9\xAE\u203C\u2049\u2122\u2139\u2194-\u2199\u21A9\u21AA\u231A\u231B\u2328\u23CF\u23E9-\u23F3\u23F8-\u23FA\u24C2\u25AA\u25AB\u25B6\u25C0\u25FB-\u25FE\u2600-\u2604\u260E\u2611\u2614\u2615\u2618\u261D\u2620\u2622\u2623\u2626\u262A\u262E\u262F\u2638-\u263A\u2640\u2642\u2648-\u2653\u265F\u2660\u2663\u2665\u2666\u2668\u267B\u267E\u267F\u2692-\u2697\u2699\u269B\u269C\u26A0\u26A1\u26A7\u26AA\u26AB\u26B0\u26B1\u26BD\u26BE\u26C4\u26C5\u26C8\u26CE\u26CF\u26D1\u26D3\u26D4\u26E9\u26EA\u26F0-\u26F5\u26F7-\u26FA\u26FD\u2702\u2705\u2708-\u270D\u270F\u2712\u2714\u2716\u271D\u2721\u2728\u2733\u2734\u2744\u2747\u274C\u274E\u2753-\u2755\u2757\u2763\u2764\u2795-\u2797\u27A1\u27B0\u27BF\u2934\u2935\u2B05-\u2B07\u2B1B\u2B1C\u2B50\u2B55\u3030\u303D\u3297\u3299]|\uD83C[\uDC04\uDCCF\uDD70\uDD71\uDD7E\uDD7F\uDD8E\uDD91-\uDD9A\uDDE6-\uDDFF\uDE01\uDE02\uDE1A\uDE2F\uDE32-\uDE3A\uDE50\uDE51\uDF00-\uDF21\uDF24-\uDF93\uDF96\uDF97\uDF99-\uDF9B\uDF9E-\uDFF0\uDFF3-\uDFF5\uDFF7-\uDFFF]|\uD83D[\uDC00-\uDCFD\uDCFF-\uDD3D\uDD49-\uDD4E\uDD50-\uDD67\uDD6F\uDD70\uDD73-\uDD7A\uDD87\uDD8A-\uDD8D\uDD90\uDD95\uDD96\uDDA4\uDDA5\uDDA8\uDDB1\uDDB2\uDDBC\uDDC2-\uDDC4\uDDD1-\uDDD3\uDDDC-\uDDDE\uDDE1\uDDE3\uDDE8\uDDEF\uDDF3\uDDFA-\uDE4F\uDE80-\uDEC5\uDECB-\uDED2\uDED5-\uDED7\uDEE0-\uDEE5\uDEE9\uDEEB\uDEEC\uDEF0\uDEF3-\uDEFC\uDFE0-\uDFEB]|\uD83E[\uDD0C-\uDD3A\uDD3C-\uDD45\uDD47-\uDD78\uDD7A-\uDDCB\uDDCD-\uDDFF\uDE70-\uDE74\uDE78-\uDE7A\uDE80-\uDE86\uDE90-\uDEA8\uDEB0-\uDEB6\uDEC0-\uDEC2\uDED0-\uDED6])\uFE0F|(?:[\u261D\u26F9\u270A-\u270D]|\uD83C[\uDF85\uDFC2-\uDFC4\uDFC7\uDFCA-\uDFCC]|\uD83D[\uDC42\uDC43\uDC46-\uDC50\uDC66-\uDC78\uDC7C\uDC81-\uDC83\uDC85-\uDC87\uDC8F\uDC91\uDCAA\uDD74\uDD75\uDD7A\uDD90\uDD95\uDD96\uDE45-\uDE47\uDE4B-\uDE4F\uDEA3\uDEB4-\uDEB6\uDEC0\uDECC]|\uD83E[\uDD0C\uDD0F\uDD18-\uDD1F\uDD26\uDD30-\uDD39\uDD3C-\uDD3E\uDD77\uDDB5\uDDB6\uDDB8\uDDB9\uDDBB\uDDCD-\uDDCF\uDDD1-\uDDDD])/';


    onPassWordChanged(String password) {
      final numericRegex = RegExp(r'[0-9]');
      final mayusculaRegex = RegExp(r'[A-Z]');
      final minusculaRegex = RegExp(r'[a-z]');
      final caracterEspecialRegex = RegExp(r'[\u0021-\u002b\u003c-\u0040]');

      if (numericRegex.hasMatch(password)) {
        tieneNumero = true;
      } else {
        tieneNumero = false;
      }

      if (mayusculaRegex.hasMatch(password)) {
        tieneMayuscula = true;
      } else {
        tieneMayuscula = false;
      }

      if (minusculaRegex.hasMatch(password)) {
        tieneMinuscula = true;
      } else {
        tieneMinuscula = false;
      }

      if (caracterEspecialRegex.hasMatch(password)) {
        tieneCaracterEspecial = true;
      } else {
        tieneCaracterEspecial = false;
      }

      if (password == '') {
        tieneNumero = false;
        tieneMayuscula = false;
        tieneMinuscula = false;
        tieneCaracterEspecial = false;
        nivelBajo = false;
        nivelMedio = false;
        nivelAlto = false;
        nivelIntermedioBajoMedio = false;
        nivelIntermedioMedioAlto = false;
        tieneDiezCaracteres = false;
      } else {
        if (password.length <= 8) {
          tieneDiezCaracteres = false;
          if (password.length >= 7 && password.length < 9) {
            nivelIntermedioBajoMedio = true;
          } else {
            nivelIntermedioBajoMedio = false;
          }
          nivelBajo = true;
          nivelMedio = false;
          nivelAlto = false;
        } else {
          if (password.length >= 9 && password.length <= 13) {
            tieneDiezCaracteres = false;
            if (password.length >= 10 && password.length < 14) {
              nivelIntermedioMedioAlto = true;
              tieneDiezCaracteres = true;
            } else {
              nivelIntermedioMedioAlto = false;
            }
            nivelMedio = true;
            nivelAlto = false;
          } else {
            if (password.length >= 14 && password.length <= 20) {
              nivelAlto = true;
            }
          }
        }
      }

      setState(() {});
    }

    final authService = Provider.of<AuthService>(context);

    final regularExp = CvsRegExp();
    
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
        title: const Text('Editar Perfil'),
      ),
      body: BlocBuilder<GenericBloc, GenericState>(
        builder: (context,state) {
 
          return FutureBuilder(
          future: state.readDatosPerfil(),
          builder: (context, snapshot) {

            String nombresCompletos = '';
            String user = '';
            String uid = '';

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

            if(snapshot.hasData) {
              
              String rspData = snapshot.data as String;

              final data = json.decode(rspData);

              nombresCompletos = data["result"]["name"];
              user = data["result"]["username"];
              uid = data["result"]["uid"].toString();
              //emailUser = data["result"]["uid"].toString();
            }

              return Container(
                color: Colors.transparent,
                width: size.width,
                height: size.height * 1.5,
                child: SingleChildScrollView(
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
                                    color: tabAccEdit == 0
                                        ? Colors.white
                                        : Colors.blue.shade800,
                                    child: Center(
                                      child: TextButton(
                                        onPressed: () {
                                          tabAccEdit = 0;
                                          setState(() {});
                                        },
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.info_outline,
                                              color: tabAccEdit == 0
                                                  ? Colors.blue.shade800
                                                  : Colors.white,
                                            ),
                                            Text(
                                              'Datos Personales',
                                              style: TextStyle(
                                                color: tabAccEdit == 0
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
                                    color: tabAccEdit == 1
                                        ? Colors.white
                                        : Colors.blue.shade800,
                                    child: Center(
                                      child: TextButton(
                                        onPressed: () {
                                          tabAccEdit = 1;
                                          setState(() {});
                                        },
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.grid_on_outlined,
                                              color: tabAccEdit == 1
                                                  ? Colors.blue.shade800
                                                  : Colors.white,
                                            ),
                                            Text(
                                              'Contraseña',
                                              style: TextStyle(
                                                //color: Colors.purple.shade700,
                                                color: tabAccEdit == 1
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
              
                      Container(
                        color: Colors.transparent,
                        height: size.height * 0.87,
                        child: Column(
                          children: [
                                        
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                                        
                            if(rutaNuevaFotoPerfil == '' && tabAccEdit == 0)
                            Container(
                              color: Colors.transparent,
                              height: size.height * 0.18,
                              width: size.width * 0.33,
                              child: GestureDetector(
                                onTap: () async {
                                  final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
                                        
                                  try {
                                    if (pickedFile != null) {
                                      final croppedFile = await ImageCropper().cropImage(
                                        sourcePath: pickedFile.path,
                                        compressFormat: ImageCompressFormat.png,
                                        compressQuality: 100,
                                        /*
                                        uiSettings: [
                                          AndroidUiSettings(
                                            hideBottomControls: true,
                                            toolbarTitle: 'Recortando',
                                            toolbarColor: Colors.deepOrange,
                                            toolbarWidgetColor: Colors.white,
                                            initAspectRatio: CropAspectRatioPreset.square,
                                            lockAspectRatio: false
                                          ),
                                          IOSUiSettings(
                                            title: 'Recortando',
                                          ),
                                          //ignore: use_build_context_synchronously
                                          WebUiSettings(
                                            context: context,
                                          ),
                                        ],
                                        */
                                      );
                                      if (croppedFile != null) {
                                        final bytes = File(croppedFile.path).readAsBytesSync();
                                        String img64 = base64Encode(bytes);
                                        
                                        FotoPerfilModel objFotoPerfilNueva = FotoPerfilModel(
                                          base64: img64,
                                          extension: 'png',
                                          nombre: 'foto_perfil_$primerNombre'
                                        );
                        
                                        rutaNuevaFotoPerfil = croppedFile.path;
                                        
                                        validandoFoto = false;
                                        
                                        setState(() {});
                                      
                                      }
                                    }
                                  } catch(_) {
                                    
                                  }
                                },
                                child: AvatarGlow(
                                  animate: true,
                                  repeat: true,
                                  //glow
                                  //showTwoGlows: false,
                                  glowColor: Colors.orangeAccent,
                                  glowRadiusFactor: size.width * 0.16,
                                  //endRadius: size.width * 0.16,
                                  child: !validandoFoto ? 
                                    Image.asset(
                                      'assets/images/btnAgregarFotoPerfil.png',
                                      height: size.height * 0.35,
                                    )
                                    :
                                    SpinKitFadingCircle(
                                      size: 35,
                                      itemBuilder: (BuildContext context, int index) {
                                        return DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: index.isEven
                                              ? Colors.black12
                                              : Colors.white,
                                          ),
                                        );
                                      },
                                    ),
                                ),
                              ),
                            ),
                                          
                            if(rutaNuevaFotoPerfil != '' && tabAccEdit == 0)
                            Container(
                              height: size.height * 0.165,
                              width: size.width * 0.33,
                              decoration: !validandoFoto ? 
                              BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(File(rutaNuevaFotoPerfil)),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(size.width * 0.2),
                                border: Border.all(
                                  width: 3,
                                  color: objColorsApp.naranja50PorcTrans,
                                  style: BorderStyle.solid,
                                ),
                              )
                              :
                              BoxDecoration(
                                borderRadius: BorderRadius.circular(size.width * 0.2),
                                border: Border.all(
                                  width: 3,
                                  color: objColorsApp.naranja50PorcTrans,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
                              
                                  try {
                                    if (pickedFile != null) {
                                      final croppedFile = await ImageCropper().cropImage(
                                        
                                        sourcePath: pickedFile.path,
                                        compressFormat: ImageCompressFormat.png,
                                        compressQuality: 100,
                                        /*
                                        uiSettings: [
                                          AndroidUiSettings(
                                            hideBottomControls: true,
                                            toolbarTitle: 'Recortando',
                                            toolbarColor: Colors.deepOrange,
                                            toolbarWidgetColor: Colors.white,
                                            initAspectRatio: CropAspectRatioPreset.square,
                                            lockAspectRatio: false
                                          ),
                                          IOSUiSettings(
                                            title: 'Recortando',
                                          ),
                                          //ignore: use_build_context_synchronously
                                          WebUiSettings(
                                            context: context,
                                          ),
                                        ],
                                        */
                                      );
                                      if (croppedFile != null) {
                                        final bytes = File(croppedFile.path).readAsBytesSync();
                                        String img64 = base64Encode(bytes);
                              
                                        FotoPerfilModel objFotoPerfilNueva = FotoPerfilModel(
                                          base64: img64,
                                          extension: 'png',
                                          nombre: 'foto_perfil_$primerNombre'
                                        );
                              
                                        validandoFoto = false;
                        
                                        rutaNuevaFotoPerfil = croppedFile.path;
                              
                                        setState(() {});
                                        /*
                              
                                        ClientTypeResponse objRspValidacionFoto = await UserFormService().verificacionFotoPerfil(null,objFotoPerfilNueva);
                              
                                        if(objRspValidacionFoto.succeeded) {
                                          coloresTextoRepuesta = Colors.white;
                                          coloresFondoRepuesta = Colors.green;
                                        } else {
                                          coloresTextoRepuesta = Colors.white;
                                          coloresFondoRepuesta = Colors.red;
                                        }
                              
                                        Fluttertoast.showToast(
                                          msg: !objRspValidacionFoto.succeeded ? 'Debe colocar su rostro para la foto de perfil.' : objRspValidacionFoto.message,
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.TOP,
                                          timeInSecForIosWeb: 5,
                                          backgroundColor: coloresFondoRepuesta,
                                          textColor: coloresTextoRepuesta,
                                          fontSize: 16.0
                                        );
                              
                                        if(!objRspValidacionFoto.succeeded) {
                                          validandoFoto = false;
                                          setState(() {});
                                          return;
                                        }
                                        
                                        rutaNuevaFotoPerfil = croppedFile.path;
                              
                                        //varObjetoProspectoFunc!.imagenPerfil = objFotoPerfilNueva;
                                        //varObjProspecto!.imagenPerfil = objFotoPerfilNueva;
                                        
                                        validandoFoto = false;
                                        setState(() {});
                                        */
                                      }
                                    }
                                  } catch(_) {
                                    
                                  }
                                },
                                child: validandoFoto ? SpinKitFadingCircle(
                                  size: 35,
                                  itemBuilder: (BuildContext context, int index) {
                                    return DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: index.isEven
                                          ? Colors.black12
                                          : Colors.white,
                                      ),
                                    );
                                  },
                                )
                                :
                                null
                              )
                            ),
                                  
                            Container(
                              //color: const Color(0xffF6F6F6),
                              color: Colors.transparent,
                              width: size.width,
                              //height: size.height * state.heightModalPlanAct,//0.65,
                              height: size.height * 0.65,
                              //height: size.height * 0.85,
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [
                              
                                  Container(
                                    color: Colors.transparent,
                                    
                                    height: size.height * 0.62,
                                    //height: size.height * 0.85,
                                    child: Column(
                                      children: [
                                            
                                        if(tabAccEdit == 0)
                                        Container(
                                          color: Colors.transparent,
                                          width: size.width * 0.92,
                                          child: const AutoSizeText(
                                            'Nombres',
                                            presetFontSizes: [18,16,14,12,10,8,6],
                                            maxLines: 2,
                                            minFontSize: 4,
                                          ),
                                        ),

                                        if(tabAccEdit == 0)
                                        Container(
                                          color: Colors.transparent,
                                          width: size.width * 0.92,
                                          child: AutoSizeText(
                                            nombresCompletos,
                                            maxLines: 2,
                                            minFontSize: 4,
                                          ),
                                        ),
                                        
                                        if(tabAccEdit == 0)
                                        SizedBox(
                                          height: size.height * 0.02,
                                        ),

                                        if(tabAccEdit == 0)
                                        Container(
                                          color: Colors.transparent,
                                          width: size.width * 0.92,
                                          child: const AutoSizeText(
                                            'Usuario',
                                            presetFontSizes: [18,16,14,12,10,8,6],
                                            maxLines: 2,
                                            minFontSize: 4,
                                          ),
                                        ),

                                        if(tabAccEdit == 0)
                                        Container(
                                          color: Colors.transparent,
                                          width: size.width * 0.92,
                                          child: AutoSizeText(
                                            user,
                                            maxLines: 2,
                                            minFontSize: 4,
                                          ),
                                        ),
                                        
                                        if(tabAccEdit == 0)
                                        SizedBox(
                                          height: size.height * 0.02,
                                        ),

                                        if(tabAccEdit == 0)
                                        Container(
                                          color: Colors.transparent,
                                          width: size.width * 0.92,
                                          child: const AutoSizeText(
                                            'UID',
                                            presetFontSizes: [18,16,14,12,10,8,6],
                                            maxLines: 2,
                                            minFontSize: 4,
                                          ),
                                        ),

                                        if(tabAccEdit == 0)
                                        Container(
                                          color: Colors.transparent,
                                          width: size.width * 0.92,
                                          child: AutoSizeText(
                                            uid,
                                            maxLines: 2,
                                            minFontSize: 4,
                                          ),
                                        ),
                                        
                                        if(tabAccEdit == 0)
                                        SizedBox(
                                          height: size.height * 0.02,
                                        ),
                                    
                                        if(tabAccEdit == 1)
                                        Container(
                                          width: size.width * 0.97,
                                          padding: const EdgeInsets.all(10),  // Espaciado interno
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50), // Bordes redondeados
                                            color: Colors.white
                                          ),
                                          child: TextField(
                                            controller: passwordAntTxt,
                                            obscureText: authService.varIsOscured,
                                            decoration: InputDecoration(
                                              labelText: 'Contraseña Actual',
                                              suffixIcon: //Icon(Icons.visibility),
                                              !authService.varIsOscured
                                                ? IconButton(
                                                    onPressed: () {
                                                      authService.varIsOscured =
                                                          !authService.varIsOscured;
                                                    },
                                                    icon: Icon(Icons.visibility,
                                                        size: 24,
                                                        color: AppLightColors()
                                                            .gray900PrimaryText),
                                                  )
                                                : IconButton(
                                                    onPressed: () {
                                                      authService.varIsOscured =
                                                          !authService.varIsOscured;
                                                    },
                                                    icon: Icon(
                                                        size: 24,
                                                        Icons.visibility_off,
                                                        color: AppLightColors()
                                                            .gray900PrimaryText),
                                                  ),
                                                        
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                            ),
                                            onChanged: (value) {
                                              /*
                                              setState(() {
                                                  verValidaciones = true;
                                                  
                                                });
                                              onPassWordChanged(value.toString());
                                              */
                                            },
                                            onTap: () {
                                              
                                            },
                                            onTapOutside: (event) {
                                              FocusScope.of(context).unfocus();
                                                        
                                              setState(() {
                                                  //verValidaciones = true;
                                                  
                                                });
                                            },
                                          ),
                                        ),
                                                        
                                        if(tabAccEdit == 1)
                                        SizedBox(
                                          height: size.height * 0.02,
                                        ),
                                                        
                                        if(tabAccEdit == 1)
                                        Container(
                                          width: size.width * 0.97,
                                          padding: const EdgeInsets.all(16),  // Espaciado interno
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50), // Bordes redondeados
                                            color: Colors.white
                                          ),
                                          child: TextField(
                                            controller: passwordTxt,
                                            obscureText: authService.varIsOscuredConfNew,
                                            decoration: InputDecoration(
                                              labelText: 'Contraseña Nueva',
                                              suffixIcon: //Icon(Icons.visibility),
                                              !authService.varIsOscuredConfNew
                                                ? IconButton(
                                                    onPressed: () {
                                                      authService.varIsOscuredConfNew =
                                                          !authService.varIsOscuredConfNew;
                                                    },
                                                    icon: Icon(Icons.visibility,
                                                        size: 24,
                                                        color: AppLightColors()
                                                            .gray900PrimaryText),
                                                  )
                                                : IconButton(
                                                    onPressed: () {
                                                      authService.varIsOscuredConfNew =
                                                          !authService.varIsOscuredConfNew;
                                                    },
                                                    icon: Icon(
                                                        size: 24,
                                                        Icons.visibility_off,
                                                        color: AppLightColors()
                                                            .gray900PrimaryText),
                                                  ),
                                                        
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                  verValidaciones = true;
                                                  
                                                });
                                              onPassWordChanged(value.toString());
                                            },
                                            onTap: () {
                                              setState(() {
                                                  verValidaciones = true;
                                                  
                                                });
                                            },
                                            onTapOutside: (event) {
                                              FocusScope.of(context).unfocus();
                                                        
                                              setState(() {
                                                  verValidaciones = true;
                                                  
                                                });
                                            },
                                          ),
                                        ),
                                                        
                                        if(tabAccEdit == 1)
                                        SizedBox(
                                          height: size.height * 0.02,
                                        ),
                                                        
                                        if (verValidaciones && tabAccEdit == 1)
                                        Container(
                                            color: Colors.transparent,
                                            width: size.width * 0.8,
                                            //height: size.height * 0.21,
                                            height: size.height * 0.27,
                                            child: Column(
                                              children: [
                                                const Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Tu contraseña debe contener mínimo',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          //fontFamily: objFuentesPassWord.fuenteMonserate,
                                                          fontSize: 13),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                      
                                                Container(
                                                  color: Colors.transparent,
                                                  width: size.width * 0.8, //- 75,
                                                  height: size.height * 0.2,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          AnimatedContainer(
                                                            duration: const Duration(milliseconds: 500),
                                                            width: 16,
                                                            height: 16,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  tieneMayuscula
                                                                      ? Colors.green
                                                                      : Colors.red,
                                                              border: tieneMayuscula
                                                                  ? Border.all(
                                                                      color: Colors
                                                                          .transparent)
                                                                  : Border.all(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade400),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          40),
                                                            ),
                                                            child: Center(
                                                                child: Icon(
                                                              tieneMayuscula
                                                                  ? Icons.check
                                                                  : Icons.close,
                                                              color: Colors.white,
                                                              size: 12,
                                                            )),
                                                          ),
                                                          Text(
                                                            '  Una mayúscula',
                                                            style: TextStyle(
                                                                color:
                                                                    !tieneMayuscula
                                                                        ? Colors.red
                                                                        : Colors.green,
                                                                //fontFamily: objFuentesPassWord.fuenteMonserate,
                                                                fontSize: 11
                                                              ),
                                                          ),
                                                        ],
                                                      ),
                                                      /*
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      */
                                                      Row(
                                                        children: [
                                                          AnimatedContainer(
                                                            duration: const Duration(milliseconds: 500),
                                                            width: 16,
                                                            height: 16,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  tieneMinuscula
                                                                      ? Colors
                                                                          .green
                                                                      : Colors
                                                                          .red,
                                                              border: tieneMinuscula
                                                                  ? Border.all(
                                                                      color: Colors
                                                                          .transparent)
                                                                  : Border.all(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade400),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          40),
                                                            ),
                                                            child: Center(
                                                                child: Icon(
                                                              tieneMinuscula
                                                                  ? Icons.check
                                                                  : Icons.close,
                                                              color: Colors.white,
                                                              size: 12,
                                                            )),
                                                          ),
                                                          Text(
                                                            '  Una minúscula',
                                                            style: TextStyle(
                                                                color:
                                                                    !tieneMinuscula
                                                                        ? Colors
                                                                            .red
                                                                        : Colors
                                                                            .green,
                                                                //fontFamily: objFuentesPassWord.fuenteMonserate,
                                                                fontSize: 11),
                                                          ),
                                                        ],
                                                      ),
                                                      /*
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      */
                                                      Row(
                                                        children: [
                                                          AnimatedContainer(
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        500),
                                                            width: 16,
                                                            height: 16,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: tieneNumero
                                                                  ? Colors.green
                                                                  : Colors.red,
                                                              border: tieneNumero
                                                                  ? Border.all(
                                                                      color: Colors
                                                                          .transparent)
                                                                  : Border.all(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade400),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          40),
                                                            ),
                                                            child: Center(
                                                                child: Icon(
                                                              tieneNumero
                                                                  ? Icons.check
                                                                  : Icons.close,
                                                              color: Colors.white,
                                                              size: 12,
                                                            )),
                                                          ),
                                                          Text(
                                                            '  Un número',
                                                            style: TextStyle(
                                                                color: !tieneNumero
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .green,
                                                                //fontFamily: objFuentesPassWord.fuenteMonserate,
                                                                fontSize: 11),
                                                          ),
                                                        ],
                                                      ),
                                                      /*
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      */
                                                      Row(
                                                        children: [
                                                          AnimatedContainer(
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        500),
                                                            width: 16,
                                                            height: 16,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  tieneCaracterEspecial
                                                                      ? Colors
                                                                          .green
                                                                      : Colors
                                                                          .red,
                                                              border: tieneCaracterEspecial
                                                                  ? Border.all(
                                                                      color: Colors
                                                                          .transparent)
                                                                  : Border.all(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade400),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          40),
                                                            ),
                                                            child: Center(
                                                                child: Icon(
                                                              tieneCaracterEspecial
                                                                  ? Icons.check
                                                                  : Icons.close,
                                                              color: Colors.white,
                                                              size: 12,
                                                            )),
                                                          ),
                                                          Text(
                                                            '  Un caracter especial',
                                                            style: TextStyle(
                                                                color:
                                                                    !tieneCaracterEspecial
                                                                        ? Colors
                                                                            .red
                                                                        : Colors
                                                                            .green,
                                                                //fontFamily: objFuentesPassWord.fuenteMonserate,
                                                                fontSize: 11),
                                                          ),
                                                        ],
                                                      ),
                                                      
                                                      Row(
                                                        children: [
                                                          AnimatedContainer(
                                                            duration: const Duration(milliseconds: 500),
                                                            width: 16,
                                                            height: 16,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: tieneDiezCaracteres
                                                                      ? Colors
                                                                          .green
                                                                      : Colors
                                                                          .red,
                                                              border: tieneDiezCaracteres
                                                                  ? Border.all(
                                                                      color: Colors
                                                                          .transparent)
                                                                  : Border.all(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade400),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          40),
                                                            ),
                                                            child: Center(
                                                                child: Icon(
                                                              tieneDiezCaracteres
                                                                  ? Icons.check
                                                                  : Icons.close,
                                                              color: Colors.white,
                                                              size: 12,
                                                            )),
                                                          ),
                                                          Text(
                                                            '  Mínimo 10 caracteres',
                                                            style: TextStyle(
                                                                color:
                                                                    !tieneDiezCaracteres
                                                                        ? Colors.red
                                                                        : Colors.green,
                                                                //fontFamily: objFuentesPassWord.fuenteMonserate,
                                                                fontSize: 11),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              
                                              ],
                                            ),
                                          ),
                                        
                                        if (verValidaciones && tabAccEdit == 1)
                                        SizedBox(
                                          height: size.height * 0.02,
                                        ),
                                  
                                        if(tabAccEdit == 1)
                                        Container(
                                            width: size.width * 0.97,
                                          padding: const EdgeInsets.all(16),  // Espaciado interno
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50), // Bordes redondeados
                                            color: Colors.white
                                          ),
                                          child: TextField(
                                            controller: passwordConfTxt,
                                            obscureText: authService.isOscuredConf,
                                            decoration: InputDecoration(
                                              labelText: 'Confirme su Contraseña',
                                              suffixIcon: //Icon(Icons.visibility),
                                              !authService.isOscuredConf
                                                ? IconButton(
                                                    onPressed: () {
                                                      authService.isOscuredConf =
                                                          !authService.isOscuredConf;
                                                    },
                                                    icon: Icon(Icons.visibility,
                                                        size: 24,
                                                        color: AppLightColors()
                                                            .gray900PrimaryText),
                                                  )
                                                : IconButton(
                                                    onPressed: () {
                                                      authService.isOscuredConf =
                                                          !authService.isOscuredConf;
                                                    },
                                                    icon: Icon(
                                                        size: 24,
                                                        Icons.visibility_off,
                                                        color: AppLightColors()
                                                            .gray900PrimaryText),
                                                  ),
                                                        
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                            ),
                                            onChanged: (value) {
                                              /*
                                              setState(() {
                                                  verValidaciones = true;
                                                  
                                                });
                                              onPassWordChanged(value.toString());
                                              */
                                            },
                                            onTap: () {
                                    
                                            },
                                            onTapOutside: (event) {
                                              FocusScope.of(context).unfocus();
                                                        
                                              setState(() {
                                                  //verValidaciones = true;
                                                  
                                                });
                                            },
                                          ),
                                        ),
                                                        
                                        if(tabAccEdit == 0)
                                        SizedBox(
                                          height: size.height * 0.01,
                                        ),
                                          
                                        if(tabAccEdit == 0)                 
                                        Container(
                                          color: Colors.transparent,
                                          width: size.width * 0.92,
                                          child: TextFormField(
                                            initialValue: emailUser,
                                            //initialValue: '',
                                            //enabled: false,
                                            cursorColor: AppLightColors().primary,
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.deny(regexToRemoveEmoji)
                                            ],
                                            style: AppTextStyles.bodyRegular(width: size.width),
                                            decoration: InputDecorationCvs.formsDecoration(
                                              labelText: 'Correo electrónico',
                                              hintTetx: 'ejemplo@gmail.com',
                                              size: size
                                            ),
                                            //controller: emailAkiTxt,
                                            autocorrect: false,
                                            keyboardType: TextInputType.emailAddress,
                                            minLines: 1,
                                            maxLines: 2,
                                            autofocus: false,
                                            maxLength: 50,
                                            textAlign: TextAlign.left,
                                            onTap: () {
                                              planAct.setHeightModalPlanAct(0.65);
                                            },
                                            onEditingComplete: () {
                                              FocusScope.of(context).unfocus();
                                              //FocusScope.of(context).requestFocus(numTelfAfilAkiNode);
                                            },
                                            onChanged: (value) {
                                              
                                            },
                                            onTapOutside: (event) {
                                              planAct.setHeightModalPlanAct(0.11);
                                              FocusScope.of(context).unfocus();
                                            },
                                            validator: (value) {                                              
                                              String pattern = regularExp.regexToEmail;
                                              RegExp regExp = RegExp(pattern);
                                              return regExp.hasMatch(value ?? '')
                                                  ? null
                                                  : '¡El valor ingresado no luce como un correo!';                                                  
                                            },
                                          ),
                                        ),
                                        
                                        if(tabAccEdit == 0)
                                        SizedBox(
                                          height: size.height * 0.11,//0.11,
                                        ),
                                    
                                        if(tabAccEdit == 1)
                                        SizedBox(
                                          height: size.height * 0.165,
                                        ),
                                    
                                        Container(
                                          color: Colors.transparent,
                                          width: size.width * 0.92,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: size.width * 0.45,
                                                color: Colors.transparent,
                                                child: GestureDetector(
                                                onTap: () async {
                                                  //context.push(Rutas().rutaHome);
                                                  context.pop();
                                                },
                                                child: ButtonCvsWidget(
                                                  text: 'Cancelar',
                                                  textStyle: AppTextStyles.h3Bold(
                                                      width: size.width,
                                                      color: AppLightColors().white),
                                                )),
                                              ),
                                              Container(
                                                width: size.width * 0.45,
                                                color: Colors.transparent,
                                                child: GestureDetector(
                                                onTap: () async {
                                          
                                                  if(tabAccEdit == 1){
                                                    if(passwordAntTxt.text.isEmpty){
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: const Text('Ingrese su contraseña actual'),
                                                            
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  // Acción para solicitar revisión
                                                                  //Navigator.of(context).pop();
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
                                            
                                                    if(passwordTxt.text != passwordConfTxt.text){
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: const Text('Las contraseñas deben coincidir'),
                                                            
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  // Acción para solicitar revisión
                                                                  //Navigator.of(context).pop();
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
                                                  }

                                                  Navigator.of(context).pop();
                                                  
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text('Datos actualizados correctamente'),
                                                        
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              // Acción para solicitar revisión
                                                              Navigator.of(context).pop();
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
                                                  //text: 'Guardar Cambios',
                                                  text: 'Actualizar',
                                                  textStyle: AppTextStyles.h3Bold(
                                                      width: size.width,
                                                      color: AppLightColors().white),
                                                )),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: size.height * 0.02,//0.11,
                                        ),
                                                                  
                                      ],
                                    ),
                                  ),
                                    
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
              
              /*
                      Stack(
                        children: [
                          
                          Positioned(
                            left: size.width * 0.042,
                            top: size.height * 0.78,
                            child: Container(
                              color: Colors.transparent,
                              width: size.width * 0.92,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: size.width * 0.45,
                                        color: Colors.transparent,
                                        child: GestureDetector(
                                        onTap: () async {
                                          //context.push(Rutas().rutaHome);
                                          context.pop();
                                        },
                                        child: ButtonCvsWidget(
                                          text: 'Cancelar',
                                          textStyle: AppTextStyles.h3Bold(
                                              width: size.width,
                                              color: AppLightColors().white),
                                        )),
                                      ),
                                      Container(
                                        width: size.width * 0.45,
                                        color: Colors.transparent,
                                        child: GestureDetector(
                                        onTap: () async {
                                  
                                          if(passwordAntTxt.text.isEmpty){
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('Ingrese su contraseña actual'),
                                                  
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        // Acción para solicitar revisión
                                                        //Navigator.of(context).pop();
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
                                  
                                          if(passwordTxt.text != passwordConfTxt.text){
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('Las contraseñas deben coincidir'),
                                                  
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        // Acción para solicitar revisión
                                                        //Navigator.of(context).pop();
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
                                  
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text('Datos actualizados correctamente'),
                                                
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      // Acción para solicitar revisión
                                                      Navigator.of(context).pop();
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
                                          //text: 'Guardar Cambios',
                                          text: 'Actualizar',
                                          textStyle: AppTextStyles.h3Bold(
                                              width: size.width,
                                              color: AppLightColors().white),
                                        )),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                              height: size.height * 0.11,//0.11,
                                            ),
                                ],
                              ),
                            ),
                          ),
                          
                        ]
                      ),
                      */
                    ],
                  ),
                ),
              );
            }
          );
        }
      ),
        
    );
  }
}
