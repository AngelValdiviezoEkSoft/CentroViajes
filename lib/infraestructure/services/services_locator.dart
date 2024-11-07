import 'package:get_it/get_it.dart';
import 'package:cvs_ec_app/infraestructure/infraestructure.dart';
import 'package:cvs_ec_app/ui/ui.dart';

final GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  //#Region Servicios 
  getIt.registerLazySingleton<LocalidadService>(() => LocalidadService());
  getIt.registerLazySingleton<ProspectoTypeService>(() => ProspectoTypeService());
  //#EndRegion

  //#Region Blocs 
  getIt.registerLazySingleton(() => VerificacionBloc());
  getIt.registerLazySingleton(() => GenericBloc());
  getIt.registerLazySingleton(() => AuthBloc());
  getIt.registerLazySingleton(() => SuscripcionBloc());
  //#EndRegion
}
