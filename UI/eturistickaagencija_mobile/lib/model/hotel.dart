import 'package:json_annotation/json_annotation.dart';

part 'hotel.g.dart';

@JsonSerializable()
class Hotel{
int? id;
String? naziv;
int? brojZvjezdica;
String? slika;
int? gradId;

Hotel(this.id,this.naziv,this.brojZvjezdica,this.slika,this.gradId);

factory Hotel.fromJson(Map<String,dynamic>json)=>_$HotelFromJson(json);
Map<String,dynamic>toJson()=>_$HotelToJson(this);
}
