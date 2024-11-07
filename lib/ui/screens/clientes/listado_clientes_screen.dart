
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
            future: ClienteService().getClientesByVendedor(),
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

                List<ClientModelResponse> lstCLientes = snapshot.data as List<ClientModelResponse>;

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
                          itemCount: lstCLientes.length,//carrito.detalles.length,
                          itemBuilder: ( _, int index ) {
                            return Slidable(
                              key: ValueKey(lstCLientes[index].id),
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
                                  height: size.height * 0.13,
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
                                        height: size.height * 0.15,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                    color: Colors.transparent,
                                                    width: size.width * 0.45,
                                                    height: size.height * 0.025,
                                                    child: AutoSizeText(
                                                          '${lstCLientes[index].primerNombre} ${lstCLientes[index].primerApellido}',
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
                                              width: size.width * 0.45,
                                              height: size.height * 0.025,
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    const TextSpan(
                                                      text: 'RUC/CI: ',
                                                      style: TextStyle(color: Colors.black)
                                                    ),
                                                    TextSpan(
                                                      text: lstCLientes[index].numIdentificacion,
                                                      style: TextStyle(color: Colors.blue)
                                                    ),
                                                  ]
                                                ),
                                              )
                                          
                                            ),
                                            Container(
                                                color: Colors.transparent,
                                                width: size.width * 0.45,
                                                height: size.height * 0.025,
                                                child: 
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                        text: 'COD: ',
                                                        style: TextStyle(color: Colors.black)
                                                      ),
                                                      TextSpan(
                                                        text: lstCLientes[index].codigoCli,
                                                        style: const TextStyle(color: Colors.blue)
                                                      ),
                                                    ]
                                                  ),
                                                )
                                            ),
                                            Container(
                                                color: Colors.transparent,
                                                width: size.width * 0.45,
                                                height: size.height * 0.025,
                                                child: AutoSizeText(
                                                      lstCLientes[index].estado,
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
                                        height: size.height * 0.11,
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
                  child: Image.asset('assets/loadingEnrolApp.gif'),
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
            /*
              showModalBottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(size.width * 0.06),
                ),
                isScrollControlled: true,
                context: context,
                builder: (BuildContext bc) {
                  return Container(
                    color: Colors.transparent,
                    width: size.width,
                    height: size.height * 0.9,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          
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
                          Container(
                            color: Colors.transparent,
                            width: size.width * 0.95, //- 100,
                            height: size.height * 0.045, //40,
                            alignment: Alignment.centerLeft,
                            child: const AutoSizeText(
                              'Registre nuevo prospecto',  
                              presetFontSizes: [30,28,26,24,22,20,18,16,14,12,10],                          
                            ),
                          ),
                          Container(
                            color: const Color(0xffF6F6F6),
                            width: size.width,
                            height: size.height * 0.85,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Container(
                                  color: Colors.transparent,
                                  width: size.width * 0.92,
                                  child: TextFormField(
                                    cursorColor: AppLightColors().primary,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    inputFormatters: [
                                      //FilteringTextInputFormatter.deny(regexToRemoveEmoji)
                                    ],
                                    style: AppTextStyles.bodyRegular(width: size.width),
                                    decoration: InputDecorationCvs.formsDecoration(
                                      labelText: 'Teléfono',
                                      hintTetx: 'Ej: 09xxxxxxxx',
                                      size: size,
                                      prefixIcon: const Icon(Icons.search, color: Colors.blue,)
                                      //prefixText: 'Tst'
                                    ),                                  
                                    //controller: emailAkiTxt,
                                    autocorrect: false,
                                    keyboardType: TextInputType.text,
                                    minLines: 1,
                                    maxLines: 2,
                                    autofocus: false,
                                    maxLength: 10,
                                    textAlign: TextAlign.left,
                                    onEditingComplete: () {
                                      FocusScope.of(context).unfocus();
                                      //FocusScope.of(context).requestFocus(numTelfAfilAkiNode);
                                    },
                                    onChanged: (value) {
                                      
                                    },
                                    onTapOutside: (event) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    validator: (value) {
                                      /*
                                      String pattern = regularExp.regexToEmail;
                                      RegExp regExp = RegExp(pattern);
                                      return regExp.hasMatch(value ?? '')
                                          ? null
                                          : '¡El valor ingresado no luce como un correo!';
                                          */
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Container(
                                  color: Colors.transparent,
                                  width: size.width * 0.92,
                                  child: TextFormField(
                                    initialValue: 'Mario Piguave',
                                    //initialValue: '',
                                    cursorColor: AppLightColors().primary,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    inputFormatters: [
                                      //FilteringTextInputFormatter.deny(regexToRemoveEmoji)
                                    ],
                                    style: AppTextStyles.bodyRegular(width: size.width),
                                    decoration: InputDecorationCvs.formsDecoration(
                                      labelText: 'Nombres',
                                      hintTetx: 'Ej: Juan Valdez',
                                      size: size
                                    ),
                                    enabled: false,
                                    //controller: emailAkiTxt,
                                    autocorrect: false,
                                    keyboardType: TextInputType.text,
                                    minLines: 1,
                                    maxLines: 2,
                                    autofocus: false,
                                    maxLength: 50,
                                    textAlign: TextAlign.left,
                                    onEditingComplete: () {
                                      FocusScope.of(context).unfocus();
                                      //FocusScope.of(context).requestFocus(numTelfAfilAkiNode);
                                    },
                                    onChanged: (value) {
                                      
                                    },
                                    onTapOutside: (event) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    validator: (value) {
                                      /*
                                      String pattern = regularExp.regexToEmail;
                                      RegExp regExp = RegExp(pattern);
                                      return regExp.hasMatch(value ?? '')
                                          ? null
                                          : '¡El valor ingresado no luce como un correo!';
                                          */
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Container(
                                  color: Colors.transparent,
                                  width: size.width * 0.92,
                                  child: TextFormField(
                                    initialValue: 'Terreno',
                                    //initialValue: '',
                                    enabled: false,
                                    cursorColor: AppLightColors().primary,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    inputFormatters: [
                                      //FilteringTextInputFormatter.deny(regexToRemoveEmoji)
                                    ],
                                    style: AppTextStyles.bodyRegular(width: size.width),
                                    decoration: InputDecorationCvs.formsDecoration(
                                      labelText: 'Producto de interés',
                                      hintTetx: 'Ej: Terreno',
                                      size: size
                                    ),
                                    //controller: emailAkiTxt,
                                    autocorrect: false,
                                    keyboardType: TextInputType.text,
                                    minLines: 1,
                                    maxLines: 2,
                                    autofocus: false,
                                    maxLength: 50,
                                    textAlign: TextAlign.left,
                                    onEditingComplete: () {
                                      FocusScope.of(context).unfocus();
                                      //FocusScope.of(context).requestFocus(numTelfAfilAkiNode);
                                    },
                                    onChanged: (value) {
                                      
                                    },
                                    onTapOutside: (event) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    validator: (value) {
                                      /*
                                      String pattern = regularExp.regexToEmail;
                                      RegExp regExp = RegExp(pattern);
                                      return regExp.hasMatch(value ?? '')
                                          ? null
                                          : '¡El valor ingresado no luce como un correo!';
                                          */
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Container(
                                  color: Colors.transparent,
                                  width: size.width * 0.92,
                                  child: TextFormField(
                                    initialValue: 'Ecuador',
                                    //initialValue: '',
                                    enabled: false,
                                    cursorColor: AppLightColors().primary,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    inputFormatters: [
                                      //FilteringTextInputFormatter.deny(regexToRemoveEmoji)
                                    ],
                                    style: AppTextStyles.bodyRegular(width: size.width),
                                    decoration: InputDecorationCvs.formsDecoration(
                                      labelText: 'País',
                                      hintTetx: 'Ej: Ecuador',
                                      size: size
                                    ),
                                    //controller: emailAkiTxt,
                                    autocorrect: false,
                                    keyboardType: TextInputType.text,
                                    minLines: 1,
                                    maxLines: 2,
                                    autofocus: false,
                                    maxLength: 50,
                                    textAlign: TextAlign.left,
                                    onEditingComplete: () {
                                      FocusScope.of(context).unfocus();
                                      //FocusScope.of(context).requestFocus(numTelfAfilAkiNode);
                                    },
                                    onChanged: (value) {
                                      
                                    },
                                    onTapOutside: (event) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    validator: (value) {
                                      /*
                                      String pattern = regularExp.regexToEmail;
                                      RegExp regExp = RegExp(pattern);
                                      return regExp.hasMatch(value ?? '')
                                          ? null
                                          : '¡El valor ingresado no luce como un correo!';
                                          */
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: size.height * 0.02,
                                ),
                                Container(
                                  color: Colors.transparent,
                                  width: size.width * 0.92,
                                  child: TextFormField(
                                    initialValue: 'Guayaquil',
                                    //initialValue: '',
                                    enabled: false,
                                    cursorColor: AppLightColors().primary,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    inputFormatters: [
                                      //FilteringTextInputFormatter.deny(regexToRemoveEmoji)
                                    ],
                                    style: AppTextStyles.bodyRegular(width: size.width),
                                    decoration: InputDecorationCvs.formsDecoration(
                                      labelText: 'Ciudad',
                                      hintTetx: 'Ej: Guayaquil',
                                      size: size
                                    ),
                                    //controller: emailAkiTxt,
                                    autocorrect: false,
                                    keyboardType: TextInputType.text,
                                    minLines: 1,
                                    maxLines: 2,
                                    autofocus: false,
                                    maxLength: 50,
                                    textAlign: TextAlign.left,
                                    onEditingComplete: () {
                                      FocusScope.of(context).unfocus();
                                      //FocusScope.of(context).requestFocus(numTelfAfilAkiNode);
                                    },
                                    onChanged: (value) {
                                      
                                    },
                                    onTapOutside: (event) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    validator: (value) {
                                      /*
                                      String pattern = regularExp.regexToEmail;
                                      RegExp regExp = RegExp(pattern);
                                      return regExp.hasMatch(value ?? '')
                                          ? null
                                          : '¡El valor ingresado no luce como un correo!';
                                          */
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: size.height * 0.03,
                                ),
                                Container(
                                  color: Colors.transparent,
                                  width: size.width * 0.92,
                                  child: TextFormField(
                                    initialValue: 'Norte',
                                    //initialValue: '',
                                    enabled: false,
                                    cursorColor: AppLightColors().primary,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    inputFormatters: [
                                      //FilteringTextInputFormatter.deny(regexToRemoveEmoji)
                                    ],
                                    style: AppTextStyles.bodyRegular(width: size.width),
                                    decoration: InputDecorationCvs.formsDecoration(
                                      labelText: 'Sector',
                                      hintTetx: 'Ej: Norte',
                                      size: size
                                    ),
                                    //controller: emailAkiTxt,
                                    autocorrect: false,
                                    keyboardType: TextInputType.text,
                                    minLines: 1,
                                    maxLines: 2,
                                    autofocus: false,
                                    maxLength: 50,
                                    textAlign: TextAlign.left,
                                    onEditingComplete: () {
                                      FocusScope.of(context).unfocus();
                                      //FocusScope.of(context).requestFocus(numTelfAfilAkiNode);
                                    },
                                    onChanged: (value) {
                                      
                                    },
                                    onTapOutside: (event) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    validator: (value) {
                                      /*
                                      String pattern = regularExp.regexToEmail;
                                      RegExp regExp = RegExp(pattern);
                                      return regExp.hasMatch(value ?? '')
                                          ? null
                                          : '¡El valor ingresado no luce como un correo!';
                                          */
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: size.height * 0.03,
                                ),
                                Container(
                                  color: Colors.transparent,
                                  width: size.width * 0.92,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Asignado', style: TextStyle(fontSize: 20),),
                                      Icon(Icons.check_box_outlined),
                                      //Icon(Icons.check_box_outline_blank_sharp),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: size.height * 0.03,
                                ),
                                Container(
                                  color: Colors.transparent,
                                  width: size.width * 0.92,
                                  child: TextFormField(
                                    initialValue: 'Yordani Oliva',
                                    //initialValue: '',
                                    enabled: false,
                                    cursorColor: AppLightColors().primary,
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    inputFormatters: [
                                      //FilteringTextInputFormatter.deny(regexToRemoveEmoji)
                                    ],
                                    style: AppTextStyles.bodyRegular(width: size.width),
                                    decoration: InputDecorationCvs.formsDecoration(
                                      labelText: 'Asesor Asignado',
                                      hintTetx: '',
                                      size: size
                                    ),
                                    //controller: emailAkiTxt,
                                    autocorrect: false,
                                    keyboardType: TextInputType.text,
                                    minLines: 1,
                                    maxLines: 2,
                                    autofocus: false,
                                    maxLength: 50,
                                    textAlign: TextAlign.left,
                                    onEditingComplete: () {
                                      FocusScope.of(context).unfocus();
                                      //FocusScope.of(context).requestFocus(numTelfAfilAkiNode);
                                    },
                                    onChanged: (value) {
                                      
                                    },
                                    onTapOutside: (event) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    validator: (value) {
                                      /*
                                      String pattern = regularExp.regexToEmail;
                                      RegExp regExp = RegExp(pattern);
                                      return regExp.hasMatch(value ?? '')
                                          ? null
                                          : '¡El valor ingresado no luce como un correo!';
                                          */
                                    },
                                  ),
                                ),
                                
                                SizedBox(
                                  height: size.height * 0.03,
                                ),
                                Container(
                                  color: Colors.transparent,
                                  width: size.width * 0.95,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: size.width * 0.45,
                                        color: Colors.transparent,
                                        child: GestureDetector(
                                        onTap: () async {
                                          //context.push(Rutas().rutaHome);
                                          context.pop();
                                        },
                                        child: ButtonCvsWidget(
                                          text: 'Cerrar',
                                          textStyle: AppTextStyles.h3Bold(
                                              width: size.width,
                                              color: AppLightColors().white),
                                        )),
                                      ),
                                      Container(
                                        width: size.width * 0.45,
                                        color: Colors.transparent,
                                        child: GestureDetector(
                                        onTap: () async {
                                          //context.push(Rutas().rutaHome);
                                          Fluttertoast.showToast(
                                                msg: 'Solicitud enviada correctamente',
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.TOP,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.green,
                                                textColor: Colors.white,
                                                fontSize: 16.0
                                              );
                                        },
                                        child: ButtonCvsWidget(
                                          //text: 'Crear',
                                          text: 'Solicitar Revisión',
                                          textStyle: AppTextStyles.h3Bold(
                                              width: size.width,
                                              color: AppLightColors().white),
                                        )),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  );
                });
          */
          },          
          backgroundColor: Color.fromRGBO(75, 57, 239, 1.0), // Color del botón
          child: Icon(Icons.person_add_alt, color: Colors.white,), // Icono dentro del botón
        ),
        
    );
  }
}

void doNothing(BuildContext context) {}