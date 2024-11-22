import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cvs_ec_app/config/environments/environments.dart';
import 'package:cvs_ec_app/domain/domain.dart';
import 'package:cvs_ec_app/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:go_router/go_router.dart';

import '../../../infraestructure/services/services.dart';

import 'package:geolocator/geolocator.dart';

Rutas objRutasGen = Rutas();
TextEditingController serverTxt = TextEditingController();
TextEditingController keyTxt = TextEditingController();

class WelcomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: size.width,
              height: size.height * 1.15,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, // Punto de inicio del degradado
                  end: Alignment.bottomRight,
                colors: [Colors.blue.shade600, Colors.white, Colors.white],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * 0.04,
                ),
                // Icono central
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 80,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                // Texto de bienvenida
                const Text(
                  '¡Bienvenido!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    '¡Gracias por unirte a la comunidad de D-One! ¡Acceda o cree su cuenta a continuación y comience su viaje!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: size.height * 0.04),
            
                // Subtítulo
                
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
                  padding: const EdgeInsets.all(16),  // Espaciado interno
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50), // Bordes redondeados
                    color: Colors.white                  
                  ),                
                  child: TextField(
                    controller: serverTxt,
                    decoration: InputDecoration(                  
                      labelText: 'Servidor',
                      suffixIcon: const Icon(Icons.qr_code_scanner_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
            
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
                  padding: const EdgeInsets.all(16),  // Espaciado interno
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50), // Bordes redondeados
                    color: Colors.white                  
                  ),                
                  child: TextField(
                    controller: keyTxt,
                    decoration: InputDecoration(                  
                      labelText: 'Key',
                      suffixIcon: const Icon(Icons.key),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
            
              const Spacer(),
            
              const Divider(color: Colors.red,),
                
              SizedBox(
                height: size.height * 0.04,
              ),

              // Botón de Comenzar
              Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: GestureDetector(
              onTap: () async {

                /*
                
TextEditingController serverTxt = TextEditingController();
TextEditingController keyTxt = TextEditingController();
                 */

                if(serverTxt.text.isEmpty || keyTxt.text.isEmpty){
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
                        mensajeAlerta: 'Ingrese los datos del formulario.'
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
                        mensajeMostrarDialogCargando: 'tu dispositivo',
                      ),
                    ]
                  ),
                );

                /*
                const imeiMovile = MethodChannel('com.ekuasoft.cvs_ec_app/imei');
                final String? imei = await imeiMovile.invokeMethod('getImei');
                */
/*
                const imeiMovile = MethodChannel('device/info');
                final String? imei = await imeiMovile.invokeMethod('deviceId');    
*/
                try{
                  String imeiCod = '';
                  var plataforma = '';

                  final deviceInfo = DeviceInfoPlugin();
                  
                  if (Platform.isAndroid) {
                    plataforma = 'Android';
                    final androidInfo = await deviceInfo.androidInfo;
                    imeiCod = androidInfo.id;
                  } else if (Platform.isIOS) {
                    plataforma = 'iOS';
                    //final iOSInfo = await deviceInfo.iosInfo;
                    //imeiCod = iOSInfo.;
                  } else {
                    plataforma = 'Desconocido';
                  }

                  Position position = await getLocation();

                  RegisterMobileRequestModel objRegisterMobileRequestModel = RegisterMobileRequestModel(
                    server: serverTxt.text,
                    key: keyTxt.text,
                    //imei: imeiCod,
                    imei: '823456047',
                    lat: position.latitude.toString(),//'-74.45445',
                    lon: position.longitude.toString(),//'72.74548487',
                    so: plataforma//'Android'
                  );

                  RegisterDeviceResponseModel respuesta = await AuthService().doneRegister(objRegisterMobileRequestModel);
                  context.pop();

                  if(respuesta.result.estado == 200){                    
                    context.push(objRutasGen.rutaDefault);
                  }
                  else{                    
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
                                
                                //const Text('Error al registrar el móvil:', style: TextStyle(color: Colors.red,)),
                                Container(
                                  color: Colors.transparent,
                                  height: size.height * 0.09,
                                  child: Image.asset('assets/gifs/gifErrorBlanco.gif'),
                                ),

                                Container(
                                  color: Colors.transparent,
                                  width: size.width * 0.95,
                                  height: size.height * 0.08,
                                  alignment: Alignment.center,
                                  child: AutoSizeText(
                                    respuesta.result.msmError,
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
                                // Acción para solicitar revisión
                                Navigator.of(context).pop();
                                //Navigator.of(context).pop();
                              },
                              child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
                catch(ex){
                  context.pop();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(ex.toString()),
                          
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Acción para solicitar revisión
                                Navigator.of(context).pop();
                                //Navigator.of(context).pop();
                              },
                              child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                            ),
                          ],
                        );
                      },
                    );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF536DFE), // Color del botón
                  borderRadius: BorderRadius.circular(20.0), // Bordes redondeados
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // Sombra bajo el botón
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Espaciado interno del botón
                child: Text(
                  'Comenzar',
                  style: TextStyle(
                    color: Colors.white,  // Color del texto
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
                  ),
                  /*
                  ElevatedButton(
                    onPressed: () {
                      context.push(objRutasGen.rutaDefault);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:Color(0xFF5C6BC0),
                      padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Comenzar',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  */
                ),
              
              ],
            ),
          ),
        ),
      ),
    );
  }

   Future<Position> getCurrentLocation() async 
   {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Los servicios de ubicación están desactivados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Los permisos de ubicación fueron denegados');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Los permisos de ubicación están denegados permanentemente.');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<Position> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verifica si el servicio de ubicación está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Si no está habilitado, puedes mostrar un mensaje o pedirle al usuario que lo active
      return Future.error('Los servicios de ubicación están desactivados.');
    }

    // Verifica si la aplicación tiene permisos de ubicación
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Si el usuario niega el permiso, muestra un mensaje
        return Future.error('Los permisos de ubicación fueron denegados');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Los permisos están denegados de forma permanente
      return Future.error('Los permisos de ubicación están denegados permanentemente.');
    }

    // Si tienes los permisos necesarios, obtiene la posición actual
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }


}