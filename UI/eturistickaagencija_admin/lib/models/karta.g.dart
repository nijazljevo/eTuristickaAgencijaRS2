// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'karta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Karta _$KartaFromJson(Map<String, dynamic> json) => Karta(
      json['id'] as int?,
      json['terminId'] as int?,
      json['korisnikId'] as int?,
      json['datumKreiranja'] == null
          ? null
          : DateTime.parse(json['datumKreiranja'] as String),
      json['ponistena'] as bool?,
    );

Map<String, dynamic> _$KartaToJson(Karta instance) => <String, dynamic>{
      'id': instance.id,
      'terminId': instance.terminId,
      'korisnikId': instance.korisnikId,
      'datumKreiranja': instance.datumKreiranja?.toIso8601String(),
      'ponistena': instance.ponistena,
    };
