import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttermiaged/login.dart';
import 'package:fluttermiaged/user_informations.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'new_vetement.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({Key? key}) : super(key: key);

  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    //Future<DocumentSnapshot<Map<String, dynamic>>> doc = FirebaseFirestore.instance.collection('users').doc(uid).get();


    TextEditingController _emailController = TextEditingController(text: user?.email);
    TextEditingController _passwordController = TextEditingController(text: "********");
    TextEditingController _birthdayController = TextEditingController();
    TextEditingController _postalController = TextEditingController();
    TextEditingController _cityController = TextEditingController();

    FirebaseFirestore.instance.collection("users").doc(uid).get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          UserInformations userInformations =  UserInformations.fromJson(data);
          _birthdayController.text = userInformations.birthday.toString();
          _postalController.text = userInformations.postal.toString();
          _cityController.text = userInformations.city.toString();
          return userInformations;
        },
        onError: (e) => print("Error getting document: $e"),
      );

    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                readOnly: true,
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email, color: Colors.black),
                  labelText: 'Email',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                obscureText: true,
                controller: _passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock, color: Colors.black),
                  labelText: 'Password',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _birthdayController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.cake, color: Colors.black),
                  labelText: "Date d'anniversaire (jj/mm/aaaa)",
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _postalController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon:
                      Icon(Icons.local_post_office, color: Colors.black),
                  labelText: 'Code Postal',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _cityController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_city, color: Colors.black),
                  labelText: 'Ville',
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                height: 30,
                child: ElevatedButton.icon(
                  label: const Text('Valider'),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .set({
                      'birthday': _birthdayController.text,
                      'city': _cityController.text,
                      'id' : uid,
                      'postal': _postalController.text,
                    });
                    print("user's informations validated");
                    if(_passwordController.text != "********"){
                      user?.updatePassword(_passwordController.text);
                      user?.reload();
                      print("user's password updated");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold)
                  ), icon: Icon(Icons.check),
                )),
            SizedBox(height: 10),
            Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                height: 30,
                child: ElevatedButton.icon(
                  label: const Text('Déconnecter'),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
                    print("user disconnected");
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold)
                  ), icon: Icon(Icons.person_off_outlined),
                )),
            SizedBox(height: 10),
            Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                height: 30,
                child: ElevatedButton.icon(
                  label: const Text('Ajouter un vêtement'),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NewVetementScreen()),
                    );
                    print("new vetement");
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold)
                  ), icon: Icon(Icons.add),
                )),
          ],
        ));
  }
}
