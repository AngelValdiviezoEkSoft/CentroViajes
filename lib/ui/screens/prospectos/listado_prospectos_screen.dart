
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:cvs_ec_app/domain/models/prospecto_type_response.dart';
import 'package:cvs_ec_app/infraestructure/infraestructure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cvs_ec_app/ui/ui.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:http/http.dart' as http;

String terminoBusqueda = '';
DatumCrmLead? objDatumCrmLead;
late TextEditingController filtroPrspTxt;
bool listaVaciaPrp = false;

class ListaProspectosScreen extends StatefulWidget {
  const ListaProspectosScreen({super.key});

  @override
  State<ListaProspectosScreen> createState() => _ListaProspectosScreenState();
}

//class MarcacionScreen extends StatelessWidget {
class _ListaProspectosScreenState extends State<ListaProspectosScreen> {

  late int _pageSize;
  int contLst = 0;
  final LocalAuthentication auth = LocalAuthentication();
  final PagingController<int, DatumCrmLead> pagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    contLst = 0;
    terminoBusqueda = '';
    filtroPrspTxt = TextEditingController();

    pagingController.addPageRequestListener((pageKey) {
      //fetchPage(pageKey);
    });
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  Future<void> fetchPage(int pageKey) async {
     try {
      final url = Uri.parse(
          "https://api.ejemplo.com/leads?page=$pageKey&size=$_pageSize"); // API ficticia
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final newItems = (data['items'] as List)
            .map((item) => DatumCrmLead.fromJson(item))
            .toList();

        final isLastPage = newItems.length < _pageSize;
        if (isLastPage) {
          pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          pagingController.appendPage(newItems, nextPageKey);
        }
      } else {
        throw Exception('Error al cargar datos paginados');
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  Future<void> refreshDataProsp() async {

    String resInt = await ValidacionesUtils().validaInternet();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SimpleDialog(
        alignment: Alignment.center,
        children: [
          SimpleDialogCargando(
            null,
            mensajeMostrar: 'Estamos consultando',
            mensajeMostrarDialogCargando: 'el listado de prospectos.',
          ),
        ]
      ),
    );

    if(resInt.isEmpty){
      var rspPrsp = await ProspectoTypeService().getProspectos();

      var objLogDecode = json.decode(rspPrsp);
      var objLogDecode2 = json.decode(objLogDecode);

      var tstLength = objLogDecode2["result"]["data"]["crm.lead"]["length"];

      String contStr = '$tstLength';

      contLst = 0;

      contLst = int.parse(contStr);

      //String estadoPrsp = '';
      ProspectoResponseModel apiResponse = ProspectoResponseModel.fromJson(objLogDecode);

      List<DatumCrmLead> prospectosFiltrados = [];

      if(terminoBusqueda.isNotEmpty){
        prospectosFiltrados = apiResponse.result.data.crmLead.data
        .where(
          (producto) => producto.name.toLowerCase().contains(terminoBusqueda.toLowerCase()))
        .toList();

        if(prospectosFiltrados.isEmpty){
          prospectosFiltrados = apiResponse.result.data.crmLead.data
          .where((producto) =>
            producto.emailFrom.toLowerCase().contains(terminoBusqueda.toLowerCase())
          )
          .toList();
        }

        if(prospectosFiltrados.isEmpty){
          prospectosFiltrados = apiResponse.result.data.crmLead.data
          .where((producto) =>
              producto.mobile.contains(terminoBusqueda)
          ).toList();
        }

        contLst = prospectosFiltrados.length;
      } else{
        prospectosFiltrados = apiResponse.result.data.crmLead.data;
      }

      context.pop();

      // Refresca los datos llamando a la misma función de carga
      setState(() {
        
      });
    } else {

      context.pop();

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return ContentAlertDialog(
            onPressed: () {
              Navigator.of(context).pop();
            },
            onPressedCont: () {
              Navigator.of(context).pop();
            },
            tipoAlerta: TipoAlerta().alertAccion,
            numLineasTitulo: 1,
            numLineasMensaje: 1,
            titulo: 'Error',
            mensajeAlerta: 'No tiene acceso a internet.'
          );
        },
      );
    }

  }

  @override
  Widget build(BuildContext context) {

    ColorsApp objColorsApp = ColorsApp();

    ScrollController scrollListaClt = ScrollController();

    final size = MediaQuery.of(context).size;

    return 
    objPermisosGen != null && objPermisosGen!.buttons.btnCreateLead ?
    Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              context.pop();
            },
          ),
          title: const Text('Prospectos'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.black),
              onPressed: () {
                refreshDataProsp();
              },
            ),
            IconButton(
              icon: const Icon(Icons.calendar_month, color: Colors.black),
              onPressed: () {
                context.push(objRutasGen.rutaAgenda);
              },
            ),
          ],
        ),
      body: BlocBuilder<GenericBloc, GenericState>(
        builder: (context,state) {

          Future<void> refreshData() async {

            String rsp = await state.lstProspectos();

            var objLogDecode = json.decode(rsp);
            var objLogDecode2 = json.decode(objLogDecode);

            var tstLength = objLogDecode2["result"]["data"]["crm.lead"]["length"];

            String contStr = '$tstLength';

            contLst = 0;

            contLst = int.parse(contStr);

            //String estadoPrsp = '';
            ProspectoResponseModel apiResponse = ProspectoResponseModel.fromJson(objLogDecode);

            List<DatumCrmLead> prospectosFiltrados = [];

            if(terminoBusqueda.isNotEmpty){
              prospectosFiltrados = apiResponse.result.data.crmLead.data
              .where(
                (producto) => producto.name.toLowerCase().contains(terminoBusqueda.toLowerCase()))
              .toList();

              if(prospectosFiltrados.isEmpty){
                prospectosFiltrados = apiResponse.result.data.crmLead.data
                .where((producto) =>
                  producto.emailFrom.toLowerCase().contains(terminoBusqueda.toLowerCase())
                )
                .toList();
              }

              if(prospectosFiltrados.isEmpty){
                prospectosFiltrados = apiResponse.result.data.crmLead.data
                .where((producto) =>
                    producto.mobile.contains(terminoBusqueda)
                ).toList();
              }

              contLst = prospectosFiltrados.length;
            } else{
              prospectosFiltrados = apiResponse.result.data.crmLead.data;
            }

            // Refresca los datos llamando a la misma función de carga
            setState(() {
              
            });
          }

          return FutureBuilder(
            future: state.lstProspectos(),
            builder: (context, snapshot) {

              if (snapshot.hasError) {
                return const Center(
                  child: AutoSizeText(
                    '!UPS¡, intenta acceder después de unos minutos.',
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }

              if (snapshot.hasData) {

                String objRsp = snapshot.data as String;
                List<DatumCrmLead> prospectosFiltrados = [];

                if(objRsp.isNotEmpty){
                  var objLogDecode = json.decode(objRsp);
                  var objLogDecode2 = json.decode(objLogDecode);

                  var tstLength = objLogDecode2["result"]["data"]["crm.lead"]["length"];

                  String contStr = '$tstLength';

                  contLst = 0;

                  contLst = int.parse(contStr);

                  ProspectoResponseModel apiResponse = ProspectoResponseModel.fromJson(objLogDecode);

                  if(terminoBusqueda.isNotEmpty){
                    prospectosFiltrados = apiResponse.result.data.crmLead.data
                    .where(
                      (producto) => producto.name.toLowerCase().contains(terminoBusqueda.toLowerCase()))
                    .toList();

                    if(prospectosFiltrados.isEmpty){
                      prospectosFiltrados = apiResponse.result.data.crmLead.data
                      .where((producto) =>
                        producto.emailFrom.toLowerCase().contains(terminoBusqueda.toLowerCase())
                      )
                      .toList();
                    }

                    if(prospectosFiltrados.isEmpty){
                      prospectosFiltrados = apiResponse.result.data.crmLead.data
                      .where((producto) =>
                          producto.mobile.contains(terminoBusqueda)
                      ).toList();
                    }

                    contLst = 0;

                    contLst = prospectosFiltrados.length;
                  } else{
                    prospectosFiltrados = apiResponse.result.data.crmLead.data;
                  }

                  pagingController.appendPage(prospectosFiltrados, 1);
                } else {
                  listaVaciaPrp = true;
                }

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                  
                      Container(
                        color: Colors.white,
                        width: size.width * 0.98,
                        child: TextField(
                          controller: filtroPrspTxt,
                          decoration: const InputDecoration(
                            hintText: 'Buscar prospectos por nombre, correo o celular',
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                          ),
                          onChanged: (value) {
                            // Actualizar el estado con el término de búsqueda
                            setState(() {
                              terminoBusqueda = value;
                            });
                          },
                        ),
                      ),

                      if(prospectosFiltrados.isNotEmpty)         
                      SizedBox(height: size.height * 0.02,),

                      if(prospectosFiltrados.isNotEmpty) 
                      Container(
                        color: Colors.transparent,
                        width: size.width,
                        height: size.height * 0.7,
                        child: CustomRefreshIndicator(
                          onRefresh: refreshData,
                          builder: (context, child, controllerOp) {
                             // Personalización del indicador
                            return Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                if (controllerOp.isDragging || controllerOp.value > 0)
                                  Positioned(
                                    top: size.height * 0.01,//50,
                                    child: Opacity(
                                      opacity: 1,//controllerOp.value,
                                      child: Container(
                                        height: size.height * 0.07,//30,
                                        width: size.width * 0.08,//30,
                                        color: Colors.transparent,
                                        /*
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blueAccent,
                                        ),
                                        */
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 1,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                Transform.translate(
                                  offset: Offset(0, 100 * controllerOp.value),
                                  child: child,
                                ),
                              ],
                            );
                          },
                          child: ListView.builder(
                            controller: scrollListaClt,
                            itemCount: contLst,//lstCLientes.length,//carrito.detalles.length,
                            itemBuilder: ( _, int index ) {
                          
                              return Slidable(
                                key: ValueKey(prospectosFiltrados[index].id),
                                startActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) => context.push(Rutas().rutaPlanificacionActividades),
                                        backgroundColor: objColorsApp.celeste,
                                        foregroundColor: Colors.white,
                                        icon: Icons.call_outlined,
                                        label: 'Actividades',
                                      ),
                                  
                                    ]
                                ),
                                child: ListTile(
                                  title: Container(
                                  color: Colors.transparent,
                                  width: size.width * 0.98,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border: Border.all(
                                            color: const Color.fromARGB(255, 217, 217, 217)),
                                        borderRadius: const BorderRadius.all(Radius.circular(10))
                                      ),
                                    width: size.width * 0.98,
                                    height: size.height * 0.195,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          color: Colors.transparent,
                                          width: size.width * 0.7,
                                          height: size.height * 0.25,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(width: size.width * 0.01,),
                                              Container(
                                                color: Colors.transparent,
                                                width: size.width * 0.14,
                                                height: size.height * 0.1,
                                                child: CircleAvatar(
                                                  radius: 30.0,
                                                  backgroundColor: Colors.grey[200],
                                                  child: const Icon(Icons.person, color: Colors.grey, size: 40.0),
                                                ),
                                              ),
                                              Container(
                                                color: Colors.transparent,
                                                width: size.width * 0.55,
                                                height: size.height * 0.25,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    color: Colors.transparent,
                                                    width: size.width * 0.54,
                                                    height: size.height * 0.04,
                                                    child: Text(
                                                      prospectosFiltrados[index].name,
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,                                                                
                                                        color: Colors.black
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      ),
                                                  ),
                                                  Container(
                                                    color: Colors.transparent,
                                                    width: size.width * 0.54,
                                                    height: size.height * 0.04,
                                                    child: Text(
                                                      prospectosFiltrados[index].contactName ?? '',
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,                                                                
                                                        color: Colors.black
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      ),
                                                  ),
                                                  Container(
                                                color: Colors.transparent,
                                                width: size.width * 0.54,
                                                height: size.height * 0.035,
                                                child: RichText(
                                                  overflow: TextOverflow.ellipsis,
                                                  text: TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                        text: 'Email: ',
                                                        style: TextStyle(color: Colors.black)
                                                      ),
                                                      TextSpan(
                                                        //
                                                        //text: '${objLogDecode2["result"]["data"]["crm.lead"]["data"][index]["email_from"]}',
                                                        text: prospectosFiltrados[index].emailFrom,
                                                        style: const TextStyle(color: Colors.blue)
                                                      ),
                                                    ]
                                                  ),
                                                )
                                            
                                              ),
                                              Container(
                                                color: Colors.transparent,
                                                width: size.width * 0.54,
                                                height: size.height * 0.035,
                                                  child: 
                                                  RichText(
                                                    overflow: TextOverflow.ellipsis,
                                                    text: TextSpan(
                                                      children: [
                                                        const TextSpan(
                                                          text: 'Teléfono: ',
                                                          style: TextStyle(color: Colors.black)
                                                        ),
                                                        TextSpan(
                                                          text: prospectosFiltrados[index].phone,
                                                          style: const TextStyle(color: Colors.blue)
                                                        ),
                                                      ]
                                                    ),
                                                  )
                                              ),
                                              Container(
                                                  color: Colors.transparent,
                                                  width: size.width * 0.54,
                                                height: size.height * 0.035,
                                                  child: AutoSizeText(
                                                      prospectosFiltrados[index].stageId.name,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 10,
                                                          color: Colors.green
                                                        ),
                                                        maxLines: 2,
                                                        textAlign: TextAlign.left,),
                                              ),
                                            
                                                  ],
                                                ),
                                              ),
                                              
                                              
                                            ],
                                          )
                                        ),
                                        Container(
                                          width: size.width * 0.11,
                                          height: size.height * 0.17,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.black12, // Color del óvalo
                                            borderRadius: BorderRadius.circular(50), // Bordes redondeados para el óvalo
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                color: Colors.transparent,
                                                height: size.height * 0.03,
                                                alignment: Alignment.topCenter,
                                                child: IconButton(
                                                  icon: const Icon(Icons.location_pin, color: Colors.grey, size: 20,),
                                                  onPressed: () {
                                                    /*
                                                    final gpsBloc = BlocProvider.of<GpsBloc>(context);
                                                      gpsBloc.askGpsAccess();
                                                      */
                                                    context.push(Rutas().rutaMap);
                                                  },
                                                ),
                                              ),
                                              Container(
                                                color: Colors.transparent,
                                                height: size.height * 0.03,
                                                alignment: Alignment.topCenter,
                                                child: IconButton(
                                                  icon: const Icon(Icons.route, color: Colors.grey, size: 20,),
                                                  onPressed: () {
                                                    
                                                  },
                                                ),
                                              ),
                                              Container(
                                                color: Colors.transparent,
                                                height: size.height * 0.03,
                                                child: IconButton(
                                                  icon: const Icon(Icons.info, color: Colors.grey, size: 20,),
                                                  onPressed: () {
                                                    objDatumCrmLead = prospectosFiltrados[index];
                                                    context.push(Rutas().rutaEditProsp);
                                                  },
                                                ),
                                              ),
                                              SizedBox(height: size.height * 0.004,)
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: size.width * 0.01,)
                                      ],
                                      ),
                                    ),
                                  ),
                                )
                              );
                            },
                          ),
                        
                        ),
                      ),
                      

                      if(prospectosFiltrados.isEmpty && !listaVaciaPrp)
                      Container(
                        width: size.width * 0.75,
                        height: size.height * 0.75,
                        color: Colors.transparent,
                        alignment: Alignment.topCenter,
                        child: ConsultaVaciaScreen(null, msmCabBand: 'Atención', msmBand: 'No existe el prospecto buscado', imgCabBand: 'gifs/consulta_vacia.gif',)
                      ),

                      if(prospectosFiltrados.isEmpty && listaVaciaPrp)
                      Container(
                        width: size.width * 0.75,
                        height: size.height * 0.75,
                        color: Colors.transparent,
                        alignment: Alignment.topCenter,
                        child: ConsultaVaciaScreen(null, msmCabBand: 'Atención', msmBand: 'No existe información para mostrar', imgCabBand: 'gifs/consulta_vacia.gif',)
                      )
                    ],
                  ),
                );
                
              }

              return Center(
                child: Container(
                  color: Colors.transparent,
                  child: Image.asset('assets/gifs/gif_carga.gif'),
                ),
              );
            }
          );
        }
      ),
      floatingActionButton: FloatingActionButton(                
        onPressed: () {
          terminoBusqueda = '';
          filtroPrspTxt = TextEditingController();
          context.push(objRutasGen.rutaRegistroPrsp);          
        },
        backgroundColor: const Color.fromRGBO(75, 57, 239, 1.0),
        child: const Icon(Icons.person_add_alt, color: Colors.white,),
      ),
    )
    :
    Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              context.pop();
            },
          ),
          title: const Text('Prospectos'),
          actions: [
            IconButton(
              icon: const Icon(Icons.calendar_month, color: Colors.black),
              onPressed: () {
                context.push(objRutasGen.rutaAgenda);
              },
            ),
          ],
        ),
      body: BlocBuilder<GenericBloc, GenericState>(
        builder: (context,state) {

          return FutureBuilder(
            future: ProspectoTypeService().getProspectos(),
            builder: (context, snapshot) {

              if (snapshot.hasError) {
                return const Center(
                  child: AutoSizeText(
                    '!UPS¡, intenta acceder después de unos minutos.',
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }

              if (snapshot.hasData) {

                //List<ClientModelResponse> lstCLientes = [];//snapshot.data as List<ClientModelResponse>;

                String objRsp = snapshot.data as String;

                var objLogDecode = json.decode(objRsp);
                var objLogDecode2 = json.decode(objLogDecode);

                var tstLength = objLogDecode2["result"]["data"]["crm.lead"]["length"];

                String contStr = '$tstLength';

                contLst = 0;

                contLst = int.parse(contStr);

                //String estadoPrsp = '';
                ProspectoResponseModel apiResponse = ProspectoResponseModel.fromJson(objLogDecode);

                List<DatumCrmLead> prospectosFiltrados = [];

                if(terminoBusqueda.isNotEmpty){
                  prospectosFiltrados = apiResponse.result.data.crmLead.data
                  .where(
                    (producto) => producto.name.toLowerCase().contains(terminoBusqueda.toLowerCase()))
                  .toList();

                  if(prospectosFiltrados.isEmpty){
                    prospectosFiltrados = apiResponse.result.data.crmLead.data
                    .where((producto) =>
                        producto.emailFrom.toLowerCase().contains(terminoBusqueda.toLowerCase()))
                    .toList();
                  }

                  if(prospectosFiltrados.isEmpty){
                    prospectosFiltrados = apiResponse.result.data.crmLead.data
                    .where((producto) =>
                        producto.mobile.toLowerCase().contains(terminoBusqueda.toLowerCase()))
                    .toList();
                  }

                  contLst = 0;

                  contLst = prospectosFiltrados.length;
                } else{
                  prospectosFiltrados = apiResponse.result.data.crmLead.data;
                }
                //

                return SingleChildScrollView(
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                  
                      Container(
                        color: Colors.white,
                        width: size.width * 0.98,
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Buscar prospectos por nombre, correo o celular',
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                          ),
                          onChanged: (value) {
                            setState(() {
                              terminoBusqueda = value;
                            });
                          },
                        ),
                      ),

                      if(prospectosFiltrados.isNotEmpty)         
                      SizedBox(height: size.height * 0.02,),

                      if(prospectosFiltrados.isNotEmpty) 
                      Container(
                        color: Colors.transparent,
                        width: size.width,
                        height: size.height * 0.65,
                        child: ListView.builder(
                          controller: scrollListaClt,
                          itemCount: contLst,
                          itemBuilder: ( _, int index ) {

                            return Slidable(
                              key: ValueKey(prospectosFiltrados[index].id),
                              startActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) => context.push(Rutas().rutaPlanificacionActividades),
                                      backgroundColor: objColorsApp.celeste,
                                      foregroundColor: Colors.white,
                                      icon: Icons.call_outlined,
                                      label: 'Actividades',
                                    ),
                                
                                  ]
                              ),
                              child: ListTile(
                                title: Container(
                                color: Colors.transparent,
                                width: size.width * 0.98,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                          color: const Color.fromARGB(255, 217, 217, 217)),
                                      borderRadius: const BorderRadius.all(Radius.circular(10))
                                    ),
                                  width: size.width * 0.98,
                                  height: size.height * 0.195,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        color: Colors.transparent,
                                        width: size.width * 0.7,
                                        height: size.height * 0.25,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(width: size.width * 0.01,),
                                            Container(
                                              color: Colors.transparent,
                                        width: size.width * 0.14,
                                        height: size.height * 0.1,
                                              child: CircleAvatar(
                                                        radius: 30.0,
                                                        backgroundColor: Colors.grey[200],
                                                        child: const Icon(Icons.person, color: Colors.grey, size: 40.0),
                                                      ),
                                            ),
                                            Container(
                                              color: Colors.transparent,
                                        width: size.width * 0.55,
                                        height: size.height * 0.25,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  color: Colors.transparent,
                                                  width: size.width * 0.54,
                                                  height: size.height * 0.04,
                                                  child: Text(
                                                    //
                                                    //'${objLogDecode2["result"]["data"]["crm.lead"]["data"][index]["name"]}',
                                                    prospectosFiltrados[index].name,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      //fontSize: 10,
                                                      color: Colors.black
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    ),
                                                ),
                                                Container(
                                                  color: Colors.transparent,
                                                  width: size.width * 0.54,
                                                  height: size.height * 0.04,
                                                  child: AutoSizeText(
                                                    //prospectosFiltrados[index]
                                                    //'${objLogDecode2["result"]["data"]["crm.lead"]["data"][index]["contact_name"]}',
                                                    prospectosFiltrados[index].contactName ?? '',
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      //fontSize: 10,
                                                      color: Colors.black
                                                    ),
                                                    maxLines: 1,
                                                    minFontSize: 4,
                                                    textAlign: TextAlign.left,
                                                    ),
                                                ),
                                                Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.54,
                                              height: size.height * 0.035,
                                              child: RichText(
                                                overflow: TextOverflow.ellipsis,
                                                text: TextSpan(
                                                  children: [
                                                    const TextSpan(
                                                      text: 'Email: ',
                                                      style: TextStyle(color: Colors.black)
                                                    ),
                                                    TextSpan(
                                                      //
                                                      //text: '${objLogDecode2["result"]["data"]["crm.lead"]["data"][index]["email_from"]}',
                                                      text: prospectosFiltrados[index].emailFrom,
                                                      style: const TextStyle(color: Colors.blue)
                                                    ),
                                                  ]
                                                ),
                                              )
                                          
                                            ),
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.54,
                                              height: size.height * 0.035,
                                                child: 
                                                RichText(
                                                  overflow: TextOverflow.ellipsis,
                                                  text: TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                        text: 'Teléfono: ',
                                                        style: TextStyle(color: Colors.black)
                                                      ),
                                                      TextSpan(
                                                        text: prospectosFiltrados[index].phone,
                                                        style: const TextStyle(color: Colors.blue)
                                                      ),
                                                    ]
                                                  ),
                                                )
                                            ),
                                            Container(
                                                color: Colors.transparent,
                                                width: size.width * 0.54,
                                              height: size.height * 0.035,
                                                child: AutoSizeText(
                                                    prospectosFiltrados[index].stageId.name,
                                                      style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 10,
                                                        color: Colors.green
                                                      ),
                                                      maxLines: 2,
                                                      textAlign: TextAlign.left,),
                                            ),
                                          
                                                ],
                                              ),
                                            ),
                                            
                                            
                                          ],
                                        )
                                      ),
                                      Container(
                                        width: size.width * 0.11,
                                        height: size.height * 0.17,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.black12, // Color del óvalo
                                          borderRadius: BorderRadius.circular(50), // Bordes redondeados para el óvalo
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          //crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              color: Colors.transparent,
                                              height: size.height * 0.03,
                                              alignment: Alignment.topCenter,
                                              child: IconButton(
                                                icon: const Icon(Icons.location_pin, color: Colors.grey, size: 20,),
                                                onPressed: () {},
                                              ),
                                            ),
                                            Container(
                                              color: Colors.transparent,
                                              height: size.height * 0.03,
                                              alignment: Alignment.topCenter,
                                              child: IconButton(
                                                icon: const Icon(Icons.route, color: Colors.grey, size: 20,),
                                                onPressed: () {},
                                              ),
                                            ),
                                            Container(
                                              color: Colors.transparent,
                                              height: size.height * 0.03,
                                              child: IconButton(
                                                icon: const Icon(Icons.info, color: Colors.grey, size: 20,),
                                                onPressed: () {
                                                  terminoBusqueda = '';
                                                  filtroPrspTxt = TextEditingController();
                                                  
                                                  objDatumCrmLead = prospectosFiltrados[index];
                                                  context.push(Rutas().rutaEditProsp);
                                                },
                                              ),
                                            ),
                                            SizedBox(height: size.height * 0.004,)
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: size.width * 0.01,)
                                    ],
                                    ),
                                  ),
                                ),
                              )
                            );
                          },
                        ),
                      ),

                      if(prospectosFiltrados.isEmpty && !listaVaciaPrp)
                      Container(
                        width: size.width * 0.75,
                        height: size.height * 0.75,
                        color: Colors.transparent,
                        alignment: Alignment.topCenter,
                        child: ConsultaVaciaScreen(null, msmCabBand: 'Atención', msmBand: 'No existe el prospecto buscado', imgCabBand: 'gifs/consulta_vacia.gif',)
                      ),

                      if(prospectosFiltrados.isEmpty && listaVaciaPrp)
                      Container(
                        width: size.width * 0.75,
                        height: size.height * 0.75,
                        color: Colors.transparent,
                        alignment: Alignment.topCenter,
                        child: ConsultaVaciaScreen(null, msmCabBand: 'Atención', msmBand: 'No existe información para mostrar', imgCabBand: 'gifs/consulta_vacia.gif',)
                      )
                    ],
                  ),
                );
                
              }

              return Center(
                child: Container(
                  color: Colors.transparent,
                  child: Image.asset('assets/gifs/gif_carga.gif'),
                ),
              );
            }
          );
        }
      ),
        
    );
  }
}

//void doNothing(BuildContext context) {}