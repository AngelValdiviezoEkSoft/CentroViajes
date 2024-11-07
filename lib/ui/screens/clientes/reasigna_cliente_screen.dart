
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cvs_ec_app/domain/domain.dart';
import 'package:cvs_ec_app/infraestructure/infraestructure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
//import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cvs_ec_app/ui/ui.dart';

ClientModelResponse? _selectVendedorGen;
late TextEditingController motivoTxt;

class ReasignaClienteScreen extends StatefulWidget {
  const ReasignaClienteScreen({super.key});

  @override
  State<ReasignaClienteScreen> createState() => _ReasignaClienteScreenState();
}

//class MarcacionScreen extends StatelessWidget {
class _ReasignaClienteScreenState extends State<ReasignaClienteScreen> {

  
  final LocalAuthentication auth = LocalAuthentication();
  //_SupportState _supportState = _SupportState.unknown;
  
  @override
  void initState() {
    super.initState();
    motivoTxt = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {

    ClientModelResponse? _selectVendedor;
    ColorsApp objColorsApp = ColorsApp();

    ScrollController scrollListaClt = ScrollController();

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocBuilder<GenericBloc, GenericState>(
        builder: (context,state) {

          return FutureBuilder(
            future: ClienteService().getVendedores(),
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

                //_selectVendedor = lstCLientes.first;

                return Scaffold(
                  appBar: EcvAppBarWidget(
                  'Reasignación de vendedor',//AppLocalizations.of(context)!.iniciarSesion,
                  oColorLetra: AppLightColors().gray800SecondaryText,
                  onPressed: () {
                    context.pop();
                  },
                  backgorundAppBarColor: AppLightColors().gray100Background,
                ),
                  body: SingleChildScrollView(
                    child: SafeArea(
                      child: Padding(
            padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                                    
                                    
                            SizedBox(height: size.height * 0.025,),
  /*                                          
                            Container(
                              color: Colors.transparent,
                              width: size.width * 0.91,
                              height: size.height * 0.025,
                              //alignment: Alignment.center,
                              child:  DropdownButton<ClientModelResponse?>(
                              hint: const Text('Selecciona un vendedor'),
                              
                              items: lstCLientes.map
                                <DropdownMenuItem<ClientModelResponse?>>(
                                (ClientModelResponse? item) {
                                return DropdownMenuItem<ClientModelResponse?>(
                                  value: item,
                                  child: Text('${item?.primerNombre} ${item?.primerApellido}'),
                                );
                              }).toList(),

                              value: _selectVendedor, //?? lstCLientes.first,
                              onChanged: (ClientModelResponse? newValue) {
                                
                                setState(() {
                                  _selectVendedor = newValue;
                                });
                              },
                            
                            ),
                            ),
*/
                            Container(
                              color: Colors.transparent,
                              width: size.width * 0.91,
                              height: size.height * 0.075,
                              child: DropdownButton<ClientModelResponse>(
                                hint: const Text('Selecciona un vendedor'),
                                value: _selectVendedor,
                                items: lstCLientes.map((ClientModelResponse item) {
                                  return DropdownMenuItem<ClientModelResponse>(
                                    value: item,
                                    child: Text('${item.primerNombre} ${item.primerApellido}'),
                                  );
                                }).toList(),
                                onChanged: (ClientModelResponse? newValue) {
                                  setState(() {
                                    _selectVendedor = newValue; // Actualiza el cliente seleccionado
                                    _selectVendedorGen = _selectVendedor;
                                    print(newValue?.primerNombre);
                                  });
                                },
                              ),
                            ),
                                            
                            SizedBox(
                              height: size.height * 0.01,
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
                                  labelText: 'Motivo',
                                  hintTetx: 'Ej: Solicitado por el cliente',
                                  size: size
                                ),
                                //controller: emailAkiTxt,
                                autocorrect: false,
                                keyboardType: TextInputType.text,
                                minLines: 2,
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
                              height: size.height * 0.05,
                            ),
                                          
                            
                            Container(
                              color: Colors.transparent,
                              width: size.width * 0.9,
                              child: GestureDetector(
                                  onTap: () async {
                                    Fluttertoast.showToast(
                                                msg: 'Cliente reasignado',
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.TOP,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.green,
                                                textColor: Colors.white,
                                                fontSize: 16.0
                                              );
                                    //context.push(Rutas().rutaListaClientes);
                                    context.pop();
                                  },
                                  child: ButtonCvsWidget(
                                    text: 'Guardar',
                                        //AppLocalizations.of(context)!.iniciarSesion,
                                    textStyle: AppTextStyles.h3Bold(
                                        width: size.width,
                                        color: AppLightColors().white),
                                  )),
                            ),
                                          
                              SizedBox(height: size.height * 0.05,),
                                    
                          ],
                        ),
                      ),
                    ),
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
    );
  }
}
