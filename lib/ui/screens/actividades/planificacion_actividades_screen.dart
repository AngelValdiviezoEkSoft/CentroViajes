import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cvs_ec_app/domain/domain.dart';
import 'package:cvs_ec_app/infraestructure/infraestructure.dart';
import 'package:cvs_ec_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

Timer? _timer;
int _segundos = 0; // Tiempo en segundos
bool _corriendo = false;

String terminoBusquedaAct = '';
bool actualizaListaAct= false;

DateTime selectedDayGenPlanAct = DateTime.now();
DateTime focusedDayGenPlanAct = DateTime.now();
List<DateTime> _dates = [];
int contLst = 0;
//import 'package:one_clock/one_clock.dart';
String actPlanSelect = '';

late TextEditingController fechaActividadContTxt;
late TextEditingController descripcionActTxt;

int tabAcciones = 0;
late TextEditingController notasActTxt;

List<DatumActivitiesResponse> actividadesFiltradas = [];

class PlanificacionActividades extends StatefulWidget {
  const PlanificacionActividades(Key? key) : super (key: key);
  @override
  State<PlanificacionActividades> createState() => PlanActState();
}

class PlanActState extends State<PlanificacionActividades> {

  @override
  void initState() {
    super.initState();

    contLst = 0;
    notasActTxt = TextEditingController();
    fechaActividadContTxt = TextEditingController();
    descripcionActTxt = TextEditingController();
    terminoBusquedaAct = '';
    actualizaListaAct= false;
    actividadesFiltradas = [];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final planAct = BlocProvider.of<GenericBloc>(context);

    return BlocBuilder<GenericBloc, GenericState>(
        builder: (context,state) {
        return FutureBuilder(
          future: state.readCombosGen(),
          builder: (context, snapshot) {

            if(!snapshot.hasData) {
              return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: Image.asset(
                    "assets/gifs/gif_carga.gif",
                    height: size.width * 0.85,//150.0,
                    width: size.width * 0.85,//150.0,
                  ),
                ),
              );
            }

            String rspCombos = snapshot.data as String;

            ProspectoCombosModel objTmp = ProspectoCombosModel(
              campanias: '',//rspCombos.split('---')[0],
              origen: '',//rspCombos.split('---')[1],
              medias: '',//rspCombos.split('---')[2],
              actividades: '',//rspCombos.split('---')[3],
              paises: '',//rspCombos.split('---')[4],
              lstActividades: rspCombos.split('---')[5],
            );

            var objAct = json.decode(objTmp.lstActividades);

            var objAct3 = objAct['data'];

            List<Map<String, dynamic>> mappedObjAct3 = List<Map<String, dynamic>>.from(objAct3);

            List<String> lstActividades = mappedObjAct3
            .map((item) => item["name"]?.toString() ?? '')
            .toList();

            return Scaffold(
              appBar: AppBar(
                title: Text(
                  objDatumCrmLead?.contactName ?? '-- Sin nombre --',
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.blue.shade800,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () {
                    context.pop();
                  },
                ),
                actions: [
                  GestureDetector(
                      onTap: () {
                        //context.push(objRutasGen.rutaAgenda);
            
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.06),
                            ),
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext bc) {
                              return BlocBuilder<GenericBloc, GenericState>(
                                builder: (context, state) {
                                  return Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Container(
                                      color: Colors.transparent,
                                      width: size.width,
                                      height: size.height *
                                          state.heightModalPlanAct, //0.57,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: AppSpacing.space03(),
                                            ),
                                            SizedBox(
                                              width: size.width * 0.15,
                                              child: Image.asset(
                                                'assets/images/ic_horizontalLine.png',
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            SizedBox(
                                              height: AppSpacing.space03(),
                                            ),
                                            const Text(
                                              'Registrar actividad',
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight:
                                                      FontWeight.bold),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'En esta interfaz es posible registrar las actividades que serán realizadas con los prospectos/leads asignados',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[700]),
                                            ),
                                            const SizedBox(height: 24),
                                            /*
                                            DropdownButtonFormField<String>(
                                              decoration: const  InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText:
                                                    'Seleccione el tipo de actividad...',
                                              ),
                                              //value: selectedActivityType,
                                              items: [
                                                'Llamada',
                                                'Reunión',
                                                'Correo'
                                              ]
                                                  .map((activity) =>
                                                      DropdownMenuItem(
                                                        value: activity,
                                                        child: Text(activity),
                                                      ))
                                                  .toList(),
                                              onChanged: (value) {
                                                
                                              },
                                            ),
                                            */
                                            Container(
                                              color: Colors.transparent,
                                              width: size.width * 0.92,
                                              child: DropdownButtonFormField<String>(
                                                decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Seleccione el tipo de actividad...',
                                                ),
                                                //value: campSelect,
                                                items: lstActividades.map((activityPrsp) =>
                                                  DropdownMenuItem(
                                                      value: activityPrsp,
                                                      child: Text(activityPrsp, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(fontSize: 12),),                                              
                                                    )
                                                  )
                                                .toList(),
                                                onChanged: (String? newValue) {                        
                                                  setState(() {
                                                    campSelect = newValue ?? '';
                                                  });
                                                },
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            TextFormField(
                                              controller: fechaActividadContTxt,
                                              readOnly: true,
                                              decoration: const InputDecoration(
                                                labelText: 'Seleccione la fecha...',
                                                border: OutlineInputBorder(),
                                                suffixIcon: Icon(Icons.calendar_today),
                                              ),
                                              onTap: () async {
                                                DateTime? pickedDate =
                                                    await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(2020),
                                                  lastDate: DateTime(2100),
                                                );
                                                if (pickedDate != null) {
                                                  fechaActividadContTxt.text = DateFormat('yyyy-MM-dd', 'es').format(pickedDate);                                                        
                                                }
                                              },
                                            ),
                                            const SizedBox(height: 16),
                                            TextFormField(
                                              controller: descripcionActTxt,
                                              onChanged: (value) {
                                                planAct.setHeightModalPlanAct(
                                                    0.92);
                                              },
                                              onTap: () {
                                                planAct.setHeightModalPlanAct(
                                                    0.92);
                                              },
                                              onEditingComplete: () {
                                                planAct.setHeightModalPlanAct(
                                                    0.65);
                                                FocusScope.of(context).unfocus();
                                              },
                                              onTapOutside: (event) {
                                                planAct.setHeightModalPlanAct(
                                                    0.65);
                                                FocusScope.of(context).unfocus();
                                              },
                                              maxLines: 4,
                                              decoration:
                                                  const InputDecoration(
                                                labelText:
                                                    'Ingrese su descripción...',
                                                border: OutlineInputBorder(),
                                              ),
                                            ),
                                            SizedBox(height: size.height * 0.035),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceEvenly,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    context.pop();
                                                  },
                                                  
                                                  style: ElevatedButton
                                                      .styleFrom(
                                                    backgroundColor: const Color(
                                                        0xFF5F2EEA), // Purple button
                                                  ),
                                                  child: const Text(
                                                    'Cerrar',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () async {

                                                    if(fechaActividadContTxt.text.isEmpty){
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
                                                            numLineasTitulo: 2,
                                                            numLineasMensaje: 2,
                                                            titulo: 'Error',
                                                            mensajeAlerta: 'Ingrese la fecha de la actividad.'
                                                          );
                                                        },
                                                      );
                                    
                                                      return;
                                                    }

                                                    if(descripcionActTxt.text.isEmpty){
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
                                                            numLineasTitulo: 2,
                                                            numLineasMensaje: 2,
                                                            titulo: 'Error',
                                                            mensajeAlerta: 'Ingrese la descripción de la actividad.'
                                                          );
                                                        },
                                                      );
                                    
                                                      return;
                                                    }

                                                    int activityTypeIdFrm = 0;

                                                    for (var elemento in mappedObjAct3) {
                                                      if (elemento['name'] == campSelect) {
                                                        activityTypeIdFrm = elemento['id'];
                                                      }
                                                    }

                                                    if(activityTypeIdFrm == 0){
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
                                                            numLineasTitulo: 2,
                                                            numLineasMensaje: 2,
                                                            titulo: 'Error',
                                                            mensajeAlerta: 'Seleccion el tipo de actividad.'
                                                          );
                                                        },
                                                      );
                                    
                                                      return;
                                                    }

