import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cvs_ec_app/config/enrutador/enrutador.dart';
import 'package:cvs_ec_app/domain/domain.dart';

const storageCol = FlutterSecureStorage();
 
class ColaboradorService {

  Future<EmpleadoResponseModel> datosColaborador(String identificacion) async {

    final resp = await EnrutadorColaborador().getDatosColaborador(identificacion);

    final oResp = EmpleadoResponseModel.fromJson(resp);

    return oResp;
  }

  Future<RegistroEmpleadoResponseModel?> registraColaborador(String identificacion, String foto) async {

    final resp = await EnrutadorColaborador().saveDatosColaborador(identificacion, foto);

    final oResp = RegistroEmpleadoResponseModel.fromJson(resp);

    return oResp;
  }

}