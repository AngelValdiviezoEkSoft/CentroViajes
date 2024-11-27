import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
//import 'package:auto_size_text/auto_size_text.dart';
import 'package:cvs_ec_app/domain/domain.dart';
import 'package:cvs_ec_app/ui/ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

DonePermissions? objPermisosGen;

String compSelect = '';
String rutaFotoPerfil = '';
String numeroIdentificacion = '';
final FeatureApp objFeaturesNotificaciones = FeatureApp();
bool permiteConsulta = false;
bool permiteGestion = false;

class HomeScreen extends StatefulWidget {
  
  /*
  HomeScreen(Key? key, String numIdent) : super (key: key) {
    numeroIdentificacion = numIdent;
  }
  
  @override
  Widget build(BuildContext context) {

    return Center(
      child: FrmHomeScreen(),
    );
  }
  */

  
  const HomeScreen(Key? key) : super (key: key);

  @override
  HomeScreenState createState() => HomeScreenState();

}

//ignore: must_be_immutable
class HomeScreenState extends State<HomeScreen> {

  int varPosicionMostrar = 0;
  //List<NotificacionesModels> varLstNotificaciones = [];

  //HomeScreenState({Key? key}) : super (key: key);

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    /*
    int varMuestraNotificacionesTrAp = 0;
    int varMuestraNotificacionesTrProc = 0;
    int varMuestraNotificacionesTrComp = 0;
    int varMuestraNotificacionesTrInfo = 0;
    */

    final size = MediaQuery.of(context).size;

    /*
    final items = <ItemBoton>[
      ItemBoton('','','',1, Icons.group_add, 'Prospectos', 'Seguimiento y control de prospectos','','', Colors.white, Colors.white,false,varMuestraNotificacionesTrComp > 0,'','','icCompras.png','icComprasTrans.png','',
        Rutas().rutaListaProspectos, 
        () {
          context.push(Rutas().rutaListaProspectos);
        }
      ),
      ItemBoton('','','',2, Icons.groups, 'Clientes', 'Listado de todos los clientes asignados','','', Colors.white, Colors.white,false,varMuestraNotificacionesTrAp > 0,'','','icTramApr.png','icTramAprTrans.png','',
        Rutas().rutaListaClientes, 
        () {
          context.push(Rutas().rutaListaClientes);
        }
      ),
      ItemBoton('','','',3, Icons.calendar_month, 'Visitas Agendadas', 'Listado de clientes programados para el día','','', Colors.white, Colors.white,false,varMuestraNotificacionesTrProc > 0,'','','icTramProc.png','icTramProcTrans.png','',
        Rutas().rutaConstruccion, 
        () => context.push(Rutas().rutaListaClientes)
      ),
      ItemBoton('','','',4, Icons.auto_stories_sharp, 'Catálogo', 'Catálogo de productos con imágenes','','', Colors.white, Colors.white,false,varMuestraNotificacionesTrComp > 0,'','','icCompras.png','icComprasTrans.png','',
        Rutas().rutaConstruccion, 
        () => context.push(Rutas().rutaListaClientes)
      ),
      ItemBoton('','','',5, Icons.dashboard_customize_outlined, 'Inventario', 'Inventario general de productos con stock','','', Colors.white, Colors.white,false,varMuestraNotificacionesTrAp > 0,'','','icTramApr.png','icTramAprTrans.png','',
        Rutas().rutaConstruccion, 
        () => context.push(Rutas().rutaListaClientes)
      ),
      ItemBoton('','','',6, Icons.format_list_bulleted_add, 'Listas de precio', 'Lista de precios generales para ventas','','', Colors.white, Colors.white,false,varMuestraNotificacionesTrProc > 0,'','','icTramProc.png','icTramProcTrans.png','',
        Rutas().rutaConstruccion, 
        () => context.push(Rutas().rutaListaClientes)
      ),
      ItemBoton('','','',7, Icons.percent, 'Promociones Vigentes', 'Listado de Promociones Vigentes','','', Colors.white, Colors.white,false,varMuestraNotificacionesTrComp > 0,'','','icCompras.png','icComprasTrans.png','',
        Rutas().rutaConstruccion, 
        () => context.push(Rutas().rutaListaClientes)
      ),
      ItemBoton('','','',8, Icons.inventory_rounded, 'Distribución en Rutas', 'Permite realizar el control de vehículos para reparto de ruta','','', Colors.white, Colors.white,false,varMuestraNotificacionesTrComp > 0,'','','icCompras.png','icComprasTrans.png','',
        Rutas().rutaConstruccion, 
        () => context.push(Rutas().rutaListaClientes)
      ),
    ]; 

    List<Widget> itemMap = items.map(
    (item) => FadeInLeft(
      duration: const Duration( milliseconds: 250 ),
      child: 
        ItemsListasWidget(
          null,
          varIdPosicionMostrar: varPosicionMostrar,
          varEsRelevante: item.esRelevante,
          varIdNotificacion: item.ordenNot,
          varNumIdenti: numeroIdentificacion,
          icon: item.icon,
          texto: item.mensajeNotificacion,
          texto2: item.mensaje2,
          color1: item.color1,
          color2: item.color2,
          onPress: () {  },
          varMuestraNotificacionesTrAp: varMuestraNotificacionesTrAp,
          varMuestraNotificacionesTrProc: varMuestraNotificacionesTrProc,
          varMuestraNotificacionesTrComp: varMuestraNotificacionesTrComp,
          varMuestraNotificacionesTrInfo: varMuestraNotificacionesTrInfo,
          varIconoNot: item.iconoNotificacion,
          //objUserSolicVac: objUserSolicNotificacion, 
          varIconoNotTrans: item.rutaImagen,
          permiteGestion: permiteGestion,
          rutaNavegacion: item.rutaNavegacion,
        ),
      )
    ).toList();
    */

