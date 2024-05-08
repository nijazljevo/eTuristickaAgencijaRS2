import 'package:json_annotation/json_annotation.dart';

part 'termin.g.dart';

@JsonSerializable()
class Termin{
int? id;
double? cijena;
double? popust;
double? cijenaPopust;
int? hotelId;
int? destinacijaId;
bool? aktivanTermin;
DateTime? datumPolaska;
DateTime? datumDolaska;
int? gradId;

Termin(this.id,this.cijena,this.popust,this.cijenaPopust,this.hotelId,this.destinacijaId,this.aktivanTermin,this.datumPolaska,this.datumDolaska,this.gradId);

factory Termin.fromJson(Map<String,dynamic>json)=>_$TerminFromJson(json);
Map<String,dynamic>toJson()=>_$TerminToJson(this);
}
