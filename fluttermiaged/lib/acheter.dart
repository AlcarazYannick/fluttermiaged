import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttermiaged/vetement_informations.dart';

import 'detail_vetement.dart';

class AcheterScreen extends StatefulWidget {
  const AcheterScreen({Key? key}) : super(key: key);

  @override
  _AcheterScreenState createState() => _AcheterScreenState();
}

class _AcheterScreenState extends State<AcheterScreen> with SingleTickerProviderStateMixin {
  var db = FirebaseFirestore.instance;

  List<List<VetementInformations>> listVetements = <List<VetementInformations>>[];
  List<Widget> widgets = <Widget>[];

  static List<String> myTabsString = ["Tous", "Pantalon", "Pull", "Casquette", "Tshirt"];

  var myTabs = List<Tab>.generate(myTabsString.length, (i) => Tab(text: myTabsString[i]));

  late TabController _tabController;


  @override
  void initState() {
    print("//==============================================//");
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    for(int i = 0; i< myTabsString.length; i++){

      print("myTabs [$i].text : ${myTabs[i].text}");
      getVetements(myTabs[i].text);
    }
    //getWidget();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> getVetements(String? categorie) async {
    List<VetementInformations> vetements = <VetementInformations>[];
    print("vetements.lenght : ${vetements.length}");
    QuerySnapshot querySnapshot = await db.collection("vetements").get();
    querySnapshot.docs.forEach((e) {
      VetementInformations vetement =
          VetementInformations.fromJson(e.data() as Map<String, dynamic>);
      vetement.id = e.id;
      if(categorie.toString() == "Tous" || vetement.categorie == categorie.toString()){
        print(" ${vetement.categorie} == ${categorie.toString()}");
        vetements.add(vetement);
      }
    });
    print(categorie);
    for(int i =0; i< vetements.length; i++){
      print("vetement $i : ${vetements[i].titre}");
    }
    listVetements.add(vetements);
    if(categorie.toString() == myTabsString[myTabsString.length-1].toString()) {
      getWidget();
    }
  }

  Future<void> getWidget() async {
    for(int i =0; i< myTabs.length; i++){
      Widget widget = GridView.count(
          crossAxisCount: 2,
          children: List.generate(listVetements[i].length, (index) {
            VetementInformations vetement = listVetements[i].elementAt(index);
            return InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailVetementScreen(vetement : listVetements[i][index]))),
              child: Card (
                child: Column(
                    children : <Widget>[
                      Image.network(vetement.imageURL.toString(), width: 120, height: 120),
                      Text(vetement.titre, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text("${vetement.prix}€"),
                      Text("Taille : ${vetement.taille}")
                    ]
                ),
              ),
            );
          })
      );
      widgets.add(widget);
    }
  }

  Future<int> callAsyncFetch() =>
      Future.delayed(const Duration(seconds: 3), () => listVetements[0].length);

  @override
  Widget build(BuildContext context) {


    //getVetements(myTabs[_tabController.index].text);
    return Container(
        child: FutureBuilder<int>(
            future: callAsyncFetch(),
            builder: (context, AsyncSnapshot<int> snapshot) {
              if (snapshot.hasData) {
                print("hasData");
                print(snapshot.requireData);
                return MaterialApp(
                    home: DefaultTabController(
                        length: 3,
                        child: Scaffold(
                            appBar: AppBar(
                                bottom: TabBar(
                                  controller: _tabController,
                                  tabs: myTabs,
                                ),
                                backgroundColor: Colors.cyan,
                                centerTitle: true,
                                toolbarHeight: 1,
                            ),
                            body: TabBarView(
                              controller: _tabController,
                              children: widgets,
                            ))));
              } else {
                return const CircularProgressIndicator();
              }
            }));
  }
}
