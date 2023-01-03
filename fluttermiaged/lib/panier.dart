import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttermiaged/acheter.dart';
import 'package:fluttermiaged/app.dart';
import 'package:fluttermiaged/vetement_informations.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'detail_vetement.dart';

class PanierScreen extends StatefulWidget {
  const PanierScreen({Key? key}) : super(key: key);

  @override
  _PanierScreenState createState() => _PanierScreenState();
}

class _PanierScreenState extends State<PanierScreen> {
  List<dynamic> listIdVetementsPanier = [];
  List<VetementInformations> listObjectVetements = [];
  double totalPrixPanier = 0;

  Future<void> getVetementsPanier(uid) async {
    listIdVetementsPanier = await FirebaseFirestore.instance
        .collection("paniers")
        .doc(uid)
        .get()
        .then((value) {
      return value.get('idVetements');
    });
    getObjects();
  }

  Future<void> deleteVetementsPanier(uid, idVetement) async {
    int index = listIdVetementsPanier.indexOf(idVetement.toString());
    listIdVetementsPanier.removeAt(index);

    FirebaseFirestore.instance
        .collection("paniers")
        .doc(uid)
        .update({'idVetements': listIdVetementsPanier}).then(
            (value) => setState(() {}));
  }

  Future<void> getObjects() async {
    totalPrixPanier = 0;
    for (int i = 0; i < listIdVetementsPanier.length; i++) {
      await FirebaseFirestore.instance
          .collection("vetements")
          .doc(listIdVetementsPanier[i])
          .get()
          .then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          VetementInformations vetementInformations =
              VetementInformations.fromJson(data);
          vetementInformations.id = doc.id;
          totalPrixPanier = totalPrixPanier + vetementInformations.prix;
          totalPrixPanier = (totalPrixPanier * 100).round() / 100;
          listObjectVetements.add(vetementInformations);
        },
        onError: (e) => print("Error getting document: $e"),
      );
    }
    //setState(() {});
  }

  Future<int> callAsyncFetch() => Future.delayed(
      const Duration(seconds: 3), () => listIdVetementsPanier.length);

  @override
  Widget build(BuildContext context) {
    listIdVetementsPanier.clear();
    listObjectVetements.clear();

    String? idUser = FirebaseAuth.instance.currentUser?.uid;
    getVetementsPanier(idUser);

    return Container(
        child: FutureBuilder<int>(
            future: callAsyncFetch(),
            builder: (context, AsyncSnapshot<int> snapshot) {
              if (snapshot.hasData) {
                print("if");
                return Scaffold(
                    appBar: AppBar(
                      title: Text(
                          'Montant panier : $totalPrixPanier €',
                          style: TextStyle(color: Colors.black)),
                      backgroundColor: Colors.white70,
                    ),
                    body: ListView(
                        padding: const EdgeInsets.all(20),
                        children: List.generate(snapshot.requireData, (index) {
                          print("index : ");
                          print(index);
                          if (listObjectVetements.asMap().containsKey(index)) {
                            VetementInformations vetement =
                                listObjectVetements[index];

                            return Card(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Image.network(vetement.imageURL.toString(),
                                      width: 120, height: 120),
                                  Text(vetement.titre, style: const TextStyle(
                                    fontWeight: FontWeight.bold,)),
                                  Text("${vetement.prix}€"),
                                  Text("Taille : ${vetement.taille}"),
                                  Text("Marque : ${vetement.marque}"),
                                  Text("Catégorie : ${vetement.categorie}"),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      IconButton(
                                        iconSize: 40,
                                        icon: const Icon(Icons.close),
                                        color: Colors.red,
                                        onPressed: () {
                                          deleteVetementsPanier(
                                              idUser, vetement.id);
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Vetement supprimé du panier",
                                              timeInSecForIosWeb: 4,
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor:
                                                  Colors.green[200],
                                              textColor: Colors.white,
                                              fontSize: 14);
                                        },
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        })));
              } else {
                return const CircularProgressIndicator();
              }
            }));
  }
}
