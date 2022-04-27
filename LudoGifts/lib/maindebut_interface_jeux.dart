// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state

import 'dart:io';
import 'package:collection/src/iterable_extensions.dart';
import 'paiement.dart';
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

import 'Les_lots.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // On initialise les données de l'utilisateur dès qu'il se connecte
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
      loggedInUser = UserModel.fromMap(value.data());
      loggedInUser.setuid(user!.uid);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        builder: (context) => Jouerenligne(
                              userModel: loggedInUser,
                            )),
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
                              title: '',
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
                        builder: (context) => Achatdepoints(
                              userModel: loggedInUser,
                            )),
                  );
                },
                child: Text(
                  "Achat de points",
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
      backgroundColor: Colors.grey.shade900,
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
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
          Navigator.of(context).push(_createRouteHome());
        },
      ),
      title: Text(
        'LUDO gifts',
        style: GoogleFonts.nunito(
          color: Colors.yellow.shade700,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
      actions: <Widget>[
        Text(
          '${loggedInUser.points} ',
          strutStyle: StrutStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            height: 1.7,
            leading: 1.7,
          ),
          style: GoogleFonts.nunito(
            color: Colors.yellow.shade700,
            fontSize: 15,
          ),
        ),
        const Image(
            image: ExactAssetImage("assets/coin.png"),
            height: 30.0,
            width: 30.0),
      ],
      centerTitle: true,
      backgroundColor: Colors.white24,
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

  // Liste des différentes mises possibles
  final List<Map<String, dynamic>> _items = [
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

  // Création des icones de sélection des fers
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

  // boolean pour connaitre le mode sélectionné
  bool mode1v1 = true;

  // Tableau de boolean pour connaitre le cheval sélectionné
  List<bool> tabBool = [true, false, false, false];

  // Construction de la fenêtre qui apparait lors du lancement de la partie
  Future enRecherchePartie(int uneMise, bool mode) {
    String m;
    if (mode == true) {
      m = "1v1";
    } else {
      m = "1v3";
    }

    // À modifier pour que l'utilisateur soit ajouté avec quelque chose qui permet de l'identifier pour le supprimer(p-e)
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
          msg: "Votre photo de profil a bien été modifiée",
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
                            hintText: "Prénom",
                            hintStyle: TextStyle(color: Colors.grey)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Entrez votre prénom");
                          }
                          return null;
                        }),
                    TextFormField(
                        controller: telephoneController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            hintText: "Numéro de téléphone",
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
                            hintText: "Numéro de voie",
                            hintStyle: TextStyle(color: Colors.grey)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Entrez votre numéro de voie");
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
                            return ("Veuillez entrer exactement 5 chiffres");
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
      return "Vous n'avez pas encore entré d'information de livraison";
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
            false, // La fenêtre ne bouge pas lorsque le clavier est sorti
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
                  child: Text("Entrer/Modifier vos informations de livraison"),
                  onPressed: () {
                    coordLivraison();
                  }),
              Padding(
                  padding: EdgeInsets.fromLTRB(50, 100, 50, 20),
                  child: ElevatedButton(
                      onPressed: () {
                        deconnexionFB();
                      },
                      child: Text("Déconnexion")))
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

class Reglage extends StatelessWidget {
  const Reglage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      backgroundColor: Colors.grey.shade900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // centrer le contenu
          children: [
            Container(
              padding: const EdgeInsets.only(top: 100, bottom: 75),
              child: ElevatedButton(
                  child: const Text(
                    ' CONDITIONS\n  GÉNÉRALES\nD\'UTILISATION',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                onPressed: () => Navigator.of(context).push(goToCGU()),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(250, 100),
                  onPrimary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  primary: Colors.yellow.shade700,
                )
              ),
            ),
            ElevatedButton(
              child: const Text(
                'RÈGLES DU JEU',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onPressed: () => Navigator.of(context).push(goToRules()),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(250, 100),
                onPrimary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                primary: Colors.grey.shade400,
              )
            ),
            Container(
              padding: const EdgeInsets.only(top: 75),
              child: InkWell(
                child: const Text(
                  'CONTACT',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  )
                )
              )
            ),
            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 100),
              child: InkWell(
                child: const Text(
                  'feur@gmail.com',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  )
                )
              )
            )
          ]
        )
      )
    );
  }
}

