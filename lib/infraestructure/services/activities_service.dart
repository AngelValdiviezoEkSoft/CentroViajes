import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:cvs_ec_app/infraestructure/infraestructure.dart';
import 'package:cvs_ec_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cvs_ec_app/domain/domain.dart';
import 'package:intl/intl.dart';

const storageAct = FlutterSecureStorage();

class ActivitiesService extends ChangeNotifier{

  final TokenManager tokenManager = TokenManager();

  final String endPoint = CadenaConexion().apiEndpoint;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  getActivities() async {
    try{

      var codImei = await storageCamp.read(key: 'codImei') ?? '';

      var objReg = await storageCamp.read(key: 'RespuestaRegistro') ?? '';
      var obj = RegisterDeviceResponseModel.fromJson(objReg);

      var objLog = await storageCamp.read(key: 'RespuestaLogin') ?? '';
      var objLogDecode = json.decode(objLog);

      List<MultiModel> lstMultiModel = [];

      lstMultiModel.add(
        MultiModel(model: 'mail.activity.type')
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

      tokenManager.startTokenCheck();

      var rsp = await GenericService().getMultiModelos(objReq, "mail.activity.type");
      
      return rsp;
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

  getActivitiesById(id) async {
    try{

      //var codImei = await storageCamp.read(key: 'codImei') ?? '';

      var objReg = await storageCamp.read(key: 'RespuestaRegistro') ?? '';
      var obj = RegisterDeviceResponseModel.fromJson(objReg);

      var objLog = await storageCamp.read(key: 'RespuestaLogin') ?? '';
      var objLogDecode = json.decode(objLog);

      List<MultiModel> lstMultiModel = [];

      lstMultiModel.add(
        MultiModel(model: 'mail.activity')
      );

      final models = [
        {
          "model": EnvironmentsProd().modMailAct,
          "filters": [
            //["date_deadline","=",DateFormat('yyyy-MM-dd', 'es').format(DateTime.now())],
            ["res_id","=",id],
            ["res_model_id","=",501]
          ]
        },
      ];

      await DataInicialService().readModelosApp(models);

      String cmbLstAct = await storageCamp.read(key: 'cmbLstActividades') ?? '';

/*
      var lstMemoriaActividades = cmbLstAct;

      var objCamp = json.decode(lstMemoriaActividades);
      */

      //var objCamp3 = objCamp['data'];

      //print('Lista Act: $objCamp');

      ActivitiesResponseModel objActividades = ActivitiesResponseModel.fromRawJson(cmbLstAct);
      
      return objActividades;
    }
    catch(_){
      //print('Test: $ex');
    }
    /*
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
    */
  }

  getActivitiesByRangoFechas(fechas) async {
    try{
      var objReg = await storageCamp.read(key: 'RespuestaRegistro') ?? '';
      var obj = RegisterDeviceResponseModel.fromJson(objReg);

      var objLog = await storageCamp.read(key: 'RespuestaLogin') ?? '';
      var objLogDecode = json.decode(objLog);

      List<MultiModel> lstMultiModel = [];

      lstMultiModel.add(
        MultiModel(model: 'mail.activity')
      );

      final models = [
        {
          "model": EnvironmentsProd().modMailAct,
          "filters": [
            ["date_deadline","=",fechas]//DateFormat('yyyy-MM-dd', 'es').format(DateTime.now())],            
          ]
        },
      ];

      await DataInicialService().readModelosApp(models);

      String cmbLstAct = await storageCamp.read(key: 'cmbLstActividades') ?? '';

      ActivitiesResponseModel objActividades = ActivitiesResponseModel.fromRawJson(cmbLstAct);
      
      return objActividades;
    }
    catch(ex){
      print('Test: $ex');
    }
  }

  registroActividades(ActivitiesTypeRequestModel objActividad) async {
    String internet = await ValidacionesUtils().validaInternet();
    
    //VALIDACIÓN DE INTERNET
    if(internet.isEmpty){
      
      try{

        var codImei = await storageProspecto.read(key: 'codImei') ?? '';

        var objReg = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
        var obj = RegisterDeviceResponseModel.fromJson(objReg);

        var objLog = await storageProspecto.read(key: 'RespuestaLogin') ?? '';
        var objLogDecode = json.decode(objLog);

        //print('Test DatosLogin: $objLog');

        List<MultiModel> lstMultiModel = [];

        lstMultiModel.add(
          MultiModel(model: "mail.activity")
        );

        ConsultaMultiModelRequestModel objReq = ConsultaMultiModelRequestModel(
          jsonrpc: EnvironmentsProd().jsonrpc,
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

        final requestBody = {
          "jsonrpc": EnvironmentsProd().jsonrpc,
          "params": {
            "key": objReq.params.key,
            "tocken": objReq.params.tocken,
            "imei": objReq.params.imei,
            "uid": objReq.params.uid,
            "company": objReq.params.company,
            "bearer": objReq.params.bearer,
            "tocken_valid_date": tockenValidDate,
            "create": {
              "date_deadline": DateFormat('yyyy-MM-dd', 'es').format(objActividad.dateDeadline!),//date_deadline
              "create_date": DateFormat('yyyy-MM-dd', 'es').format(objActividad.createDate!),
              "create_uid": objReq.params.uid,//objActividad.createUid,          
              "active": true,
              "previous_activity_type_id": objActividad.previousActivityTypeId,
              "display_name": objActividad.displayName,
              "activity_type_id": objActividad.activityTypeId,
              "res_model_id": 501,
              "user_id": objActividad.userId,
              "res_id": objActividad.resId,
              "summary": objActividad.note,
              "note": objActividad.note
            },
          }
        };

        final headers = {
          "Content-Type": EnvironmentsProd().contentType
        };

        String ruta = '';
        final objStr = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
        
        if(objStr.isNotEmpty)
        {
          var obj = RegisterDeviceResponseModel.fromJson(objStr);
          ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/create/mail.activity/model';
        }

        final response = await http.post(
          Uri.parse(ruta),
          headers: headers,
          body: jsonEncode(requestBody), 
        );

        print('respuesta: ${response.body}');
      
        var rspValidacion = json.decode(response.body);

        if(rspValidacion['result']['mensaje'] != null && (rspValidacion['result']['mensaje'].toString().trim().toLowerCase() == MensajeValidacion().tockenNoValido || rspValidacion['result']['mensaje'].toString().trim().toLowerCase() == MensajeValidacion().tockenExpirado)){
          await tokenManager.checkTokenExpiration();
          await registroActividades(objActividad);
        } 

        var objRspPrsp = await storageProspecto.read(key: 'RegistraActividad') ?? '';

        ActividadRegistroResponseModel objLead = ActividadRegistroResponseModel(
          id: 0,
          jsonrpc: '',
          result: ResultActividad(
            data: [],
            estado: 0,
            mensaje: ''
          )
        );

        if(objRspPrsp.isNotEmpty){
          objLead = ActividadRegistroResponseModel.fromRawJson(objRspPrsp);

          objLead.result.data.length = objLead.result.data.length;
        }

        var objRespuestaFinal = ActividadRegistroResponseModel.fromRawJson(response.body);

        for(int i = 0; i < objLead.result.data.length; i++)
        {
          Datum objCrmLeadDatumAppModel = Datum(
            activityTypeId: objLead.result.data[i].activityTypeId,
            dateDeadline: objLead.result.data[i].dateDeadline,
            id: objLead.result.data[i].id,
            resId: objLead.result.data[i].resId,
            resModel: objLead.result.data[i].resModel,
            userId: objLead.result.data[i].userId
          );

          objRespuestaFinal.result.data.add(objCrmLeadDatumAppModel);

        }

        await storageProspecto.write(key: 'RegistraActividad', value: jsonEncode(objRespuestaFinal.toJson()));

        return objRespuestaFinal;
      } 
      catch(ex){
        print('Error al grabar: $ex');
      }
    } else {
      await storageProspecto.write(key: 'RegistraActividad', value: jsonEncode(objActividad.toJson()));

      return ProspectoRegistroResponseModel(
        id: 0,
        jsonrpc: '',
        result: ProspectoRegistroModel(
          estado: 0, 
          mensaje: '', 
          data: []
        ),
        mensaje: 'No tiene conexión a internet, ahora tiene datos pendientes de grabar.'
      );
    }

  }

  cierreActividadesX(ActivitiesTypeRequestModel objActividad) async {
    String internet = await ValidacionesUtils().validaInternet();
    
    //VALIDACIÓN DE INTERNET
    if(internet.isEmpty){
      
      try{

        var codImei = await storageProspecto.read(key: 'codImei') ?? '';

        var objReg = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
        var obj = RegisterDeviceResponseModel.fromJson(objReg);

        var objLog = await storageProspecto.read(key: 'RespuestaLogin') ?? '';
        var objLogDecode = json.decode(objLog);

        //print('Test DatosLogin: $objLog');

        List<MultiModel> lstMultiModel = [];

        lstMultiModel.add(
          MultiModel(model: "mail.activity")
        );

        ConsultaMultiModelRequestModel objReq = ConsultaMultiModelRequestModel(
          jsonrpc: EnvironmentsProd().jsonrpc,
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

        final requestBody = {
          "jsonrpc": EnvironmentsProd().jsonrpc,
          "params": {
            "key": objReq.params.key,
            "tocken": objReq.params.tocken,
            "imei": objReq.params.imei,
            "uid": objReq.params.uid,
            "company": objReq.params.company,
            "bearer": objReq.params.bearer,
            "tocken_valid_date": tockenValidDate,
            "create": {
              "date_deadline": DateFormat('yyyy-MM-dd', 'es').format(objActividad.dateDeadline!),//date_deadline
              "create_date": DateFormat('yyyy-MM-dd', 'es').format(objActividad.createDate!),
              "create_uid": objReq.params.uid,//objActividad.createUid,          
              "active": true,
              "previous_activity_type_id": objActividad.previousActivityTypeId,
              "display_name": objActividad.displayName,
              "activity_type_id": objActividad.activityTypeId,
              "res_model_id": 501,
              "user_id": objActividad.userId,
              "res_id": objActividad.resId,
              "summary": objActividad.note,
              "note": objActividad.note
            },
          }
        };

        final headers = {
          "Content-Type": EnvironmentsProd().contentType
        };

        String ruta = '';
        final objStr = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
        
        if(objStr.isNotEmpty)
        {
          var obj = RegisterDeviceResponseModel.fromJson(objStr);
          ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/create/mail.activity/model';
        }

        final response = await http.post(
          Uri.parse(ruta),
          headers: headers,
          body: jsonEncode(requestBody), 
        );

        print('respuesta: ${response.body}');
      
        var rspValidacion = json.decode(response.body);

        if(rspValidacion['result']['mensaje'] != null && (rspValidacion['result']['mensaje'].toString().trim().toLowerCase() == MensajeValidacion().tockenNoValido || rspValidacion['result']['mensaje'].toString().trim().toLowerCase() == MensajeValidacion().tockenExpirado)){
          await tokenManager.checkTokenExpiration();
          await registroActividades(objActividad);
        } 

        var objRspPrsp = await storageProspecto.read(key: 'RegistraActividad') ?? '';

        ActividadRegistroResponseModel objLead = ActividadRegistroResponseModel(
          id: 0,
          jsonrpc: '',
          result: ResultActividad(
            data: [],
            estado: 0,
            mensaje: ''
          )
        );

        if(objRspPrsp.isNotEmpty){
          objLead = ActividadRegistroResponseModel.fromRawJson(objRspPrsp);

          objLead.result.data.length = objLead.result.data.length;
        }

        var objRespuestaFinal = ActividadRegistroResponseModel.fromRawJson(response.body);

        for(int i = 0; i < objLead.result.data.length; i++)
        {
          Datum objCrmLeadDatumAppModel = Datum(
            activityTypeId: objLead.result.data[i].activityTypeId,
            dateDeadline: objLead.result.data[i].dateDeadline,
            id: objLead.result.data[i].id,
            resId: objLead.result.data[i].resId,
            resModel: objLead.result.data[i].resModel,
            userId: objLead.result.data[i].userId
          );

          objRespuestaFinal.result.data.add(objCrmLeadDatumAppModel);

        }

        await storageProspecto.write(key: 'RegistraActividad', value: jsonEncode(objRespuestaFinal.toJson()));

        return objRespuestaFinal;
      } 
      catch(ex){
        print('Error al grabar: $ex');
      }
    } else {
      await storageProspecto.write(key: 'RegistraActividad', value: jsonEncode(objActividad.toJson()));

      return ProspectoRegistroResponseModel(
        id: 0,
        jsonrpc: '',
        result: ProspectoRegistroModel(
          estado: 0, 
          mensaje: '', 
          data: []
        ),
        mensaje: 'No tiene conexión a internet, ahora tiene datos pendientes de grabar.'
      );
    }

  }

}
