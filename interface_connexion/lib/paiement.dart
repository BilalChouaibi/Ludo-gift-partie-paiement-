import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_model.dart';

class Achatdepoints extends StatefulWidget {
  const Achatdepoints({Key? key, required this.userModel}) : super(key: key);
  final UserModel userModel;
  @override
  _AchatdepointsState createState() => _AchatdepointsState(userModel);
}

class _AchatdepointsState extends State<Achatdepoints> {
  UserModel userModel;
  _AchatdepointsState(this.userModel);
  void ajoutPoints(int val) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel.uid)
        .update({"points": FieldValue.increment(val)});
    setState(() {
      userModel.setPoints(val);
    });
  }

  //permet de garder la valeur écrite dans le Textfield
  TextEditingController prix = new TextEditingController();
  //clef statique utilisée générée par braintree afin
  //de pourvoir procéder au paiement.
  //et garde les information lié paiement
  //contrairement au clien token, la clé de tokenisation
  //a des limite, on ne peut pas stocker de carte bancaire
  //ou les informations liée au client
  static final String tokenizationKey = 'sandbox_fwhmcgc6_nrxdmd4h7jk5gzkd';

  void showNonce(int value) {
    //affiche un popup de validation
    //value correspond à la valeur à ajouter
    //coin correspond au nombre de point total du joueur
    ajoutPoints(value);
    showDialog(
      barrierColor: Color.fromRGBO(33, 33, 33, 1),
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.deepPurple[900],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        title: Text(
          'PAIEMENT REUSSI!!!',
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(bottom: 10),
                width: 100,
                height: 100,
                child: Image.asset('assets/coin.png')),
            Text(
              "Voici tes $value pts",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(33, 33, 33, 1),
      appBar: MyAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/coin.png', height: 100, fit: BoxFit.cover),
            Expanded(
              child: Container(
                width: 300,
                padding: const EdgeInsets.all(16.0),
                //à régler
                child: ElevatedButton(
                  //avec async le résulltat des lignes de codes suivante vont
                  //être affichées que lorsque le await est appelé
                  onPressed: () async {
                    //BraintreeDropInRequest sert à faire la demande de paiement à
                    //parir d'un tarif prédéfinit
                    //fonctionne avec googlepay,applepay,CB et paypal
                    var request = BraintreeDropInRequest(
                      tokenizationKey: tokenizationKey,
                      collectDeviceData: true,
                      //fait appel au système de paiement google pay
                      googlePaymentRequest: BraintreeGooglePaymentRequest(
                        totalPrice: '2.89',
                        currencyCode: 'USD',
                        billingAddressRequired: false,
                      ),
                      //fait appel au système de paiement de paypal
                      paypalRequest: BraintreePayPalRequest(
                        amount: '2.89',
                        displayName: 'Example company',
                      ),
                      //possibilité de payement par CB par l'api de braintree
                      cardEnabled: true,
                    );
                    //Pour démarrer la requête de paiement
                    final result = await BraintreeDropIn.start(request);
                    // ici si le paiment est fait alors on peut executer la méthode shownonce
                    if (result != null) {
                      showNonce(10500);
                    }
                  },
                  child: Text(
                    '10500 \n 2.89€',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),

                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.black,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15.0),
                    ),
                    primary: Color.fromRGBO(245, 205, 1, 1),
                  ),
                ),
              ),
            ),
            //à regler
            Expanded(
              child: Container(
                width: 300,
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    var request = BraintreeDropInRequest(
                      tokenizationKey: tokenizationKey,
                      collectDeviceData: true,
                      googlePaymentRequest: BraintreeGooglePaymentRequest(
                        totalPrice: '9.99',
                        currencyCode: 'USD',
                        billingAddressRequired: false,
                      ),
                      paypalRequest: BraintreePayPalRequest(
                        amount: '9.99',
                        displayName: 'Example company',
                      ),
                      cardEnabled: true,
                    );
                    final result = await BraintreeDropIn.start(request);
                    if (result != null) {
                      showNonce(50750);
                    }
                  },
                  child: Text(
                    '50750 \n 9.99€',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.black,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15.0),
                    ),
                    primary: Color.fromRGBO(245, 205, 1, 1),
                  ),
                ),
              ),
            ),
            //à regler
            Expanded(
              child: Container(
                width: 300,
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    var request = BraintreeDropInRequest(
                      tokenizationKey: tokenizationKey,
                      collectDeviceData: true,
                      googlePaymentRequest: BraintreeGooglePaymentRequest(
                        totalPrice: '19.99',
                        currencyCode: 'USD',
                        billingAddressRequired: false,
                      ),
                      paypalRequest: BraintreePayPalRequest(
                        amount: '19.99',
                        displayName: 'Example company',
                      ),
                      cardEnabled: true,
                    );
                    final result = await BraintreeDropIn.start(request);
                    if (result != null) {
                      showNonce(100750);
                    }
                  },
                  child: Text(
                    '100750 \n 19.99€',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.blue,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15.0),
                    ),
                    primary: Color.fromRGBO(245, 205, 1, 1),
                  ),
                ),
              ),
            ),
            //à régler

            Column(
              children: [
                Text(
                  "Achat personnalisé:",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),

                Container(
                  margin: EdgeInsets.only(bottom: 20, top: 20),
                  width: 250,
                  //à régler
                  //Zone de texte qui va être stocké dans la variable String prix
                  child: TextField(
                    controller: prix,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(245, 205, 1, 1),
                        ),
                      ),
                      prefixIcon: Icon(Icons.euro),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Color.fromRGBO(245, 205, 1, 1),
                      )),
                      hintText: 'valeur entière',
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                //à régler
                ElevatedButton(
                  onPressed: () async {
                    var request = BraintreeDropInRequest(
                      tokenizationKey: tokenizationKey,
                      collectDeviceData: true,
                      googlePaymentRequest: BraintreeGooglePaymentRequest(
                        totalPrice: prix.text,
                        currencyCode: 'USD',
                        billingAddressRequired: false,
                      ),
                      paypalRequest: BraintreePayPalRequest(
                        //Conversion TexteditingController to String
                        amount: prix.text,
                        displayName: 'Example company',
                      ),
                      cardEnabled: true,
                    );
                    final result = await BraintreeDropIn.start(request);
                    if (result != null) {
                      //calcul pour faire le nombre total de point + le nombre de point suplémentaire en
                      //fonction du pourcentage lié au prix
                      //mettre les valeurs en centime pour une meilleure précision.
                      int cours = 4198; //le cours du point (nbredepiece/euro)
                      int pourcentage = 10; //% de + pour 10€ de points
                      double calcul = (cours * int.parse(prix.text) +
                          cours *
                              (int.parse(prix.text) *
                                  (int.parse(prix.text) * 100) *
                                  pourcentage /
                                  1000) /
                              100);
                      int point = calcul.toInt();
                      showNonce(point);
                    }
                  },
                  child: Text('Valider'),
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.black,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15.0),
                    ),
                    primary: Color.fromRGBO(245, 205, 1, 1),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        //currentIndex: this.selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profil()),
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
    );
  }
}

// !!!! A remplacer avec les vrai pages !!!!!
class Reglage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class Message extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class Profil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
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
          Navigator.of(context).push(_createRoute2());
        },
      ),
      title: Text(
        'LUDOPRIZE',
        style: GoogleFonts.nunito(
          color: Colors.yellow.shade700,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white24,
    );
  }
}

Route _createRoute2() {
  return PageRouteBuilder(pageBuilder: (BuildContext context,
      Animation<double> animation, //
      Animation<double> secondaryAnimation) {
    return Text("testroute2");
  });
}
/* void showNonce(BraintreePaymentMethodNonce nonce) {
    _coin = _coin + 10500;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Payment method nonce:'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Nonce: ${nonce.nonce}'),
            SizedBox(height: 16),
            Text('Type label: ${nonce.typeLabel}'),
            SizedBox(height: 16),
            Text('Description: ${nonce.description}'),
          ],
        ),
      ),
    );
  }*/