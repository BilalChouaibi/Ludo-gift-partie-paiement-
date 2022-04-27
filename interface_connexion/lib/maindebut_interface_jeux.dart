// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state

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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // On initialise les donnees de l'utilisateur des qu'il se connecte
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      setState(() {
        loggedInUser = UserModel.fromMap(value.data());
        loggedInUser.setuid(user!.uid);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: MyAppBar(),
          body: Center(
              child: Column(
            children: [
              Expanded(
                  child: Container(
                width: 300,
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Jouerenligne(userModel: loggedInUser)),
                      );
                    },
                    child: Text(
                      "Jouer en Ligne",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      primary: Color.fromRGBO(22, 217, 80, 1),
                    )),
              )),
              Expanded(
                  child: Container(
                width: 300,
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LesLots(
                                  userModel: loggedInUser,
                                )),
                      );
                    },
                    child: Text(
                      "Lots",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      primary: Color.fromRGBO(255, 131, 0, 1),
                    )),
              )),
              Expanded(
                  child: Container(
                width: 300,
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Grandprix()),
                      );
                    },
                    child: Text(
                      "Grand prix",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      primary: Color.fromRGBO(228, 0, 115, 1),
                    )),
              )),
              Expanded(
                  child: Container(
                width: 300,
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Achatdepoints(userModel: loggedInUser)),
                      );
                    },
                    child: Text(
                      "Achat de point",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      primary: Color.fromRGBO(255, 205, 0, 1),
                    )),
              )),
            ],
          )),
          backgroundColor: Color.fromRGBO(20, 22, 48, 1),
        ));
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(50);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
          size: 20,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },
      ),
      title: Text(
        'LUDOGIFT',
        style: GoogleFonts.nunito(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
      centerTitle: true,
      backgroundColor: Color.fromRGBO(42, 44, 72, 1),
    );
  }
}

class Jouerenligne extends StatefulWidget {
  const Jouerenligne({Key? key, required this.userModel}) : super(key: key);
  final UserModel userModel;

  @override
  EnLigne createState() => EnLigne(userModel);
}

class EnLigne extends State<Jouerenligne> {
  // Reste a faire :
  // Verifier que ce qui a ete fait marche correctement pcq je suis pas sur
  // Faire en sorte que selon de le mode des qu'il y a assez de joueurs une realtime database soit cree avec les joueurs de la partie
  // Pour stocker l'etat du plateau(pour pouvoir recup la partie si un utilisateur quitte) et recuperer le gagnant
  // La tache du haut est a realiser en collaboration avec le serveur de jeu
  // Rendre l'interface plus belle

  UserModel userModel;
  EnLigne(this.userModel);

  // Liste des differentes mises possibles
  final List<Map<String, dynamic>> _items = [
    // Liste des differentes mises possibles
    {'value': 1000},
    {'value': 2000},
    {'value': 5000},
    {'value': 10000},
    {'value': 20000},
    {'value': 30000},
    {'value': 40000},
    {'value': 50000},
    {'value': 100000},
    {'value': 200000},
    {'value': 300000},
    {'value': 400000},
    {'value': 500000},
    {'value': 1000000},
    {'value': 2000000},
    {'value': 3000000},
    {'value': 4000000},
    {'value': 5000000},
    {'value': 10000000},
  ];

  // Creation des icon de selection des fers
  Widget cheval1 = const Image(
      image: ExactAssetImage("assets/argent.jpg"), height: 70.0, width: 70.0);
  Widget cheval2 = const Image(
      image: ExactAssetImage("assets/or.jpg"), height: 70.0, width: 70.0);
  Widget cheval3 = const Image(
      image: ExactAssetImage("assets/noir.jpg"), height: 70.0, width: 70.0);
  Widget cheval4 = const Image(
      image: ExactAssetImage("assets/blanc.jpg"), height: 70.0, width: 70.0);

  final _key = GlobalKey<FormState>();
  int laMise = 0;

  // boolean pour connaitre le mode selectionné
  bool mode1v1 = true;

  // Tab de boolean pour connaitre le cheval selectionne
  List<bool> tabBool = [true, false, false, false];

