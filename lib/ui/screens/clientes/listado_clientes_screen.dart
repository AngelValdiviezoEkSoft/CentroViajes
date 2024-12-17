
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:cvs_ec_app/domain/domain.dart';
import 'package:cvs_ec_app/infraestructure/services/services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cvs_ec_app/ui/ui.dart';
import 'package:http/http.dart' as http;

late TextEditingController filtroCliTxt;

String terminoBusquedaClient= '';
List<ResPartnerDatumAppModel> clientesFiltrados = [];
bool listaVaciaCli = false;

class ListaClientesScreen extends StatefulWidget {
  const ListaClientesScreen({super.key});

  @override
  State<ListaClientesScreen> createState() => _ListaClientesScreenState();
}

//class MarcacionScreen extends StatelessWidget {
class _ListaClientesScreenState extends State<ListaClientesScreen> {

  final LocalAuthentication auth = LocalAuthentication();
  final PagingController<int, DatumClienteModelData> pagingController = PagingController(firstPageKey: 0);
  late int _pageSize;
  
  @override
  void initState() {
    super.initState();

    clientesFiltrados = [];

    filtroCliTxt = TextEditingController();
    terminoBusquedaClient= '';

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
            .map((item) => DatumClienteModelData.fromJson(item))
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

  Future<void> refreshDataCli() async {

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
            mensajeMostrarDialogCargando: 'el listado de clientes.',
          ),
        ]
      ),
    );

    if(resInt.isEmpty){
      var rsp = await ClienteService().getClientes();
      
      var objLogDecode = json.decode(rsp);

      ClienteResponseModel apiResponse = ClienteResponseModel.fromJson(objLogDecode);

      List<DatumClienteModelData> clientesFiltrados = [];

      if(terminoBusquedaClient.isNotEmpty){
                    if(!terminoBusquedaClient.contains('+') && !terminoBusquedaClient.contains('0')){
                      clientesFiltrados = apiResponse.result.data.resPartner.data
                      .where((producto) =>
                          producto.name.toLowerCase().contains(terminoBusquedaClient.toLowerCase())
                      ).toList();

                      if(clientesFiltrados.isEmpty){
                        clientesFiltrados = apiResponse.result.data.resPartner.data
                        .where((producto) =>
                            producto.email.toLowerCase().contains(terminoBusquedaClient.toLowerCase())
                        ).toList();
                      }
                    } else {
                      if(clientesFiltrados.isEmpty){
                        clientesFiltrados = apiResponse.result.data.resPartner.data
                        .where((producto) =>
                            producto.mobile.contains(terminoBusquedaClient)
                        ).toList();
                      }
                    }
      } else{
        clientesFiltrados = apiResponse.result.data.resPartner.data;
      }

      context.pop();

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

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              //ignore: use_build_context_synchronously
              FocusScope.of(context).unfocus();
              
              filtroCliTxt = TextEditingController();
              terminoBusquedaClient= '';
              context.pop();

            },
          ),
          title: const Text('Clientes'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.black),
              onPressed: () {
                refreshDataCli();
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
            var rsp = await state.lstClientes();

            
            var objLogDecode = json.decode(rsp);
            //var objLogDecode2 = json.decode(objLogDecode);

            ResPartnerAppModel  apiResponse = ResPartnerAppModel.fromJson(objLogDecode);

            List<ResPartnerDatumAppModel> clientesFiltrados = [];

            if(terminoBusquedaClient.isNotEmpty){
              if(!terminoBusquedaClient.contains('+') && !terminoBusquedaClient.contains('0')){                

                for(int i = 0; i < apiResponse.data.length; i++){
                  if(apiResponse.data[i].name != null && apiResponse.data[i].name!.toLowerCase().contains(terminoBusquedaClient.toLowerCase())){
                    clientesFiltrados.add(apiResponse.data[i]);
                  }
                }

                if(clientesFiltrados.isEmpty){
                  /*
                  clientesFiltrados = apiResponse.data//.result.data.resPartner.data
                  .where((producto) =>
                      producto.email.toLowerCase().contains(terminoBusquedaClient.toLowerCase())
                  ).toList();
                  */

                  for(int i = 0; i < apiResponse.data.length; i++){
                    if(apiResponse.data[i].email != null && apiResponse.data[i].email!.toLowerCase().contains(terminoBusquedaClient.toLowerCase())){
                      clientesFiltrados.add(apiResponse.data[i]);
                    }
                  }
                }
              } else {
                if(clientesFiltrados.isEmpty){

                  for(int i = 0; i < apiResponse.data.length; i++){
                    if(apiResponse.data[i].mobile != null && apiResponse.data[i].mobile!.toLowerCase().contains(terminoBusquedaClient.toLowerCase())){
                      clientesFiltrados.add(apiResponse.data[i]);
                    }
                  }
                }
              }
            } else{
              clientesFiltrados = apiResponse.data;//result.data.resPartner.data;
            }

            setState(() {
        
            });
          }

          Future<void> refreshDataByFiltro(String filtro, String objMemoria) async {
            clientesFiltrados = [];
            ResPartnerAppModel apiResponse = ResPartnerAppModel.fromRawJson(objMemoria);

            if(filtro.isNotEmpty){
              if(!filtro.contains('+') && !filtro.contains('0')){                      

                for(int i = 0; i < apiResponse.data.length; i++){
                  if(apiResponse.data[i].name != null && apiResponse.data[i].name!.toLowerCase().contains(filtro.toLowerCase())){
                    clientesFiltrados.add(apiResponse.data[i]);
                  }
                }

                if(clientesFiltrados.isEmpty){

                  for(int i = 0; i < apiResponse.data.length; i++){
                    if(apiResponse.data[i].email != null && apiResponse.data[i].email!.toLowerCase().contains(filtro.toLowerCase())){
                      clientesFiltrados.add(apiResponse.data[i]);
                    }
                  }

                }
              } else {
                if(clientesFiltrados.isEmpty) {

                  for(int i = 0; i < apiResponse.data.length; i++){
                    if(apiResponse.data[i].mobile != null && apiResponse.data[i].mobile!.toLowerCase().contains(terminoBusquedaClient.toLowerCase())){
                      clientesFiltrados.add(apiResponse.data[i]);
                    }
                  }
                }
              }
            } else{
              clientesFiltrados = apiResponse.data;//.resPartner.data;
            }

            if(terminoBusquedaClient.isNotEmpty) {
              setState(() {});
            }

          }

          return FutureBuilder(
            future: state.lstClientes(),
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
                
                if(objRsp.isNotEmpty){
                  if(terminoBusquedaClient.isEmpty) {
                    refreshDataByFiltro('', objRsp);
                    listaVaciaCli = false;
                  }
                                    
                } else {
                  listaVaciaCli = true;
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
                          decoration: const InputDecoration(
                            hintText: 'Buscar clientes por nombre, correo o celular',
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                          ),
                          onChanged: (value) {
                            terminoBusquedaClient = value;
                            refreshDataByFiltro(value, objRsp);
                          },
                        ),
                      ),

                      if(clientesFiltrados.isNotEmpty)        
                      SizedBox(height: size.height * 0.02,),

                      if(clientesFiltrados.isNotEmpty)
                      Container(
                        color: Colors.transparent,
                        width: size.width,
                        height: size.height * 0.85,
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
                            itemCount: clientesFiltrados.length,
                            itemBuilder: ( _, int index ) {
                          
                              return Slidable(
                                key: ValueKey(clientesFiltrados[index].id),
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
                                    height: size.height * 0.15,
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
                                                        overflow: TextOverflow.ellipsis,
                                                            //
                                                            //'${objLogDecode2["result"]["data"]["res.partner"]["data"][index]["name"]}',
                                                            clientesFiltrados[index].name ?? '',
                                                            style: const TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              //fontSize: 10,
                                                              color: Colors.black
                                                            ),
                                                            //minFontSize: 5,
                                                            maxLines: 1,
                                                            textAlign: TextAlign.left,
                                                            ),
                                                  ),
                          
                                                  if(clientesFiltrados[index].email != null)
                                                  Container(
                                                    color: Colors.transparent,
                                                    width: size.width * 0.54,
                                                    height: size.height * 0.035,
                                                    child: RichText(
                                                      overflow: TextOverflow.ellipsis,
                                                      text: TextSpan(
                                                        children: [
                                                          const TextSpan(
                                                            text: 'Correo: ',
                                                            style: TextStyle(color: Colors.black)
                                                          ),
                                                          TextSpan(
                                                            text: clientesFiltrados[index].email,
                                                            style: const TextStyle(color: Colors.blue),
                                                            
                                                          ),
                                                        ]
                                                      ),
                                                    )
                                                  ),
                          
                                                  if(clientesFiltrados[index].countryId.name != null)
                                                  Container(
                                                    color: Colors.transparent,
                                                    width: size.width * 0.54,
                                                    height: size.height * 0.035,
                                                    child: RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          const TextSpan(
                                                            text: 'País: ',
                                                            style: TextStyle(color: Colors.black)
                                                          ),
                                                          TextSpan(
                                                            text: clientesFiltrados[index].countryId.name,
                                                            style: const TextStyle(color: Colors.blue)
                                                          ),
                                                        ]
                                                      ),
                                                    )
                                                  ),
                                                  
                                              if(clientesFiltrados[index].mobile != null && clientesFiltrados[index].mobile!.isNotEmpty)
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
                                                        TextSpan(//
                                                          //text: '${objLogDecode2["result"]["data"]["res.partner"]["data"][index]["mobile"]}',//lstCLientes[index].mobile,
                                                          text: clientesFiltrados[index].mobile,
                                                          style: const TextStyle(color: Colors.blue)
                                                        ),
                                                      ]
                                                    ),
                                                  )
                                              ),
                                              
                                                  ],
                                                ),
                                              ),
                                              
                                              
                                            ],
                                          )
                                        ),

                                        Container(
                                          width: size.width * 0.11,
                                          height: size.height * 0.14,
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
                                              /*
                                              Container(
                                                color: Colors.transparent,
                                                height: size.height * 0.03,
                                                child: IconButton(
                                                  icon: const Icon(Icons.info, color: Colors.grey, size: 20,),
                                                  onPressed: () {

                                                  },
                                                ),
                                              ),
                                              */
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

                      if(clientesFiltrados.isEmpty && !listaVaciaCli)
                      Container(
                        width: size.width * 0.75,
                        height: size.height * 0.75,
                        color: Colors.transparent,
                        child: ConsultaVaciaScreen(null, msmCabBand: 'Atención', msmBand: 'No existe el cliente buscado', imgCabBand: 'gifs/consulta_vacia.gif',)
                      ),

                      if(clientesFiltrados.isEmpty && listaVaciaCli)
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
                  //child: Image.asset('assets/loadingEnrolApp.gif'),
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

void doNothing(BuildContext context) {}