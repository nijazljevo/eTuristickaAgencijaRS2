import 'package:json_annotation/json_annotation.dart';

part 'destinacija.g.dart';

@JsonSerializable()
class Destinacija{
int? id;
String? naziv;
String? slika;
int? gradId;

Destinacija(this.id,this.naziv,this.slika,this.gradId);

factory Destinacija.fromJson(Map<String,dynamic>json)=>_$DestinacijaFromJson(json);
Map<String,dynamic>toJson()=>_$DestinacijaToJson(this);
}
