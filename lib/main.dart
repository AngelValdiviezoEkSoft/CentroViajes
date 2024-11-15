import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cvs_ec_app/app/app.dart';
import 'package:cvs_ec_app/infraestructure/infraestructure.dart';
import 'package:cvs_ec_app/ui/ui.dart';

void main() {

  setupServiceLocator();

  /*
  Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    if (result == ConnectivityResult.mobile) {
      print("Conectado a una red móvil.");
    } else if (result == ConnectivityResult.wifi) {
      print("Conectado a una red Wi-Fi.");
    } else {
      print("Sin conexión a internet.");
    }
  });
  */

  runApp( 
    MultiBlocProvider(
      providers: [//asd
      
        BlocProvider(create: (context) => getIt<AuthBloc>()..add(AppStarted())),
        BlocProvider(create: (context) => getIt<VerificacionBloc>()),
        BlocProvider(create: (context) => getIt<GenericBloc>()),
        BlocProvider(create: (context) => getIt<SuscripcionBloc>()),

      ],
      child: ProviderScope(child: CentroViajesApp()),
    )
  );
}