  // Construction de la fenetre qui apparait lors du lancement de la artie
  Future enRecherchePartie(int uneMise, bool mode) {
    String m;
    if (mode == true) {
      m = "1v1";
    } else {
      m = "1v3";
    }

    // A modifier pour que l'utilisateur soit ajouté avec qqch qui permet de l'identifier pour le supprimer(p-e)
    FirebaseFirestore.instance
        .collection("recherche")
        .doc(uneMise.toString() + "_" + m)
        .set({"${userModel.pseudo}": userModel.uid});

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Recherche"),
            content: Text("Votre recherche de partie est en cours..."),
            actions: [
              // Si une partie est trouvée, lancer la partie
              TextButton(
                child: Text("Annuler la recherche"),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection("recherche")
                      .doc(uneMise.toString() + "_" + m)
                      .update({"${userModel.pseudo}": FieldValue.delete()});
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  // Methode pour calculer les gains possibles selon la mise et le mode selectionné
  double calculgain(bool? mode1v1, int uneMise) {
    if (mode1v1 == true) {
      return uneMise * 1.9;
    } else {
      return laMise * 2.8;
    }
  }

  // Methode qui change le signe des valeurs du tableau selon le cheval selectionné pour que celui apparaisse comme tel
  void changeSigne(int nbr) {
    for (int i = 0; i < 4; i++) {
      if (i != nbr) {
        setState(() {
          tabBool[i] = false;
        });
      } else {
        (setState(() {
          tabBool[i] = true;
        }));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade900, // Couleur de fond
        appBar: MyAppBar(),
        body: Form(
            key: _key,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(children: [
                Text(
                  "Choisissez un mode de jeu",
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          style: TextButton.styleFrom(
                              backgroundColor: mode1v1
                                  ? Colors.green
                                  : Colors.grey
                                      .shade900), // Si mode1v1 == false couleur -> grey.shade900 sinon couleur -> green
                          onPressed: () {
                            setState(() {
                              mode1v1 = true;
                            });
                          },
                          child: Text("1v1"),
                        ),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          style: TextButton.styleFrom(
                              backgroundColor: !mode1v1
                                  ? Colors.green
                                  : Colors.grey.shade900),
                          onPressed: () {
                            setState(() {
                              mode1v1 = false;
                            });
                          },
                          child: Text("1v3"),
                        ),
                      )),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: SelectFormField(
                                type: SelectFormFieldType.dropdown,
                                style: TextStyle(color: Colors.white70),
                                labelText: 'Votre mise',
                                items: _items,
                                onChanged: (value) {
                                  setState(() {
                                    laMise = int.parse(
                                        value); // On caste la value en entier
                                  });
                                },
                                validator: (value) {
                                  if (userModel.points < laMise) {
                                    // Si la mise>nbr de points du joueur -> erreur
                                    return "Veuillez choisir une mise qui correspond à votre nombre de points";
                                  }
                                  if (laMise == 0) {
                                    return "Veuillez choisir une mise";
                                  }
                                  return null;
                                },
                              ))),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Text(
                              'Les gains possibles : ${calculgain(mode1v1, laMise)}',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.white70)),
                        ),
                      )
                    ]),
                Text('Choisissez votre fer à cheval',
                    style: TextStyle(fontSize: 20, color: Colors.white70)),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor:
                            tabBool[0] ? Colors.green : Colors.grey.shade900,
                        fixedSize: Size(70, 70)),
                    onPressed: () {
                      changeSigne(0);
                    },
                    child: cheval1,
                  ),
                  ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor:
                            tabBool[1] ? Colors.green : Colors.grey.shade900,
                        fixedSize: Size(70, 70)),
                    onPressed: () {
                      changeSigne(1);
                    },
                    child: cheval2,
                  ),
                  ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor:
                            tabBool[2] ? Colors.green : Colors.grey.shade900,
                        fixedSize: Size(70, 70)),
                    onPressed: () {
                      changeSigne(2);
                    },
                    child: cheval3,
                  ),
                  ElevatedButton(
                    style: TextButton.styleFrom(
                        backgroundColor:
                            tabBool[3] ? Colors.green : Colors.grey.shade900,
                        fixedSize: Size(70, 70)),
                    onPressed: () {
                      changeSigne(3);
                    },
                    child: cheval4,
                  ),
                ]),
                TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                      backgroundColor: Colors.grey.shade400,
                    ),
                    child: Text('Lancer la recherche'),
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        enRecherchePartie(laMise, mode1v1);
                      }
                    })
              ]),
            )));
  }
}

class LesLots extends StatefulWidget {
  // classe LesLots
  const LesLots({Key? key, required this.userModel}) : super(key: key);
  final UserModel userModel;

