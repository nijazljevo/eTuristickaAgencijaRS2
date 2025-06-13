import 'package:json_annotation/json_annotation.dart';

part 'clan.g.dart';

@JsonSerializable()
class Clan{
int? id;
DateTime? datumRegistracije;
int? korisnikId;

Clan(this.id,this.datumRegistracije,this.korisnikId);

factory Clan.fromJson(Map<String,dynamic>json)=>_$ClanFromJson(json);
Map<String,dynamic>toJson()=>_$ClanToJson(this);
}
