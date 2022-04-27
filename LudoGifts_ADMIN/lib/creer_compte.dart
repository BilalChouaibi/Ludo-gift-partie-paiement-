// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Tutoriel Flutter',
      home: MyHomePage(title: 'Banger'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => Page();
}

class Page extends State<MyHomePage>{
  
  bool val = false;
  @override
  Widget build(BuildContext context) {

  return GetMaterialApp(
      home: Scaffold(
        backgroundColor:Colors.indigo.shade900,
          body: Padding(     // Mettre de l'espacement
          padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment:MainAxisAlignment.center,  // centrer le contenu
              children: <Widget>[
                Padding(padding: EdgeInsets.all(10),child:
                TextField(            // Zone d'entrée de texte 
                  decoration: InputDecoration(hintText: "Pseudo",hintStyle: TextStyle(color: Colors.white70)) // Pour avoir le Mail ecrit en fond avant de commencer a ecrire 
                )
                ),
                Padding(padding: EdgeInsets.all(10),child:
                TextField(            // Zone d'entrée de texte 
                  decoration: InputDecoration(hintText: "Date",hintStyle: TextStyle(color: Colors.white70))  
                )
                ),
                Padding(padding: EdgeInsets.all(10),child:
                TextField(            // Zone d'entrée de texte 
                  decoration: InputDecoration(hintText: "Mail",hintStyle: TextStyle(color: Colors.white70)) 
                )
                ),
                Padding(padding: EdgeInsets.all(10),child:
                TextField(            // Zone d'entrée de texte 
                  decoration: InputDecoration(hintText: "Mot de passe",hintStyle: TextStyle(color: Colors.white70)) 
                )
                ),
                Padding(padding: EdgeInsets.all(10),child:
                TextField(            // Zone d'entrée de texte 
                  decoration: InputDecoration(hintText: "Repeter mot de passe",hintStyle: TextStyle(color: Colors.white70))  
                )
                ),

                CheckboxListTile( // Checkbox 
                    controlAffinity : ListTileControlAffinity.leading , // Pour que le texte soit à droite de la checkbox 
                    value: val,
                    onChanged: (value) { // ce qu'on fait quand la checkbox est validée
                    setState(() {
                      val = !val;
                      });
                    },
                    title : Text('Je certifie avoir plus de 16 ans') ,
                ),

                CheckboxListTile( // Checkbox 
                    controlAffinity : ListTileControlAffinity.leading , // Pour que le texte soit à droite de la checkbox 
                    value: val,
                    onChanged: (value) { // ce qu'on fait quand la checkbox est validée
                    setState(() {
                      val = !val;
                      });
                    },
                    title : affiche ,
                ),      
              ]
            )
          )
      )
  );
  }
}
Widget affiche = 
  InkWell( child: const Text('J\'accepte les termes et conditions d\'utilisation'), 
  onTap: () => launch('https://www.twitch.tv/'));