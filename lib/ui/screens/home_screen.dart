import 'package:animate_do/animate_do.dart';
//import 'package:auto_size_text/auto_size_text.dart';
import 'package:cvs_ec_app/domain/domain.dart';
import 'package:cvs_ec_app/ui/ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

String rutaFotoPerfil = '';
String numeroIdentificacion = '';
final FeatureApp objFeaturesNotificaciones = FeatureApp();
bool permiteConsulta = false;
bool permiteGestion = false;

class HomeScreen extends StatelessWidget {
  
  HomeScreen(Key? key, String numIdent) : super (key: key) {
    numeroIdentificacion = numIdent;
  }
  
  @override
  Widget build(BuildContext context) {

    return Center(
      child: FrmHomeScreen(),
    );
  }
}

//ignore: must_be_immutable
class FrmHomeScreen extends StatelessWidget {

  int varPosicionMostrar = 0;
  //List<NotificacionesModels> varLstNotificaciones = [];

  FrmHomeScreen({Key? key}) : super (key: key);

  @override
  Widget build(BuildContext context) {

    int varMuestraNotificacionesTrAp = 0;
    int varMuestraNotificacionesTrProc = 0;
    int varMuestraNotificacionesTrComp = 0;
    int varMuestraNotificacionesTrInfo = 0;

    final size = MediaQuery.of(context).size;

    final items = <ItemBoton>[
      ItemBoton('','','',1, Icons.groups, 'Clientes', 'Listado de todos los clientes asignados','','', Colors.white, Colors.white,false,varMuestraNotificacionesTrAp > 0,'','','icTramApr.png','icTramAprTrans.png','','', () => context.push(Rutas().rutaListaClientes),),
      ItemBoton('','','',2, Icons.calendar_month, 'Visitas Agendadas', 'Listado de clientes programados para el día','','', Colors.white, Colors.white,false,varMuestraNotificacionesTrProc > 0,'','','icTramProc.png','icTramProcTrans.png','','', () => context.push(Rutas().rutaListaClientes)),
      ItemBoton('','','',3, Icons.group_add, 'Prospectos', 'Seguimiento y control de prospectos','','', Colors.white, Colors.white,false,varMuestraNotificacionesTrComp > 0,'','','icCompras.png','icComprasTrans.png','','', () => context.push(Rutas().rutaListaClientes)),
      ItemBoton('','','',4, Icons.auto_stories_sharp, 'Catálogo', 'Catálogo de productos con imágenes','','', Colors.white, Colors.white,false,varMuestraNotificacionesTrComp > 0,'','','icCompras.png','icComprasTrans.png','','', () => context.push(Rutas().rutaListaClientes)),
      ItemBoton('','','',5, Icons.dashboard_customize_outlined, 'Inventario', 'Inventario general de productos con stock','','', Colors.white, Colors.white,false,varMuestraNotificacionesTrAp > 0,'','','icTramApr.png','icTramAprTrans.png','','', () => context.push(Rutas().rutaListaClientes)),
      ItemBoton('','','',6, Icons.format_list_bulleted_add, 'Listas de precio', 'Lista de precios generales para ventas','','', Colors.white, Colors.white,false,varMuestraNotificacionesTrProc > 0,'','','icTramProc.png','icTramProcTrans.png','','', () => context.push(Rutas().rutaListaClientes)),
      ItemBoton('','','',7, Icons.percent, 'Promociones Vigentes', 'Listado de Promociones Vigentes','','', Colors.white, Colors.white,false,varMuestraNotificacionesTrComp > 0,'','','icCompras.png','icComprasTrans.png','','', () => context.push(Rutas().rutaListaClientes)),
      ItemBoton('','','',8, Icons.inventory_rounded, 'Distribución en Rutas', 'Permite realizar el control de vehículos para reparto de ruta','','', Colors.white, Colors.white,false,varMuestraNotificacionesTrComp > 0,'','','icCompras.png','icComprasTrans.png','','', () => context.push(Rutas().rutaListaClientes)),
    ]; 

    List<Widget> itemMap = items.map(
    (item) => FadeInLeft(
      duration: const Duration( milliseconds: 250 ),
      child: 
        ItemsListasWidget(
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
        ),
      )
    ).toList();

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context,state) { 
              return Scaffold(
                backgroundColor: Colors.white,
                /*
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  //title: const Image(image: AssetImage('assets/LogoBlanco.png'),width: 150,),
                  title: Text('Avance del día'),
                  elevation: 0,
                ),
                */
                 appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              context.push(objRutasGen.rutaPerfil);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150'), // Reemplaza con la URL de la imagen del avatar
              ),
            ),
          ),
          title: Text(
            'Dashboard',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.flip_camera_android_rounded, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.cloud_sync_outlined, color: Colors.black),
              onPressed: () {},
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
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white,
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.grid_view_outlined, color: Colors.white,),
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
            height: tamanio.height * 0.15,
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

          const SizedBox(height: 8.0),

          Text(
            amount,
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
                Container(
                  width: tamanio.width * 0.17,
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        children: [
                          CircularProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.white.withOpacity(0.5),
                          color: progressColor,
                          semanticsLabel: '55%',
                          semanticsValue: '55%',
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
                      /*
                      primary: Colors.white, // Cambia el color de fondo del botón
                      onPrimary: Colors.black, // Cambia el color del texto
                      */
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FaIcon(FontAwesomeIcons.chartLine, size: 20, color: Colors.white,),
                        const Text('Detalles', style: TextStyle(color:  Colors.white, fontSize: 12),),
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
