import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttermiaged/login.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttermiaged/profil.dart';

import 'app.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({Key? key}) : super(key: key);

  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  //FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Container(
                child: AppBar(
                  title: Image.asset(
                    "images/logoTransparent.png",
                    fit: BoxFit.cover,
                    height: 55,
                  ),
                  backgroundColor: Colors.cyan,
                  centerTitle: true,
                  toolbarHeight: 72,
                ),
              ),
              Container(
                child : Image.asset(
                  'images/logo_miaged.png',
                  width: 600.0,
                  height: 240.0,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
                child: TextField(
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
                  height: 60,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton.icon(
                    label: const Text('SIGN UP'),
                    onPressed: () async {
                      FirebaseAuth auth = FirebaseAuth.instance;
                      User? user;
                      print("ici");
                      try {
                        print("try");
                        UserCredential userCredential =
                            await auth.createUserWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text);
                        user = userCredential.user;

                        var userData = {'birthday': null, 'city': null, 'id':user?.uid, 'postal':null};
                        var collection = FirebaseFirestore.instance.collection('users');
                        collection.doc(user?.uid).set(userData) // <-- Your data
                            .then((_) => print('User added'))
                            .catchError((error) => print('Add User failed: $error'));

                        var panierData = {'idVetements': []};
                        var collection2 = FirebaseFirestore.instance.collection('paniers');
                        collection2.doc(user?.uid).set(panierData) // <-- Your data
                            .then((_) => print('Panier Added'))
                            .catchError((error) => print('Add Panier failed: $error'));

                        Fluttertoast.showToast(
                            msg: "Compte crée !",
                            timeInSecForIosWeb: 7,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.grey[600],
                            textColor: Colors.white,
                            fontSize: 14);

                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const LoginScreen()));

                      } on FirebaseAuthException catch (e) {
                        print("exception");
                        print(e.code);
                        Fluttertoast.showToast(
                            msg: e.message.toString(),
                            timeInSecForIosWeb: 7,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.grey[600],
                            textColor: Colors.white,
                            fontSize: 14);

                        _emailController.clear();
                        _passwordController.clear();
                      }


                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        textStyle: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold)
                    ), icon: Icon(Icons.person_add_alt_1_rounded)
                  )),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Already have an account ?"),
                  GestureDetector(
                      onTap: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
                      },
                      child: const Text("Sign In", style: TextStyle(fontWeight: FontWeight.bold))
                  )
                ],
              )
            ],
          )),
    );
  }
}
