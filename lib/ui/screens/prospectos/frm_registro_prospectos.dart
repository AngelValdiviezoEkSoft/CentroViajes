

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:cvs_ec_app/ui/ui.dart';

int tabAccionesRegPrsp = 0;
late TextEditingController montoNuevo2_Txt;
late TextEditingController nombreTrx2_Txt;
DateTime dateRgPrsp = DateTime.now();

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

    montoNuevo2_Txt = TextEditingController();
    nombreTrx2_Txt = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {

    ColorsApp objColorsApp = ColorsApp();

    ScrollController scrollListaClt = ScrollController();

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

          return 
            Stack(
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
                            padding: EdgeInsets.all(8.0),
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
                                initialValue: 'Mario Piguave',
                                //initialValue: '',
                                cursorColor: AppLightColors().primary,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                inputFormatters: [
                                  //FilteringTextInputFormatter.deny(regexToRemoveEmoji)
                                ],
                                style: AppTextStyles.bodyRegular(width: size.width),
                                decoration: InputDecorationCvs.formsDecoration(
                                  labelText: 'Nombres',
                                  hintTetx: 'Ej: Juan Valdez',
                                  size: size
                                ),
                                enabled: false,
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
                                initialValue: 'Terreno',
                                //initialValue: '',
                                enabled: false,
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
                                initialValue: 'Ecuador',
                                //initialValue: '',
                                enabled: false,
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
                                initialValue: 'Guayaquil',
                                //initialValue: '',
                                enabled: false,
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
                                enabled: false,
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Asignado', style: TextStyle(fontSize: 20),),
                                  Icon(Icons.check_box_outlined),
                                  //Icon(Icons.check_box_outline_blank_sharp),
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
                                enabled: false,
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
                              height: size.height * 0.01,
                                                                ),
                                                            
                                                                Container(
                              color: Colors.transparent,
                              width: size.width * 0.92,
                              child: TextFormField(
                                initialValue: 'Test',
                                //initialValue: '',
                                enabled: false,
                                cursorColor: AppLightColors().primary,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                inputFormatters: [
                                  //FilteringTextInputFormatter.deny(regexToRemoveEmoji)
                                ],
                                style: AppTextStyles.bodyRegular(width: size.width),
                                decoration: InputDecorationCvs.formsDecoration(
                                  labelText: 'Seleccione el medio',
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
                              height: size.height * 0.01,
                                                                ),
                              
                                                                Container(
                              color: Colors.transparent,
                              width: size.width * 0.92,
                              child: TextFormField(
                                initialValue: 'Test 1',
                                //initialValue: '',
                                enabled: false,
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
                              height: size.height * 0.01,
                            ),

                            Container(
                                    color: Colors.transparent,
                                    width: size.width * 0.92,
                                    child: DropdownButtonFormField<String>(
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText:
                                                        'Seleccione la campaña...',
                                                  ),
                                                  //value: selectedActivityType,
                                                  items: [
                                                    'Campaña 1',
                                                    'Campaña 2',
                                                    'Campaña 3'
                                                  ]
                                                      .map((activityPrsp) =>
                                                          DropdownMenuItem(
                                                            value: activityPrsp,
                                                            child: Text(activityPrsp),
                                                          ))
                                                      .toList(),
                                                  onChanged: (value) {
                                                  },
                                                ),
                                  ),
                                                            
                                                                SizedBox(
                              height: size.height * 0.01,
                                                                ),

                            Container(
                                    color: Colors.transparent,
                                    width: size.width * 0.92,
                                    child: DropdownButtonFormField<String>(
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText:
                                                        'Seleccione el origen...',
                                                  ),
                                                  //value: selectedActivityType,
                                                  items: [
                                                    'Guayaquil',
                                                    'Durán',
                                                    'Yaguachi'
                                                  ]
                                                      .map((activityPrsp) =>
                                                          DropdownMenuItem(
                                                            value: activityPrsp,
                                                            child: Text(activityPrsp),
                                                          ))
                                                      .toList(),
                                                  onChanged: (value) {
                                                  },
                                                ),
                                  ),
                                                               
                            SizedBox(
                              height: size.height * 0.01,
                            ),

                            Container(
                                    color: Colors.transparent,
                                    width: size.width * 0.92,
                                    child: DropdownButtonFormField<String>(
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText:
                                                        'Seleccione la media...',
                                                  ),
                                                  //value: selectedActivityType,
                                                  items: [
                                                    'Alta',
                                                    'Media',
                                                    'Baja'
                                                  ]
                                                      .map((activityPrsp) =>
                                                          DropdownMenuItem(
                                                            value: activityPrsp,
                                                            child: Text(activityPrsp),
                                                          ))
                                                      .toList(),
                                                  onChanged: (value) {
                                                  },
                                                ),
                                  ),
                                                               
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                                                                
                                                                Container(
                              color: Colors.transparent,
                              width: size.width * 0.92,
                              child: TextFormField(
                                initialValue: 'Maria Pepa',
                                //initialValue: '',
                                enabled: false,
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
                                initialValue: '',
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
                                //enabled: false,
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
  height: size.height * 0.04,
                                  ),
                                  
                                  Container(
  color: Colors.transparent,
  width: size.width * 0.92,
  child: TextFormField(
  //initialValue: 'Terreno',
  //initialValue: '',
  //enabled: false,
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
  initialValue: '',
  //enabled: false,
  cursorColor: AppLightColors().primary,
  autovalidateMode: AutovalidateMode.onUserInteraction,
  inputFormatters: [
    //FilteringTextInputFormatter.deny(regexToRemoveEmoji)
  ],
  style: AppTextStyles.bodyRegular(width: size.width),
  decoration: InputDecorationCvs.formsDecoration(
    labelText: 'Correo',
    hintTetx: 'Ej: correo@ejemplo.com',
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
  height: size.height * 0.06,
                                  ),
                                  
                                  Container(
                                    color: Colors.transparent,
                                    width: size.width * 0.92,
                                    child: TextFormField(
                                      initialValue: dateRgPrsp.toString(),
                                                readOnly: true,
                                                decoration: InputDecoration(
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
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText:
                                                        'Seleccione el tipo de actividad...',
                                                  ),
                                                  //value: selectedActivityType,
                                                  items: [
                                                    'Media',
                                                    'Alta',
                                                    'Muy Alta'
                                                  ]
                                                      .map((activityPrsp) =>
                                                          DropdownMenuItem(
                                                            value: activityPrsp,
                                                            child: Text(activityPrsp),
                                                          ))
                                                      .toList(),
                                                  onChanged: (value) {
                                                    /*
                                                                            setState(() {
                                                            selectedActivityType = value;
                                                                            });
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
  height: size.height * 0.15,
  child: TextFormField(
  //initialValue: 'Yordani Oliva',
  initialValue: '',
  //enabled: false,
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
  //controller: emailAkiTxt,
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
                                initialValue: '',
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
                                //controller: emailAkiTxt,
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
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Prospecto Registrado'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Este cliente se encuentra registrado desde el 01/02/2024 '
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
      ),
        
    );
  }
}
