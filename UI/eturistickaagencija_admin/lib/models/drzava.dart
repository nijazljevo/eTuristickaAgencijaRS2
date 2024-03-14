
import 'package:json_annotation/json_annotation.dart';
part 'drzava.g.dart';
@JsonSerializable()
class Drzava{
  int? id;
  String? naziv;
  int? kontinentId;
 

  Drzava(this.id,this.naziv,this.kontinentId);

factory Drzava.fromJson(Map<String,dynamic>json)=>_$DrzavaFromJson(json);
Map<String,dynamic>toJson()=>_$DrzavaToJson(this);
}