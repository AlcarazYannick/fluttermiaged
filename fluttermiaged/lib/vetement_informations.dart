

class VetementInformations {
  String? id;
  String titre;
  String taille;
  double prix;
  String marque;
  String imageURL;
  String categorie;


  VetementInformations({
    this.id,
    required this.titre,
    required this.taille,
    required this.prix,
    required this.marque,
    required this.imageURL,
    required this.categorie
  });


  factory VetementInformations.fromJson(Map<String, dynamic> parsedJson){
    return VetementInformations(
        titre: parsedJson['titre'],
        taille : parsedJson['taille'],
        prix : parsedJson ['prix'],
        marque: parsedJson['marque'],
        imageURL : parsedJson['imageURL'],
        categorie : parsedJson ['categorie']
    );
  }

}
