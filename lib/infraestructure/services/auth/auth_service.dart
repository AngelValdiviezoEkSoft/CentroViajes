import 'dart:async';
import 'dart:convert';

import 'package:cvs_ec_app/config/config.dart';
import 'package:cvs_ec_app/config/routes/app_router.dart';
import 'package:cvs_ec_app/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

//import '../../config/routes/routes.dart';

late Timer _timer;

class AuthService extends ChangeNotifier {
  final env = CadenaConexion();
  final storage = const FlutterSecureStorage();
  List<OpcionesMenuModel> lstOp = [];

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String passWord = '';
  String email = '';
  bool _areInputsView = false;
  bool _inputPin = false;

  bool get areInputsView => _areInputsView;
  set areInputsView(bool value) {
    _areInputsView = value;
    notifyListeners();
  }

  bool get inputPin => _inputPin;
  set inputPin(bool value) {
    _inputPin = value;
    notifyListeners();
  }

  bool isLoading = false;
  bool get varIsLoading => isLoading;
  set varIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  bool isLoadingCambioClave = false;
  bool get varIsLoadingCambioClave => isLoadingCambioClave;
  set varIsLoadingCambioClave(bool value) {
    isLoadingCambioClave = value;
    notifyListeners();
  }

  String varCedula = '';
  String varPasaporte = '';

  bool isOscured = true;
  bool get varIsOscured => isOscured;
  set varIsOscured(bool value) {
    isOscured = value;
    notifyListeners();
  }

  bool isOscuredConf = true;
  bool get varIsOscuredConf => isOscuredConf;
  set varIsOscuredConf(bool value) {
    isOscuredConf = value;
    notifyListeners();
  }

  bool isOscuredConfNew = true;
  bool get varIsOscuredConfNew => isOscuredConfNew;
  set varIsOscuredConfNew(bool value) {
    isOscuredConfNew = value;
    notifyListeners();
  }

  bool isPasaporte = false;
  bool get varIsPasaporte => isPasaporte;
  set varIsPasaporte(bool value) {
    isPasaporte = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  //#region Registro Dispositivo
  doneRegister(RegisterMobileRequestModel objRegister) async {
    final ruta = '${env.apiEndpoint}done/register';

    final Map<String, dynamic> body = {
    "jsonrpc": "2.0",
    "params": {
      "server": objRegister.server,
      "key": objRegister.key,
      "imei": objRegister.imei,
      "lat": objRegister.lat,
      "lon": objRegister.lon,
      "so": objRegister.so
      }
    };
    
    final response = await http.post(
      Uri.parse(ruta),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );
    
    var reponseRs = response.body;

    //print("Test: " + response.body);

    var obj = RegisterDeviceResponseModel.fromJson(reponseRs);

    //final data = json.encode(obj.result);
    await storage.write(key: 'RespuestaRegistro', value: reponseRs);

    return obj;//RegisterDeviceResponseModel.fromJson(reponseRs);
    
  }
  
  doneGetTocken(String imei, String key) async {
    final ruta = '${env.apiEndpoint}done/$imei/tocken/$key';
    
    final Map<String, dynamic> body = {
      "jsonrpc": "2.0",
      "params": {}
    };
    
    final response = await http.post(
      Uri.parse(ruta),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );
    
    var reponseRs = response.body;

    var obj = RegisterDeviceResponseModel.fromJson(reponseRs);

    await storage.write(key: 'RespuestaRegistro', value: '');
    await storage.write(key: 'RespuestaRegistro', value: reponseRs);

    return obj;    
  }
  
  doneValidateTocken(String imei, String key) async {
    final ruta = '${env.apiEndpoint}done/$imei/validate/tocken/$key';
    
     final response = await http.post(
      Uri.parse(ruta),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      /*
      body: jsonEncode(
        <String, String>
        {
          "server": objRegister.server,
          "key": objRegister.key,
          "imei": objRegister.imei,
          "lat": objRegister.lat,
          "lon": objRegister.lon,
          "so": objRegister.so
        }
      ),
      */
    );
    
    var reponseRs = response.body;
    return RegisterDeviceResponseModel.fromJson(reponseRs);
    
  }
  
  //#endregion

  login(AuthRequest authRequest, String ruta) async {
    try {

      final response = await http.post(
        Uri.parse(ruta),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>
          {
            "db": authRequest.db,
            "login": authRequest.login,
            "password": authRequest.password
          }
        ),
      );

      final oResp = AuthResponseModel.fromJson(response.body);

      return oResp;
    } catch (e) {
      /*
      return RespuestaGenericaModel(
          code: 1,
          description: 'Failed',
          detail: RespuestaGenericaDetailModel(response: 'Error interno'),
          status: '');
          */
    }
  }

  consultaUsuarios(ConsultaDatosRequestModel authRequest, String imei, String key) async {
    final ruta = '${env.apiEndpoint}<imei>/done/data/<model>/model';
    
     final response = await http.post(
      Uri.parse(ruta),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>
        {
          "key": authRequest.key,
          "tocken": authRequest.token,
          "imei": authRequest.imei,
          "uid": authRequest.uid,
          "company": authRequest.company,
          "bearer": authRequest.bearer,
          "tocken_valid_date": authRequest.tokenValidDate,
          //"filters": objRegister.so  //PEDIR EJEMPLO
        }
      ),
    );
    
    var reponseRs = response.body;
    return RegisterDeviceResponseModel.fromJson(reponseRs);
    
  }
  
    Future<dynamic> opcionesMenuPorPerfil(BuildContext context) async {
    lstOp = [
      OpcionesMenuModel(
        descMenu: 'Editar Perfil', 
        icono: Icons.person_pin, 
        onPress: () => context.push(objRutas.rutaEditarPerfil),
      ),
      OpcionesMenuModel(
        descMenu: 'Soporte', 
        icono: Icons.question_mark,
        onPress: () => context.push(objRutas.rutaConstruccion),
      ),
      OpcionesMenuModel(
        descMenu: 'Terminos de uso',
        icono: Icons.info,
        onPress: () => context.push(objRutas.rutaConstruccion),
      ),
    ];
    return lstOp;
  }

  Future logOut() async {
    await storage.deleteAll();
    //await cleanPreferences();
    return;
  }

}
