
import 'dart:convert';
import 'dart:io';
import 'package:cvs_ec_app/infraestructure/infraestructure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:cvs_ec_app/config/config.dart';
import 'package:cvs_ec_app/domain/domain.dart';
import 'package:intl/intl.dart';

const storageProspecto = FlutterSecureStorage();
MensajesAlertas objMensajesProspectoService = MensajesAlertas();
ResponseValidation objResponseValidationService = ResponseValidation();
final envPrsp = CadenaConexion();

class ProspectoTypeService extends ChangeNotifier{

  final String endPoint = CadenaConexion().apiEndpoint;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //ProspectoTypeService(String tipoIdent, String numIdent){
  ProspectoTypeService(){
    //getProspecto(tipoIdent, numIdent);
  }

  bool isValidForm(){
    return formKey.currentState?.validate() ?? false;
  }

  getProspectos() async {
    try{

      var codImei = await storage.read(key: 'codImei') ?? '';

      var objReg = await storage.read(key: 'RespuestaRegistro') ?? '';
      var obj = RegisterDeviceResponseModel.fromJson(objReg);

      var objLog = await storage.read(key: 'RespuestaLogin') ?? '';
      var objLogDecode = json.decode(objLog);

      List<MultiModel> lstMultiModel = [];

      lstMultiModel.add(
        MultiModel(model: 'crm.lead')
      );

      ConsultaMultiModelRequestModel objReq = ConsultaMultiModelRequestModel(
        jsonrpc: '2.0',
        params: ParamsMultiModels(
          bearer: obj.result.bearer,
          company: objLogDecode['result']['current_company'],
          imei: codImei,
          key: obj.result.key,
          tocken: obj.result.tocken,
          tockenValidDate: obj.result.tockenValidDate,
          uid: objLogDecode['result']['uid'],
          models: lstMultiModel
        )
      );

      var objRsp = await GenericService().getMultiModelos(objReq, "crm.lead");

      return json.encode(objRsp);
      
    }    
    on SocketException catch (_) {
      Fluttertoast.showToast(
        msg: objMensajesProspectoService.mensajeFallaInternet,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );  
    }
    
  }

