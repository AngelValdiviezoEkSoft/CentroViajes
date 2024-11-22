
import 'dart:convert';

import 'package:cvs_ec_app/infraestructure/infraestructure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cvs_ec_app/config/config.dart';

const storageDataInicial = FlutterSecureStorage();

class DataInicialService extends ChangeNotifier{

  final String endPoint = CadenaConexion().apiEndpoint;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isValidForm(){
    return formKey.currentState?.validate() ?? false;
  }
  
  readCombosProspectos() async {

    try{

      var objCamp = await CampaniaService().getCompanias();
      var objOrigen = await OrigenService().getOrigenes();
      var objMedias = await MediaService().getMedias();
      var objActividades = await ActivitiesService().getActivities();
      var objPaises = await PaisService().getPaises();

      await storageDataInicial.write(key: 'cmbCampania', value: json.encode(objCamp));
      await storageDataInicial.write(key: 'cmbOrigen', value: json.encode(objOrigen));
      await storageDataInicial.write(key: 'cmbMedia', value: json.encode(objMedias));
      await storageDataInicial.write(key: 'cmbActividades', value: json.encode(objActividades));
      await storageDataInicial.write(key: 'cmbPaises', value: json.encode(objPaises));

    }
    catch(_){

    }
  }


}
