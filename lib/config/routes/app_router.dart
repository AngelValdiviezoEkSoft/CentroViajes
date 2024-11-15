
import 'package:cvs_ec_app/ui/ui.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../infraestructure/infraestructure.dart';

final objRutas = Rutas();

final GoRouter appRouter = GoRouter(
  routes: [//
    GoRoute(
      path: objRutas.rutaDefault,
      builder: (context, state) => BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          /*
          if (state is AuthUnauthenticated) {
            return const WelcomeScreen();FrmRegistroClientesScreen
          }
          */
          
          return AuthScreen();//const ListaClientesScreen();
        },
      ),
    ),
    GoRoute(
      path: objRutas.rutaRegistroCliente,
      builder: (context, state) => FrmRegistroClientesScreen(),      
    ),
    GoRoute(
      path: objRutas.rutaListaClientes,
      builder: (context, state) => const ListaClientesScreen(),      
    ),
    GoRoute(
      path: objRutas.rutaReasignaCliente,
      builder: (context, state) => const ReasignaClienteScreen(),      
    ),
    GoRoute(
      path: objRutas.rutaPlanActCliente,
      builder: (context, state) => const PlanificacionActividadClienteScreen(),      
    ),
    GoRoute(
      path: objRutas.rutaHome,
      builder: (context, state) => HomeScreen(null, ''),      
    ),
    GoRoute(
      path: objRutas.rutaLstAct,
      builder: (context, state) => ListaActividades(),
    ),
    GoRoute(
      path: objRutas.rutaConexionInternet,
      builder: (context, state) => const ConexionInternetScreen(null),
    ),
    /*
    GoRoute(
      path: objRutas.rutaBienvenida,
      builder: (context, state) => FutureBuilder(
        builder: (context) {
          return WelcomeScreen();
        }
      ),      
    ),
    */
    GoRoute(
      path: objRutas.rutaBienvenida,
      builder: (context, state) => BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          
          return FutureBuilder(
            future: state.readToken(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if(!snapshot.hasData) {
                return const CargaScreen(null);
              } else {
                if(snapshot.data != '') {
                  if(snapshot.data == 'NI') {

                    return const ConexionInternetScreen(null);

                  }
                }
              }
              return WelcomeScreen();
            }
          );
        },
      ),
    ),
    GoRoute(
      path: objRutas.rutaAgenda,
      builder: (context, state) => AgendaScreen(),      
    ),
    GoRoute(
      path: objRutas.rutaPerfil,
      builder: (context, state) => PerfilScreen(),      
    ),
    GoRoute(
      path: objRutas.rutaRegistroPrsp,
      builder: (context, state) => const FrmRegistroProspectoScreen(),      
    ),
    GoRoute(
      path: objRutas.rutaPlanificacionActividades,
      builder: (context, state) => PlanificacionActividades(),      
    ),
    GoRoute(
      path: objRutas.rutaEditarPerfil,
      builder: (context, state) {

        final planAct = BlocProvider.of<GenericBloc>(context);
        planAct.setHeightModalPlanAct(0.11);

        return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthService(),
            lazy: false,
          ),
        ],
        child: const FrmEditPerfilScreen(),
        );        
      },

      //
    ),
    GoRoute(
      path: objRutas.rutaConstruccion,
      builder: (context, state) => const EnConstruccionScreen(),      
    ),
    GoRoute(
      path: objRutas.rutaCheckAuth,
      builder: (context, state) => const CheckAuthScreen(),      
    ),
  ],
  initialLocation: objRutas.rutaBienvenida,
);
//