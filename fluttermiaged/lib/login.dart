import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttermiaged/create_user.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttermiaged/profil.dart';

import 'app.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                    label: const Text('LOGIN'),
                    onPressed: () async {
                      FirebaseAuth auth = FirebaseAuth.instance;
                      User? user;
                      print("ici");
                      try {
                        print("try");
                        UserCredential userCredential =
                            await auth.signInWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text);
                        user = userCredential.user;
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

                      print(user);
                      if (user != null) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const AppScreen()));
                      }
                    },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                          textStyle: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold)
                      ), icon: Icon(Icons.person_outline)
                  )),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Don't have an account ?"),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const CreateUserScreen()));
                    },
                    child: Text("Sign Up", style: TextStyle(fontWeight: FontWeight.bold))
                  )
                ],
              )

            ],
          )),
    );
  }
}
