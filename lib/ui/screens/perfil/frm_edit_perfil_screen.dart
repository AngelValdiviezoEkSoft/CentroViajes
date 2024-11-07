

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cvs_ec_app/domain/domain.dart';
import 'package:cvs_ec_app/infraestructure/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:cvs_ec_app/ui/ui.dart';
import 'package:provider/provider.dart';

int tabAcc = 0;
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
/*
      varObjetoProspectoFunc!.imagenPerfil = objFotoPerfilNueva;
      varObjProspecto!.imagenPerfil = objFotoPerfilNueva;
      */
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {

    final planAct = BlocProvider.of<GenericBloc>(context);
    //planAct.setHeightModalPlanAct(0.11);

    ColorsApp objColorsApp = ColorsApp();

    ScrollController scrollListaClt = ScrollController();

    final size = MediaQuery.of(context).size;

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

          return 
            Container(
              color: Colors.transparent,
              width: size.width,
              height: size.height * 1.5,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Column(
                          children: [
                    
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                    
                            if(rutaNuevaFotoPerfil == '')
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
                                        /*
                                        aspectRatioPresets: [CropAspectRatioPreset.square],
                                        cropStyle: CropStyle.rectangle,
                                        */
                                        sourcePath: pickedFile.path,
                                        compressFormat: ImageCompressFormat.png,
                                        compressQuality: 100,
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
                                            /*
                                            presentStyle: CropperPresentStyle.dialog,
                                            boundary: const CroppieBoundary(
                                              width: 520,
                                              height: 520,
                                            ),
                                            viewPort: const CroppieViewPort(width: 480, height: 480, type: 'circle'),
                                            enableExif: true,
                                            enableZoom: true,
                                            showZoomer: true,
                                            */
                                          ),
                                        ],
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
                      
                            if(rutaNuevaFotoPerfil != '')
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
                                            /*
                                            presentStyle: CropperPresentStyle.dialog,
                                            boundary: const CroppieBoundary(
                                              width: 520,
                                              height: 520,
                                            ),
                                            viewPort: const CroppieViewPort(width: 480, height: 480, type: 'circle'),
                                            enableExif: true,
                                            enableZoom: true,
                                            showZoomer: true,
                                            */
                                          ),
                                        ],
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
                              height: size.height * 0.65,//0.86,
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),
                              
                                  Container(
                                    color: Colors.transparent,
                                    //height: size.height * 0.7,
                                    height: size.height * 0.62,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                                
                                          Container(
                                            color: Colors.transparent,
                                            width: size.width * 0.92,
                                            child: TextFormField(
                                              initialValue: 'Mario Rosendo Piguave Rodriguez',
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
                                                //FocusScope.of(context).unfocus();
                                                planAct.setHeightModalPlanAct(0.11);
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
                                              initialValue: 'm.piguave@ekuasoft',
                                              //initialValue: '',
                                              enabled: false,
                                              cursorColor: AppLightColors().primary,
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              inputFormatters: [
                                                //FilteringTextInputFormatter.deny(regexToRemoveEmoji)
                                              ],
                                              style: AppTextStyles.bodyRegular(width: size.width),
                                              decoration: InputDecorationCvs.formsDecoration(
                                                labelText: 'Usuario',
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
                                              initialValue: 'abc_123',
                                              //initialValue: '',
                                              enabled: false,
                                              cursorColor: AppLightColors().primary,
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              inputFormatters: [
                                                //FilteringTextInputFormatter.deny(regexToRemoveEmoji)
                                              ],
                                              style: AppTextStyles.bodyRegular(width: size.width),
                                              decoration: InputDecorationCvs.formsDecoration(
                                                labelText: 'UID',
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
                                              },
                                            ),
                                          ),
                                                                              
                                          SizedBox(
                                            height: size.height * 0.02,
                                          ),
                    
                                                       /*                       
                                          Container(
                                            color: Colors.transparent,
                                            width: size.width * 0.92,
                                            child: TextFormField(
                                              initialValue: '',
                                              obscureText: true,
                                              cursorColor: AppLightColors().primary,
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              inputFormatters: [
                                              ],
                                              style: AppTextStyles.bodyRegular(width: size.width),
                                              decoration: InputDecorationCvs.formsDecoration(
                                                labelText: 'Contraseña',
                                                hintTetx: '',
                                                size: size
                                              ),
                                              keyboardType: TextInputType.text,
                                              minLines: 1,
                                              maxLines: 1,
                                              autofocus: false,
                                              textAlign: TextAlign.left,                                      
                                              onEditingComplete: () {
                                                FocusScope.of(context).unfocus();
                                              },
                                              onChanged: (value) {
                                                onPassWordChanged(value.toString());
                                              },
                                              onTapOutside: (event) {
                                                FocusScope.of(context).unfocus();
                    
                                                setState(() {
                                                    verValidaciones = true;
                                                    
                                                  });
                                              },
                                              validator: (value) {
                                              },
                                            ),
                                                                              ),
                                                                              */
                    
                                          Container(
                                            padding: const EdgeInsets.all(16),  // Espaciado interno
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50), // Bordes redondeados
                                              color: Colors.white
                                            ),
                                            child: TextField(
                                              obscureText: authService.varIsOscured,
                                              decoration: InputDecoration(
                                                labelText: 'Contraseña',
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
                    
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                    
                                           if (verValidaciones)
                                              Container(
                                                color: Colors.transparent,
                                                width: size.width * 0.8,
                                                //height: size.height * 0.21,
                                                height: size.height * 0.27,
                                                child: Column(
                                                  children: [
                                                    Row(
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
                                            
                                            SizedBox(
                                              height: size.height * 0.02,
                                            ),
                    
                                          Container(
                                                  color: Colors.transparent,
                                                  width: size.width * 0.92,
                                                  child: DropdownButtonFormField<String>(
                                                                decoration: InputDecoration(
                                                                  border: OutlineInputBorder(),
                                                                  labelText:
                                                                      'Seleccione la compañía...',
                                                                ),
                                                                //value: selectedActivityType,
                                                                items: [
                                                                  'Compañía 1',
                                                                  'Compañía 2',
                                                                  'Compañía 3'
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
                                              initialValue: '',
                                              //initialValue: '',
                                              //enabled: false,
                                              cursorColor: AppLightColors().primary,
                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                              inputFormatters: [
                                                //FilteringTextInputFormatter.deny(regexToRemoveEmoji)
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
                                            height: size.height * 0.11,//0.11,
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
                          //top: size.height * 0.82,
                          top: size.height * 0.78,
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
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Datos actualizados correctamente'),
                                          
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
                                    text: 'Guardar Cambios',
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
                    ),
                  ],
                ),
              ),
            );    
        }
      ),
        
    );
  }
}
