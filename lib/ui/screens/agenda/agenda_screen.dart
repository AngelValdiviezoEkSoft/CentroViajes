import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cvs_ec_app/domain/domain.dart';
import 'package:cvs_ec_app/infraestructure/infraestructure.dart';
import 'package:cvs_ec_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

List<DateTime> _dates = [];
String terminoBusquedaActAgenda = '';
DateTime selectedDayGen = DateTime.now();
DateTime focusedDayGen = DateTime.now();
//int tabAccionesCal = 0;
List<bool> isSelected = [false,true ]; // 'Mes' está seleccionado inicialmente
bool actualizaListaActAgenda = false;
List<DatumActivitiesResponse> actividadesFilAgenda = [];
int contLstAgenda = 0;

class AgendaScreen extends StatefulWidget {
  
  const AgendaScreen(Key? key) : super(key: key);

  @override
  State<AgendaScreen> createState() => AgendaScreenState();

}


class AgendaScreenState extends State<AgendaScreen>  {

  @override
  void initState() {
    super.initState();
    terminoBusquedaActAgenda = '';
    actualizaListaActAgenda = false;
    _dates = [];
    actividadesFilAgenda = [];
    contLstAgenda = 0;
    isSelected = [false,true ];
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    CalendarFormat calendarFormat = CalendarFormat.week;
    ColorsApp objColorsApp = ColorsApp();
    ScrollController scrollListaClt = ScrollController();

    return FutureBuilder(
      future: ActivitiesService().getActivitiesByFecha(DateFormat('yyyy-MM-dd', 'es').format(DateTime.now())),//),
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
        
      if(snapshot.hasData && snapshot.data != null) {

        ActivitiesResponseModel rspAct = snapshot.data as ActivitiesResponseModel;

        if(!actualizaListaActAgenda)
        {
          contLstAgenda = rspAct.length;
          actividadesFilAgenda = rspAct.data;
        }

        Future<void> refreshDataByFiltro(String filtro) async {            
          actividadesFilAgenda = [];

          //CrmLead apiResponse = CrmLead.fromJson(objMemoria);

          if(terminoBusquedaActAgenda.isNotEmpty){
            
            actividadesFilAgenda = rspAct.data
            .where(
              (producto) => producto.activityTypeId.name.toLowerCase().contains(terminoBusquedaActAgenda.toLowerCase()))
            .toList();

            contLstAgenda = 0;

            contLstAgenda = actividadesFilAgenda.length;
          } else{
            actividadesFilAgenda = rspAct.data;
            actualizaListaActAgenda = false;
          }            

          if(terminoBusquedaActAgenda.isNotEmpty && actualizaListaActAgenda) {
            setState(() {});
          }

        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("Agenda"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                context.pop();
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  // Acción del botón de refrescar
                },
              ),
            ],
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: Colors.black,
          ),
          body: Container(
            width: size.width * 0.99,
            height: size.height,
            color: Colors.transparent,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Selector de Mes o Semana
                  /*
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            buildToggleButton("Mes", false),
                            buildToggleButton("Semana", true),
                          ],
                        ),
                        Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                  */
                  
                  SizedBox(height:  size.height * 0.02,),
        
                  ToggleButtons(
                borderColor: Colors.purple,
                fillColor: Colors.purple,
                borderWidth: 2,
                selectedBorderColor: Colors.purple,
                selectedColor: Colors.white,
                borderRadius: BorderRadius.circular(20),
                onPressed: (int index) {
                  setState(() {
                    for (int i = 0; i < isSelected.length; i++) {
                      isSelected[i] = i == index;
                    }
                  });
                },
                isSelected: isSelected,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      'Mes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected[0] ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      'Semana',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected[1] ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
                
              ),
                  
                  if(isSelected[1])
                  Container(
                    width: size.width *0.95,
                    height: size.height * 0.2,
                    color: Colors.transparent,
                    child: TableCalendar(     
                      calendarFormat: calendarFormat,
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.now(),
                      focusedDay: focusedDayGen,
                      selectedDayPredicate: (day) {
                        return focusedDayGen == day;
                      },
                      onDaySelected: (selectedDay, focusedDay) async {
                        
                        _dates = [];
                        _dates.add(selectedDay);

                        ActivitiesResponseModel objRsp = await ActivitiesService().getActivitiesByRangoFechas(_dates, objDatumCrmLead?.id ?? 0);

                        actividadesFilAgenda = [];
                        actividadesFilAgenda = objRsp.data;

                        setState(() {                                                    
                          rspAct = objRsp;
                          actualizaListaActAgenda = true;
                          contLstAgenda = actividadesFilAgenda.length;

                          selectedDayGen = selectedDay;
                          focusedDayGen = focusedDay; // update `focusedDayGen` here as well
                        });
                      }
                    )
                  ),
                  
                  if(isSelected[0])
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

                        actividadesFilAgenda = [];
                        actividadesFilAgenda = objRsp.data;

                        setState(() {
                          rspAct = objRsp;
                          actualizaListaActAgenda = true;
                          contLstAgenda = actividadesFilAgenda.length;
                        });
                      }
                    )                          
                  ),
                  /*
                  Container(
                    width: size.width *0.95,
                    height: size.height * 0.39,
                    color: Colors.transparent,
                    child: TableCalendar(     
                      //calendarFormat: calendarFormat,
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.now(),
                      focusedDay: focusedDayGen,
                      selectedDayPredicate: (day) {
                        return focusedDayGen == day;
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          selectedDayGen = selectedDay;
                          focusedDayGen = focusedDay; // update `focusedDayGen` here as well
                        });
                      }
                    )
                  ),
                  */
                  
                  SizedBox(height: size.height * 0.008),

                  if(contLstAgenda > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      onChanged: (value) {
                        actualizaListaActAgenda = true;
                        terminoBusquedaActAgenda = value;
                        refreshDataByFiltro(value);
                      },
                      decoration: InputDecoration(
                        labelText: 'Buscar agendas por código, nombre, RUC...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),

                  //if(contLstAgenda > 0)
                  SizedBox(height: size.height * 0.007),

                  if(contLstAgenda > 0)
                  Container(
                    color: Colors.transparent,
                    width: size.width,
                    height: size.height * 0.55,
                    child: ListView.builder(
                      controller: scrollListaClt,
                      itemCount: contLstAgenda,
                      itemBuilder: ( _, int index ) {

                        return Slidable(
                          //key: ValueKey(lstActividades[index].id),
                          startActionPane: ActionPane(
                            motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (cont) async {
                                    const storage = FlutterSecureStorage();
                                      
                                    await storage.write(key: 'idMem', value: actividadesFilAgenda[index].resId.toString());
                                    
                                    //ignore: use_build_context_synchronously
                                    context.push(objRutasGen.rutaPlanificacionActividades);
                                    
                                    /*
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
                                                                          child: const AutoSizeText(
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
                                  */
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
                                title: Text(actividadesFilAgenda[index].activityTypeId.name),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    
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
                                            text: DateFormat('yyyy-MM-dd', 'es').format(actividadesFilAgenda[index].dateDeadline),
                                            style: const TextStyle(
                                              color: Colors.blue,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  
                                    //Text(actividadesFilAgenda[index]., style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                            ),
                          )
                        );
                      
                      },
                    ),
                  ),

                  if(contLstAgenda == 0)
                  Container(
                    width: size.width,
                    height: size.height,
                    color: Colors.transparent,
                    /*
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/upsSolicitudes.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Colors.transparent
                    ),
                    */
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(height: size.height * 0.58,),
                        Container(
                          color: Colors.transparent,
                          width: size.width * 0.95,
                          height: size.height * 0.09,
                          alignment: Alignment.center,
                          child: AutoSizeText('¡HEY!', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'AristotelicaDisplayDemiBoldTrial',color: objColorsApp.naranjaIntenso,), maxLines: 1,  presetFontSizes: const [58,56,54,52,50,48,46,44,42,40,38,36,34,32,30,28,26,24,22,20,18,16,14,12,10]),
                        ),
                        Container(
                          color: Colors.transparent,
                          width: size.width * 0.95,
                          height: size.height * 0.09,
                          alignment: Alignment.topCenter,
                          child: const AutoSizeText('No existen actividades agendadas para la fecha actual', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,), maxLines: 2,  presetFontSizes: [42,40,38,36,34,32,30,28,26,24,22,20,18,16,14,12,10]),
                        ),
                      ],
                    ), 
                  )

                  /*
                  // Lista de agendas
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
              
                ],
              ),
            ),
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

  // Widget para los botones de Mes/Semana
  Widget buildToggleButton(String text, bool isSelected) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          /*
          primary: isSelected ? Colors.blue : Colors.grey[200],
          onPrimary: isSelected ? Colors.white : Colors.black,
          */
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  // Widget para cada elemento de la agenda
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
}
