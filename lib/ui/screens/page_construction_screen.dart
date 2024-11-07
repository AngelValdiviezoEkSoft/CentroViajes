
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EnConstruccionScreen extends StatefulWidget {

  const EnConstruccionScreen({Key? key}) : super (key: key);

  @override
  EnConstruccionScreenState createState() => EnConstruccionScreenState();

}

class EnConstruccionScreenState extends State<EnConstruccionScreen>{

  @override
  void initState(){
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    final sizeScreen = MediaQuery.of(context).size;
    
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Container(
            width: sizeScreen.width,
            alignment: Alignment.center,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>
              [

                Container(
                  color: Colors.transparent,
                  width: sizeScreen.width * 0.85,
                  height: sizeScreen.height * 0.35,
                  child: Image.asset('assets/gifs/PaginaEnEspera.gif'),
                ),
                
                Container(
                  color: Colors.transparent,
                  width: sizeScreen.width,
                  height: 90,
                  child: Center(
                    child: AutoSizeText (
                      'Lo sentimos',
                      style: TextStyle(color: Colors.orangeAccent, decorationStyle: TextDecorationStyle.solid, fontWeight: FontWeight.bold,),
                      presetFontSizes: const [40,38,36,34,32,30,28,26,24,22,20,18],
                      textAlign: TextAlign.center,
                      maxLines: 3,
                    ),
                  ),
                ),

                Container(
                  color: Colors.transparent,
                  width: sizeScreen.width * 0.87,
                  height: sizeScreen.height * 0.22,
                  alignment: Alignment.center,
                  child: RichText(
                    maxLines: 15,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Página en construcción',
                      style: TextStyle(color: Colors.black, fontSize: 22,),
                      ),
                    )
                  ),

                  Container(
                  color: Colors.transparent,
                  width: sizeScreen.width,
                  height: 90,
                  child: Center(
                    child: AutoSizeText (
                      'Mantente atento.',
                      style: TextStyle(color: Colors.black, decorationStyle: TextDecorationStyle.solid, fontWeight: FontWeight.bold,),
                      presetFontSizes: const [24,22,20,18],
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                ),

                Center(
                      child: OutlinedButton(
                        onPressed: () {
                          // Acción de cerrar sesión
                          context.pop();
                        },
                        child: Container(
                          width: sizeScreen.width * 0.33,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.logout, color: Colors.black,),
                              Text(
                                'Regresar',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),

              ]
            ),
          ),
              
        ),
      );
     
  }
}