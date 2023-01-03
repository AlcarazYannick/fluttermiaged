
import 'dart:html';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttermiaged/profil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'dart:async';



class NewVetementScreen extends StatefulWidget {
  const NewVetementScreen({Key? key}) : super(key: key);

  @override
  _NewVetementScreenState createState() => _NewVetementScreenState();
}

class _NewVetementScreenState extends State<NewVetementScreen> {

  String clothe = "?";
  String? _selectedValue = "Pantalon";

  @override
  Widget build(BuildContext context) {

    TextEditingController _imageURLController = TextEditingController();
    TextEditingController _titreController = TextEditingController();
    TextEditingController _tailleController = TextEditingController();
    TextEditingController _marqueController = TextEditingController();
    TextEditingController _prixController = TextEditingController();

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
              padding: const EdgeInsets.all(10),
              child: DropdownButton<String>(
                value: _selectedValue,
                onChanged: (String? newValue) {
                  print(newValue);
                  setState(() {
                    _selectedValue = newValue;
                  });
                },
                items: <String>['Pantalon', 'Pull', 'Casquette', 'Tshirt']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _imageURLController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.image, color: Colors.black),
                  labelText: "ImageURL",
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _titreController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title, color: Colors.black),
                  labelText: "Titre",
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _tailleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.format_size, color: Colors.black),
                  labelText: 'Taille',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _marqueController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.abc, color: Colors.black),
                  labelText: 'Marque',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _prixController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.euro, color: Colors.black),
                  labelText: 'Prix',
                ),
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton.icon(
                  label: const Text('Valider'),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('vetements')
                        .doc()
                        .set({
                      'imageURL' : _imageURLController.text,
                      'titre': _titreController.text,
                      'categorie': _selectedValue,
                      'taille' : _tailleController.text,
                      'marque': _marqueController.text,
                      'prix' : double.parse(_prixController.text)
                    });
                    Fluttertoast.showToast(
                        msg: "Vetement posté !",
                        timeInSecForIosWeb: 4,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.green[200],
                        textColor: Colors.white,
                        fontSize: 14);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold)
                  ), icon: Icon(Icons.check),
                )),
          ],
        )),
    );
  }

}