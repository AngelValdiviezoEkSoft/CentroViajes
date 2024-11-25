part of 'generic_bloc.dart';

class GenericState extends Equatable {

  final storage = const FlutterSecureStorage();
  final int positionMenu;
  final int positionFormaPago;
  final double coordenadasMapa;
  final double radioMarcacion;
  final String formaPago;
  final String localidadId;
  final String idFormaPago;
  final double heightModalPlanAct;

  const GenericState(
    {
      positionMenu = 0,
      positionFormaPago = 0,
      coordenadasMapa = 0,
      radioMarcacion = 0,
      formaPago = 'C',
      localidadId = '',
      idFormaPago = '',
      heightModalPlanAct = 0.65
    } 
  ) : positionMenu = positionMenu ?? 0,
      positionFormaPago = positionFormaPago ?? 0,
      coordenadasMapa = coordenadasMapa ?? 0,
      radioMarcacion = radioMarcacion ?? 0,
      formaPago = formaPago ?? 'C',
      localidadId = localidadId ?? '',
      idFormaPago = idFormaPago ?? '',
      heightModalPlanAct = heightModalPlanAct ?? 0.65;
  

  GenericState copyWith({
    int? positionMenu,
    int? positionFormaPago,
    double? coordenadasMapa,
    double? radioMarcacion,
    String? formaPago,
    String? localidadId,
    String? idFormaPago,
    double? heightModalPlanAct
  }) 
  => GenericState(
    positionMenu: positionMenu ?? this.positionMenu,
    positionFormaPago: positionFormaPago ?? this.positionFormaPago,
    coordenadasMapa: coordenadasMapa ?? this.coordenadasMapa,
    radioMarcacion: radioMarcacion ?? this.radioMarcacion,
    formaPago: formaPago ?? this.formaPago,
    localidadId: localidadId ?? this.localidadId,
    idFormaPago: idFormaPago ?? this.idFormaPago,
    heightModalPlanAct: heightModalPlanAct ?? this.heightModalPlanAct
  );


  @override
  List<Object> get props => [positionMenu,positionFormaPago,coordenadasMapa,radioMarcacion,formaPago,localidadId,idFormaPago, heightModalPlanAct];

  Future<String> readCompanias() async {

    try{
      final resp = await storage.read(key: 'RespuestaLogin') ?? '';

      final data = json.decode(resp);
      final objTmp = data['result'];
      final lstFinal = objTmp['allowed_companies'];

      Map<String, dynamic> dataTmp = json.decode(json.encode(lstFinal));

      // Extrae los valores de 'name' y crea la lista de String
      List<String> lstRsp = dataTmp.values.map((item) => item['name'].toString()).toList();

      return json.encode(lstRsp);
    }
    catch(ex){
      //print('Error: ' + ex.toString());
      return '';
    }
  }

  Future<String> waitCarga() async {
    
    return await Future.delayed(
      const Duration(milliseconds: 2500), 
        () => 'ok'
      ); 
  }
  
  readCombosCreateProspectos() async {
    
    String cmbCamp = await storage.read(key: 'cmbCampania') ?? '';
    String cmbOrigen = await storage.read(key: 'cmbOrigen') ?? '';
    String cmbMedia = await storage.read(key: 'cmbMedia') ?? '';
    String cmbAct = await storage.read(key: 'cmbActividades') ?? '';
    String cmbPais = await storage.read(key: 'cmbPaises') ?? '';

    return "$cmbCamp---$cmbOrigen---$cmbMedia---$cmbAct---$cmbPais";
  }

  readDatosPerfil() async {    
    String objLogin = await storage.read(key: 'RespuestaLogin') ?? '';

    return objLogin;
  }


}