  getProspecto(String tipoIdent,String numIdent) async {
    try{

      String tipoProspecto = await storageProspecto.read(key: 'tipoCliente') ?? '';
      final baseURL = '${endPoint}Prospectos/$tipoProspecto/$tipoIdent/$numIdent';

      final varResponse = await http.get(Uri.parse(baseURL));
      if(varResponse.statusCode != 200) return null;

      /*
      final prospRsp = ProspectoTypeResponse.fromJson(varResponse.body);
      varObjTipoRsp = prospRsp;
      if(prospRsp.succeeded && varObjTipoRsp!.data != null) {
        
        varObjTipoRsp!.data!.tipoCliente = tipoProspecto;

        if(prospRsp.statusCode == objResponseValidationService.responseExitoGet && prospRsp.succeeded){
          objRspProsp = prospRsp.data;
        }
      } else {
        prospRsp.succeeded = false;
        varObjTipoRsp!.succeeded = false;
      }
      */

      
      notifyListeners();
    }
    on SocketException catch (_) {
      Fluttertoast.showToast(
        msg: objMensajesProspectoService.mensajeFallaInternet,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
          
    }
    /*
    
    Future.microtask(() => 
                        Navigator.of(context, rootNavigator: true).pushReplacement(
                          CupertinoPageRoute<bool>(
                            fullscreenDialog: true,
                            builder: (BuildContext context) => ConexionInternetScreen(),
                          ),
                        )
                      );
    
     */
  }

  Future<bool> llenaData(ProspectoType objPrpTp) async {
    bool frmValido = true;

    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp  = RegExp(pattern);
/*
    if(!regExp.hasMatch(objPrpTp.email)) {
      frmValido = false;
    }
    */
    
/*
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final coordElegidas = prefs.getString("coordenadasIngreso");
    List<String> latLng = coordElegidas!.split(',');

    double latitude = double.parse(latLng[0]);
    double longitude = double.parse(latLng[1]);

    objPrpTp.latitud = latitude;
    objPrpTp.longitud = longitude;

    if(objPrpTp.fechaNacimiento.trim() == '' || objPrpTp.genero.trim() == null || objPrpTp.genero.trim() == 'S' || objPrpTp.direccion.trim() == null || objPrpTp.direccion.trim() == ''  || objPrpTp.email.trim() == '' || objPrpTp.longitud == 0 || objPrpTp.longitud == 0) {
      frmValido = false;
    }
    */

    if(objPrpTp.fechaNacimiento.trim() == '' || objPrpTp.genero.trim() == null || objPrpTp.genero.trim() == 'S' || objPrpTp.direccion.trim() == null || objPrpTp.direccion.trim() == '') {
      frmValido = false;
    }

    return frmValido;
  }

  getProspectoRegistrado(String phoneProsp) async {
    try{
      
      var codImei = await storage.read(key: 'codImei') ?? '';

      var objReg = await storage.read(key: 'RespuestaRegistro') ?? '';
      var obj = RegisterDeviceResponseModel.fromJson(objReg);

      var objLog = await storage.read(key: 'RespuestaLogin') ?? '';
      var objLogDecode = json.decode(objLog);

      List<MultiModel> lstMultiModel = [];

      lstMultiModel.add(
        MultiModel(model: 'crm.lead')
      );

      
      ConsultaMultiModelRequestModel objReq = ConsultaMultiModelRequestModel(
        jsonrpc: '2.0',
        params: ParamsMultiModels(
          bearer: obj.result.bearer,
          company: objLogDecode['result']['current_company'],
          imei: codImei,
          key: obj.result.key,
          tocken: obj.result.tocken,
          tockenValidDate: obj.result.tockenValidDate,
          uid: objLogDecode['result']['uid'],
          models: lstMultiModel
        )
      );

      String tockenValidDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(objReq.params.tockenValidDate);

      final headers = {
        "Content-Type": "application/json",
      };

      //final ruta = '${envPrsp.apiEndpoint}$codImei/done/crm/lead/status';

      String ruta = '';
      final objStr = await storage.read(key: 'RespuestaRegistro') ?? '';
      
      if(objStr.isNotEmpty)
      {  
        var obj = RegisterDeviceResponseModel.fromJson(objStr);
        ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/crm/lead/status';
      }

      final requestBody = {
        "jsonrpc": "2.0",
        "params": {
          "key": objReq.params.key,
          "tocken": objReq.params.tocken,
          "imei": objReq.params.imei,
          "uid": objReq.params.uid,
          "company": objReq.params.company,
          "bearer": objReq.params.bearer,
          "tocken_valid_date": tockenValidDate,
          "phone": phoneProsp
        }
      };

      final response = await http.post(
        Uri.parse(ruta),
        headers: headers,
        body: jsonEncode(requestBody), 
      );

      print("Consulta celular: ${response.body}");

      //return json.encode(objRsp);
      
    }    
    on SocketException catch (_) {
      Fluttertoast.showToast(
        msg: objMensajesProspectoService.mensajeFallaInternet,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );  
    }
    
  }

  registraProspecto(DatumCrmLead objProspecto) async {
    try{

      var codImei = await storage.read(key: 'codImei') ?? '';

      var objReg = await storage.read(key: 'RespuestaRegistro') ?? '';
      var obj = RegisterDeviceResponseModel.fromJson(objReg);

      var objLog = await storage.read(key: 'RespuestaLogin') ?? '';
      var objLogDecode = json.decode(objLog);

      List<MultiModel> lstMultiModel = [];

      lstMultiModel.add(
        MultiModel(model: 'crm.lead')
      );

      ConsultaMultiModelRequestModel objReq = ConsultaMultiModelRequestModel(
        jsonrpc: '2.0',
        params: ParamsMultiModels(
          bearer: obj.result.bearer,
          company: objLogDecode['result']['current_company'],
          imei: codImei,
          key: obj.result.key,
          tocken: obj.result.tocken,
          tockenValidDate: obj.result.tockenValidDate,
          uid: objLogDecode['result']['uid'],
          models: lstMultiModel
        )
      );

      String tockenValidDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(objReq.params.tockenValidDate);

      /*
      final requestBody = {
        "jsonrpc": "2.0",
        "params": {
          "name": objProspecto.name,
          "campaignId": objProspecto.campaignId.id,
          "countryId": objProspecto.countryId.id,
          "city": objProspecto.city,
          "mediumId": objProspecto.mediumId.id,
          "street": objProspecto.street,
          "description": objProspecto.description,
          "emailFrom": objProspecto.emailFrom,
          "partnerId": objProspecto.partnerId.id,
          "dayClose": objProspecto.dayClose,
        }
      };

      final headers = {
        "Content-Type": "application/json",
      };

      final ruta = '${envPrsp.apiEndpoint}${objReq.params.imei}/done/create/${jsonEncode(requestBody)}/model';

      final response = await http.post(
        Uri.parse(ruta),
        headers: headers,
        //body: jsonEncode(requestBody), 
      );
      */

      ////***//// */ ME FALTA LA OBSERVACIÓN
      
      final requestBody = {
      "jsonrpc": "2.0",
      "params": {
        "key": objReq.params.key,
        "tocken": objReq.params.tocken,
        "imei": objReq.params.imei,
        "uid": objReq.params.uid,
        "company": objReq.params.company,
        "bearer": objReq.params.bearer,
        "tocken_valid_date": tockenValidDate,
        "create": {
          "name": objProspecto.name,
          "phone": objProspecto.phone
        },
      }
    };

    final headers = {
      "Content-Type": "application/json",
    };

    //final ruta = '${envPrsp.apiEndpoint}${objReq.params.imei}/done/create/crm.lead/model';
    //final ruta = 'https://ekuasoft-taller-16347134.dev.odoo.com/api/v1/${objReq.params.imei}/done/create/crm.lead/model';

    String ruta = '';
    final objStr = await storage.read(key: 'RespuestaRegistro') ?? '';
    
    if(objStr.isNotEmpty)
    {  
      var obj = RegisterDeviceResponseModel.fromJson(objStr);
      ruta = '${obj.result.url}${objReq.params.imei}/done/create/crm.lead/model';
    }

    final response = await http.post(
      Uri.parse(ruta),
      headers: headers,
      body: jsonEncode(requestBody), 
    );
    
    //print(response.body);

      return ProspectoRegistroResponseModel.fromJson(response.body);
      //String tst = '';
    }    
    on SocketException catch (_) {
      Fluttertoast.showToast(
        msg: objMensajesProspectoService.mensajeFallaInternet,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );  
    }
    
  }

}
