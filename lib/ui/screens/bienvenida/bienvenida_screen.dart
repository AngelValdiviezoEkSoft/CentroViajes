import 'package:cvs_ec_app/config/environments/environments.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Rutas objRutasGen = Rutas();

class WelcomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: size.width,
              height: size.height * 1.15,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, // Punto de inicio del degradado
                  end: Alignment.bottomRight,
                colors: [Colors.blue.shade600, Colors.white, Colors.white],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * 0.04,
                ),
                // Icono central
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 80,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                // Texto de bienvenida
                Text(
                  '¡Bienvenido!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    '¡Gracias por unirte a la comunidad de D-One! ¡Acceda o cree su cuenta a continuación y comience su viaje!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: size.height * 0.04),
            
                // Subtítulo
                
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
                  padding: EdgeInsets.all(16),  // Espaciado interno
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50), // Bordes redondeados
                    color: Colors.white                  
                  ),                
                  child: TextField(
                    decoration: InputDecoration(                  
                      labelText: 'Servidor',
                      suffixIcon: const Icon(Icons.qr_code_scanner_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
            
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Container(
                  padding: EdgeInsets.all(16),  // Espaciado interno
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50), // Bordes redondeados
                    color: Colors.white                  
                  ),                
                  child: TextField(
                    decoration: InputDecoration(                  
                      labelText: 'Key',
                      suffixIcon: const Icon(Icons.qr_code_scanner_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
            
              Spacer(),
            
                Divider(color: Colors.red,),
                SizedBox(
                  height: size.height * 0.04,
                ),
                // Botón de Comenzar
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: GestureDetector(
              onTap: () {
                context.push(objRutasGen.rutaDefault);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF536DFE), // Color del botón
                  borderRadius: BorderRadius.circular(20.0), // Bordes redondeados
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Sombra bajo el botón
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Espaciado interno del botón
                child: Text(
                  'Comenzar',
                  style: TextStyle(
                    color: Colors.white,  // Color del texto
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
                  ),
                  /*
                  ElevatedButton(
                    onPressed: () {
                      context.push(objRutasGen.rutaDefault);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:Color(0xFF5C6BC0),
                      padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Comenzar',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  */
                ),
              
              ],
            ),
          ),
        ),
      ),
    );
  }
}