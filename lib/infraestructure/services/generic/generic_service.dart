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

class GenericService extends ChangeNotifier {
  final env = CadenaConexion();
  final storage = const FlutterSecureStorage();
  List<OpcionesMenuModel> lstOp = [];

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  getModelos(ConsultaModelRequestModel objReq) async {
    final ruta = '${env.apiEndpoint}<imei>/done/data/<model>/model';
    
    final Map<String, dynamic> body = 
    {
      "jsonrpc": "2.0",
      "params": {
        "key": objReq.params.key,//"EKzbvpyoQJhresnrSCN1PzMfAc", 
        "tocken": objReq.params.tocken,//"LKMZ1g83WCGwHCy3bXHe2breLesTACkBmQDqBKjelJ9PoxQs", 
        "imei": objReq.params.imei,//"523456789",
        "uid": objReq.params.uid,//5,
        "company": objReq.params.company,//5,
        "bearer": objReq.params.bearer,//"RUt6YnZweW9RSmhyZXNuclNDTjFQek1mQWM1MjM0NTY3ODlMS01aMWc4M1dDR3dIQ3kzYlhIZTJicmVMZXNUQUNrQm1RRHFCS2plbEo5UG94UXMyMDI0LTExLTA3IDE5OjQ0OjQx",                           
        "tocken_valid_date": objReq.params.tockenValidDate,//"2024-11-07 19:44:41",
        "filters": ''
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
  
  getMultiModelos(ConsultaMultiModelRequestModel objReq) async {
    final ruta = '${env.apiEndpoint}done/data/multi/models';
    //https://<tu_dominio_odoo>/api/v1/<imei>/done/data/multi/models

    List<MultiModel> lstMultiModel = [];

    for(int i = 0; i < objReq.params.models.length; i++){
      lstMultiModel.add(objReq.params.models[i]);
    }

    final Map<String, dynamic> body = 
    {
      "jsonrpc": "2.0",
      "params": {
      "key": objReq.params.key,//"EKzbvpyoQJhresnrSCN1PzMfAc", 
      "tocken": objReq.params.tocken,//"LKMZ1g83WCGwHCy3bXHe2breLesTACkBmQDqBKjelJ9PoxQs", 
      "imei": objReq.params.imei,//"523456789",
      "uid": objReq.params.uid,//5,
      "company": objReq.params.company,//5,
      "bearer": objReq.params.bearer,//"RUt6YnZweW9RSmhyZXNuclNDTjFQek1mQWM1MjM0NTY3ODlMS01aMWc4M1dDR3dIQ3kzYlhIZTJicmVMZXNUQUNrQm1RRHFCS2plbEo5UG94UXMyMDI0LTExLTA3IDE5OjQ0OjQx",                           
      "tocken_valid_date": objReq.params.tockenValidDate,//"2024-11-07 19:44:41",
      "models": jsonEncode(lstMultiModel),
      /*
      [
        {
          "model": "res.partner",
          //"filters": [["is_company", "=", True]]
        },
        {
          "model": "product.template",
          //"filters": [["sale_ok", "=", True]]
        }

        ]
        */
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

}
