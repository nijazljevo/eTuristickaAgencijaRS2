import 'package:json_annotation/json_annotation.dart';

part 'uposlenik.g.dart';

@JsonSerializable()
class Uposlenik{
int? id;
int? korisnikId;
bool? aktivan;
DateTime? datumZaposlenja;




Uposlenik(this.id,this.korisnikId,this.aktivan,this.datumZaposlenja);

factory Uposlenik.fromJson(Map<String,dynamic>json)=>_$UposlenikFromJson(json);
Map<String,dynamic>toJson()=>_$UposlenikToJson(this);
}
