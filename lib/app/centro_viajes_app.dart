import 'package:cvs_ec_app/config/routes/routes.dart';
import 'package:cvs_ec_app/ui/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cron/cron.dart';

class CentroViajesApp extends StatefulWidget {
  @override
  _CentroViajesAppState createState() => _CentroViajesAppState();
}

class _CentroViajesAppState extends State<CentroViajesApp> {
  final TokenManager tokenManager = TokenManager();
  final cron = Cron();

  @override
  void initState() {
    super.initState();
/*
    const imeiMovile = MethodChannel('com.ekuasoft.cvs_ec_app/imei');
    final String? imei = await imeiMovile.invokeMethod('getImei');
    */

    // Configura una tarea que se ejecuta cada minuto.
    cron.schedule(Schedule.parse('*/6 * * * * *'), () {
      setState(() {
        //tokenManager.startTokenCheck(imei!);
        tokenManager.startTokenCheck();
      });
    });
  }

  @override
  void dispose() {
    cron.close();
    tokenManager.stopTokenCheck();
    super.dispose();
  }

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

/*
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
*/