Route goToCGU() {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const PageCGU(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          child);
}

Route goToRules() {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const PageRules(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          child);
}

class PageCGU extends StatelessWidget {
  const PageCGU({Key? key}) : super(key: key);

  // Affiche chaque élément de items sur sa propre ligne (alignement vertical simple et double)
  List<String> lines(List<String> items) => items.map((x) => "$x\n").toList();
  List<String> bigLines(List<String> items) => items.map((x) => "$x\n\n").toList();

  // Affiche chaque élément de items dans des listes (non-numérotées et numérotées)
  List<String> bullet(List<String> items) => items.map((x) => "· $x").toList();
  List<String> dashBullet(List<String> items) => items.map((x) => "- $x").toList();
  List<String> numberedBullet(List<String> items) => items.mapIndexed((i, x) => "${i + 1}.\t$x").toList();

  // Concatène tous les items vers une String (utile pour composer les fonctions précédentes ensembles)
  String c(List<String> items) => items.reduce((a, b) => a + b);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      backgroundColor: Colors.grey.shade900,
      body: SingleChildScrollView( //On rend la page scrollable
        padding: const EdgeInsets.all(30),
        child: RichText(
          text: TextSpan(
            text: c(lines([
                c(numberedBullet([
                  c(lines([
                    "\tObjet : Présentation du projet",
                    c(bigLines([
                      "Le présent document a pour but de décrire un projet de jeu vidéo LUDO gifts payant pour les utilisateurs qui permet de faire gagner des lots ou des sommes d’argent.",
                      "Le périmètre du document couvre uniquement la question de la légalité au projet au regard du droit des jeux d’argent et de hasard français[1]. Toute autre question est expressément exclue du présent document."
                    ]))
                  ])),
                  c(lines([
                    "\tLe principe du jeu LUDO gifts.",
                    c(bigLines([
                      "Le jeu est une compétition qui confronte, à partir d'un jeu vidéo, de 2 joueurs à 4joueurs pour un score ou une victoire. Le joueur victorieux peut recevoir un lot ou un prix.",
                      "Il s’agit d’une application mobile à télécharger sur les stores (Google Play et l’App Store d’Apple[2]) avec des éléments de création visuelle et informatique. L’application permet une série d’interactions entre le joueur et LUDO gifts avec des situations simulées se présentant sous forme d'images animées et sonorisées."
                    ]))
                  ])),
                  c(lines([
                    "\tLe paiement du joueur possible lors du téléchargement de l’application, pour des achats de contenus additionnels et pour un abonnement.",
                    c(bigLines([
                      "Le joueur est amené lors de son inscription, outre le coût de sa connexion à internet, à payer une somme en euro à l’éditeur du jeu pour télécharger celui-ci.",
                      c(lines([
                        "La dépense du joueur porte uniquement sur :",
                        c(bigLines(dashBullet([
                          "Le coût d'achat initial du jeu (frais au téléchargement) – Ce coût est à préciser par le client ;",
                          "Le coût d'achat de ses contenus additionnels (Skill, avatar, images, points) – il est précisé que ces achats additionnels de contenus ne peuvent en aucun cas influer sur les chances de victoire des joueurs. Ces dépenses ne donnent aucun pouvoir supplémentaire ou aucun point de vie dans les compétitions ; – Ce coût éventuel est à préciser par le client -",
                          "Et le coût d'abonnement au jeu (licence mensuelle, annuelle, etc.).– Ce coût est à préciser par le client ainsi que la durée de l’abonnement ;"
                        ])))
                      ])),
                      "Selon la loi française ces dépenses de jeu sont expressément exclues de la définition du sacrifice financier selon les articles L321-11[3] CSI et R 321-50 CSI[4]. Dès lors le jeu ne rentre pas dans le périmètre interdit des jeux d’argent et de hasard selon l’article L320-1 CSI[5].",
                      "Sous réserve de la législation sur la vente à distance (droit de rétractation de l’acheteur …), la dépense du joueur est définitive.",
                      "Afin de respecter la prohibition des jeux d’argent, il ne peut être réalisé aucune mise payante par les joueurs ou par des parieurs tiers au jeu en argent réel lors des compétitions. Par mise on entend le fait pour un joueur ou un tiers parieur de procéder à une dépense quelconque lors de la compétition dans l’espoir de remporter tout ou partie de la somme payée par son adversaire, sauf les exceptions des articles L321-11[6] CSI et R 321-50 CSI[7]."
                    ]))
                  ])),
                  c(lines([
                    "\t L’espoir de gagner un lot ou un prix pour le joueur gagnant.",
                    c(bigLines([
                      "Lorsque le joueur gagne une ou plusieurs victoires lors des compétitions, il peut bénéficier de lots ayant une valeur monétaire (objet, produit, service) voire même une somme d’argent.",
                      "La liste des gains est à préciser."
                    ]))
                  ])),
                  c(lines([
                    "\t Le jeu est ouvert aux personnes physiques de 16 ans ou plus.",
                    c(bigLines([
                      "Le joueur est une personne physique de 16 ans ou plus.",
                      "Lors de son inscription, il sera demandé au joueur copie d’une pièce d’identité et un email valide.",
                      "Il est tenu compte de l’encadrement très spécifique du eSport chez les mineurs.",
                      c(bigLines(dashBullet([
                        "Elle est interdite pour les mineurs de moins de 12 ans[8] ;",
                        "Elle est soumise entre 12 et 18 ans ainsi à un régime très spécifique[9] notamment ;"
                      ]))),
                      c(bigLines(bullet([
                          "Le recueil de l'autorisation du représentant légal du mineur ;",
                          "La justification de l’identité du mineur et du des représentants légaux grâce à un titre d’identité ;",
                          "Une part des rémunérations du mineur est conservée sur un compte spécifique à la Caisse des dépôts et consignation."
                      ])))
                    ]))
                  ]))
                ])),
                c(bigLines(bigLines([ "Pascal Reynaud", "Avocat au barreau de Strasbourg", "reynaud.avocat@gmail.com" ]))),
                c(bigLines([
                  "[1]Par droit des jeux d’argent et de hasard on entend :  le Code de la Sécurité Intérieure aux articles 320-1 et suivant dans sa version applicable à compter du 1er janvier 2020 (ci-après CSI & la loi n° 2010-476 du 12 mai 2010 relative à l'ouverture à la concurrence et à la régulation du secteur des jeux d'argent et de hasard en ligne.",
                  "[2] Attention, Google et APPLE peuvent appliquer des politiques plus strictes que la loi française. En particulier, Google exige que les jeux avec des lots à gagner soient gratuits et que cela soit mentionné sur les informations relatives au jeu (CGU/CGV etc.).",
                  "[3] Article L321-11 CSI : Pour les compétitions de jeux vidéo se déroulant en ligne et pour les phases qualificatives se déroulant en ligne des compétitions de jeux vidéo, les frais d'accès à internet et le coût éventuel d'acquisition du jeu vidéo servant de support à la compétition ne constituent pas un sacrifice financier au sens de l'article L. 320-1.",
                  "[4] Article R321-50 CSI : Pour l'application de l'article L. 321-11, le coût d'achat éventuel du jeu vidéo servant de support à la compétition comprend le coût d'achat initial du jeu, le coût d'achat de ses contenus additionnels et le coût d'abonnement au jeu.",
                  "[5] Article L320-1 CSI : Sous réserve des dispositions de l'article L. 320-6, les jeux d'argent et de hasard sont prohibés. Sont réputés jeux d'argent et de hasard et interdits comme tels toutes opérations offertes au public, sous quelque dénomination que ce soit, pour faire naître l'espérance d'un gain qui serait dû, même partiellement, au hasard et pour lesquelles un sacrifice financier est exigé de la part des participants. Cette interdiction recouvre les jeux dont le fonctionnement repose sur le savoir-faire des joueurs. Le sacrifice financier est établi dans les cas où une avance financière est exigée de la part des participants, même si un remboursement ultérieur est rendu possible par le règlement du jeu.",
                  "[6] Article L321-11 CSI : Pour les compétitions de jeux vidéo se déroulant en ligne et pour les phases qualificatives se déroulant en ligne des compétitions de jeux vidéo, les frais d'accès à internet et le coût éventuel d'acquisition du jeu vidéo servant de support à la compétition ne constituent pas un sacrifice financier au sens de l'article L. 320-1.",
                  "[7] Article R321-50 CSI : Pour l'application de l'article L. 321-11, le coût d'achat éventuel du jeu vidéo servant de support à la compétition comprend le coût d'achat initial du jeu, le coût d'achat de ses contenus additionnels et le coût d'abonnement au jeu.",
                  "[8] Article R321-44 CSI : La participation d'enfants de moins de douze ans à des compétitions de jeux vidéo offrant des récompenses monétaires est interdite.",
                  "[9] Article L321-10 CSI : La participation d'un mineur aux compétitions de jeux vidéo peut être autorisée dans des conditions définies par décret en Conseil d'État. Elle est conditionnée au recueil de l'autorisation du représentant légal de ce mineur. Le représentant légal est informé des enjeux financiers de la compétition et des jeux utilisés comme support de celle-ci. Cette information comprend notamment la référence à la signalétique prévue à l'article 32 de la loi n° 98-468 du 17 juin 1998 relative à la prévention et à la répression des infractions sexuelles ainsi qu'à la protection des mineurs. L'article L. 7124-9 du Code du travail s'applique aux rémunérations de toute nature perçues pour l'exercice d'une pratique en compétition du jeu vidéo par des mineurs de moins de seize ans soumis à l'obligation scolaire."
                ])),
                c(bigLines([
                  "Article R321-43 CSI",
                  c(bigLines(numberedBullet([
                    c(bigLines([
                      "L'autorisation du représentant légal du mineur prévue à l'article L. 321-10 est écrite. L'organisateur conserve une copie pendant un an, éventuellement sous forme dématérialisée, de cette autorisation, ainsi que le numéro, la nature et l'autorité de délivrance du document d'identité du ou des représentants légaux et du mineur concerné.",
                      "Le mineur et le ou les représentants légaux justifient de leur identité par la présentation de leur carte nationale d'identité ou passeport délivrés par l'administration compétente de l'État dont le titulaire possède la nationalité.",
                      "Ces documents doivent être en cours de validité, à l'exception de la carte nationale d'identité française et du passeport français, qui peuvent être présentés en cours de validité ou périmés depuis moins de 5 ans."
                    ])),
                    c(bigLines([
                      "Les dispositions du I s'appliquent y compris lorsqu'une autorisation individuelle préalable est requise en application de l'article L. 7124-1 du Code du travail.",
                      "Article R321-45 CSI",
                      "Pour l'application du deuxième alinéa de l'article L. 321-10 du code la sécurité intérieure, la part des récompenses monétaires, perçues par un enfant âgé de moins de seize ans soumis à l'obligation scolaire dans le cadre de sa participation à des compétitions de jeux vidéo mentionnées à l'article L. 321-8 du code de la sécurité intérieure, dont le montant peut être laissé à la disposition de ses représentants légaux est fixée par arrêté conjoint des ministres chargés du numérique et du travail, en fonction du montant des récompenses.",
                      "L'organisateur de la compétition de jeux vidéo verse le surplus, qui constitue le pécule, à la Caisse des dépôts et consignations en rappelant l'état civil de l'enfant, son domicile et le nom de ses représentants légaux.",
                      "La Caisse des dépôts et consignations ouvre dans ses écritures, au nom de chacun des mineurs intéressés, un compte de dépôt auquel sont portés les versements effectués par les organisateurs de jeux vidéo.",
                      "Elle gère le pécule dans les mêmes conditions que celles prévues par les articles L. 7124-9 et R. 7124-34 à R. 7124-37 du Code du travail.",
                      "Article R321-46 CSI",
                      "Les droits d'inscription et autres sacrifices financiers consentis par les joueurs mentionnés à l'article L. 321-9 désignent l'ensemble des frais payés par les joueurs aux organisateurs pour prendre part à la compétition."
                    ]))
                  ])))
                ]))
            ]))
          )
        )
      )
    );
  }
}

class PageRules extends StatelessWidget {
  const PageRules({Key? key}) : super(key: key);

  // Affiche chaque élément de items sur sa propre ligne (alignement vertical simple et double)
  List<String> lines(List<String> items) => items.map((x) => "$x\n").toList();
  List<String> bigLines(List<String> items) => items.map((x) => "$x\n\n").toList();

  // Affiche chaque élément de items dans des listes non-numérotées
  List<String> bullet(List<String> items) => items.map((x) => "· $x").toList();
  // Concatène tous les items vers une String (utile pour composer les fonctions précédentes ensembles)
  String c(List<String> items) => items.reduce((a, b) => a + b);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      backgroundColor: Colors.grey.shade900,
      body: SingleChildScrollView( //On rend la page scrollable
        padding: const EdgeInsets.all(30),
        child: RichText(
          text: TextSpan(
            text: c(bigLines([
              "Ludo gifts eSport est un jeu de Ludo en ligne. Vous pouvez jouer à Ludo gifts en mode multijoueur en ligne. Le premier joueur à déplacer ses 4 pions dans son triangle de départ remporte la partie !",
              "À propos de Ludo gifts",
              "Ludo gifts eSports est une version en ligne du jeu de société classique Ludo dans un concept innovant où l'on peut remporter des lots en faisant monter sa barre de points. Vous pouvez jouer uniquement contre les participants en ligne. C’est un jeu vraiment facile à apprendre, ce qui le rend adapté aux joueurs de 16 ans et plus.",
              "Règles du Ludo gifts",
              "Le Ludo est un jeu joué à deux ou quatre joueurs. Chaque joueur doit choisir l'une des quatre couleurs disponibles pour jouer.",
              "Le jeu commence avec un lancer de dé de chaque joueur à tour de rôle. Pour qu'un joueur commence à déplacer un pion sur le plateau, il doit obtenir un six. Une fois que vous avez plusieurs pions en jeu, vous pouvez choisir le pion que vous souhaitez déplacer.",
              c(lines(bullet([
                "Si vous avez un ou plusieurs pions en jeu, vous pouvez choisir de retirer un pion ou de déplacer un pion de six cases.",
                "Les joueurs qui obtiennent un six gagnent un jet de dé supplémentaire."
              ]))),
              "Cases occupées",
              c(lines(bullet([
                "Si votre pion atterrit sur une case occupée par un adversaire, son pion retourne à sa base et il doit faire un six pour la retirer.",
                "Si vous atterrissez sur la même case que l'un de vos autres pions, cela bloque le chemin de vos adversaires.",
                "Manger un pion fait rejouer."
              ]))),
              "Comment gagner",
              "Vous remarquerez cinq carrés de chaque couleur se dirigeant vers le milieu. Une fois qu'un de vos pions fait un voyage tout autour du plateau, il suit ce chemin coloré jusqu'à ce qu'il atteigne le centre.",
              "Une fois que vos quatre pions ont atteint le centre, vous avez terminé le jeu. Le gagnant est celui qui parvient à atteindre le centre le premier. Les autres joueurs s'affrontent ensuite jusqu'à ce que tous les pions aient atteint le milieu.",
              "Chaque gagnant remportera les points de son adversaire moins 10% qui reviendront à l'application en mode 1vs1.",
              "Chaque gagnant remportera les points du troisième et quatrième moins 10% qui reviendront à l'application. Le deuxième aura la possibilité de reprendre ses points pour une autre partie en mode 1vs3.",
              "Grand prix",
              "Un grand prix aura lieu toutes les fins de mois. Il faudra avoir les points nécessaires pour y participer. Le principe reste le même, un seul gagnant par table jusqu'au gagnant final qui remportera le prix.",
              "Boutique",
              "Une boutique de lots sera à disposition pour ceux qui ont les points nécessaires pour les atteindre.",
              "Il faudra obligatoirement acheter des points à la boutique de points pour pouvoir jouer."
            ]))
          )
        )
      )
    );
  }
}

Route _createRouteHome() {
  return PageRouteBuilder(
    pageBuilder: (BuildContext context,
        Animation<double> animation, //
        Animation<double> secondaryAnimation) {
      return HomePage();
    },
    transitionsBuilder: (BuildContext context,
        Animation<double> animation, //
        Animation<double> secondaryAnimation,
        Widget child) {
      return child;
    },
  );
}
