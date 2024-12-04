
import 'package:animate_do/animate_do.dart';
import 'package:cvs_ec_app/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnableGpsMessage extends StatelessWidget {
  
  const EnableGpsMessage(Key? key) : super (key: key);    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //Se deshabilita para la suscripción
          
          const Positioned(
            top: 88,
            left: 20,
            child: BtnBackEnableGps()
          ),
          
          Center(
          child: BlocBuilder<GpsBloc, GpsState>(
            builder: (context, state) {
      
              return !state.isGpsEnabled ?
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  Text('Debe de habilitar el GPS',style: TextStyle( fontSize: 25, fontWeight: FontWeight.w300 ),),
                  
                ],
              )
              :  
              Container();
            }
          ),
        ),
        ]
      ),
    
    );
  }
}


class BtnBackEnableGps extends StatelessWidget {
  //ProspectoType? objProspectoGps;
  const BtnBackEnableGps({
    Key? key,
    //objProspectoGps
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      duration: const Duration( milliseconds: 300 ),
      child: CircleAvatar(
        maxRadius: 30,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: const Icon( Icons.arrow_back_ios_new, color: Colors.black ),
          onPressed: () async {
            final gpsBloc = BlocProvider.of<GpsBloc>(context);
            /* //Para cuando se quiera hacer uso del mapa como en uber
            BlocProvider.of<SearchBloc>(context).add(
              OnDeactivateManualMarkerEvent()
            );
            */
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("coordenadasIngreso",'');
            gpsBloc.vuelvePantallaFrm(false,false,false);
          },
        ),
      ),
    );
  }
}
