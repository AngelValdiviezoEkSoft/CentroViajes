import 'package:auto_size_text/auto_size_text.dart';
import 'package:cvs_ec_app/domain/domain.dart';
import 'package:cvs_ec_app/infraestructure/services/services.dart';
import 'package:cvs_ec_app/ui/ui.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

class PerfilScreen extends StatelessWidget {

  const PerfilScreen(Key? key) :super (key: key);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    ScrollController scrollListaClt = ScrollController();

    return Scaffold(      
      body: Container(
        color: Colors.transparent,
        height: size.height * 0.99,
        child: SingleChildScrollView(
          child: Column(
            children: [
              
              Container(
                color: Colors.transparent,
                width: size.width,
                height: size.height * 0.3,
                child: Stack(
                  children: [
                    Container(
                      height: 200,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/main_background.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 160,
                      left: 20,
                      child: CircleAvatar(
                        //foregroundColor: Colors.red,
                        radius: 45,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.check_circle_outline,
                          size: 90,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          
              const SizedBox(height: 10),
          
              // Nombre del usuario
              Container(
                color: Colors.transparent,
                width: size.width * 0.87,
                child: const Text(
                  'Andrew D.',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              // Correo electrónico
              Container(
                color: Colors.transparent,
                width: size.width * 0.87,
                child: const Text(
                  'andrew@domainname.com',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),
          
              FutureBuilder(
                future: AuthService().opcionesMenuPorPerfil(context),
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
          
                  List<OpcionesMenuModel> lstOpcionesMenuModel = snapshot.data as List<OpcionesMenuModel>;
          
                  return SingleChildScrollView(
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: size.height * 0.008,
                              ),
                                          
                              Container(
                                color: Colors.transparent,
                                width: size.width,
                                height: size.height * 0.5,
                                child: ListView.builder(
                                  controller: scrollListaClt,
                                  itemCount: lstOpcionesMenuModel.length,//carrito.detalles.length,
                                  itemBuilder: ( _, int index ) {
                                    return ListTile(
                                      title: Container(
                                      color: Colors.transparent,
                                      width: size.width * 1.1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            border: Border.all(
                                                color: const Color.fromARGB(255, 217, 217, 217)),
                                            borderRadius: const BorderRadius.all(Radius.circular(10))
                                          ),
                                        width: size.width * 0.98,
                                        height: size.height * 0.13,
                                        child: GestureDetector(
                                          onTap: lstOpcionesMenuModel[index].onPress,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                color: Colors.transparent,
                                                width: size.width * 0.85,
                                                height: size.height * 0.25,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(width: size.width * 0.01,),
                                                    Container(
                                                      color: Colors.transparent,
                                                width: size.width * 0.14,
                                                height: size.height * 0.1,
                                                      child: CircleAvatar(
                                                                radius: 30.0,
                                                                backgroundColor: Colors.grey[200],
                                                                child: Icon(
                                                                  lstOpcionesMenuModel[index].icono, color: Colors.grey, size: 40.0),
                                                              ),
                                                    ),
                                                    SizedBox(width: size.width * 0.02,),
                                                    Container(
                                                      color: Colors.transparent,
                                                      width: size.width * 0.65,
                                                      height: size.height * 0.15,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Container(
                                                            color: Colors.transparent,
                                                            width: size.width * 0.4,
                                                            //height: size.height * 0.025,
                                                            child: AutoSizeText(
                                                              lstOpcionesMenuModel[index].descMenu,
                                                              style: const TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 20,
                                                                color: Colors.black
                                                              ),
                                                              maxLines: 1,
                                                              textAlign: TextAlign.left,
                                                              ),
                                                          ),
                                                          Container(
                                                            color: Colors.transparent,
                                                            width: size.width * 0.25,
                                                            //height: size.height * 0.025,
                                                            alignment: Alignment.centerRight,
                                                            child: const Icon(Icons.arrow_forward_ios, size: 30,)),
                                                        ],
                                                      ),
                                                    ),
                                                    
                                                    
                                                  ],
                                                )
                                              ),
                                              /*
                                              Container(
                                                //color: Colors.transparent,
                                                width: size.width * 0.11,
                                                height: size.height * 0.12,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: Colors.black12, // Color del óvalo
                                                  borderRadius: BorderRadius.circular(50), // Bordes redondeados para el óvalo
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      color: Colors.transparent,
                                                      height: size.height * 0.04,
                                                      child: IconButton(
                                                        icon: const Icon(Icons.location_pin, color: Colors.grey, size: 25,),
                                                        onPressed: () {},
                                                      ),
                                                    ),
                                                    Container(
                                                      color: Colors.transparent,
                                                      height: size.height * 0.04,
                                                      child: IconButton(
                                                        icon: const Icon(Icons.route, color: Colors.grey, size: 25,),
                                                        onPressed: () {},
                                                      ),
                                                    ),
                                                    Container(
                                                      color: Colors.transparent,
                                                      height: size.height * 0.04,
                                                      child: IconButton(
                                                        icon: const Icon(Icons.info, color: Colors.grey, size: 25,),
                                                        onPressed: () {},
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              */
                                              SizedBox(width: size.width * 0.01,)
                                            ],
                                            ),
                                        ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                                      
                               
                            ],
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
              ),
          
            //SizedBox(height: 20),
            // Botón de cerrar sesión

            Container(
              color: Colors.transparent,
              width: size.width * 0.9,
              height: size.height * 0.08,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                child: OutlinedButton(
                  onPressed: () {
                    // Acción de cerrar sesión
                    context.pop();
                  },
                  child: Container(
                    width: size.width * 0.15,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.close, color: Colors.black,),
                        Text(
                          'Salir',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

              Center(
                child: OutlinedButton(
                  onPressed: () {
                    // Acción de cerrar sesión
                    context.pop();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Container(
                    color: Colors.transparent,
                    width: size.width * 0.25,
                    child: GestureDetector(
                      onTap: () {

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('¿Está seguro que desea cerrar su sesión?'),
                              
                              actions: [
                                TextButton(
                                  onPressed: () {

                                    Navigator.of(context).pop();

                                    context.push(objRutasGen.rutaBienvenida);

                                  },
                                  child: Text('Sí', style: TextStyle(color: Colors.blue[200]),),
                                ),
                                TextButton(
                                  onPressed: () {

                                    Navigator.of(context).pop();

                                    //context.push(objRutasGen.rutaBienvenida);

                                  },
                                  child: const Text('No', style: TextStyle(color: Colors.black),),
                                ),
                              ],
                            );
                          },
                        );
                      
                      
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.logout, color: Colors.black,),
                          Text(
                            'Cerrar Sesión',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
