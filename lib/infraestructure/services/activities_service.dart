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

      List<MultiModel> lstMultiModel = [];

      lstMultiModel.add(
        MultiModel(model: 'mail.activity')
      );

      final models = [
        {
          "model": EnvironmentsProd().modMailAct,
          "filters": [
            //["date_deadline","=",DateFormat('yyyy-MM-dd', 'es').format(DateTime.now())],
            //["res_id","=",id],
            ["res_model_id","=",501]
          ]
        },
      ];

      var codImei = await storageProspecto.read(key: 'codImei') ?? '';

      var objReg = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
      var obj = RegisterDeviceResponseModel.fromJson(objReg);

      var objLog = await storageProspecto.read(key: 'RespuestaLogin') ?? '';
      var objLogDecode = json.decode(objLog);

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
          models: []
        )
      );

      String ruta = '';
      final objStr = await storageCamp.read(key: 'RespuestaRegistro') ?? '';
      
      if(objStr.isNotEmpty)
      {  
        var obj = RegisterDeviceResponseModel.fromJson(objStr);
        ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/data/multi/models';
      }

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
          "models": models
        }
      };

      final headers = {
        "Content-Type": EnvironmentsProd().contentType//"application/json",
      };

      final response = await http.post(
        Uri.parse(ruta),
        headers: headers,
        body: jsonEncode(requestBody), 
      );
      
      //var rspValidacion = json.decode(response.body);

    //print('Lst gen: ${response.body}');

      var rsp = AppResponseModel.fromRawJson(response.body);


      await storageCamp.write(key: 'cmbLstActividades', value: json.encode(rsp.result.data.mailActivity));


      String cmbLstAct = await storageCamp.read(key: 'cmbLstActividades') ?? '';

      ActivitiesResponseModel objActividades = ActivitiesResponseModel.fromRawJson(cmbLstAct);
      
      return objActividades;
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

      if(id == 0){
        var strMem = await storageAct.read(key: 'idMem') ?? '';

        id = int.parse(strMem);
      }

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

      var codImei = await storageProspecto.read(key: 'codImei') ?? '';

      var objReg = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
      var obj = RegisterDeviceResponseModel.fromJson(objReg);

      var objLog = await storageProspecto.read(key: 'RespuestaLogin') ?? '';
      var objLogDecode = json.decode(objLog);

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
          models: []
        )
      );

      String ruta = '';
      final objStr = await storageCamp.read(key: 'RespuestaRegistro') ?? '';
      
      if(objStr.isNotEmpty)
      {  
        var obj = RegisterDeviceResponseModel.fromJson(objStr);
        ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/data/multi/models';
      }

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
          "models": models
        }
      };

      final headers = {
        "Content-Type": EnvironmentsProd().contentType//"application/json",
      };

      final response = await http.post(
        Uri.parse(ruta),
        headers: headers,
        body: jsonEncode(requestBody), 
      );
      
      //var rspValidacion = json.decode(response.body);

    //print('Lst gen: ${response.body}');

      var rsp = AppResponseModel.fromRawJson(response.body);


      await storageCamp.write(key: 'cmbLstActividades', value: json.encode(rsp.result.data.mailActivity));


      String cmbLstAct = await storageCamp.read(key: 'cmbLstActividades') ?? '';

      ActivitiesResponseModel objActividades = ActivitiesResponseModel.fromRawJson(cmbLstAct);
      
      return objActividades;
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

  getActivitiesByFecha(fecha) async {
    try{

      List<MultiModel> lstMultiModel = [];

      lstMultiModel.add(
        MultiModel(model: 'mail.activity')
      );

      final models = [
        {
          "model": EnvironmentsProd().modMailAct,
          "filters": [
            ["date_deadline","=",fecha],            
            ["res_model_id","=",501]
          ]
        },
      ];

      var codImei = await storageProspecto.read(key: 'codImei') ?? '';

      var objReg = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
      var obj = RegisterDeviceResponseModel.fromJson(objReg);

      var objLog = await storageProspecto.read(key: 'RespuestaLogin') ?? '';
      var objLogDecode = json.decode(objLog);

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
          models: []
        )
      );

      String ruta = '';
      final objStr = await storageCamp.read(key: 'RespuestaRegistro') ?? '';
      
      if(objStr.isNotEmpty)
      {  
        var obj = RegisterDeviceResponseModel.fromJson(objStr);
        ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/data/multi/models';
      }

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
          "models": models
        }
      };

      final headers = {
        "Content-Type": EnvironmentsProd().contentType//"application/json",
      };

      final response = await http.post(
        Uri.parse(ruta),
        headers: headers,
        body: jsonEncode(requestBody), 
      );
      
      //var rspValidacion = json.decode(response.body);

    //print('Lst gen: ${response.body}');

      var rsp = AppResponseModel.fromRawJson(response.body);


      await storageCamp.write(key: 'cmbLstActividades', value: json.encode(rsp.result.data.mailActivity));


      String cmbLstAct = await storageCamp.read(key: 'cmbLstActividades') ?? '';

      ActivitiesResponseModel objActividades = ActivitiesResponseModel.fromRawJson(cmbLstAct);
      
      return objActividades;
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

  getActivitiesByRangoFechas(fechas, resId) async {
    try{

      List<MultiModel> lstMultiModel = [];

      lstMultiModel.add(
        MultiModel(model: 'mail.activity')
      );

      if(resId == 0){        
        var idMem = await storageProspecto.read(key: 'idMem') ?? '';

        if(idMem.isNotEmpty){
          resId = int.parse(idMem);
        }        
      }

      var models = [];

      if(fechas == 'mem'){
        var fecMem = await storageProspecto.read(key: 'fecMem') ?? '';

        if(fecMem.isNotEmpty){
          DateTime fecha = DateTime.parse(fecMem);
          fechas = null;
          fechas = [];
          fechas.add(fecha);
        } else {
          fechas = null;
        }
      } else {
        var fecMem = await storageProspecto.read(key: 'fecMem') ?? '';

        if(fecMem.isNotEmpty){
          DateTime fecha = DateTime.parse(fecMem);

          fechas = null;
          fechas = [];

          fechas.add(fecha);
        }
      }

      if(fechas == null){
        models = [
          {
            "model": EnvironmentsProd().modMailAct,
            "filters": [            
              ["date_deadline","=",DateFormat('yyyy-MM-dd', 'es').format(DateTime.now())],            
              ["res_model_id", "=", 501],
              if(resId > 0)
              ["res_id", "=", resId]
            ]
          },
        ];
      } else {
        try{
          models = [
            {
            "model": EnvironmentsProd().modMailAct,
            "filters": [            
              ["date_deadline",">=",DateFormat('yyyy-MM-dd', 'es').format(fechas[0])],            
              ["date_deadline","<=",DateFormat('yyyy-MM-dd', 'es').format(fechas[1])],
              ["res_model_id", "=", 501],
              if(resId > 0)
              ["res_id", "=", resId]
            ]
          },
        ];
        }
        catch(_)
        {
          models = [
              {
              "model": EnvironmentsProd().modMailAct,
              "filters": [            
                ["date_deadline","=",DateFormat('yyyy-MM-dd', 'es').format(fechas[0])],            
                ["res_model_id", "=", 501],
                if(resId > 0)
                ["res_id", "=", resId]
              ]
            },
          ];
        }
      }

      var codImei = await storageProspecto.read(key: 'codImei') ?? '';

      var objReg = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
      var obj = RegisterDeviceResponseModel.fromJson(objReg);

      var objLog = await storageProspecto.read(key: 'RespuestaLogin') ?? '';
      var objLogDecode = json.decode(objLog);

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
          models: []
        )
      );

      String ruta = '';
      final objStr = await storageCamp.read(key: 'RespuestaRegistro') ?? '';
      
      if(objStr.isNotEmpty)
      {  
        var obj = RegisterDeviceResponseModel.fromJson(objStr);
        ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/data/multi/models';
      }

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
          "models": models
        }
      };

      final headers = {
        "Content-Type": EnvironmentsProd().contentType//"application/json",
      };

      final response = await http.post(
        Uri.parse(ruta),
        headers: headers,
        body: jsonEncode(requestBody), 
      );
      
      var rsp = AppResponseModel.fromRawJson(response.body);

      print('Test: ${response.body}');

      String cmbLstAct = json.encode(rsp.result.data.mailActivity);//await storageCamp.read(key: 'cmbLstActividades') ?? '';

      ActivitiesResponseModel objActividades = ActivitiesResponseModel.fromRawJson(cmbLstAct);

      var lstProsp = await storageCamp.read(key: 'RespuestaProspectos') ?? '';

      var objLogDecode2 = json.decode(lstProsp);      

      CrmLeadAppModel apiResponse = CrmLeadAppModel.fromJson(objLogDecode2);

      CrmLeadDatumAppModel? objFin;
      
      for(int i = 0; i < apiResponse.data.length; i++){
        if(apiResponse.data[i].id == resId){
          //prospectosFiltrados.add(apiResponse.data[i]);
          objFin = apiResponse.data[i];
        }
      }

      DatumCrmLead objDatumCrmLeadFin = DatumCrmLead(
        activityIds: [],//objFin!.activityIds,
        campaignId: CampaignId(
          id: objFin?.campaignId.id ?? 0,
          name: objFin?.campaignId.name ?? ''
        ),
        countryId: StructCombos(
          id: objFin?.countryId.id ?? 0,
          name: objFin?.countryId.name ?? ''
        ),
        dayClose: 0,//objFin.dateClose,
        emailFrom: objFin?.emailFrom ?? '',
        expectedRevenue: objFin?.expectedRevenue ?? 0,
        id: objFin?.id ?? 0,
        lostReasonId: CampaignId(
          id: objFin?.lostReasonId.id ?? 0,
          name: objFin?.lostReasonId.name ?? ''
        ),
        mediumId: StructCombos(
          id: objFin?.mediumId.id ?? 0,
          name: objFin?.mediumId.name ?? ''
        ),
        name: objFin?.name ?? '',
        partnerId: StructCombos(
          id: objFin?.partnerId.id ?? 0,
          name: objFin?.partnerId.name ?? ''
        ),
        priority: objFin?.priority ?? '',
        sourceId: StructCombos(
          id: objFin?.sourceId.id ?? 0,
          name: objFin?.sourceId.name ?? ''
        ),
        stageId: StructCombos(
          id: objFin?.stageId.id ?? 0,
          name: objFin?.stageId.name ?? ''
        ),
        stateId: StructCombos(
          id: objFin?.stateId.id ?? 0,
          name: objFin?.stateId.name ?? ''
        ),
        tagIds: objFin?.tagIds ?? [],
        title: CampaignId(
          id: objFin?.title.id ?? 0,
          name: objFin?.title.name ?? ''
        ),
        type: objFin?.type ?? '',
        //city: objFin!.cit
        contactName: objFin?.contactName,
        dateClose: objFin?.dateClose,
        dateDeadline: objFin?.dateDeadline,
        dateOpen: objFin?.dateOpen,
        description: objFin?.description,
        //emailCc: objFin!.em
        mobile: '',
        city: '',
        emailCc: '',
        partnerName: objFin?.partnerId.name ?? '',
        phone: objFin?.phone,
        probability: objFin?.probability,
        referred: objFin?.referred,
        street: objFin?.street,
        userId: StructCombos(
          id: objFin?.userId.id ?? 0,
          name: objFin?.userId.name ?? ''
        ),
      );

      ActivitiesPageModel objRspFinal = ActivitiesPageModel(
        activities: objActividades,
        lead: objDatumCrmLeadFin
      );
      
      return objRspFinal;
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
              "note": objActividad.note,
              //"working_time": objActividad.workingTime,
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

  cierreActividadesXId(ActivitiesTypeRequestModel objActividad) async {
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
            "write": {
              "date_deadline": DateFormat('yyyy-MM-dd', 'es').format(objActividad.dateDeadline!),//date_deadline
              //"create_date": DateFormat('yyyy-MM-dd', 'es').format(objActividad.createDate!),
              //"create_uid": objReq.params.uid,//objActividad.createUid,          
              //"active": true,
              //"previous_activity_type_id": objActividad.previousActivityTypeId,
              //"display_name": objActividad.displayName,
              //"activity_type_id": objActividad.activityTypeId,
              "res_model_id": 501,
              "user_id": objActividad.userId,
              "res_id": objActividad.resId,
              "summary": objActividad.note,
              "note": objActividad.note,
              "id": objActividad.actId,
              "working_time": objActividad.workingTime,
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
          ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/write/mail.activity/model';
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