  // On transmet l'utilisateur qui est connecté entre les differentes pages
  @override
  State<LesLots> createState() => Lots(userModel);
}

class Lots extends State<LesLots> {
  //classe Lots
  UserModel userModel;
  Lots(this.userModel);
  bool val = false;
  bool val2 = false;
  int nbLot = 3; //nombre de lots dispo
  int argent = 0; //argent tmp

  void initArgent() {
    setState(() {
      argent = userModel.points;
    });
  }

  List<String> lesNoms = [
    'photo',
    'PS5',
    'iphone'
  ]; //les noms,prix,lien img des lots
  List<int> lesPrix = [50, 100, 150];
  List<String> lesImg = ['camera.jpg', 'ps5.jpg', 'iphone.jpg'];

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

  ajouterLot(String unNom, String unLien, int unPrix) {
    //ajoute un lot
    //A verifier :o
    lesPrix.add(unPrix);
    lesNoms.add(unNom);
    lesImg.add(unLien);
    nbLot = nbLot + 1;
  }

  supprimerLot(int index) {
    //supprime un lot
    int inde = index - 1;
    lesPrix.remove(inde);
    lesNoms.remove(inde);
    lesImg.remove(inde);
    nbLot = nbLot - 1;
  }

  verifierArgent(int prix, int i) {
    //verifie si l'argent est suffisant + affichage
    if (argent >= prix) {
      //Affiche boutton OBTENIR si argent suffisant
      return Container(
        margin: EdgeInsets.all(20.0),
        child: TextButton(
          style: TextButton.styleFrom(
              primary: Colors.greenAccent.shade400,
              backgroundColor: Colors.yellow.shade700,
              textStyle: const TextStyle(fontSize: 15),
              fixedSize: const Size(70, 30)),
          onPressed: () {
            //si suffisant, afficher popUp + instruction
            //Navigator.of(context).push(_createRoute2());
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Félicitations !"),
                    content: Text(
                        "Êtes-vous sûr de vouloir acheter le pack ${lesNoms[i]} ? "),
                    actions: [
                      TextButton(
                        child: Text("OUI"),
                        onPressed: () {
                          ajoutPoints(-lesPrix[i]);
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
        margin: EdgeInsets.all(10.0),
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
    //boucle qui vas afficher tout les lots (nbLot)
    List<Widget> menu = [];
    for (var i = 0; i < nbLot; i++) {
      menu.add(Row(
        //ROW 1

        children: [
          Container(
            margin: EdgeInsets.all(10.0),
            child: CircleAvatar(
              radius: 40.0,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/${lesImg[i]}'),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text(
              'Lot n°${i + 1} \n Pack ${lesNoms[i]} \n Prix: ${lesPrix[i]}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          verifierArgent(lesPrix[i], i),
        ],
      ));
    }
    return Column(children: menu);
  }

  @override
  Widget build(BuildContext context) {
    initArgent();
    return Scaffold(
        appBar: MyAppBar(),
        resizeToAvoidBottomInset:
            false, // Widget immobile quand on deploie le clavier
        backgroundColor: Colors.grey.shade900,
        body: Padding(
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
                  getMenu(),
                ])));
  }
}

class Profil extends StatefulWidget {
  const Profil({Key? key, required this.userModel}) : super(key: key);
  final UserModel userModel;

  @override
  ProfilState createState() => ProfilState(userModel);
}

class ProfilState extends State<Profil> {
  UserModel userModel;
  ProfilState(this.userModel);

  void changerPseudo() {
    final _formKey = GlobalKey<FormState>();
    TextEditingController pseudoController = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text('Changer pseudo'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                        controller: pseudoController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            hintText: "Pseudo",
                            hintStyle: TextStyle(color: Colors.black)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Entrez votre nouveau pseudo");
                          }
                          return null;
                        }),
                    ElevatedButton(
                        child: Text("Valider"),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            changeFB(pseudoController.text);
                            Navigator.of(context).pop();
                          }
                        })
                  ],
                ),
              ),
            ),
          );
        });
  }

  void changeFB(String nvPseudo) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel.uid)
        .update({"pseudo": nvPseudo}).then((value) {
      setState(() {
        userModel.setPseudo(nvPseudo);
      });
      Fluttertoast.showToast(
          msg: "Votre pseudo a bien été modifié",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
    });
  }

  Future<void> changePP() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final directory = await getApplicationDocumentsDirectory();
    final name = p.basename(image.path);
    final imageFile = File('${directory.path}/$name');
    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel.uid)
        .update({"photo": imageFile.path}).then((value) {
      setState(() {
        userModel.setPhoto(imageFile.path);
      });
      Fluttertoast.showToast(
          msg: "Votre photo de profil a bien été modfiée",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
    });
  }

  Widget affichePP() {
    if (userModel.photo!.startsWith('http')) {
      final image = NetworkImage(userModel.photo.toString());
      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipOval(
                child: Material(
                    child: Ink.image(
              image: image,
              fit: BoxFit.cover,
              width: 128,
              height: 128,
            ))),
            IconButton(
              padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
              icon: Icon(Icons.add_box_outlined),
              onPressed: () {
                changePP();
              },
            )
          ]);
    } else if (userModel.photo == 'pdp.jpg') {
      final image = AssetImage("assets/pdp.jpg");
      return ClipOval(
          child: Material(
              child: Ink.image(
        image: image,
        fit: BoxFit.cover,
        width: 128,
        height: 128,
        child: IconButton(
          padding: EdgeInsets.fromLTRB(80, 80, 5, 5),
          icon: Icon(Icons.add_box),
          onPressed: () {
            changePP();
          },
        ),
      )));
    }

    final image = Image.file(File(userModel.photo.toString()));
    return ClipOval(
        child: Material(
            child: Ink.image(
      image: image.image,
      fit: BoxFit.cover,
      width: 128,
      height: 128,
      child: IconButton(
          padding: EdgeInsets.fromLTRB(80, 80, 5, 5),
          icon: Icon(Icons.add_box),
          onPressed: () {
            changePP();
          }),
    )));
  }

  void changeLivraisonFB(List<Map> info) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel.uid)
        .update({"infos": info}).then((value) {
      Fluttertoast.showToast(
          msg: "Vos informations de livraisons ont bien été modifiées",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
    });
  }

  void coordLivraison() {
    final _formKey = GlobalKey<FormState>();
    TextEditingController sexeController = TextEditingController();
    TextEditingController nomController = TextEditingController();
    TextEditingController prenomController = TextEditingController();
    TextEditingController telephoneController = TextEditingController();
    TextEditingController numeroController = TextEditingController();
    TextEditingController voieController = TextEditingController();
    TextEditingController complementController = TextEditingController();
    TextEditingController cpController = TextEditingController();
    TextEditingController villeController = TextEditingController();
    final List<Map<String, dynamic>> sexe = [
      {'value': 'Homme'},
      {'value': 'Femme'}
    ];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text('Informations de livraison'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Informations personnelles")),
                    SelectFormField(
                      controller: sexeController,
                      type: SelectFormFieldType.dropdown,
                      style: TextStyle(color: Colors.black),
                      labelText: 'Sexe',
                      items: sexe,
                    ),
                    TextFormField(
                        controller: nomController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            hintText: "Nom",
                            hintStyle: TextStyle(color: Colors.grey)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Entrez votre nom");
                          }
                          return null;
                        }),
                    TextFormField(
                        controller: prenomController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            hintText: "Prenom",
                            hintStyle: TextStyle(color: Colors.grey)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Entrez votre prenom");
                          }
                          return null;
                        }),
                    TextFormField(
                        controller: telephoneController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            hintText: "Numero de téléphone",
                            hintStyle: TextStyle(color: Colors.grey)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Entrez votre numéro");
                          }
                          /*if(!!RegExp(r"^[0-9]{10}$").hasMatch(value)){
                          return ("Veuillez entrer un numéro de téléphone valide");
                        }*/
                          return null;
                        }),

                    Padding(
                        padding: EdgeInsets.all(8.0), child: Text("Adresse")),
                    TextFormField(
                        controller: numeroController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            hintText: "Numero de voie",
                            hintStyle: TextStyle(color: Colors.grey)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Entrez votre Numero de voie");
                          }
                          return null;
                        }),
                    TextFormField(
                      controller: complementController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          hintText:
                              "facultatif : Complément(exemple : bis,ter,etc...)",
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                    TextFormField(
                        controller: voieController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            hintText: "Voie",
                            hintStyle: TextStyle(color: Colors.grey)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Entrez une adresse");
                          }
                          return null;
                        }),
                    TextFormField(
                        controller: cpController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            hintText: "Code Postal",
                            hintStyle: TextStyle(color: Colors.grey)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Entrez un code postal");
                          }
                          if (!RegExp(r"^[0-9]{5}$").hasMatch(value)) {
                            return ("Veuillez entrer exactemet 5 chiffres");
                          }
                          return null;
                        }),
                    TextFormField(
                        controller: villeController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            hintText: "Ville",
                            hintStyle: TextStyle(color: Colors.grey)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Entrez une ville");
                          }
                          return null;
                        }),
                    // Select avec les villes correspondat au Code Postal
                    ElevatedButton(
                        child: Text("Valider"),
                        onPressed: () {
                          List<Map> info = [
                            {"sexe": sexeController.text},
                            {"nom": nomController.text},
                            {"prenom": prenomController.text},
                            {"telephone": telephoneController.text},
                            {"numero": numeroController.text},
                            {"voie": voieController.text},
                            {"complement": complementController.text},
                            {"code postal": cpController.text},
                            {"ville": villeController.text},
                          ];
                          if (_formKey.currentState!.validate()) {
                            changeLivraisonFB(info);
                            Navigator.of(context).pop();
                          }
                        })
                  ],
                ),
              ),
            ),
          );
        });
  }

  void deconnexionFB() {
    FirebaseAuth.instance.signOut().then((value) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Accueil()));
    });
  }

  List infos = [];
  String infosUtil() {
    if (infos.isNotEmpty) {
      String a = '';
      String adr = '';
      if (infos[6].values.toString().replaceAll("(", "").replaceAll(")", "") !=
          "") {
        adr = infos[4]
                .values
                .toString()
                .replaceAll("(", "")
                .replaceAll(")", "") +
            " " +
            infos[6].values.toString().replaceAll("(", "").replaceAll(")", "") +
            " " +
            infos[5].values.toString().replaceAll("(", "").replaceAll(")", "");
      } else {
        adr = infos[4]
                .values
                .toString()
                .replaceAll("(", "")
                .replaceAll(")", "") +
            " " +
            infos[5].values.toString().replaceAll("(", "").replaceAll(")", "");
      }
      if (infos[0].values.toString().replaceAll("(", "").replaceAll(")", "") ==
          "Homme") {
        a = "M.";
      } else {
        a = "Mme";
      }
      return " $a ${infos[1].values.toString().replaceAll("(", "").replaceAll(")", "")} ${infos[2].values.toString().replaceAll("(", "").replaceAll(")", "")} \n ${infos[3].values.toString().replaceAll("(", "").replaceAll(")", "")} \n Adresse : $adr \n ${infos[7].values.toString().replaceAll("(", "").replaceAll(")", "")} ${infos[8].values.toString().replaceAll("(", "").replaceAll(")", "")} ";
    } else {
      return "Vous n'avez pas encore entrer d'informations de livraisons";
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel.uid)
        .get()
        .then((value) {
      setState(() {
        if (value.data()!["infos"] != null) {
          infos = value.data()!["infos"];
        } else {
          infos = [];
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset:
            false, // La fenetre ne bouge pas lorsque le clavier est sorti
        backgroundColor: Colors.grey.shade900,
        appBar: MyAppBar(),
        body: Center(
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(50, 100, 50, 10),
                  child: affichePP()),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("${userModel.pseudo}",
                        style: TextStyle(color: Colors.white70, fontSize: 20)),
                    IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          changerPseudo();
                        }),
                  ]),
              SizedBox(
                  child: Text(
                infosUtil(),
                style: TextStyle(color: Colors.white70, fontSize: 18),
              )),
              ElevatedButton(
                  child: Text("Entrer/Modifier vos informations de livraisons"),
                  onPressed: () {
                    coordLivraison();
                  }),
              Padding(
                  padding: EdgeInsets.fromLTRB(50, 100, 50, 20),
                  child: ElevatedButton(
                      onPressed: () {
                        deconnexionFB();
                      },
                      child: Text("Deconnexion")))
            ],
          ),
        ));
  }
}

class Grandprix extends StatelessWidget {
  const Grandprix({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Center(
        child: Column(
          children: [
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }
}

class Message extends StatelessWidget {
  const Message({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Center(
        child: Column(
          children: [
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }
}

class Reglage extends StatelessWidget {
  const Reglage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Center(
        child: Column(
          children: [
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }
}
