// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agencija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Agencija _$AgencijaFromJson(Map<String, dynamic> json) => Agencija(
      json['id'] as int?,
      json['adresa'] as String?,
      json['email'] as String?,
      json['telefon'] as String?,
    );

Map<String, dynamic> _$AgencijaToJson(Agencija instance) => <String, dynamic>{
      'id': instance.id,
      'adresa': instance.adresa,
      'email': instance.email,
      'telefon': instance.telefon,
    };
