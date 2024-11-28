import 'package:cvs_ec_app/ui/bloc/bloc.dart';
import 'package:cvs_ec_app/ui/screens/screens.dart';
import 'package:cvs_ec_app/ui/theme/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import 'package:one_clock/one_clock.dart';

int tabAcciones = 0;

class PlanificacionActividades extends StatefulWidget {
  const PlanificacionActividades(Key? key) : super (key: key);
  @override
  State<PlanificacionActividades> createState() => PlanActState();
}

class PlanActState extends State<PlanificacionActividades> {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '- Usuario -',
          style: TextStyle(color: Colors.white),
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
                context.push(objRutasGen.rutaAgenda);
              },
              child: const Icon(
                Icons.calendar_month,
                color: Colors.white,
                size: 40,
              )),
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
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                      width: size.width * 0.95,
                      child: Text(
                        'Compra de terreno con plan de viaje',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      )),
                  SizedBox(height: 15),
                  Row(
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
                  SizedBox(height: 8),
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
            if (tabAcciones == 0) PlanAct(),
            if (tabAcciones == 1)
              // Información General
              sectionTitle(Icons.info, "Información General"),
            if (tabAcciones == 1) infoRow("Razón Social", "Randy Rudolph"),
            if (tabAcciones == 1)
              infoRow("Nombre Comercial", "[partner -> business_name]"),
            if (tabAcciones == 1) infoRow("Clasificación", "Randy Rudolph"),
            if (tabAcciones == 1) infoRow("Canal", "Randy Rudolph"),
            if (tabAcciones == 1) infoRow("Dirección", "Randy Rudolph"),
            if (tabAcciones == 1)
              // Territorio
              sectionTitle(Icons.place, "Territorio"),
            if (tabAcciones == 1) infoRow("Estado", "Activo"),
            if (tabAcciones == 1) infoRow("Ciudad", "Guayaquil"),
            if (tabAcciones == 1) infoRow("Cantón", "Tarquí"),
            if (tabAcciones == 1) infoRow("Región", "Costa"),
            if (tabAcciones == 1) infoRow("Lugar", "Norte"),
            if (tabAcciones == 1)
              // Precios y Ventas
              sectionTitle(Icons.monetization_on, "Precios y Ventas"),
            if (tabAcciones == 1) infoRow("Ingreso esperado", "\$5000.00"),
            if (tabAcciones == 1) infoRow("Probabilidad", "50%"),
          ],
        ),
      ),
    );
  }
}

Widget sectionTitle(IconData icon, String title) {
  return Container(
    padding: EdgeInsets.all(10.0),
    color: Colors.blue.shade900,
    width: double.infinity,
    child: Row(
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
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
          label + ":",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value),
      ],
    ),
  );
}

class PlanAct extends StatefulWidget {
  @override
  _PlanActState createState() => _PlanActState();
}

class _PlanActState extends State<PlanAct> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final planAct = BlocProvider.of<GenericBloc>(context);
/*
    final planAct = BlocProvider.of<GenericBloc>(context);
    planAct.setHeightModalPlanAct(0.57);
*/

        return Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.green[200],
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 8),
                      Text('Agendado para hoy', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
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
                                              Text(
                                                'Registrar actividad',
                                                style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                'En esta interfaz es posible registrar las actividades que serán realizadas con los prospectos/leads asignados',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[700]),
                                              ),
                                              SizedBox(height: 24),
                                              DropdownButtonFormField<String>(
                                                decoration: InputDecoration(
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
                                                  /*
                                                                          setState(() {
                                                          selectedActivityType = value;
                                                                          });
                                                                          */
                                                },
                                              ),
                                              SizedBox(height: 16),
                                              TextFormField(
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  labelText:
                                                      'Seleccione la fecha y hora...',
                                                  border: OutlineInputBorder(),
                                                  suffixIcon: Icon(
                                                      Icons.calendar_today),
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
                                                    /*
                                                          setState(() {
                                                            selectedDate = pickedDate;
                                                          });
                                                          */
                                                  }
                                                },
                                              ),
                                              const SizedBox(height: 16),
                                              TextFormField(
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
                                                    child: Text(
                                                      'Cerrar',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: Color(
                                                          0xFF5F2EEA), // Purple button
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      context.pop();
                                                      context.pop();
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'Actividad registrada correctamente',
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity:
                                                              ToastGravity.TOP,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor:
                                                              Colors.green,
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 16.0);
                                                    },
                                                    child: Text(
                                                      'Crear Actividad',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: const Color(
                                                          0xFF5F2EEA), // Purple button
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
                        icon: Icon(Icons.login),
                        label: Text('Llegada'),
                        //style: ElevatedButton.styleFrom(primary: Color(0xFF5F2EEA)),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Registro de salida'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Desea registrar la salida y cerrar la'
                                      'visita del cliente',
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
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
                        icon: Icon(Icons.logout),
                        label: Text('Salida'),
                        //style: ElevatedButton.styleFrom(primary: Color(0xFF5F2EEA)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Container(
              width: size.width * 0.99,
              color: Colors.transparent,
              child: Center(
                child: DigitalClock.light(
                  textScaleFactor: 2.5,
                  datetime: DateTime.now(),
                  isLive: true,
                  digitalClockTextColor: Color(0xFF5F2EEA),
                  //decoration: BoxDecoration(),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Notas',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Notas de la visita o llamada para registrar la acción realizada.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        );
  }
}
