import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttermiaged/vetement_informations.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DetailVetementScreen extends StatelessWidget {
  final VetementInformations vetement;
  const DetailVetementScreen({Key? key, required this.vetement})
      : super(key: key);



  @override
  Widget build(BuildContext context) {

    List<VetementInformations> vetementsPanier = <VetementInformations>[];

    var db = FirebaseFirestore.instance;
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    Future<void> updatePanier(uid) async {
      DocumentReference docRef = db.collection("paniers").doc(uid);
      List<dynamic>? listIdVetements;
      listIdVetements = await docRef.get().then((value) {
        return value.get('idVetements');
      });
      listIdVetements?.add(vetement.id);
      db.collection("paniers").doc(uid).update({'idVetements': listIdVetements});
    }


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Image.asset(
          "images/logoTransparent.png",
          fit: BoxFit.cover,
          height: 55,
        ),
        backgroundColor: Colors.cyan,
        centerTitle: true,
        toolbarHeight: 72,
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
                child: Image.network(this.vetement.imageURL.toString(),
                    width: 200, height: 200),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      vetement.titre,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Taille : " + vetement.taille,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Prix : " + vetement.prix.toString() + "€",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Marque : " + vetement.marque.toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Catégorie : " + vetement.categorie.toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
              Container(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton.icon(
                    label: const Text('Ajouter au panier '),
                    onPressed: () async {
                      updatePanier(uid);
                      Fluttertoast.showToast(
                          msg: "Vetement ajouté au panier",
                          timeInSecForIosWeb: 4,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.green[200],
                          textColor: Colors.white,
                          fontSize: 14);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold)
                    ), icon: Icon(Icons.add),
                  ))
            ],
          )),
    );
  }
}
