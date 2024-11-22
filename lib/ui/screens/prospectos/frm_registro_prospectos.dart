

import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cvs_ec_app/domain/domain.dart';
import 'package:cvs_ec_app/infraestructure/infraestructure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:cvs_ec_app/ui/ui.dart';

int tabAccionesRegPrsp = 0;

late TextEditingController nombresTxt;
late TextEditingController emailTxt;
late TextEditingController direccionTxt;
late TextEditingController observacionesTxt;
late TextEditingController paisTxt;
late TextEditingController probabilityTxt;

DateTime dateRgPrsp = DateTime.now();

String campSelect = '';
String mediaSelect = '';
String originSelect = '';
String actSelect = '';

class FrmRegistroProspectoScreen extends StatefulWidget {
  const FrmRegistroProspectoScreen({super.key});

  @override
  State<FrmRegistroProspectoScreen> createState() => _FrmRegistroProspectoScreenState();
}

class _FrmRegistroProspectoScreenState extends State<FrmRegistroProspectoScreen> {

  final LocalAuthentication auth = LocalAuthentication();  
  
  @override
  void initState() {
    super.initState();

    nombresTxt = TextEditingController();
    emailTxt = TextEditingController();
    direccionTxt = TextEditingController();
    observacionesTxt = TextEditingController();
    paisTxt = TextEditingController();
    probabilityTxt = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {

    //ColorsApp objColorsApp = ColorsApp();

    //ScrollController scrollListaClt = ScrollController();

    final size = MediaQuery.of(context).size;

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

          /* 
          return FutureBuilder(
                future: state.readCompanias(),
          */

          return FutureBuilder(
            future: state.readCombosCreateProspectos(),
            builder: (context, snapshot) {
              
              if(!snapshot.hasData) {
                return Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                    child: Image.asset(
                      "assets/gifs/gif_carga.gif",
                      height: 150.0,
                      width: 150.0,
                    ),
                  ),
                );
              }
              else{
                if(snapshot.data != null) {
                  
                  ProspectoCombosModel objTmp = snapshot.data as ProspectoCombosModel;

                  var objCamp = json.decode(objTmp.campanias);
                  var objCamp2 = json.decode(objCamp);

                  var objMedia = json.decode(objTmp.medias);
                  var objMedia2 = json.decode(objMedia);

                  var objOrigen = json.decode(objTmp.origen);
                  var objOrigen2 = json.decode(objOrigen);

                  var objAct = json.decode(objTmp.actividades);
                  var objAct2 = json.decode(objAct);

                  var objCamp3 = objCamp2['result']['data']['utm.campaign']['data'];
                  var objMedia3 = objMedia2['result']['data']['utm.medium']['data'];
                  var objOrigen3 = objOrigen2['result']['data']['utm.source']['data'];
                  var objAct3 = objAct2['result']['data']['mail.activity.type']['data'];

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

                  //List<String> lstCampanias = objCamp3.map((item) => item["name"] ?? '' as String?).toList();//List<String>.from(json.decode(objCamp3));
                  /*
                  List<String> lstMedias = objMedia3.map((item) => item["name"] ?? '' as String?).toList();//List<String>.from(json.decode(objMedia3));
                  List<String> lstOrigenes = objOrigen3.map((item) => item["name"] ?? '' as String?).toList();//List<String>.from(json.decode(objOrigen3));
                  */

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

                  return Stack(
                    children: [
                      Column(
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
                                
                            
                                Container(
                                  color: Colors.transparent,
                                  width: size.width * 0.92,
                                  child: TextFormField(
                                    cursorColor: AppLightColors().primary,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    inputFormatters: [
                                      //FilteringTextInputFormatter.deny(regexToRemoveEmoji)
                                    ],
                                    style: AppTextStyles.bodyRegular(width: size.width),
                                    decoration: InputDecorationCvs.formsDecoration(
                                      labelText: 'Teléfono',
                                      hintTetx: 'Ej: 09xxxxxxxx',
                                      size: size,
                                      prefixIcon: const Icon(Icons.search, color: Colors.blue,)
                                      //prefixText: 'Tst'
                                    ),                                  
                                    //controller: emailAkiTxt,
                                    autocorrect: false,
                                    keyboardType: TextInputType.text,
                                    minLines: 1,
                                    maxLines: 2,
                                    autofocus: false,
                                    maxLength: 10,
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
                                      /*
                                      String pattern = regularExp.regexToEmail;
                                      RegExp regExp = RegExp(pattern);
                                      return regExp.hasMatch(value ?? '')
                                          ? null
                                          : '¡El valor ingresado no luce como un correo!';
                                          */
                                    },
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
                                      //initialValue: 'Mario Piguave',
                                      //initialValue: '',
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
                                      validator: (value) {
                                        /*
                                        String pattern = regularExp.regexToEmail;
                                        RegExp regExp = RegExp(pattern);
                                        return regExp.hasMatch(value ?? '')
                                            ? null
                                            : '¡El valor ingresado no luce como un correo!';
                                            */
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
                                      initialValue: 'Terreno',
                                      //initialValue: '',                                      
                                      cursorColor: AppLightColors().primary,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      inputFormatters: [
                                        //FilteringTextInputFormatter.deny(regexToRemoveEmoji)
                                      ],
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
                                        //FocusScope.of(context).requestFocus(numTelfAfilAkiNode);
                                      },
                                      onChanged: (value) {
                                        
                                      },
                                      onTapOutside: (event) {
                                        FocusScope.of(context).unfocus();
                                      },
                                      validator: (value) {
                                        /*
                                        String pattern = regularExp.regexToEmail;
                                        RegExp regExp = RegExp(pattern);
                                        return regExp.hasMatch(value ?? '')
                                            ? null
                                            : '¡El valor ingresado no luce como un correo!';
                                            */
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
                                      inputFormatters: [
                                        //FilteringTextInputFormatter.deny(regexToRemoveEmoji)
                                      ],
                                      style: AppTextStyles.bodyRegular(width: size.width),
                                      decoration: InputDecorationCvs.formsDecoration(
                                        labelText: 'País',
                                        hintTetx: 'Ej: Ecuador',
                                        size: size
                                      ),
                                      controller: paisTxt,
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
                                      validator: (value) {
                                        /*
                                        String pattern = regularExp.regexToEmail;
                                        RegExp regExp = RegExp(pattern);
                                        return regExp.hasMatch(value ?? '')
                                            ? null
                                            : '¡El valor ingresado no luce como un correo!';
                                            */
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
                                      initialValue: 'Guayaquil',
                                      //initialValue: '',                                      
                                      cursorColor: AppLightColors().primary,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      inputFormatters: [
                                        //FilteringTextInputFormatter.deny(regexToRemoveEmoji)
                                      ],
                                      style: AppTextStyles.bodyRegular(width: size.width),
                                      decoration: InputDecorationCvs.formsDecoration(
                                        labelText: 'Ciudad',
                                        hintTetx: 'Ej: Guayaquil',
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
                                      validator: (value) {
                                        /*
                                        String pattern = regularExp.regexToEmail;
                                        RegExp regExp = RegExp(pattern);
                                        return regExp.hasMatch(value ?? '')
                                            ? null
                                            : '¡El valor ingresado no luce como un correo!';
                                            */
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
                                      initialValue: 'Norte',
                                      //initialValue: '',
                                      cursorColor: AppLightColors().primary,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      inputFormatters: [
                                        //FilteringTextInputFormatter.deny(regexToRemoveEmoji)
                                      ],
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
                                      validator: (value) {
                                        /*
                                        String pattern = regularExp.regexToEmail;
                                        RegExp regExp = RegExp(pattern);
                                        return regExp.hasMatch(value ?? '')
                                            ? null
                                            : '¡El valor ingresado no luce como un correo!';
                                            */
                                      },
                                    ),
                                  ),
                                  
                                  SizedBox(
                                    height: size.height * 0.03,
                                  ),
                                  
                                  Container(
                                    color: Colors.transparent,
                                    width: size.width * 0.92,
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Asignado', style: TextStyle(fontSize: 20),),
                                        Icon(Icons.check_box_outlined),
                                      ],
                                    ),
                                                                      ),
                                                                      
                                                                      SizedBox(
                                    height: size.height * 0.01,
                                                                      ),
                                                                      
                                                                      Container(
                                    color: Colors.transparent,
                                    width: size.width * 0.92,
                                    child: TextFormField(
                                      initialValue: 'Yordani Oliva',
                                      //initialValue: '',
                                      cursorColor: AppLightColors().primary,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      inputFormatters: [
                                        //FilteringTextInputFormatter.deny(regexToRemoveEmoji)
                                      ],
                                      style: AppTextStyles.bodyRegular(width: size.width),
                                      decoration: InputDecorationCvs.formsDecoration(
                                        labelText: 'Asesor Asignado',
                                        hintTetx: '',
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
                                      validator: (value) {
                                        /*
                                        String pattern = regularExp.regexToEmail;
                                        RegExp regExp = RegExp(pattern);
                                        return regExp.hasMatch(value ?? '')
                                            ? null
                                            : '¡El valor ingresado no luce como un correo!';
                                            */
                                      },
                                    ),
                                                                      ),
                                                                      
                                                                      
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),

                                  Container(
                                    color: Colors.transparent,
                                    width: size.width * 0.94,
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
                                                //child: Text(activityPrsp),
                                                child: AutoSizeText(activityPrsp, maxLines: 1, minFontSize: 2, maxFontSize: 13,),
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
                                    height: size.height * 0.02,
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
                                      value: originSelect,
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
                                          originSelect = newValue ?? '';
                                        });
                                      },
                                    ),
                                    ),
                                                                      
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),

                                  /*
                                  String  = '';
                                  String  = '';
                                  String  = '';

                                  List<String>  = List<String>.from(json.decode(objTmp.campanias));
                  List<String>  = List<String>.from(json.decode(objTmp.medias));
                  List<String>  = List<String>.from(json.decode(objTmp.origen));
                                   */
                  
                                  Container(
                                    color: Colors.transparent,
                                    width: size.width * 0.94,
                                    child: DropdownButtonFormField<String>(
                                                  decoration: const InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText:
                                                        'Seleccione la media',
                                                  ),
                                                  value: mediaSelect,
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
                                      initialValue: 'Maria José',
                                      //initialValue: '',
                                      cursorColor: AppLightColors().primary,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      inputFormatters: [
                                        //FilteringTextInputFormatter.deny(regexToRemoveEmoji)
                                      ],
                                      style: AppTextStyles.bodyRegular(width: size.width),
                                      decoration: InputDecorationCvs.formsDecoration(
                                        labelText: 'Recomendado por',
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
                                      validator: (value) {
                                        /*
                                        String pattern = regularExp.regexToEmail;
                                        RegExp regExp = RegExp(pattern);
                                        return regExp.hasMatch(value ?? '')
                                            ? null
                                            : '¡El valor ingresado no luce como un correo!';
                                            */
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
                                      //initialValue: 'Mario Piguave',
                                      //initialValue: '',
                                      cursorColor: AppLightColors().primary,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      inputFormatters: [
                                        //FilteringTextInputFormatter.deny(regexToRemoveEmoji)
                                      ],
                                      style: AppTextStyles.bodyRegular(width: size.width),
                                      decoration: InputDecorationCvs.formsDecoration(
                                        labelText: 'Probabilidad',
                                        hintTetx: 'Ej: 50%',
                                        size: size
                                      ),
                                      controller: probabilityTxt,
                                      autocorrect: false,
                                      keyboardType: TextInputType.number,
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
                                        /*
                                        String pattern = regularExp.regexToEmail;
                                        RegExp regExp = RegExp(pattern);
                                        return regExp.hasMatch(value ?? '')
                                            ? null
                                            : '¡El valor ingresado no luce como un correo!';
                                            */
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
                    //initialValue: 'Terreno',
                    //initialValue: '',
                    cursorColor: AppLightColors().primary,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputFormatters: [
                      //FilteringTextInputFormatter.deny(regexToRemoveEmoji)
                    ],
                    style: AppTextStyles.bodyRegular(width: size.width),
                    decoration: InputDecorationCvs.formsDecoration(
                      labelText: 'Ingreso esperado en dólares',
                      //hintTetx: 'Ej: 5',
                      size: size
                    ),
                    //controller: emailAkiTxt,
                    autocorrect: false,
                    keyboardType: TextInputType.number,
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
                      /*
                      String pattern = regularExp.regexToEmail;
                      RegExp regExp = RegExp(pattern);
                      return regExp.hasMatch(value ?? '')
                          ? null
                          : '¡El valor ingresado no luce como un correo!';
                          */
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
                    height: size.height * 0.06,
                                        ),
                                        
                                        Container(
                                          color: Colors.transparent,
                                          width: size.width * 0.92,
                                          child: TextFormField(
                                            initialValue: dateRgPrsp.toString(),
                                                      readOnly: true,
                                                      decoration: const InputDecoration(
                                                        labelText:
                                                            'Cierre esperado',
                                                        border: OutlineInputBorder(),
                                                        suffixIcon: Icon(
                                                            Icons.calendar_today),
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
                                                                  dateRgPrsp = pickedDate;
                                                                });
                                                                
                                                        }
                                                      },
                                                    ),
                                                                                      
                  ),
                  
                  SizedBox(
                    height: size.height * 0.04,
                  ),

                  Container(
                    color: Colors.transparent,
                    width: size.width * 0.92,
                    child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Seleccione el tipo de actividad...',
                        ),
                        value: actSelect,
                        items: lstActividades
                            .map((activityPrsp) =>
                                DropdownMenuItem(
                                  value: activityPrsp,
                                  child: AutoSizeText(activityPrsp, maxLines: 1, minFontSize: 2, maxFontSize: 13,),
                                ))
                            .toList(),
                        onChanged: (value) {
                          
                          setState(() {
                            actSelect = value ?? '';
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
                    height: size.height * 0.15,
                    child: TextFormField(
                      controller: direccionTxt,
                    //initialValue: 'Yordani Oliva',
                    //initialValue: '',
                    cursorColor: AppLightColors().primary,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputFormatters: [
                      //FilteringTextInputFormatter.deny(regexToRemoveEmoji)
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
                    validator: (value) {
                      /*
                      String pattern = regularExp.regexToEmail;
                      RegExp regExp = RegExp(pattern);
                      return regExp.hasMatch(value ?? '')
                          ? null
                          : '¡El valor ingresado no luce como un correo!';
                          */
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
                                            //initialValue: 'Ej: Interesado en casa pero no tiene trabajo estable',
                                            //initialValue: '',
                                            cursorColor: AppLightColors().primary,
                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                            inputFormatters: [
                                              //FilteringTextInputFormatter.deny(regexToRemoveEmoji)
                                            ],
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
                                              //FocusScope.of(context).requestFocus(numTelfAfilAkiNode);
                                            },
                                            onChanged: (value) {
                                              
                                            },
                                            onTapOutside: (event) {
                                              FocusScope.of(context).unfocus();
                                            },
                                            validator: (value) {
                                              /*
                                              String pattern = regularExp.regexToEmail;
                                              RegExp regExp = RegExp(pattern);
                                              return regExp.hasMatch(value ?? '')
                                                  ? null
                                                  : '¡El valor ingresado no luce como un correo!';
                                                  */
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
                                width: size.width * 0.45,
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
                                width: size.width * 0.45,
                                color: Colors.transparent,
                                child: GestureDetector(
                                onTap: () async {

                                  if(nombresTxt.text.isEmpty || emailTxt.text.isEmpty){
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
                                          mensajeAlerta: 'Ingrese todos los datos del formulario.'
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
                                  }

                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => SimpleDialog(
                                      alignment: Alignment.center,
                                      children: [
                                        SimpleDialogCargando(
                                          mensajeMostrar: 'Estamos registrando',
                                          mensajeMostrarDialogCargando: 'al nuevo cliente.',
                                        ),
                                      ]
                                    ),
                                  );

                                  DatumCrmLead objProsp = DatumCrmLead(                                    
                                    
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
                                    phone: '+593 ',
                                    partnerName: nombresTxt.text,
                                    mobile: '',
                                    dateOpen: DateTime.now(),
                                    dateDeadline: DateTime.now(),
                                    probability: double.parse(probabilityTxt.text),

                                    activityIds: [
                                      StructCombos(id: 2, name: actSelect)
                                    ],
                                    campaignId: CampaignId(
                                      id: 2,
                                      name: ''
                                    ),
                                    countryId: StructCombos (
                                      id: 2,
                                      name: paisTxt.text
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
                                  );

                                  ProspectoRegistroResponseModel objRsp = await ProspectoTypeService().registraProspecto(objProsp);

                                  String respuestaReg = objRsp.result.mensaje;
                                  int estado = objRsp.result.estado;
                                  String gifRespuesta = '';

                                  context.pop();
                                  context.pop();
                                  context.pop();

                                  if(estado == 200){
                                    gifRespuesta = 'assets/gifs/exito.gif';
                                  } else {
                                    gifRespuesta = 'assets/gifs/gifErrorBlanco.gif';
                                  }

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
                                

                                  /*
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Prospecto Registrado'),
                                        content: const Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Este prospecto se encuentra registrado desde el 01/02/2024 '
                                              'y su ultima gestión fue realizada el 01/05/2024',
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Cancelar', style: TextStyle(color: Colors.blue[200]),),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              // Acción para solicitar revisión
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Solicitar Revisión', style: TextStyle(color: Colors.blue[200]),),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                */
                                },
                                child: ButtonCvsWidget(
                                  //text: 'Crear',
                                  text: 'Crear Prospecto',
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
