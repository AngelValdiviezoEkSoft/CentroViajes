import 'package:cvs_ec_app/config/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CentroViajesApp extends StatelessWidget {
  const CentroViajesApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    return MaterialApp.router(
        title: 'Centro de viajes',
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
      );
  }
}
