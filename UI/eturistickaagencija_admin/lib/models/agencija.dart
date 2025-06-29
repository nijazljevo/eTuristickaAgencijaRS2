
import 'package:json_annotation/json_annotation.dart';
part 'agencija.g.dart';
@JsonSerializable()
class Agencija{
  int? id;
  String? adresa;
  String? email;
  String? telefon;

  Agencija(this.id,this.adresa,this.email,this.telefon);

factory Agencija.fromJson(Map<String,dynamic>json)=>_$AgencijaFromJson(json);
Map<String,dynamic>toJson()=>_$AgencijaToJson(this);
}