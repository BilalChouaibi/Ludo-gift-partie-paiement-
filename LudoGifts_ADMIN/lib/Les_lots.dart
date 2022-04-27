import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interface_connexion/paiement.dart';
import 'package:path_provider/path_provider.dart';
import 'main.dart';
import 'user_model.dart';
import 'package:path/path.dart' as p;
import 'package:select_form_field/select_form_field.dart';
import 'paiement.dart';
import 'Les_lots.dart';
import 'maindebut_interface_jeux.dart';

class LesLots extends StatefulWidget {
  //classe LesLots
  LesLots({Key? key, required this.title, required this.userModel})
      : super(key: key);
  final String title;
  final UserModel userModel;

  // On transmet l'utilisateur qui est connecté entre les differentes pages
  @override
  State<LesLots> createState() => Lots(userModel);
}

class Lots extends State<LesLots> {
  //classe Lots
  UserModel userModel = UserModel();
  UserModel loggedInUser = UserModel();
  // Lots(this.userModel);
  Lots(UserModel un) {
    userModel = un;
    recup(); //on initialise les lots via firebase
  }
  int nbLot = 35; //nombre de lots max
  int argent = 0; //argent tmp

  void initArgent() {
    //initialiser le nombre de points du joueur
    setState(() {
      argent = userModel.points;
    });
  }

