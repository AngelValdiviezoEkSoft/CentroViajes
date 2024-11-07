import 'dart:async';
import 'package:cvs_ec_app/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storageClient = FlutterSecureStorage();

class ClienteService extends ChangeNotifier {
  //final String endPoint = CadenaConexion().apiEndPointEcommerce;

  /*
  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );
  */

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  /*
  List<BannerModels> varLstBaners = [];
  List<Categoria> varLstPasillos = [];
  List<CategoriaProducto> varLstProductos = [];
  List<CategoriaProducto> varLstProductosByQuery = [];
  ClienteTypeEcommerce? objClienteEcommerce;
  ClienteEcommerceTypeResponse? objRespuestaConsulta;
  ComprasTypeResponse? objRespuestaConsultaTracking;
  PedidosEcommerceTypeResponse? objPedidosEcommerceTypeResponse;
  
  List<DireccionType> direccionClienteEcommerce = [];
*/
  List<ClientModelResponse> lstClientes = [];
  
  /*
  final StreamController<List<CategoriaProducto>> _suggestionStreamContoller = StreamController.broadcast();
  Stream<List<CategoriaProducto>> get suggestionStream => _suggestionStreamContoller.stream;
  */

  final storageEcommerce = const FlutterSecureStorage();

  Future<dynamic> getClientesByVendedor() async {
    /*
    String tokenUser = await storageEcommerce.read(key: 'jwtEnrolApp') ?? '';
    final baseURL = '${endPoint}ProcesoPago/GetTrackingEcommerce?IdPuntoOperacion=$idPuntoOperacion&IdTransaccion=$idTransaccion';
    final varResponse = await http.get(
      Uri.parse(baseURL),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $tokenUser',
      },
    );

    if (varResponse.statusCode != 200) return null;

    final objRespuesta = ComprasTypeResponse.fromJson(varResponse.body);

    objRespuestaConsultaTracking = objRespuesta;

    if (objRespuesta.succeeded!) {
      objRespuestaConsultaCompra = objRespuesta.compra!;
    }
    */

    lstClientes.add(
      ClientModelResponse(id: 1, primerApellido: 'Angel', segundoNombre: 'Elías', primerNombre: 'Valdiviezo', segundoApellido: 'González', direccion: 'Durán', estado: 'Activo', codigoCli: '001', numIdentificacion: '099887766'),      
    );

    lstClientes.add(
      ClientModelResponse(id: 2, primerApellido: 'Angel 2', segundoNombre: 'Elías', primerNombre: 'Valdiviezo', segundoApellido: 'González', direccion: 'Durán', estado: 'Activo', codigoCli: '002', numIdentificacion: '099887765')
    );

    return lstClientes;
  }

  Future<dynamic> getVendedores() async {

    lstClientes.add(
      ClientModelResponse(id: 1, primerApellido: 'Yordani', segundoNombre: '', primerNombre: 'Oliva', segundoApellido: '', direccion: 'Guayacanes', estado: 'Activo', codigoCli: '003', numIdentificacion: '099887764'),
    );

    lstClientes.add(
      ClientModelResponse(id: 2, primerApellido: 'Angel', segundoNombre: 'Elías', primerNombre: 'Valdiviezo', segundoApellido: 'González', direccion: 'Durán', estado: 'Activo', codigoCli: '004', numIdentificacion: '099887763')
    );

    return lstClientes;
  }

}