                                                    ActivitiesTypeRequestModel objReqst = ActivitiesTypeRequestModel(
                                                      active: true,
                                                      createDate: DateTime.parse(fechaActividadContTxt.text),
                                                      createUid: 0,
                                                      displayName: objDatumCrmLead?.contactName ?? '',
                                                      previousActivityTypeId: 0,
                                                      note: descripcionActTxt.text,
                                                      activityTypeId: activityTypeIdFrm,
                                                      dateDeadline: objDatumCrmLead?.dateDeadline ?? DateTime.now(),
                                                      userId: objDatumCrmLead?.userId!.id ?? 0,
                                                      userCreateId: objDatumCrmLead?.userId!.id ?? 0,
                                                      resId: objDatumCrmLead?.id ?? 0,
                                                      actId: 0
                                                    );

                                                    showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (context) => SimpleDialog(
                                                        alignment: Alignment.center,
                                                        children: [
                                                          SimpleDialogCargando(
                                                            null,
                                                            mensajeMostrar: 'Estamos registrando',
                                                            mensajeMostrarDialogCargando: 'la nueva actividad para el prospecto.',
                                                          ),
                                                        ]
                                                      ),
                                                    );
                                    
                                                    ActividadRegistroResponseModel objResp = await ActivitiesService().registroActividades(objReqst);

                                                    String respuestaReg = objResp.result.mensaje;
                                                    int estado = objResp.result.estado;
                                                    String gifRespuesta = '';

                                                    //ignore: use_build_context_synchronously
                                                    context.pop();

                                                    if(estado == 200){
                                                      gifRespuesta = 'assets/gifs/exito.gif';
                                                    } else {
                                                      gifRespuesta = 'assets/gifs/gifErrorBlanco.gif';
                                                    }