    List<String> lstComp = [];

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: BlocBuilder<GenericBloc, GenericState>(
            builder: (context,state) {

              return FutureBuilder(
                future: state.readPrincipalPage(),
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  
                  if(!snapshot.hasData) {
                    return Scaffold(
                        backgroundColor: Colors.white,
                      body: Center(
                        child: Image.asset(
                          "assets/gifs/gif_carga.gif",
                          height: size.width * 0.85,
                          width: size.width * 0.85,
                        ),
                      ),
                    );
                  }
                  else {
                    if(snapshot.data != null && snapshot.data!.isNotEmpty) {

                    String rspTmp = snapshot.data as String;

                    String lstTmp = rspTmp.split('---')[0];
                    String objPerm = rspTmp.split('---')[1];
                    String cardSalesStr = rspTmp.split('---')[2];
                    String cardCollectionStr = rspTmp.split('---')[3];

                    List<ItemBoton> lstMenu = state.deserializeItemBotonMenuList(objPerm);

                    List<String> lstNames = List<String>.from(json.decode(lstTmp));

                    lstComp = lstNames;

                    bool cardSales = bool.parse(cardSalesStr);
                    bool cardCollection = bool.parse(cardCollectionStr);
                    
                    if(compSelect.isEmpty){
                      compSelect = lstComp.first;
                    }

                    List<Widget> itemMap = lstMenu.map(
                      (item) => FadeInLeft(
                        duration: const Duration( milliseconds: 250 ),
                        child: 
                          ItemsListasWidget(
                            null,
                            varIdPosicionMostrar: varPosicionMostrar,
                            varEsRelevante: item.esRelevante,
                            varIdNotificacion: item.ordenNot,
                            varNumIdenti: numeroIdentificacion,
                            icon: item.icon,
                            texto: item.mensajeNotificacion,
                            texto2: item.mensaje2,
                            color1: item.color1,
                            color2: item.color2,
                            onPress: () {  },
                            varMuestraNotificacionesTrAp: 0,
                            varMuestraNotificacionesTrProc: 0,
                            varMuestraNotificacionesTrComp: 0,
                            varMuestraNotificacionesTrInfo: 0,
                            varIconoNot: item.iconoNotificacion,
                            varIconoNotTrans: item.rutaImagen,
                            permiteGestion: permiteGestion,
                            rutaNavegacion: item.rutaNavegacion,
                          ),
                        )
                      ).toList();
                    
                    return Scaffold(
                      backgroundColor: Colors.white,
                      appBar: AppBar(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        leading: GestureDetector(
                          onTap: () {
                            context.push(objRutasGen.rutaPerfil);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://via.placeholder.com/150'), // Reemplaza con la URL de la imagen del avatar
                            ),
                          ),
                        ),
                        title: const Text(
                          'Dashboard',
                          style: TextStyle(color: Colors.black),
                        ),
                        actions: [
                              
                              Container(
                  color: Colors.transparent,
                  width: size.width * 0.65,
                  height: size.height * 0.055,
                  child:   DropdownButton<String>(
                      hint: const Icon(Icons.flip_camera_android_rounded), // Ícono del ComboBox
                      value: compSelect,
                      onChanged: (String? newValue) {
                        //compSelect = newValue ?? '';
                        setState(() {
                          compSelect = newValue ?? '';
                        });
                      },
                      items: lstComp
                      .map((activityPrsp) =>
                          DropdownMenuItem(
                            value: activityPrsp,
                            child: Text(activityPrsp),
                          ))
                      .toList(),
                    ),
                              ),
                              IconButton(
                  icon: const Icon(Icons.notifications_active, color: Colors.black),
                  onPressed: () {},
                              ),
                            ],
                          ),
                    
                    body: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Scaffold(
                            backgroundColor: Colors.white,
                            body: SingleChildScrollView(
                              child: Column(
                                children: [

                                  if(cardSales)
                                  Container(
                                    color: Colors.transparent,
                                    width: size.width * 0.99,
                                    child: _buildCard(
                                      title: 'Ventas',
                                      meta: '\$970.20 / Meta',
                                      amount: '\$500.20',
                                      progress: 0.55,
                                      backgroundColor: Colors.blue.shade800,
                                      progressColor: const Color.fromARGB(255, 4, 48, 126),
                                      tamanio: size
                                    ),
                                  ),
                                            
                                  const SizedBox(height: 16.0),
                    
                                  if(cardCollection)
                                  Container(
                                    color: Colors.transparent,
                                    width: size.width * 0.99,
                                    child: _buildCard(
                                      title: 'Cobranza',
                                      meta: '\$970.20 / Meta',
                                      amount: '\$500.20',
                                      progress: 0.55,
                                      backgroundColor: Colors.white,
                                      //progressColor: Colors.blueAccent,
                                      progressColor: const Color.fromARGB(255, 4, 48, 126),
                                      textColor: Colors.black,
                                      tamanio: size
                                    ),
                                  ),
                  
                              const SizedBox(height: 16.0),
                                        
                                  Container(
                                    color: Colors.transparent,
                                    width: size.width * 0.99,
                                    height: size.height * 0.55,
                                    child: Stack(
                                      children: <Widget>[
                                        
                                        Container(
                                          color: Colors.transparent,
                                          width: size.width,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                color: Colors.transparent,
                                                width: size.width * 0.35,
                                                child: const Text('Operaciones', style: TextStyle(fontSize: 12),)
                                              ),
                                              Container(
                                                width: size.width * 0.35,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade700,
                                                  borderRadius: BorderRadius.circular(8.0),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.white,
                                                      spreadRadius: 2,
                                                      blurRadius: 5,
                                                      offset: Offset(0, 3),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(Icons.grid_view_outlined, color: Colors.white,),
                                                    SizedBox(
                                                      width: size.width * 0.02,
                                                    ),
                                                    const Text('Avance del día', style: TextStyle(fontSize: 12, color: Colors.white),),
                                                  ],
                                                )
                                              ),
                                            ],
                                          ),
                                        ),
                                    
                                        Container(
                                          margin: const EdgeInsets.only( top: 25 ),
                                          width: size.width * 0.99,
                                          height: size.height * 0.45,
                                          child: ListView(
                                            physics: const BouncingScrollPhysics(),
                                            children: <Widget>[
                                              const SizedBox( height: 3, ),
                                              ...itemMap,
                                            ],
                                          ),
                                        ),
                                    
                                        //_Encabezado()
                                    
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ),
                    )
                    
                  );
                
                  }
                  }

                  return Container();
                }
              );
            
              
            }
        )
      ),
    );
  }
}

  Widget _buildCard({
    required String title,
    required String meta,
    required String amount,
    required double progress,
    required Color backgroundColor,
    required Color progressColor,
    required Size tamanio,
    Color textColor = Colors.white,
  }) {
    return Container(
      height: tamanio.height * 0.21,
      padding: const EdgeInsets.all(0.5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Container(
            width: tamanio.width * 0.35,
            height: tamanio.height * 0.28,
            color: Colors.transparent,
            child: Column(
              children: [
                SizedBox(
                  height: tamanio.height * 0.02,
                ),
                
                Container(
                  width: tamanio.width * 0.3,
                  color: Colors.transparent,
                  child: Text(
                              title,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                ),
                
                Container(
                  width: tamanio.width * 0.3,
                  color: Colors.transparent,
                  child: Text(
                    meta,
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                      fontSize: 14.0,
                    ),
                  ),
                ),

                const SizedBox(height: 6.0),

                AutoSizeText(
                  amount,
                  maxLines: 1,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8.0),

              ],
            ),
          ),

          Container(
            width: tamanio.width * 0.4,
            height: tamanio.height * 0.1,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if(objPermisosGen != null && objPermisosGen!.buttons.btnProgressOfTheDay)
                Container(
                  width: tamanio.width * 0.17,
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        children: [
                          Container(
                            color: Colors.transparent,
                            width: tamanio.width * 0.1,
                            height: tamanio.height * 0.05,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.white.withOpacity(0.5),
                              color: progressColor,
                              semanticsLabel: '55%',
                              semanticsValue: '55%',
                            ),
                          ),
                          Positioned(
                            top: 8,
                            left: 5,
                            child: Text('55%', style: TextStyle(color: textColor),)
                          )
                        ]
                      ),
                      FaIcon(FontAwesomeIcons.chartLine, size: 20, color: textColor,),
                    ],
                  ),
                ),
                Container(
                  width: tamanio.width * 0.3,
                  height: tamanio.height * 0.035,
                  color: Colors.transparent,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(                      
                      backgroundColor: Colors.grey.shade700,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FaIcon(FontAwesomeIcons.chartLine, size: 20, color: Colors.white,),
                        Text('Detalles', style: TextStyle(color:  Colors.white, fontSize: 12),),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
