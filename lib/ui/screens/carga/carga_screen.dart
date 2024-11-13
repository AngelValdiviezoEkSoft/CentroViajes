import 'package:cvs_ec_app/ui/ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class CargaScreen extends StatelessWidget {
  
  const CargaScreen(Key? key) : super (key: key);
  
  @override
  Widget build(BuildContext context) {

    return Center(
      child: FrmCargaScreen(),
    );
  }
}

//ignore: must_be_immutable
class FrmCargaScreen extends StatelessWidget {

  int varPosicionMostrar = 0;
  //List<NotificacionesModels> varLstNotificaciones = [];

  FrmCargaScreen({Key? key}) : super (key: key);

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context,state) { 
              return Scaffold(
                backgroundColor: Colors.white,
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    body: Image.asset(
                      "assets/gifs/gif_carga.gif",
                      height: 150.0,
                      width: 150.0,
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
