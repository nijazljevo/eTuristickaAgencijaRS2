// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rezervacija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rezervacija _$RezervacijaFromJson(Map<String, dynamic> json) => Rezervacija(
      json['id'] as int?,
      (json['cijena'] as num?)?.toDouble(),
      json['hotelId'] as int?,
      json['otkazana'] as bool?,
      json['datumRezervacije'] == null
          ? null
          : DateTime.parse(json['datumRezervacije'] as String),
      json['korisnikId'] as int?,
    );

Map<String, dynamic> _$RezervacijaToJson(Rezervacija instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cijena': instance.cijena,
      'hotelId': instance.hotelId,
      'otkazana': instance.otkazana,
      'datumRezervacije': instance.datumRezervacije?.toIso8601String(),
      'korisnikId': instance.korisnikId,
    };
