import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_model.dart';
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

  //les valeurs des lots vides, avant de les remplacer par ceux de Firebase, je ne mets pas de tableau vide pour éviter des éventuelles erreurs faisant casser l'application
  List<String> lesNoms = List<String>.generate(35, (_) => "");
  List<int> lesPrix = List<int>.generate(35, (_) => 0);
  List<String> lesImg = List<String>.generate(35, (_) => " ");
  //les noms, prix, liens image des lots

  List<String> msg = List<String>.generate(10, (_) => 'null',);
  //récupère les messages

  // Méthode pour modifier le nombre de points dans la FB et pour l'userModel actuel
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
    //fonction qui permet de récupérer toutes les infos des lots et les mettre dans les tableaux ci-dessus
    // cette partie du code est pour initaliser le nombre maximum de lots, enlever les commentaires et remplacer 36 par le nombre de lots souhaités
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
    //permet de récuperer les messages
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
      //print(msg);
    });
  }

  verifierArgent(int prix, int i, String pack) {
    //vérifie si l'argent est suffisant + affichage
    if (argent >= prix) {
      //Affiche bouton OBTENIR si argent suffisant
      return Container(
        margin: EdgeInsets.all(0.0),
        child: TextButton(
          style: TextButton.styleFrom(
              primary: Colors.greenAccent.shade400,
              backgroundColor: Colors.yellow.shade700,
              textStyle: const TextStyle(fontSize: 15),
              fixedSize: const Size(70, 30)),
          onPressed: () {
            //si suffisant, afficher popèUp + instruction
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Félicitation !"), //confirmation d'achat
                    content: Text(
                        "Êtes-vous sûr de vouloir acheter le pack ${lesNoms[i]} ? "),
                    actions: [
                      TextButton(
                        child: Text("OUI"),
                        onPressed: () {
                          ajoutPoints(-lesPrix[i]);
                          for (var i = 0; i < 10; i++) {
                            if (msg[i] == "null") {
                              //envoi un message a l'admin
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
    //recup();
    List<Widget> menu = [];
    for (var i = 0; i < nbLot; i++) {
      if (lesNoms[i] != "null") {
        menu.add(Row(
          //ROW 1
          children: [
            Container(
                //image du lot
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
              width: 150, //description du lot
              margin: EdgeInsets.all(10.0),
              child: Text(
                'Lot ${i + 1} : \n Pack ${lesNoms[i]} \n Prix: ${lesPrix[i]}',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ));
        menu.add(Column(
          children: [
            verifierArgent(
                lesPrix[i], i, lesNoms[i]), //vérifie si l'argent est suffisant
          ],
        ));
      }
    }

    return Column(children: menu);
  }

  Widget build(BuildContext context) {
    initArgent(); //initialise les points du joeur
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
                    Icons.info,
                    color: Colors.yellow.shade700,
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white24,
                  )),
              title: Text(
                "À propos",
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
            false, // Widget immobile quand on déploie le clavier
        backgroundColor: Colors.grey.shade900,
        body: SingleChildScrollView(
            // Mettre de l'espacement
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
            child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // centrer le contenu
                children: <Widget>[
                  Text(
                    //affiche les points
                    "Vous avez $argent points",
                    style: TextStyle(color: Colors.white70, fontSize: 20),
                  ),
                  getMenu(), //affichage des lots
                ])));
  }
}

class Message extends StatefulWidget {
  const Message({Key? key, String? uid}) : super(key: key);

  @override
  MessageAdmin createState() => MessageAdmin();
}

class MessageAdmin extends State<Message> {
  TextEditingController msgController =
      TextEditingController(); //initialise des messages sans contenu pour éviter des bugs liées a firebase

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
    //affichage des messages
    List<Widget> menu = [];
    for (var i = 9; i >= 0; i--) {
      if (msg1[i] != "null") {
        menu.add(Container(
          margin: const EdgeInsets.all(15.0),
          padding: const EdgeInsets.all(5.0),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.yellow.shade700)),
          child: Text(
            msg1[i],
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
        ));
      }
    }

    return Column(children: menu);
  }

  recup1() {
    //récupère les message de la base de données
    FirebaseFirestore.instance
        .collection("messages")
        .doc("ADMIN")
        .get()
        .then((value) {
      for (var i = 0; i < 10; i++) {
        setState(() {
          msg1[i] = (value.get("msg${i + 1}"));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //affichage
    recup1();
    return Scaffold(
      appBar: MyAppBar(),
      backgroundColor: Colors.grey.shade900,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child:
                  Text("Mes messages :", style: TextStyle(color: Colors.blue)),
            ),
            getMenu(),
          ],
        ),
      ),
    );
  }
}
