
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cvs_ec_app/domain/domain.dart';
import 'package:cvs_ec_app/infraestructure/infraestructure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cvs_ec_app/ui/ui.dart';

late TextEditingController montoNuevo_Txt;
late TextEditingController nombreTrx_Txt;
String terminoBusquedaClient= '';

class ListaClientesScreen extends StatefulWidget {
  const ListaClientesScreen({super.key});

  @override
  State<ListaClientesScreen> createState() => _ListaClientesScreenState();
}

//class MarcacionScreen extends StatelessWidget {
class _ListaClientesScreenState extends State<ListaClientesScreen> {

  final LocalAuthentication auth = LocalAuthentication();
  //_SupportState _supportState = _SupportState.unknown;
  
  @override
  void initState() {
    super.initState();

    montoNuevo_Txt = TextEditingController();
    nombreTrx_Txt = TextEditingController();
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
              context.pop();
            },
          ),
          title: const Text('Clientes'),
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
            future: ClienteService().getClientes(),
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

                var objLogDecode = json.decode(objRsp);
                var objLogDecode2 = json.decode(objLogDecode);

                //var tstLength = objLogDecode2["result"]["data"]["res.partner"]["length"];

                //String contStr = '$tstLength';

                //int contLst = int.parse(contStr);

                ClienteResponseModel apiResponse = ClienteResponseModel.fromJson(objLogDecode);

                List<DatumClienteModelData> clientesFiltrados = [];

                if(terminoBusquedaClient.isNotEmpty){
                  clientesFiltrados = apiResponse.result.data.resPartner.data
                  .where((producto) =>
                      producto.name.toLowerCase().contains(terminoBusquedaClient.toLowerCase()))
                  .toList();
                } else{
                  clientesFiltrados = apiResponse.result.data.resPartner.data;
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
                            hintText: 'Buscar clientes por nombres...',
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                          ),
                          onChanged: (value) {
                            // Actualizar el estado con el término de búsqueda
                            setState(() {
                              terminoBusquedaClient = value;
                            });
                          },
                        ),
                      ),

                      if(clientesFiltrados.isNotEmpty)        
                      SizedBox(height: size.height * 0.02,),

                      if(clientesFiltrados.isNotEmpty)
                      Container(
                        color: Colors.transparent,
                        width: size.width,
                        height: size.height * 0.65,
                        child: ListView.builder(
                          controller: scrollListaClt,
                          itemCount: clientesFiltrados.length,
                          itemBuilder: ( _, int index ) {

                            String? email = objLogDecode2["result"]["data"]["res.partner"]["data"][index]["email"];
                            String? pais = '';

                            if(objLogDecode2["result"]["data"]["res.partner"]["data"][index]["country_id"] != null){
                              pais = objLogDecode2["result"]["data"]["res.partner"]["data"][index]["country_id"]["name"];
                            }

                            return Slidable(
                              //key: ValueKey(objLogDecode2["result"]["data"]["res.partner"]["data"][index]["id"]),
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
                              /*
                              endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    
                                  SlidableAction(
                                    onPressed: (context) => context.push(Rutas().rutaReasignaCliente),
                                    backgroundColor: objColorsApp.morado,
                                    foregroundColor: Colors.white,
                                    icon: Icons.update,
                                    label: 'Solicitud de revisión de prospecto',
                                  ),
                                  
                                ],
                              ),
                              */
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
                                                    child: AutoSizeText(
                                                          //
                                                          //'${objLogDecode2["result"]["data"]["res.partner"]["data"][index]["name"]}',
                                                          clientesFiltrados[index].name,
                                                          style: const TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            //fontSize: 10,
                                                            color: Colors.black
                                                          ),
                                                          minFontSize: 5,
                                                          maxLines: 2,
                                                          textAlign: TextAlign.left,
                                                          ),
                                                ),

                                                if(email != null)
                                                Container(
                                                  color: Colors.transparent,
                                                  width: size.width * 0.54,
                                                  height: size.height * 0.035,
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        const TextSpan(
                                                          text: 'Correo: ',
                                                          style: TextStyle(color: Colors.black)
                                                        ),
                                                        TextSpan(
                                                          text: clientesFiltrados[index].email,
                                                          style: const TextStyle(color: Colors.blue)
                                                        ),
                                                      ]
                                                    ),
                                                  )
                                                ),

                                                if(pais != null)
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
                                                

                                            Container(
                                                color: Colors.transparent,
                                                width: size.width * 0.54,
                                                height: size.height * 0.035,
                                                child: 
                                                RichText(
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
                                                onPressed: () {},
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
                              
                      if(clientesFiltrados.isEmpty)
                      Container(
                        width: size.width * 0.75,
                        height: size.height * 0.75,
                        color: Colors.transparent,
                        child: ConsultaVaciaScreen(null, msmCabBand: 'Atención', msmBand: 'No existe el cliente buscado', imgCabBand: 'gifs/consulta_vacia.gif',)
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
      /*
      floatingActionButton: 
      
      FloatingActionButton(                
          onPressed: () {
            context.push(objRutasGen.rutaRegistroPrsp);
          },
          backgroundColor: const Color.fromRGBO(75, 57, 239, 1.0), // Color del botón
          child: const Icon(Icons.person_add_alt, color: Colors.white,), // Icono dentro del botón
        ),
        */
    );
  }
}

void doNothing(BuildContext context) {}