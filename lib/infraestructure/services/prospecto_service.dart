
import 'dart:convert';
import 'dart:io';
import 'package:cvs_ec_app/infraestructure/infraestructure.dart';
import 'package:cvs_ec_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:cvs_ec_app/domain/domain.dart';
import 'package:intl/intl.dart';

const storageProspecto = FlutterSecureStorage();
MensajesAlertas objMensajesProspectoService = MensajesAlertas();
ResponseValidation objResponseValidationService = ResponseValidation();
final envPrsp = CadenaConexion();

class ProspectoTypeService extends ChangeNotifier{

  final String endPoint = CadenaConexion().apiEndpoint;

  final TokenManager tokenManager = TokenManager();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /*
  ProspectoTypeService(){
    //getProspecto(tipoIdent, numIdent);
  }
  */

  bool isValidForm(){
    return formKey.currentState?.validate() ?? false;
  }

  getProspectos() async {
    try{

      var codImei = await storageProspecto.read(key: 'codImei') ?? '';

      var objReg = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
      var obj = RegisterDeviceResponseModel.fromJson(objReg);

      var objLog = await storageProspecto.read(key: 'RespuestaLogin') ?? '';
      var objLogDecode = json.decode(objLog);

      List<MultiModel> lstMultiModel = [];

      lstMultiModel.add(
        MultiModel(model: 'crm.lead')
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

      var objRsp = await GenericService().getMultiModelos(objReq, "crm.lead");

      await storageProspecto.write(key: 'RespuestaProspectos', value: json.encode(objRsp));

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
  }

  Future<bool> llenaData(ProspectoType objPrpTp) async {
    bool frmValido = true;

    //String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    //RegExp regExp  = RegExp(pattern);

    if(objPrpTp.fechaNacimiento.trim() == '' || objPrpTp.genero.trim() == null || objPrpTp.genero.trim() == 'S' || objPrpTp.direccion.trim() == null || objPrpTp.direccion.trim() == '') {
      frmValido = false;
    }

    return frmValido;
  }

  getProspectoRegistrado(String phoneProsp) async {
    try{
      
      var codImei = await storageProspecto.read(key: 'codImei') ?? '';

      var objReg = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
      var obj = RegisterDeviceResponseModel.fromJson(objReg);

      var objLog = await storageProspecto.read(key: 'RespuestaLogin') ?? '';
      var objLogDecode = json.decode(objLog);

      List<MultiModel> lstMultiModel = [];

      lstMultiModel.add(
        MultiModel(model: 'crm.lead')
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

      final headers = {
        "Content-Type": EnvironmentsProd().contentType//"application/json",
      };

      String ruta = '';
      final objStr = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
      
      if(objStr.isNotEmpty)
      {  
        var obj = RegisterDeviceResponseModel.fromJson(objStr);
        ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/crm/lead/status';
      }

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
          "phone": phoneProsp
        }
      };

      final response = await http.post(
        Uri.parse(ruta),
        headers: headers,
        body: jsonEncode(requestBody), 
      );

      var rspValidacion = json.decode(response.body);

      if(rspValidacion['result']['mensaje'] == 'El tocken no es valido'){
        await tokenManager.checkTokenExpiration();
        await getProspectoRegistrado(phoneProsp);
      }

      return response.body;
      
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
    String internet = await ValidacionesUtils().validaInternet();//await (Connectivity().checkConnectivity());
    
    //VALIDACIÓN DE INTERNETL
    if(internet.isEmpty){
      
      try{

        var codImei = await storageProspecto.read(key: 'codImei') ?? '';

        var objReg = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
        var obj = RegisterDeviceResponseModel.fromJson(objReg);

        var objLog = await storageProspecto.read(key: 'RespuestaLogin') ?? '';
        var objLogDecode = json.decode(objLog);

        List<MultiModel> lstMultiModel = [];

        lstMultiModel.add(
          MultiModel(model: 'crm.lead')
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

        print('Fecha token: $tockenValidDate');

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
            "name": objProspecto.name,
            "phone": objProspecto.phone,          
            "contact_name": objProspecto.contactName,
            "partner_name": objProspecto.partnerName,          
            "date_closed": DateFormat('yyyy-MM-dd', 'es').format(objProspecto.dateClose!),
            "email_from": objProspecto.emailFrom,
            "street": objProspecto.street,
            "expected_revenue": objProspecto.expectedRevenue,
            "referred": objProspecto.referred,
            "description": objProspecto.description,
            "probability": objProspecto.probability,

            "campaign_id": objProspecto.campaignId!.id,
            "source_id": objProspecto.sourceId.id,
            "medium_id": objProspecto.mediumId.id,
            "country_id": objProspecto.countryId.id,

          },
        }
      };

        final headers = {
          "Content-Type": EnvironmentsProd().contentType//"application/json",
        };

        String ruta = '';
        final objStr = await storageProspecto.read(key: 'RespuestaRegistro') ?? '';
        
        if(objStr.isNotEmpty)
        {  
          var obj = RegisterDeviceResponseModel.fromJson(objStr);
          ruta = '${obj.result.url}/api/v1/${objReq.params.imei}/done/create/crm.lead/model';
        }

        final response = await http.post(
          Uri.parse(ruta),
          headers: headers,
          body: jsonEncode(requestBody), 
        );
      
        //print(response.body);

        var rspValidacion = json.decode(response.body);

        if(rspValidacion['result']['mensaje'] == 'El tocken no es valido'){
          await tokenManager.checkTokenExpiration();
          await registraProspecto(objProspecto);
        }

        return ProspectoRegistroResponseModel.fromJson(response.body);
        //String tst = '';
      } 
      catch(ex){
        print('Error al grabar: $ex');
      }
    } else {
      await storageProspecto.write(key: 'registraProspecto', value: jsonEncode(objProspecto.toJson()));
      //await storageProspecto.write(key: 'TienePendienteRegistros', value: 'S');

      return ProspectoRegistroResponseModel(
        id: 0,
        jsonrpc: '',
        result: ProspectoRegistroModel(
          estado: 0, mensaje: ''
        ),
        mensaje: 'No tiene conexión a internet, ahora tiene datos pendientes de grabar.'
      );
    }

  }

}