/*
                                                    if(objResp.result.mensaje.isNotEmpty){
                                
                                                      showDialog(
                                                        //ignore: use_build_context_synchronously
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: Container(
                                                              color: Colors.transparent,
                                                              height: size.height * 0.17,
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  
                                                                  Container(
                                                                    color: Colors.transparent,
                                                                    height: size.height * 0.09,
                                                                    child: Image.asset(gifRespuesta),
                                                                  ),
                                    
                                                                  Container(
                                                                    color: Colors.transparent,
                                                                    width: size.width * 0.95,
                                                                    height: size.height * 0.08,
                                                                    alignment: Alignment.center,
                                                                    child: AutoSizeText(
                                                                      objResp.result.mensaje,
                                                                      maxLines: 2,
                                                                      minFontSize: 2,
                                                                    ),
                                                                  )
                                                                ],
                                                              )
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                                child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    
                                                      //return;
                                                    }
                                                    */
                                    
                                                    //ignore:use_build_context_synchronously
                                                    context.pop();
                                                    //ignore:use_build_context_synchronously
                                                    context.pop();
                                    
                                                    showDialog(
                                                      //ignore:use_build_context_synchronously
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Container(
                                                            color: Colors.transparent,
                                                            height: size.height * 0.17,
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                
                                                                Container(
                                                                  color: Colors.transparent,
                                                                  height: size.height * 0.09,
                                                                  child: Image.asset(gifRespuesta),
                                                                ),
                                    
                                                                Container(
                                                                  color: Colors.transparent,
                                                                  width: size.width * 0.95,
                                                                  height: size.height * 0.08,
                                                                  alignment: Alignment.center,
                                                                  child: AutoSizeText(
                                                                    respuestaReg,
                                                                    maxLines: 2,
                                                                    minFontSize: 2,
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                              child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  
                                                  },
                                                  
                                                  style: ElevatedButton
                                                      .styleFrom(
                                                    backgroundColor: const Color(
                                                        0xFF5F2EEA), // Purple button
                                                  ),
                                                  child: const Text(
                                                    'Crear Actividad',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            });
                      },
                      child: const Icon(
                        Icons.calendar_month,
                        color: Colors.white,
                        size: 40,
                      )
                    ),
                  SizedBox(
                    width: size.width * 0.04,
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Colors.blue.shade800,
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            color: Colors.transparent,
                              width: size.width * 0.95,
                              child: const Text(
                                'Compra de terreno con plan de viaje',
                                style: TextStyle(color: Colors.white, fontSize: 17),
                              )),
                          const SizedBox(height: 15),
                          const Row(
                            children: [
                              Text(
                                "⭐⭐⭐⭐⭐",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.yellow,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  color: tabAcciones == 0
                                      ? Colors.white
                                      : Colors.blue.shade800,
                                  child: Center(
                                    child: TextButton(
                                      onPressed: () {
                                        tabAcciones = 0;
                                        setState(() {});
                                      },
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            color: tabAcciones == 0
                                                ? Colors.blue.shade800
                                                : Colors.white,
                                          ),
                                          Text(
                                            'Acciones',
                                            style: TextStyle(
                                              color: tabAcciones == 0
                                                  ? Colors.blue.shade800
                                                  : Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  color: tabAcciones == 1
                                      ? Colors.white
                                      : Colors.blue.shade800,
                                  child: Center(
                                    child: TextButton(
                                      onPressed: () {
                                        tabAcciones = 1;
                                        setState(() {});
                                      },
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.grid_on_outlined,
                                            color: tabAcciones == 1
                                                ? Colors.blue.shade800
                                                : Colors.white,
                                          ),
                                          Text(
                                            'Detalles',
                                            style: TextStyle(
                                              //color: Colors.purple.shade700,
                                              color: tabAcciones == 1
                                                  ? Colors.blue.shade800
                                                  : Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (tabAcciones == 0) const PlanAct(null),
                    if (tabAcciones == 1)
                      // Información General
                      sectionTitle(Icons.info, "Información General"),
                    if (tabAcciones == 1) infoRow("Razón Social", "Randy Rudolph"),
                    if (tabAcciones == 1)
                      infoRow("Nombre Comercial", "[partner -> business_name]"),
                    if (tabAcciones == 1) infoRow("Clasificación", "Randy Rudolph"),
                    if (tabAcciones == 1) infoRow("Canal", "Randy Rudolph"),
                    if (tabAcciones == 1) infoRow("Dirección", objDatumCrmLead?.street ?? '-----'),
                    if (tabAcciones == 1)
                      // Territorio
                      sectionTitle(Icons.place, "Territorio"),
                    if (tabAcciones == 1) infoRow("Estado", objDatumCrmLead?.stageId.name ?? '-----'),
                    if (tabAcciones == 1) infoRow("Ciudad", "Guayaquil"),
                    if (tabAcciones == 1) infoRow("Cantón", "Tarquí"),
                    if (tabAcciones == 1) infoRow("Región", "Costa"),
                    if (tabAcciones == 1) infoRow("Lugar", "Norte"),
                    if (tabAcciones == 1)
                      // Precios y Ventas
                      sectionTitle(Icons.monetization_on, "Precios y Ventas"),
                    if (tabAcciones == 1) infoRow("Ingreso esperado", "\$${objDatumCrmLead?.expectedRevenue}"),
                    if (tabAcciones == 1) infoRow("Probabilidad", "${objDatumCrmLead?.probability}%"),
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }
}

Widget sectionTitle(IconData icon, String title) {
  return Container(
    padding: const EdgeInsets.all(10.0),
    color: Colors.blue.shade900,
    width: double.infinity,
    child: Row(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

Widget infoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$label:",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value),
      ],
    ),
  );
}

class PlanAct extends StatefulWidget {

  const PlanAct(Key? key) : super(key: key);

  @override
  PlanActStateTwo createState() => PlanActStateTwo();
}

class PlanActStateTwo extends State<PlanAct> {

  ColorsApp objColorsApp = ColorsApp();

  @override
  void initState() {
    super.initState();
    //_corriendo = false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ScrollController scrollListaClt = ScrollController();
  
    return BlocBuilder<GenericBloc, GenericState>(
      builder: (context,state) {
        return FutureBuilder(
          future: ActivitiesService().getActivitiesById(objDatumCrmLead?.id ?? 0),
          builder: (context, snapshot) {

            if(!snapshot.hasData) {
              return Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: Image.asset(
                    "assets/gifs/gif_carga.gif",
                    height: size.width * 0.85,//150.0,
                    width: size.width * 0.85,//150.0,
                  ),
                ),
              );
            }

            if(snapshot.data != null) {

              ActivitiesResponseModel rspAct = snapshot.data as ActivitiesResponseModel;

              if(!actualizaListaAct)
              {
                contLst = rspAct.length;
                actividadesFiltradas = rspAct.data;
              }

              Future<void> refreshDataByFiltro(String filtro) async {            
                actividadesFiltradas = [];

                //CrmLead apiResponse = CrmLead.fromJson(objMemoria);

                if(terminoBusquedaAct.isNotEmpty){
                  
                  actividadesFiltradas = rspAct.data
                  .where(
                    (producto) => producto.activityTypeId.name.toLowerCase().contains(terminoBusquedaAct.toLowerCase()))
                  .toList();

                  contLst = 0;

                  contLst = actividadesFiltradas.length;
                } else{
                  actividadesFiltradas = rspAct.data;
                  actualizaListaAct = false;
                }            

                if(terminoBusquedaAct.isNotEmpty && actualizaListaAct) {
                  setState(() {});
                }

              }


              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: size.width *0.95,
                          height: size.height * 0.39,
                          color: Colors.transparent,
                          child: CalendarDatePicker2(
                            config: CalendarDatePicker2Config(
                              calendarType: CalendarDatePicker2Type.range,
                              lastDate: DateTime.now()
                            ),
                            value: _dates,
                            onValueChanged: (dates) async {
                              _dates = dates;

                              if(dates.length == 1)
                              {
                                return;
                              }

                              ActivitiesResponseModel objRsp = await ActivitiesService().getActivitiesByRangoFechas(dates, objDatumCrmLead?.id ?? 0);

                              actividadesFiltradas = [];
                              actividadesFiltradas = objRsp.data;

                              setState(() {
                                rspAct = objRsp;
                                actualizaListaAct = true;
                                contLst = actividadesFiltradas.length;
                              });
                            }
                          )                          
                        ),
                        /*
                        Container(
                          color: Colors.transparent,
                          width: size.width,
                          height: size.height * 0.07,
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Agendado para hoy',
                              labelStyle: TextStyle(color: Color(0xFF5DC38C))
                            ),
                            value: actPlanSelect,
                            items: lstActividades.map((activityPrsp) =>
                              DropdownMenuItem(
                                value: activityPrsp,
                                child: Text(activityPrsp, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(fontSize: 12),),                          
                              )
                            ).toList(),
                            onChanged: (String? newValue) {                        
                              setState(() {
                                actPlanSelect = newValue ?? '';
                              });
                            },
                          ),
                        ),
                        */

                        //SizedBox(height: size.height * 0.009),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: TextField(
                            inputFormatters: [
                              EmojiInputFormatter()
                            ],
                            onChanged: (value) {
                              actualizaListaAct = true;
                              terminoBusquedaAct = value;
                              refreshDataByFiltro(value);
                            },
                            onEditingComplete: () {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                actualizaListaAct = false;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Buscar actividades',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),

                        //SizedBox(height: size.height * 0.05),
                        
                      ],
                    ),
                  ),

                  Container(
                    color: Colors.transparent,
                    width: size.width,
                    height: size.height * 0.65,
                    child: ListView.builder(
                      controller: scrollListaClt,
                      itemCount: contLst,
                      itemBuilder: ( _, int index ) {

                        return Slidable(
                          //key: ValueKey(lstActividades[index].id),
                          startActionPane: ActionPane(
                            motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {                                    
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Registro detalle de actividad"),
                                          content: Form(
                                            //key: _formKey,
                                            child: Container(
                                              color: Colors.transparent,
                                              height: size.height * 0.3,
                                              child: Column(
                                                children: [
                                                  
                                                  Container(
                                                    width: size.width * 0.99,
                                                    color: Colors.transparent,
                                                    child: Center(
                                                      child: Container(
                                                        width: size.width * 0.95,
                                                        height: size.height * 0.11,
                                                        color: Colors.transparent,
                                                        child: const Center(
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  //formatearTiempo(_segundos),
                                                                  '00:00:00',
                                                                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                                                                ),
                                                              
                                                              ],
                                                            ),
                                                          ),
                                                      )
                                                    ),
                                                  ),
                                              
                                                  Container(
                                                    color: Colors.transparent,
                                                    width: size.width * 0.92,
                                                    child: TextFormField(
                                                      inputFormatters: [
                                                        EmojiInputFormatter()
                                                      ],
                                                      cursorColor: AppLightColors().primary,
                                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                                      style: AppTextStyles.bodyRegular(width: size.width),
                                                      decoration: const InputDecoration(
                                                        label: Text('Notas'),
                                                        border: OutlineInputBorder(),
                                                        hintText: 'Notas de la visita o llamada para registrar la acción realizada.',
                                                      ),                                              
                                                      controller: notasActTxt,
                                                      autocorrect: false,
                                                      keyboardType: TextInputType.text,
                                                      minLines: 1,
                                                      maxLines: 4,
                                                      autofocus: false,
                                                      maxLength: 150,
                                                      textAlign: TextAlign.left,
                                                      onEditingComplete: () {
                                                        FocusScope.of(context).unfocus();
                                                      },
                                                      onChanged: (value) {
                                                        
                                                      },
                                                      onTapOutside: (event) {
                                                        FocusScope.of(context).unfocus();
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(),
                                              child: const Text("Cancelar"),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text('Registro de salida'),
                                                      content: const Column(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            'Desea registrar la salida y cerrar la '
                                                            'visita del cliente',
                                                          ),
                                                        ],
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            //context.pop();
                                                            Navigator.pop(context);
                                                            
                                                            //Navigator.of(context).pop();
                                                          },
                                                          child: Text(
                                                            'NO',
                                                            style: TextStyle(color: Colors.blue[200]),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            // Acción para solicitar revisión
                                                            Navigator.of(context).pop();

                                                            if(notasActTxt.text.isEmpty){
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
                                                                    numLineasTitulo: 2,
                                                                    numLineasMensaje: 2,
                                                                    titulo: 'Error',
                                                                    mensajeAlerta: 'Ingrese sus notas para poder cerrar esta actividad.'
                                                                  );
                                                                },
                                                              );
                                            
                                                              return;
                                                            }
                                                              
                                                            //detenerCronometro();
                                                            //rspAct.data[index].id;
                                                            //print('Test grabado: ${rspAct.data[index].id}');

                                                            ActivitiesTypeRequestModel objSave = ActivitiesTypeRequestModel(
                                                              active: true,
                                                              createDate: DateTime.now(),//DateTime.parse(fechaActividadContTxt.text),
                                                              createUid: 0,
                                                              displayName: objDatumCrmLead?.contactName ?? '',
                                                              previousActivityTypeId: 0,
                                                              note: descripcionActTxt.text,
                                                              activityTypeId: rspAct.data[index].activityTypeId.id,
                                                              dateDeadline: rspAct.data[index].dateDeadline,
                                                              userId: objDatumCrmLead?.userId!.id ?? 0,
                                                              userCreateId: objDatumCrmLead?.userId!.id ?? 0,
                                                              resId: objDatumCrmLead?.id ?? 0,
                                                              actId: rspAct.data[index].id
                                                            );

                                                            //NOTA: SOLO FALTA VERIFICAR QUE SE GRABE CORRECTAMENTE

                                                            //await ActivitiesService().cierreActividadesXId(objSave);

                                                            Navigator.of(context).pop();
                                                            Navigator.of(context).pop();

                                                             showDialog(
                                                              //ignore: use_build_context_synchronously
                                                              context: context,
                                                              builder: (BuildContext context) {
                                                                return AlertDialog(
                                                                  title: Container(
                                                                    color: Colors.transparent,
                                                                    height: size.height * 0.17,
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        
                                                                        Container(
                                                                          color: Colors.transparent,
                                                                          height: size.height * 0.09,
                                                                          child: Image.asset('assets/gifs/exito.gif'),
                                                                        ),
                                          
                                                                        Container(
                                                                          color: Colors.transparent,
                                                                          width: size.width * 0.95,
                                                                          height: size.height * 0.08,
                                                                          alignment: Alignment.center,
                                                                          child: AutoSizeText(
                                                                            'Actividad cerrada exitosamente',
                                                                            maxLines: 2,
                                                                            minFontSize: 2,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    )
                                                                  ),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed: () {
                                                                        Navigator.of(context).pop();
                                                                      },
                                                                      child: Text('Aceptar', style: TextStyle(color: Colors.blue[200]),),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          
                                                            
                                                            
                                                            //Navigator.of(context).pop();
                                                          },
                                                          child: Text(
                                                            'Sí',
                                                            style: TextStyle(color: Colors.blue[200]),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              
                                              },
                                              //child: const Text("Salida"),
                                              child: const Text("Cerrar Actividad"),
                                            ),
                                            /*
                                            ElevatedButton(
                                              onPressed: () {
                                                //iniciarCronometro();
                                              },
                                              child: const Text("Llegada"),
                                            ),
                                            */
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  backgroundColor: objColorsApp.fucsia,
                                  foregroundColor: Colors.white,
                                  icon: Icons.account_circle,
                                  label: 'Cierre de Actividades',
                                )
                              ]
                          ),
                          child:  Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                            child: Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.grey[300],
                                  child: const Icon(Icons.person),
                                ),
                                title: Text(actividadesFiltradas[index].activityTypeId.name),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //Text('RUC/C: 095011183001', style: TextStyle(fontSize: 12)),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: 'Date Dead Line:',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                            ),
                                          ),
                                          TextSpan(
                                            text: DateFormat('yyyy-MM-dd', 'es').format(actividadesFiltradas[index].dateDeadline),
                                            style: const TextStyle(
                                              color: Colors.blue,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    //Text('COD: 59345', style: TextStyle(fontSize: 12)),
                                    /*

                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'COD:',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                            ),
                                          ),
                                          TextSpan(
                                            text: rspAct.data[index].,
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),


                                    const Text('Tipo de Agenda: Llamada', style: TextStyle(fontSize: 12)),
                                    const Text('Activo', style: TextStyle(fontSize: 12, color: Colors.green)),
                                    */
                                  ],
                                ),
                                /*
                                trailing: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('10:20 AM', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Icon(Icons.phone, color: Colors.grey),
                                  ],
                                ),
                                */
                              ),
                            ),
                          )
                        );
                      
                      },
                    ),
                  ),

/*
                  Container(
                    width: size.width *0.95,
                    height: isSelected[1] ? size.height * 0.55 : size.height * 0.4,
                    color: Colors.transparent,
                    child: ListView.builder(
                      itemCount: 5, // Número de elementos en la lista
                      itemBuilder: (context, index) {
                        return _buildAgendaItem();
                      },
                    ),
                  ),
                    */

                  /*
                  const SizedBox(height: 32),
                  
                  Container(
                    width: size.width * 0.99,
                    color: Colors.transparent,
                    child: Center(
                      child: Container(
                        width: size.width * 0.95,
                        height: size.height * 0.11,
                        color: Colors.transparent,
                        child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  formatearTiempo(_segundos),
                                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                                ),
                              
                              ],
                            ),
                          ),
                      )
                    ),
                  ),
              
                  const SizedBox(height: 16),
                  
                  Container(
                    color: Colors.transparent,
                    width: size.width * 0.92,
                    child: TextFormField(     
                                
                      inputFormatters: [
                        EmojiInputFormatter()
                      ],
                      cursorColor: AppLightColors().primary,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: AppTextStyles.bodyRegular(width: size.width),
                      decoration: const InputDecoration(
                        label: Text('Notas'),
                        border: OutlineInputBorder(),
                        hintText: 'Notas de la visita o llamada para registrar la acción realizada.',
                      ),
              
                      controller: notasActTxt,
                      autocorrect: false,
                      keyboardType: TextInputType.text,
                      minLines: 1,
                      maxLines: 4,
                      autofocus: false,
                      maxLength: 150,
                      textAlign: TextAlign.left,
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                      onChanged: (value) {
                        
                      },
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                
                  */

                ],
              );
          
            }

            return Container();
          }
        );
      }
    );
  }
}