  List<String> lesNoms = [
    //les valeurs des lots vide, avant de les remplacer par ceux de firebase, je met pas de tableaux vide pour éviter des eventuels erreurs faisant cassser l'app
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
  ]; //les noms,prix,lien img des lots
  List<int> lesPrix = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ];
  List<String> lesImg = [
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
  ];
  List<String> msg = [
    //les messages "vide" on fait ça pour éviter des bugs
    'null',
    'null',
    'null',
    'null',
    'null',
    'null',
    'null',
    'null',
    'null',
    'null',
  ];

  // Methode pour modifier le nbr de points dans la FB et pour l'userModel acctuel
  void ajoutPoints(int val) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel.uid)
        .update({"points": FieldValue.increment(val)});
    setState(() {
      userModel.setPoints(val);
    });
  }

  recup() {
    //fonction qui permet de récuperer tout les infos des lots et les mettre dans les tableaux si dessus
    // cette partie du code c'est pour initalisé le nombre max de lots, enlever les commentaire et remplacer 36 par le nombre de lots souhaité
    /*for (var i = 8; i < 36; i++) {
      FirebaseFirestore.instance
          .collection("lots")
          .doc('eDTIEg6wveiJIZZ9WdEr')
          .update({"lien${i}": ""});
    }*/
    FirebaseFirestore.instance
        .collection("lots")
        .doc("eDTIEg6wveiJIZZ9WdEr")
        .get()
        .then((value) {
      setState(() {
        for (var i = 0; i < nbLot; i++) {
          lesNoms[i] = (value.get("nom${i + 1}"));
        }
      });
      setState(() {
        for (var i = 0; i < nbLot; i++) {
          lesPrix[i] = (value.get("prix${i + 1}"));
        }
      });
      setState(() {
        for (var i = 0; i < nbLot; i++) {
          lesImg[i] = (value.get("lien${i + 1}"));
        }
      });
    });
  }

  recup1() {
    FirebaseFirestore.instance //recuperer les messages de la base de donnees
        .collection("messages")
        .doc("cnC9D8LDRyya6uPRxpjw")
        .get()
        .then((value) {
      for (var i = 0; i < 10; i++) {
        setState(() {
          msg[i] = (value.get("msg${i + 1}"));
        });
      }
    });
  }

  verifierArgent(int prix, int i, String pack) {
    //verifie si l'argent est suffisant + affichage
    if (argent >= prix) {
      //Affiche boutton OBTENIR si argent suffisant
      return Container(
        margin: EdgeInsets.all(0.0),
        child: TextButton(
          style: TextButton.styleFrom(
              primary: Colors.greenAccent.shade400,
              backgroundColor: Colors.yellow.shade700,
              textStyle: const TextStyle(fontSize: 15),
              fixedSize: const Size(70, 30)),
          onPressed: () {
            //si suffisant, afficher popUp + instruction
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Félicitation !"),
                    content: Text(
                        "Êtes-vous sûr de vouloir acheter le pack ${lesNoms[i]} ? "),
                    actions: [
                      TextButton(
                        child: Text("OUI"),
                        onPressed: () {
                          ajoutPoints(-lesPrix[i]); //décrémente les points

                          for (var i = 0; i < 10; i++) {
                            //signale l'admin
                            if (msg[i] == "null") {
                              //on ajoute le message a la premiére occurence d'un message "non définit"
                              FirebaseFirestore.instance
                                  .collection("messages")
                                  .doc("cnC9D8LDRyya6uPRxpjw")
                                  .update({
                                "msg${i + 1}":
                                    "${userModel.pseudo} à commander le pack $pack, son email : ${userModel.email} ",
                              });
                              break;
                            }
                          }

                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text("NON"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                });
          },
          child: const Text(
            'Obtenir ',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      //Sinon afficher le montant nécessaire
      return Container(
        margin: EdgeInsets.all(0.0),
        child: Text(
          '$argent/$prix',
          style: TextStyle(
            color: Colors.yellow,
            fontSize: 17,
          ),
        ),
      );
    }
  }

  Widget getMenu() {
    //l'affichage des lignes de lots
    List<Widget> menu = [];
    for (var i = 0; i < nbLot; i++) {
      if (lesNoms[i] != "null") {
        //affiche seulement les lots définit != "null"
        menu.add(Row(
          //ROW 1
          children: [
            Container(
                //image
                margin: EdgeInsets.all(10.0),
                child: CircleAvatar(
                  radius: 40.0,
                  backgroundColor: Colors.transparent,
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('${lesImg[i]}'),
                    fit: BoxFit.cover, // -> 02
                  ),
                )),
            Container(
              //Description
              width: 150,
              margin: EdgeInsets.all(10.0),
              child: Text(
                'Lot ${i + 1} : \n Pack ${lesNoms[i]} \n Prix: ${lesPrix[i]}',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Container(
                child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red), //Supprimer
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Attention"),
                              content: Text(
                                  "Êtes-vous sûr de vouloir supprimer le pack ${lesNoms[i]} ? "),
                              actions: [
                                TextButton(
                                  child: Text("OUI"),
                                  onPressed: () {
                                    setState(() {
                                      FirebaseFirestore.instance
                                          .collection("lots")
                                          .doc("eDTIEg6wveiJIZZ9WdEr")
                                          .update({"nom${i + 1}": "null"});
                                    });
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Text(
                                                "Vous avez supprimé le lot"),
                                            actions: [
                                              TextButton(
                                                child: Text("OK"),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            LesLots(
                                                              title: '',
                                                              userModel:
                                                                  userModel,
                                                            )),
                                                  );
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                ),
                                TextButton(
                                  child: Text("NON"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          });
                    })),
          ],
        ));
        menu.add(Column(
          children: [
            verifierArgent(
                lesPrix[i], i, lesNoms[i]), //verifie si l'argent est suffisant
          ],
        ));
      }
    }

    return Column(children: menu);
  }

  Widget build(BuildContext context) {
    initArgent(); //initialise les points du joueur
    recup1();
    return Scaffold(
        appBar: MyAppBar(),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Profil(
                                userModel: loggedInUser,
                              )),
                    );
                  },
                  child: Icon(
                    Icons.person,
                    color: Colors.yellow.shade700,
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white24,
                  )),
              title: Text(
                "Profil",
                style: GoogleFonts.nunito(
                  color: Colors.yellow.shade700,
                ),
              ),
              backgroundColor: Colors.white24,
            ),
            BottomNavigationBarItem(
              icon: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Message()),
                    );
                  },
                  child: Icon(
                    Icons.mail,
                    color: Colors.yellow.shade700,
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white24,
                  )),
              title: Text(
                "Messages",
                style: GoogleFonts.nunito(
                  color: Colors.yellow.shade700,
                ),
              ),
              backgroundColor: Colors.white24,
            ),
            BottomNavigationBarItem(
              icon: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Reglage()),
                    );
                  },
                  child: Icon(
                    Icons.settings,
                    color: Colors.yellow.shade700,
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white24,
                  )),
              title: Text(
                "Réglages",
                style: GoogleFonts.nunito(
                  color: Colors.yellow.shade700,
                ),
              ),
              backgroundColor: Colors.white24,
            ),
          ],
          backgroundColor: Colors.white24,
        ),
        resizeToAvoidBottomInset:
            false, // Widget immobile quand on deploie le clavier
        backgroundColor: Colors.grey.shade900,
        body: SingleChildScrollView(
            // Mettre de l'espacement
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
            child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // centrer le contenu
                children: <Widget>[
                  Text(
                    "Vous avez $argent points",
                    style: TextStyle(color: Colors.white70, fontSize: 20),
                  ),
                  getMenu(), //affichage des lots
                  TextButton(
                    //boutton pour ajouter un lot
                    style: TextButton.styleFrom(
                        primary: Colors.greenAccent.shade400,
                        backgroundColor: Colors.yellow.shade700,
                        textStyle: const TextStyle(fontSize: 20),
                        fixedSize: const Size(300, 50)),
                    onPressed: () {
                      Navigator.of(context)
                          .push(_createRouteAjouterLots(nbLot));
                    },
                    child: const Text(
                      'Ajouter un lot ',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  )
                ])));
  }
}

