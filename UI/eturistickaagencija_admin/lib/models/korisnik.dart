import 'package:json_annotation/json_annotation.dart';

part 'korisnik.g.dart';

@JsonSerializable()
class Korisnik{
int? id;
String? ime;
String? prezime;
String? korisnikoIme;
String? slika;
String? email;
String? password;
String? passwordPotvrda;
int? ulogaId;


Korisnik(this.id,this.ime,this.prezime,this.korisnikoIme,this.slika,this.email,this.password,this.passwordPotvrda,this.ulogaId);

factory Korisnik.fromJson(Map<String,dynamic>json)=>_$KorisnikFromJson(json);
Map<String,dynamic>toJson()=>_$KorisnikToJson(this);
}