class BtnSlidableAction extends StatefulWidget {
  const BtnSlidableAction(Key? key) : super (key: key);
  @override
  State<BtnSlidableAction> createState() => BtnSlidableActionState();
}

class BtnSlidableActionState extends State<BtnSlidableAction> {

  ColorsApp objColorsApp = ColorsApp();

  void iniciarCronometro() {
    if (!_corriendo) {
      _corriendo = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _segundos++;
        });
      });
    }
  }

  void detenerCronometro() {
    if (_corriendo) {
      _timer?.cancel();
      _corriendo = false;
    }
  }

  void reiniciarCronometro() {
    _timer?.cancel();
    setState(() {
      _segundos = 0;
      _corriendo = false;
    });
  }

  String formatearTiempo(int segundos) {
    int horas = segundos ~/ 3600;
    int minutos = (segundos % 3600) ~/ 60;
    int segs = segundos % 60;
    return '${horas.toString().padLeft(2, '0')}:${minutos.toString().padLeft(2, '0')}:${segs.toString().padLeft(2, '0')}';
  }

  
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return SlidableAction(
      onPressed: (context) {
        
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Registro detalle de actividad"),
              content: Form(
                //key: _formKey,
                child: Container(
                  color: Colors.transparent,
                  height: size.height * 0.3,
                  child: Column(
                    children: [
                      
                      Container(
                        width: size.width * 0.99,
                        color: Colors.transparent,
                        child: Center(
                          child: Container(
                            width: size.width * 0.95,
                            height: size.height * 0.11,
                            color: Colors.transparent,
                            child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      formatearTiempo(_segundos),
                                      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                                    ),
                                  
                                  ],
                                ),
                              ),
                          )
                        ),
                      ),
                  
                      Container(
                        color: Colors.transparent,
                        width: size.width * 0.92,
                        child: TextFormField(     
                                    
                          inputFormatters: [
                            EmojiInputFormatter()
                          ],
                          cursorColor: AppLightColors().primary,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: AppTextStyles.bodyRegular(width: size.width),
                          decoration: const InputDecoration(
                            label: Text('Notas'),
                            border: OutlineInputBorder(),
                            hintText: 'Notas de la visita o llamada para registrar la acción realizada.',
                          ),
                  
                          controller: notasActTxt,
                          autocorrect: false,
                          keyboardType: TextInputType.text,
                          minLines: 1,
                          maxLines: 4,
                          autofocus: false,
                          maxLength: 150,
                          textAlign: TextAlign.left,
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                          },
                          onChanged: (value) {
                            
                          },
                          onTapOutside: (event) {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                    
                    
                    ],
                  ),
                )
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Registro de salida'),
                          content: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Desea registrar la salida y cerrar la'
                                ' visita del cliente',
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                //context.pop();
                                Navigator.pop(context);
                                
                                //Navigator.of(context).pop();
                              },
                              child: Text(
                                'NO',
                                style: TextStyle(color: Colors.blue[200]),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Acción para solicitar revisión
                                Navigator.of(context).pop();
                                  
                                //detenerCronometro();
                                
                                
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Sí',
                                style: TextStyle(color: Colors.blue[200]),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  
                  },
                  child: const Text("Salida"),
                ),
                ElevatedButton(
                  onPressed: () {
                    iniciarCronometro();
                  },
                  child: const Text("Llegada"),
                ),
              ],
            );
          },
        );
      },
      backgroundColor: objColorsApp.celeste,
      foregroundColor: Colors.white,
      icon: Icons.call_outlined,
      label: 'Actividades',
    );
  }

}

Widget _buildAgendaItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.person),
          ),
          title: const Text('Randy Rudolph'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Text('RUC/C: 095011183001', style: TextStyle(fontSize: 12)),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'RUC/C:',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    TextSpan(
                      text: '095011183001',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              //Text('COD: 59345', style: TextStyle(fontSize: 12)),

              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'COD:',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    TextSpan(
                      text: '59345',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),


              const Text('Tipo de Agenda: Llamada', style: TextStyle(fontSize: 12)),
              const Text('Activo', style: TextStyle(fontSize: 12, color: Colors.green)),
            ],
          ),
          trailing: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('10:20 AM', style: TextStyle(fontWeight: FontWeight.bold)),
              Icon(Icons.phone, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }