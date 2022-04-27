// ignore_for_file:  prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable, avoid_print


import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:interface_connexion/maindebut_interface_jeux.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  
  await Firebase.initializeApp();   // L'application doit attendre le lancement de FireBase avant de se lancer
  runApp(MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      title: 'Tutoriel Flutter',
      debugShowCheckedModeBanner: false,
      home: Accueil(),
    );
  }
}

class Accueil extends StatefulWidget {
  const Accueil({Key? key}) : super(key: key);

  @override
  State<Accueil> createState() => Page();
}

class Page extends State<Accueil>{

void connexionFireBase() {                        // Fonction de connexion a son compte
final firebaseAuth = FirebaseAuth.instance;       //Initialisation de l'instance FireBase
firebaseAuth
    .signInWithEmailAndPassword(                        // Fonction de FireBase qui permet de s'autenfier qui prend en parametre le mail et le mdp saisie dans le formulaire
        email: mailController.text, password: mdpController.text)
    .then((result) {                                   
      bool emailVerified = result.user!.emailVerified; // Ensuite on verifie que le compte a bien été verifie si oui on emmene a la page d'Accueil
      if (emailVerified){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
      }    
      else{showDialog(                                                                    // Si non on fait apparaitre une fenetre qui dit que le comtpe n'a pas été verif
        context: context,
        builder: (BuildContext context) {
        return AlertDialog(
            title: Text("Vérification mail"),
            content: Text('Vous devez verifier votre mail avant de pouvoir vous connecter.'),
            actions: [
            TextButton(
                child: Text("Ok"),
                onPressed: () {
                Navigator.of(context).pop();
                },
            )
          ]
        );
        });
      }
      })
    .catchError((err) {               // Si probleme rencontre lors de la connexion(pb de mdp, etc...) on fait apparaitre une fennetre qui signale l'erreur
    String a = '';
    switch(err.code) { 
    case 'user-disabled': { 
      a ='L\'utilsateur a été desactivé';
    } 
    break; 
    case 'user-not-found': { 
      a = 'L\'utilisateur est introuvable'; 
    } 
    break; 
    case 'wrong-password': { 
      a = 'Mot de passe incorrect'; 
    } 
    break;
    }
      print(a);
      showDialog(
        context: context,
        builder: (BuildContext context) {
        return AlertDialog(
            title: Text("Erreur"),
            content: Text(a),
            actions: [
            TextButton(
                child: Text("Ok"),
                onPressed: () {
                Navigator.of(context).pop();
                },
            )
            ],
        );
        });
});
}

void connexnionAvecFacebook() async{
    final facebookLoginResult = await FacebookAuth.instance.login();
    final facebookAuthCredential = FacebookAuthProvider.credential(facebookLoginResult.accessToken!.token);
    final firebaseAuth = FirebaseAuth.instance; 
    await firebaseAuth.signInWithCredential(facebookAuthCredential).then((result) {                             
Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
}); 
       
}

void connexionAvecGoogle() async{
  final googleSignIn = GoogleSignIn();
  final utilisateur = await googleSignIn.signIn();
  final auth = await utilisateur!.authentication;

  final credential = GoogleAuthProvider.credential(
    accessToken: auth.accessToken,
    idToken: auth.idToken,
  );

  final firebaseAuth = FirebaseAuth.instance; 
  firebaseAuth.signInWithCredential(credential).then((result) {                            
Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));      });
}

  bool val = false;             
  Widget fb = const Image( image: ExactAssetImage("assets/facebook.jpg"),height: 70.0,    // On construit les Widgets d'Image de Facebook et Google
  width: 70.0);

  Widget google = const Image( image: ExactAssetImage("assets/google.png"),height: 70.0,
  width: 70.0);

  TextEditingController mailController = TextEditingController(); // On initialise les controlleurs qui vont permettre de recuperer la valeur saisie dans les TextFormField et la cle qui permet de verif la validite du form
  TextEditingController mdpController = TextEditingController();
  final _key = GlobalKey<FormState>();                                        

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async => false,
      child:  Scaffold(
        resizeToAvoidBottomInset:false,             // La fenetre ne bouge pas lorsque le clavier est sorti 
        backgroundColor:Colors.grey.shade900,       // Couleur de fond
          body: Form(
          key: _key, 
          child :Padding(     // Mettre de l'espacement
          padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment:MainAxisAlignment.center,  // centrer le contenu
              children: <Widget>[ // Contient tous les widgets qui seront dans le corps de la page  

                TextFormField(
                  controller: mailController,
                  style:TextStyle(color:Colors.white70),            // Zone d'entrée de texte 
                  decoration: InputDecoration(hintText: "Mail",hintStyle: TextStyle(color: Colors.white70)), // Pour avoir le Mail ecrit en fond avant de commencer a ecrire 
                  validator: (value) {
                    // Verifier que le Field n'est pas vide 
                    if (value!.isEmpty) {
                      return ("Veuillez entrer un mail");
                    }
                    // Verifier que le mail a bien un format de mail 
                    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                      return ("Veuillez entrer un mail valide");
                    }
                    return null;
                  }
                ),
                 TextFormField(
                  style:TextStyle(color:Colors.white70), 
                  controller: mdpController,
                  obscureText: true, // Pour que le texte caché soit masqué
                  decoration: InputDecoration(hintText: "Mot de passe",hintStyle: TextStyle(color: Colors.white70)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Veuillez entrer un mot de passe");
                    }
                    return null;
                  }
                ),
                Padding(padding: const EdgeInsets.fromLTRB(15, 30, 15,15),
                child: TextButton(
                  style: TextButton.styleFrom(
                     primary: Colors.greenAccent.shade400,
                     backgroundColor: Colors.yellow.shade700,
                     textStyle: const TextStyle(fontSize: 20),
                     fixedSize: const Size(300, 50)
                     ),
                    onPressed: () {
                      if (_key.currentState!.validate()) {connexionFireBase();}
                      },
                    child: const Text(
                          'Valider',
                           style: TextStyle(
                           color: Colors.black,
                          ),
                    ),
                )
                ),

                // Lien vers la page pour reinitialiser son mot de passe 
                InkWell( child: const Text('Mot de passe oublié ?',style: TextStyle(color: Colors.white70)), 
                onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MdpOublie()))),
                
                // Conteneur des boutons de connexion avec FaceBook et Google
                Padding(padding: const EdgeInsets.fromLTRB(15, 15, 15,15),
                child:
                Row(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children:[
                IconButton(
                    onPressed: (){connexnionAvecFacebook();},
                    tooltip: 'Connexnion avec Facebook',
                    icon: fb ),
                IconButton(
                    onPressed: (){connexionAvecGoogle();},
                    tooltip: 'Connexion avec Google',
                    icon: google ) 
                  ])),

                  // Lien vers la Création de Compte
                  Text('Pas encore de compte ? Créez en un ici',style: TextStyle(color: Colors.white54),),
                  TextButton(
                     style: TextButton.styleFrom(
                     primary: Colors.black,
                     backgroundColor: Colors.grey.shade400,
                     ),
                    child: Text('Créer un compte'),
                    onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CreerCompte()));
                   },),

                   const Padding(padding: EdgeInsets.fromLTRB(15, 100, 15,0),
                   child:Text('Compte supprimé apres 6 mois d\'inactivité \n Réinscription nécessaire pour avoir accès au jeu !',textAlign: TextAlign.center,style: TextStyle(color:Colors.grey),)
                  ),
              ],
            ),
          ),
          )
    ));
  }  
}

class CreerCompte extends StatefulWidget {
  const CreerCompte({Key? key}) : super(key: key);

  @override
  State<CreerCompte> createState() => CreationCompte();
}

class CreationCompte extends State<CreerCompte>{

  Future<bool> validerAgeEtCond() async {
    bool valide = true;
    await showDialog (
          context: context,                            
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Validation"),
              content: Text("En cliquant sur Oui, vous certifiez avoir plus de 16 et accepetez les conditions d'utilisations."),
              actions: [
                TextButton(
                  child: Text("Non"),
                  onPressed: (){
                    setState(() {
                      valide = false;
                    });
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("Oui"),
                  onPressed: () {
                    setState(() {
                      valide = true;
                    });
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
        );
      return valide;
  }
  
  void creationCompte() {     // Fonction pour s'enregistrer dans la BDD
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;  // Initialisation de l'instance FireStore qui permet de stocker les donnees
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    firebaseAuth
        .createUserWithEmailAndPassword(                                // On cree un moyen d'authentification 
            email: emailController.text, password: mdpController.text)
        .then((result) {
        result.user!.sendEmailVerification();
        firebaseFirestore                           // On ajoute l'utilsateur a la BDD avec les infos qu'il a saisi
          .collection("users")
          .doc(result.user!.uid)
          .set({
            "email":emailController.text,
            "pseudo":pseudoController.text,
            "points":0,
            "photo":'pdp.jpg'
      });
    }).then((res) {                                       // On l'emmene sur la page qui dit qu'il doit valider son mail 
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CompteCree()));
      }).catchError((err) {
      showDialog(
          context: context,                             // Si pb rencontre(deja un compte avec ce mail,etc..) message d'erreur qui s'affiche
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.message),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }

  void creationCompteFaceBook() async{ 
    if ((await validerAgeEtCond())== true){
    try {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;  // Initialisation de l'instance FireStore qui permet de stocker les donnees
    final facebookLoginResult = await FacebookAuth.instance.login();
    final userData = await FacebookAuth.instance.getUserData();

    final facebookAuthCredential = FacebookAuthProvider.credential(facebookLoginResult.accessToken!.token);
    FirebaseAuth.instance.signInWithCredential(facebookAuthCredential).then((result) {
        firebaseFirestore                           // On ajoute l'utilsateur a la BDD avec les infos qu'il a saisi
          .collection("users")
          .doc(result.user!.uid)
          .set({
            'email': userData['email'],
            'pseudo': userData['name'],
            'photo': userData['picture']['data']['url'],
            'points':0,
      });
    }).then((res) {
      Fluttertoast.showToast(
        msg: "Compte crée avec succès",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0
    );                                      
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Accueil()));
      });
    }
    on FirebaseAuthException catch (e) {
      var err = '';
      switch (e.code) {
        case 'account-exists-with-different-credential':
          err = 'Un compte a deja été crée via un autre moyen avec cet email';
          break;
        case 'invalid-credential':
          err = 'Une erreur inconnue est survenue';
          break;
        case 'operation-not-allowed':
          err = 'L\'opération n\'a pas été autorisée';
          break;
        case 'user-disabled':
          err = 'Cet utilisateur a été desactivé';
          break;
        case 'user-not-found':
          err = 'L\'utilisateur n\'a pas été trouvé';
          break;
      }
      showDialog(context: context, builder: (context) => AlertDialog(
        title: Text('La création de compte avec FaceBook a echoué'),
        content: Text(err),
        actions: [TextButton(onPressed: () {
          Navigator.of(context).pop();

        }, child: Text('Ok'))],
      ));

    }}
  }

  void creationCompteGoogle() async{
  if ((await validerAgeEtCond())== true){
  final googleSignIn = GoogleSignIn();
  final utilisateur = await googleSignIn.signIn();
  final auth = await utilisateur!.authentication;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;  // Initialisation de l'instance FireStore qui permet de stocker les donnees

  final credential = GoogleAuthProvider.credential(
    accessToken: auth.accessToken,
    idToken: auth.idToken
  );

  FirebaseAuth.instance.signInWithCredential(credential).then((result) {
        firebaseFirestore                           // On ajoute l'utilsateur a la BDD avec les infos qu'il a saisi
          .collection("users")
          .doc(result.user!.uid)
          .set({
            'email':utilisateur.email ,
            'pseudo':utilisateur.email,
            'photo':utilisateur.photoUrl,
            'points':0,
      });
    }).then((res) {        
      Fluttertoast.showToast(
        msg: "Compte crée avec succès",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0
    );                              
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Accueil()));
      });
  }
  }

  // On initialise les valeurs dont on aura besoin pour le Form
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController pseudoController = TextEditingController();
  TextEditingController mdpController = TextEditingController();
  TextEditingController rmdpController = TextEditingController();
  bool val = false;
  bool val2 = false;
  Widget affiche = InkWell( child: const Text('J\'accepte les termes et conditions d\'utilisation',style: TextStyle(color: Colors.white70,decoration: TextDecoration.underline)), 
  onTap: () => launch('https://www.twitch.tv/'));
  Widget fb = const Image( image: ExactAssetImage("assets/facebook.jpg"),height: 70.0,    // On construit les Widgets d'Image de Facebook et Google
  width: 70.0);

  Widget google = const Image( image: ExactAssetImage("assets/google.png"),height: 70.0,
  width: 70.0);


  @override
  Widget build(BuildContext context) {

  return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset:false, // Widget immobile quand on deploie le clavier
        backgroundColor:Colors.grey.shade900,
          body: Form(
          key: _formKey,      // La cle qui permettra de verifier si le Form est valide
          child :Padding(     // Mettre de l'espacement
          padding: const EdgeInsets.fromLTRB(30, 0, 30,30),
            child: Column(
              mainAxisAlignment:MainAxisAlignment.center,  // centrer le contenu
              children: <Widget>[
                // Conteneur des boutons de connexion avec FaceBook et Google
                Padding(padding: const EdgeInsets.fromLTRB(15, 15, 15,15),
                child:
                Row(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children:[
                IconButton(
                    onPressed: (){creationCompteFaceBook();},
                    tooltip: 'Créer un compte avec Facebook',
                    icon: fb ),
                IconButton(
                    onPressed: (){creationCompteGoogle();},
                    tooltip: 'Créer un compte avec Google',
                    icon: google ) 
                  ])),
                TextFormField( 
                  controller: pseudoController, 
                  style:TextStyle(color:Colors.white70),            // Zone d'entrée de texte 
                  decoration: InputDecoration(hintText: "Pseudo",hintStyle: TextStyle(color: Colors.white70)), // Pour avoir le Mail ecrit en fond avant de commencer a ecrire 
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Veuillez entrer un pseudo");
                    }
                    return null;
                  }
                ),
                TextFormField(
                  controller: emailController,   
                  style:TextStyle(color:Colors.white70),           // Zone d'entrée de texte 
                  decoration: InputDecoration(hintText: "Mail",hintStyle: TextStyle(color: Colors.white70)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Veuillez entrer un mail");
                     }
                  // Expression reguliere pour format email valide
                    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
                      return ("Veuillez entrer un mail valide");
                    }
                    return null;
                 },
                ),
                TextFormField(
                  controller: mdpController,
                  obscureText: true,            // Zone d'entrée de texte 
                  style:TextStyle(color:Colors.white70),
                  decoration: InputDecoration(hintText: "Mot de passe",hintStyle: TextStyle(color: Colors.white70)),
                  validator: (value) {
                    // On verifie que le mdp fait au moins 7 caracteres
                    RegExp expr = RegExp(r'^.{7,}$');
                    if (value!.isEmpty) {
                      return ("Veuillez entrer un mot de passe");
                    }
                    if (!expr.hasMatch(value)) {
                      return ("Veuillez entrer un mot de passe qui fait plus que 7 caractères");
                    }
                  }, 
                ),
                TextFormField( 
                  controller: rmdpController,
                  obscureText: true,           // Zone d'entrée de texte 
                  style:TextStyle(color:Colors.white70),
                  decoration: InputDecoration(hintText: "Repeter mot de passe",hintStyle: TextStyle(color: Colors.white70)),
                  validator: (value) {
                    // On verifie que le mdp et le repeter mdp correspondent 
                    if (mdpController.text != value) {
                    return "Les mots de passe ne correspondent pas";
                  }
                  return null;
                  }, 
                ),

                CheckboxListTile( // Checkbox 
                    controlAffinity : ListTileControlAffinity.leading , // Pour que le texte soit à droite de la checkbox 
                    value: val,
                    onChanged: (value) { // ce qu'on fait quand la checkbox est validée
                    setState(() {
                      val = !val;
                      });
                    },
                    title : Text('Je certifie avoir plus de 16 ans',style: TextStyle(color: Colors.white54)) ,
                ),

                CheckboxListTile( // Checkbox 
                    controlAffinity : ListTileControlAffinity.leading , // Pour que le texte soit à droite de la checkbox 
                    value: val2,
                    onChanged: (value) { // ce qu'on fait quand la checkbox est validée
                    setState(() {
                      val2 = !val2;
                      });
                    },
                    title : affiche ,
                ),
                Padding(padding:const  EdgeInsets.fromLTRB(15, 30, 15,15),
                child:
                TextButton(
                  style: TextButton.styleFrom(
                     primary: Colors.greenAccent.shade400,
                     backgroundColor: Colors.greenAccent.shade400,
                     textStyle: const TextStyle(fontSize: 20),
                     fixedSize: const Size(300, 50)
                     ),
                    onPressed: () 
                    {
                      // On verifie que toutes les conditions du formulaire sont valides puis on appelle la methode de connexion
                      if (_formKey.currentState!.validate() & val & val2) {
                          creationCompte();
                     }

                    },
                    child: const Text(
                          'Valider ',
                           style: TextStyle(
                           color: Colors.white,
                          ),
                    ),
                  ),
                ),
                Padding(padding:const  EdgeInsets.fromLTRB(15, 30, 15,15),
                child:
                TextButton(
                  style: TextButton.styleFrom(
                     primary: Colors.greenAccent.shade400,
                     backgroundColor: Colors.red,
                     textStyle: const TextStyle(fontSize: 20),
                     fixedSize: const Size(300, 50)
                     ),
                    onPressed: () {Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Accueil()));},
                    child: const Text(
                          'Retour acceuil',
                           style: TextStyle(
                           color: Colors.white,
                          ),
                    ),
                )
                )    
              ]
            )
          )
        )
      )); 
  }
}

class MdpOublie extends StatelessWidget {
  TextEditingController mailRecupController = TextEditingController();
  final _key = GlobalKey<FormState>();

  Widget logo = const Image( image: ExactAssetImage("assets/logo.PNG"),height: 70.0,
  width: 70.0); 
  @override
  Widget build(BuildContext context) {

  return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset:false, // Widget immobile quand on deploie le clavier
        backgroundColor:Colors.grey.shade900,
          body: Padding(     // Mettre de l'espacement
          padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment:MainAxisAlignment.center,  // centrer le contenu
              children: <Widget>[  
                // Contient tous les widgets qui seront dans le corps de la page 
                Padding(padding:const  EdgeInsets.fromLTRB(15, 30, 15,15),child:logo),
                Text('Mot de passe oublie ?',textAlign: TextAlign.center,style:TextStyle(fontWeight:FontWeight.bold,fontSize: 20,color: Colors.white70)),
                Text('Veuillez saisir votre email utilisé lors de l\'inscription',textAlign: TextAlign.center,style:TextStyle(color: Colors.white54)),
                Padding(padding:const  EdgeInsets.fromLTRB(15, 30, 15,15),
                child:
                Form(
                key:_key,      
                child:            
                TextFormField(   
                  controller:mailRecupController,
                  style:TextStyle(color:Colors.white70),          // Zone d'entrée de texte 
                  decoration: InputDecoration(hintText: "Saissisez votre mail",hintStyle: TextStyle(color: Colors.white70)), // Pour avoir le Mail ecrit en fond avant de commencer a ecrire 
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Veuillez entrer un mail");
                    }
                    return null;
                  }
                ),
                ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                     primary: Colors.greenAccent.shade400,
                     backgroundColor: Colors.greenAccent.shade400,
                     textStyle: const TextStyle(fontSize: 20),
                     fixedSize: const Size(300, 50)
                     ),
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                          final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                         _firebaseAuth.sendPasswordResetEmail(email:mailRecupController.text);  // Methode de firebase pour envoyer un mail de recuperation de mdp 
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MailEnvoye()));  
                     }
                      },
                    child: const Text(
                          'Valider',
                           style: TextStyle(
                           color: Colors.white,
                          ),
                    ),
                ),
                Padding(padding:const  EdgeInsets.fromLTRB(15, 30, 15,15),
                child:
                TextButton(
                  style: TextButton.styleFrom(
                     primary: Colors.greenAccent.shade400,
                     backgroundColor: Colors.red,
                     textStyle: const TextStyle(fontSize: 20),
                     fixedSize: const Size(300, 50)
                     ),
                    onPressed: () {Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Accueil()));},
                    child: const Text(
                          'Retour acceuil',
                           style: TextStyle(
                           color: Colors.white,
                          ),
                    ),
                )
                )
              ]
            )
          )
  ));
  }
} 

class CompteCree extends StatelessWidget{
@override
  Widget build(BuildContext context) {
  return WillPopScope(
      onWillPop: () async => false,
      child:  Scaffold(
    backgroundColor:Colors.grey.shade900,
          body: Padding(     // Mettre de l'espacement
          padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment:MainAxisAlignment.center,  // centrer le contenu
              children: <Widget>[
              Image(
                image: AssetImage("assets/validé.gif"),
              ),
              Padding(padding:const  EdgeInsets.fromLTRB(15, 30, 15,15),
              child: Text('Votre compte a bien été crée, veuillez verifier votre email pour valider la création.',style: TextStyle(color: Colors.white70,fontSize: 20),),
              ),
              Padding(padding:const  EdgeInsets.fromLTRB(15, 30, 15,15),
                child:
                TextButton(
                  style: TextButton.styleFrom(
                     primary: Colors.greenAccent.shade400,
                     backgroundColor: Colors.red,
                     textStyle: const TextStyle(fontSize: 20),
                     fixedSize: const Size(300, 50)
                     ),
                    onPressed: () {Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Accueil()));},
                    child: const Text(
                          'Retour acceuil',
                           style: TextStyle(
                           color: Colors.white,
                          ),
                    ),
                )
                )
              ],
            )
          )
     ));
  }
}

class MailEnvoye extends StatelessWidget{
@override
  Widget build(BuildContext context) {
  return WillPopScope(
      onWillPop: () async => false,
      child:  Scaffold(
    backgroundColor:Colors.grey.shade900,
          body: Padding(     // Mettre de l'espacement
          padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment:MainAxisAlignment.center,  // centrer le contenu
              children: <Widget>[
              Image(
                image: AssetImage("assets/envoi.gif"),
              ),
              Padding(padding:const  EdgeInsets.fromLTRB(15, 30, 15,15),
                child:
                Text('Si l\'adresse que vous saisissez appartient à un compte existant,un e-mail vous sera envoyé prochainement.',textAlign: TextAlign.center,style:TextStyle(color: Colors.white54)),
                ),
              Padding(padding:const  EdgeInsets.fromLTRB(15, 30, 15,15),
                child:
                TextButton(
                  style: TextButton.styleFrom(
                     primary: Colors.greenAccent.shade400,
                     backgroundColor: Colors.red,
                     textStyle: const TextStyle(fontSize: 20),
                     fixedSize: const Size(300, 50)
                     ),
                    onPressed: () {Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Accueil()));},
                    child: const Text(
                          'Retour acceuil',
                           style: TextStyle(
                           color: Colors.white,
                          ),
                    ),
                )
                )
              ],
            )
          )
     ));
  }
}






