
class UserInformations {

  String? postal;
  String? birthday;
  String? city;


  UserInformations({
    this.postal,
    this.birthday,
    this.city
  });


  factory UserInformations.fromJson(Map<String, dynamic> parsedJson){
    return UserInformations(
        postal: parsedJson['postal'],
        birthday : parsedJson['birthday'],
        city : parsedJson ['city']
    );
  }

}
