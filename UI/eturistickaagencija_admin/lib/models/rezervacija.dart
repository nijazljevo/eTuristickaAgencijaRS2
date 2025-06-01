import 'package:json_annotation/json_annotation.dart';

part 'rezervacija.g.dart';

@JsonSerializable()
class Rezervacija {
  int? id;
  double? cijena;
  int? hotelId;
  bool? otkazana;
  DateTime? datumRezervacije;
  DateTime? checkIn;
  DateTime? checkOut;
  int? brojOsoba;
  String? tipSobe;
  int? korisnikId;

  Rezervacija(
      this.id,
      this.cijena,
      this.hotelId,
      this.otkazana,
      this.datumRezervacije,
      this.checkIn,
      this.checkOut,
      this.brojOsoba,
      this.tipSobe,
      this.korisnikId);

  factory Rezervacija.fromJson(Map<String, dynamic> json) =>
      _$RezervacijaFromJson(json);
  Map<String, dynamic> toJson() => _$RezervacijaToJson(this);
}
