import 'package:json_annotation/json_annotation.dart';

part 'karta.g.dart';

@JsonSerializable()
class Karta{
int? id;
int? terminId;
int? korisnikId;
DateTime? datumKreiranja;
bool? ponistena;

Karta(this.id,this.terminId,this.korisnikId,this.datumKreiranja,this.ponistena);

factory Karta.fromJson(Map<String,dynamic>json)=>_$KartaFromJson(json);
Map<String,dynamic>toJson()=>_$KartaToJson(this);
}
