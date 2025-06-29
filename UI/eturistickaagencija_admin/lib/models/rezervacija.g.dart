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
      json['checkIn'] == null
          ? null
          : DateTime.parse(json['checkIn'] as String),
      json['checkOut'] == null
          ? null
          : DateTime.parse(json['checkOut'] as String),
      json['brojOsoba'] as int?,
      json['tipSobe'] as String?,
      json['korisnikId'] as int?,
    );

Map<String, dynamic> _$RezervacijaToJson(Rezervacija instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cijena': instance.cijena,
      'hotelId': instance.hotelId,
      'otkazana': instance.otkazana,
      'datumRezervacije': instance.datumRezervacije?.toIso8601String(),
      'checkIn': instance.checkIn?.toIso8601String(),
      'checkOut': instance.checkOut?.toIso8601String(),
      'brojOsoba': instance.brojOsoba,
      'tipSobe': instance.tipSobe,
      'korisnikId': instance.korisnikId,
    };
