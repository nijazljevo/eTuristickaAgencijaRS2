import 'package:json_annotation/json_annotation.dart';

part 'kontinent.g.dart';

@JsonSerializable()
class Kontinent{
int? id;
String? naziv;


Kontinent(this.id,this.naziv);

factory Kontinent.fromJson(Map<String,dynamic>json)=>_$KontinentFromJson(json);
Map<String,dynamic>toJson()=>_$KontinentToJson(this);
}
