
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

class ListaProspectosScreen extends StatefulWidget {
  const ListaProspectosScreen({super.key});

  @override
  State<ListaProspectosScreen> createState() => _ListaProspectosScreenState();
}

//class MarcacionScreen extends StatelessWidget {
class _ListaProspectosScreenState extends State<ListaProspectosScreen> {

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

                List<ClientModelResponse> lstCLientes = [];//snapshot.data as List<ClientModelResponse>;

                String objRsp = snapshot.data as String;

                var objLogDecode = json.decode(objRsp);
                var objLogDecode2 = json.decode(objLogDecode);

                var tstLength = objLogDecode2["result"]["data"]["crm.lead"]["length"];

                String contStr = '$tstLength';

                int contLst = int.parse(contStr);

                String estadoPrsp = '';

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
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: 'Buscar prospectos, códigos, nombres...',
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                          ),
                        ),
                      ),
                              
                      SizedBox(height: size.height * 0.02,),
                                  
                      Container(
                        color: Colors.transparent,
                        width: size.width,
                        height: size.height * 0.65,
                        child: ListView.builder(
                          controller: scrollListaClt,
                          itemCount: contLst,//lstCLientes.length,//carrito.detalles.length,
                          itemBuilder: ( _, int index ) {

                            try{
                              if(objLogDecode2["result"]["data"]["crm.lead"]["data"][index]["stage_id"] != null){
                                estadoPrsp = '${objLogDecode2["result"]["data"]["crm.lead"]["data"][index]["stage_id"]["name"]}';
                              }
                            }
                            catch(ex){
                              print(ex);
                              estadoPrsp = '${objLogDecode2["result"]["data"]["crm.lead"]["data"][index]["stage_id"]}';
                            }

                            return Slidable(
                              //key: ValueKey(lstCLientes[index].id),
                              key: ValueKey(objLogDecode2["result"]["data"]["crm.lead"]["data"][index]["id"]),
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
                                                  child: AutoSizeText(
                                                    //'${lstCLientes[index].primerNombre} ${lstCLientes[index].primerApellido}',
                                                    '${objLogDecode2["result"]["data"]["crm.lead"]["data"][index]["name"]}',
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 10,
                                                      color: Colors.black
                                                    ),
                                                    maxLines: 2,
                                                    textAlign: TextAlign.left,
                                                    ),
                                                ),
                                                Container(
                                                  color: Colors.transparent,
                                                  width: size.width * 0.54,
                                                  height: size.height * 0.04,
                                                  child: AutoSizeText(
                                                    //'${lstCLientes[index].primerNombre} ${lstCLientes[index].primerApellido}',
                                                    '${objLogDecode2["result"]["data"]["crm.lead"]["data"][index]["contact_name"]}',
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 10,
                                                      color: Colors.black
                                                    ),
                                                    maxLines: 2,
                                                    textAlign: TextAlign.left,
                                                    ),
                                                ),
                                                Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.54,
                                              height: size.height * 0.035,
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    const TextSpan(
                                                      text: 'Email: ',
                                                      style: TextStyle(color: Colors.black)
                                                    ),
                                                    TextSpan(
                                                      text: '${objLogDecode2["result"]["data"]["crm.lead"]["data"][index]["email_from"]}',
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
                                                      TextSpan(
                                                        text: '${objLogDecode2["result"]["data"]["crm.lead"]["data"][index]["phone"]}',
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
                                                      estadoPrsp,
                                                      //lstCLientes[index].estado,//ESTADO
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
      floatingActionButton: 
      
      FloatingActionButton(                
          onPressed: () {
            context.push(objRutasGen.rutaRegistroPrsp);          
          },
          backgroundColor: const Color.fromRGBO(75, 57, 239, 1.0), // Color del botón
          child: const Icon(Icons.person_add_alt, color: Colors.white,), // Icono dentro del botón
        ),
        
    );
  }
}

//void doNothing(BuildContext context) {}