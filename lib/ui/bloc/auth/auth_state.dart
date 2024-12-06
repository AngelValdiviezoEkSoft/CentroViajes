part of 'auth_bloc.dart';

/*
sealed class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}
*/


abstract class AuthState extends Equatable {
  
  final storage = const FlutterSecureStorage();

  @override
  List<Object> get props => [];
  
  Future<String> readToken() async {
    try {
      String rspFinal = 'home';
/*
      var connectivityResult = await (Connectivity().checkConnectivity());

      var tienePendienteRegistros = await storage.read(key: 'TienePendienteRegistros') ?? '';
    
      if (tienePendienteRegistros == 'S' && !connectivityResult.contains(ConnectivityResult.mobile) && !connectivityResult.contains(ConnectivityResult.wifi)) {
        return 'NI';
      }
      */

      var rspReg = await storage.read(key: 'RespuestaRegistro') ?? '';
      var rspLog = await storage.read(key: 'RespuestaLogin') ?? '';

      if(rspReg.isEmpty && rspLog.isEmpty){
        rspFinal = '';
      }
      else {
        if(rspLog.isEmpty){
          rspFinal = 'log';
        }        
      }

      await DataInicialService().readCombosProspectos();

      return rspFinal; 
    }
    catch(ex) {
      return '';
    }
    
  }

}

class AuthInitial extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthNoInternet extends AuthState {}

class AuthGpsFake extends AuthState {}

class ValidLicenseKey extends AuthState {}

class InvalidLicenseKey extends AuthState {}

class PinCompleted extends AuthState {}

class PinSubmitted extends AuthState {}

class InvalidPin extends AuthState {}

class ValidPin extends AuthState {}

class AuthRegistered extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);

  @override
  List<Object> get props => [message];
}


