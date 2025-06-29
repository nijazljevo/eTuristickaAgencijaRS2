// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'destinacija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Destinacija _$DestinacijaFromJson(Map<String, dynamic> json) => Destinacija(
      json['id'] as int?,
      json['naziv'] as String?,
      json['slika'] as String?,
      json['gradId'] as int?,
    );

Map<String, dynamic> _$DestinacijaToJson(Destinacija instance) =>
    <String, dynamic>{
      'id': instance.id,
      'naziv': instance.naziv,
      'slika': instance.slika,
      'gradId': instance.gradId,
    };