class AjouterLot extends StatelessWidget {
  //interface pour ajouter un lot
  UserModel userModel;
  UserModel loggedInUser = UserModel();
  AjouterLot(this.userModel, this.nbLots);
  List<String> noms = [];
  int nbLots = 0;
  TextEditingController nomController = TextEditingController();
  TextEditingController prixController = TextEditingController();
  TextEditingController lienController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance //récupére les noms des lots déja existant
        .collection("lots")
        .doc("eDTIEg6wveiJIZZ9WdEr")
        .get()
        .then((value) {
      for (var i = 0; i < nbLots; i++) {
        noms.add(value.get("nom${i + 1}"));
      }
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        //currentIndex: this.selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Profil(
                              userModel: loggedInUser,
                            )),
                  );
                },
                child: Icon(
                  Icons.person,
                  color: Colors.yellow.shade700,
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white24,
                )),
            title: Text(
              "Profil",
              style: GoogleFonts.nunito(
                color: Colors.yellow.shade700,
              ),
            ),
            backgroundColor: Colors.white24,
          ),
          BottomNavigationBarItem(
            icon: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Message()),
                  );
                },
                child: Icon(
                  Icons.mail,
                  color: Colors.yellow.shade700,
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white24,
                )),
            title: Text(
              "Messages",
              style: GoogleFonts.nunito(
                color: Colors.yellow.shade700,
              ),
            ),
            backgroundColor: Colors.white24,
          ),
          BottomNavigationBarItem(
            icon: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Reglage()),
                  );
                },
                child: Icon(
                  Icons.settings,
                  color: Colors.yellow.shade700,
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white24,
                )),
            title: Text(
              "Réglages",
              style: GoogleFonts.nunito(
                color: Colors.yellow.shade700,
              ),
            ),
            backgroundColor: Colors.white24,
          ),
        ],

        backgroundColor: Colors.white24,
      ),
      backgroundColor: Colors.grey.shade900,
      body: Center(
        child: Column(
          children: <Widget>[
            //les inputs..
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                  controller: nomController,
                  style: TextStyle(color: Colors.white70),
                  decoration: InputDecoration(
                      hintText: "Nom du lot",
                      hintStyle: TextStyle(color: Colors.white70))),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                  controller: prixController,
                  style: TextStyle(color: Colors.white70),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: "Prix du lot",
                      hintStyle: TextStyle(color: Colors.white70))),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                  controller: lienController,
                  style: TextStyle(color: Colors.white70),
                  decoration: InputDecoration(
                      hintText: "Lien de l'image du lot",
                      hintStyle: TextStyle(color: Colors.white70))),
            ),
            Padding(
              padding: EdgeInsets.all(100),
              child: TextButton(
                style: TextButton.styleFrom(
                    primary: Colors.greenAccent.shade400,
                    backgroundColor: Colors.yellow.shade700,
                    textStyle: const TextStyle(fontSize: 20),
                    fixedSize: const Size(300, 50)),
                onPressed: () {
                  for (var i = 0; i < nbLots; i++) {
                    // ajoute le lot au premier nom qui est null
                    if (noms[i] == "null") {
                      String tmp = nomController.text;
                      int prix = int.parse(prixController.text);
                      String lien = lienController.text;
                      FirebaseFirestore.instance
                          .collection("lots")
                          .doc("eDTIEg6wveiJIZZ9WdEr")
                          .update({
                        "nom${i + 1}": "$tmp ",
                        "prix${i + 1}": prix,
                        "lien${i + 1}": "$lien"
                      });
                      break;
                    }
                  }

                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text("Vous avez ajouté un lot"),
                          actions: [
                            TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                //Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LesLots(
                                            title: '',
                                            userModel: userModel,
                                          )),
                                );
                              },
                            ),
                          ],
                        );
                      });
                },
                child: Text(
                  "Ajouter un lot",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Message extends StatefulWidget {
  const Message({Key? key, String? uid}) : super(key: key);

  @override
  MessageAdmin createState() => MessageAdmin();
}

class MessageAdmin extends State<Message> {
  //const Message({Key? key}) : super(key: key);
  TextEditingController msgController = TextEditingController();
  List<String> msg = [
    'null',
    'null',
    'null',
    'null',
    'null',
    'null',
    'null',
    'null',
    'null',
    'null',
  ];
  List<String> msg1 = [
    'null',
    'null',
    'null',
    'null',
    'null',
    'null',
    'null',
    'null',
    'null',
    'null',
  ];

  Widget getMenu() {
    //retourne les messages
    List<Widget> menu = [];
    for (var i = 0; i < 10; i++) {
      if (msg[i] != "null") {
        // si le msg est vide
        menu.add(Container(
          margin: const EdgeInsets.all(15.0),
          padding: const EdgeInsets.all(5.0),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.yellow.shade700)),
          child: Text(
            msg[i],
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
        ));
      }
    }

    return Column(children: menu);
  }

  recup() {
    //recuperer les messages de la bdd
    FirebaseFirestore.instance
        .collection("messages")
        .doc("cnC9D8LDRyya6uPRxpjw")
        .get()
        .then((value) {
      for (var i = 0; i < 10; i++) {
        setState(() {
          msg[i] = (value.get("msg${i + 1}"));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    /*FirebaseFirestore.instance
        .collection("messages")
        .doc("cnC9D8LDRyya6uPRxpjw")
        .get()
        .then((value) {
      for (var i = 0; i < 10; i++) {
        setState(() {
          msg[i] = (value.get("msg${i + 1}"));
        });
      }
*/
    recup();

    return Scaffold(
      appBar: MyAppBar(),
      backgroundColor: Colors.grey.shade900,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Mes messages :", style: TextStyle(color: Colors.blue)),
            getMenu(), //affiche les msg
            TextButton(
              child: Text("EFFACER"), //pour effaacer tout les messages
              onPressed: () {
                for (var i = 0; i < 10; i++) {
                  if (msg[i] != "null") {
                    FirebaseFirestore.instance
                        .collection("messages")
                        .doc("cnC9D8LDRyya6uPRxpjw")
                        .update({
                      "msg${i + 1}": "null",
                    });
                  }
                }
              },
            ),
            TextField(
                controller: msgController,
                style: TextStyle(color: Colors.white70),
                decoration: InputDecoration(
                    hintText: "Message a tout les joueurs",
                    hintStyle: TextStyle(color: Colors.white70))),
            TextButton(
              style: TextButton.styleFrom(
                  primary: Colors.greenAccent.shade400,
                  backgroundColor: Colors.yellow.shade700,
                  textStyle: const TextStyle(fontSize: 15),
                  fixedSize: const Size(70, 30)),
              onPressed: () {
                String msg = msgController.text;
                for (var i = 0; i < 10; i++) {
                  // ajoute le lot au premier nom qui est null
                  if (msg1[i] == "null") {
                    String msg = msgController.text;
                    FirebaseFirestore.instance
                        .collection("messages")
                        .doc("ADMIN")
                        .update({
                      "msg${i + 1}": "$msg",
                    });
                    break;
                  }
                }
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text("Message envoyé"), //confirmation d'envoi
                        actions: [
                          TextButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
              child: Text(
                "Envoyer",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Route _createRouteAjouterLots(nbLot) {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  return PageRouteBuilder(
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return AjouterLot(loggedInUser, nbLot);
    },
    transitionsBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      return child;
    },
  );
}
