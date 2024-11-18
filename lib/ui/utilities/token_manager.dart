import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cvs_ec_app/domain/domain.dart';
import 'package:cvs_ec_app/infraestructure/infraestructure.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class TokenManager {
  Timer? _timer;

  // Iniciar la verificación del token cada X minutos (por ejemplo, 5 minutos)
  void startTokenCheck() async {
    /*
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) async {
      await checkTokenExpiration();
    });
    */
    await checkTokenExpiration();
  }

  // Detener el temporizador
  void stopTokenCheck() {
    //_timer?.cancel();
  }

  // Verificar si el token ha expirado
  Future<void> checkTokenExpiration() async {
    
    //const imeiMovile = MethodChannel('com.ekuasoft.cvs_ec_app/imei');
    /*
    const imeiMovile = MethodChannel('device/info');
    final String? imeiFinal = await imeiMovile.invokeMethod('deviceId');
    */

    String imeiCod = '';

    final deviceInfo = DeviceInfoPlugin();
    
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      imeiCod = androidInfo.id;
    } else if (Platform.isIOS) {
      //plataforma = 'iOS';
      //final iOSInfo = await deviceInfo.iosInfo;
      //imeiCod = iOSInfo.;
    } else {
      //plataforma = 'Desconocido';
    }

    const storage = FlutterSecureStorage();
    
    final objStr = await storage.read(key: 'RespuestaRegistro') ?? '';
    
    if(objStr.isNotEmpty)
    {  
      var obj = RegisterDeviceResponseModel.fromJson(objStr);

      final expiration = obj.result.tockenValidDate;

      imeiCod = '823456041'; //BORRAR LUEGO

      //VALIDACIÓN DE TOKEN
      
      final objRspValida = await AuthService().doneValidateTocken(imeiCod, obj.result.key, obj.result.tocken);//'456200');//obj.result.key);

      final data = json.decode(objRspValida);
      final codEstado = data['result']['estado'];

      if(codEstado != 200){
        return;
      }

      //DateTime nuevaFecha = expiration.subtract(const Duration(days: 8));

      if (DateTime.now().isAfter(expiration)) {
      //if (DateTime.now().isAfter(nuevaFecha)) {
        // Token expirado: realiza alguna acción (por ejemplo, redirigir a la pantalla de inicio de sesión)
        //print("Token expirado. Realizando acción.");
        // Aquí puedes llamar a la función de logout o refrescar el token.        
        await AuthService().doneGetTocken(imeiCod, obj.result.key);        
      }
      
    }
  }
}
