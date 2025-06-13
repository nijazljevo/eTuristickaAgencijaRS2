// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Clan _$ClanFromJson(Map<String, dynamic> json) => Clan(
      json['id'] as int?,
      json['datumRegistracije'] == null
          ? null
          : DateTime.parse(json['datumRegistracije'] as String),
      json['korisnikId'] as int?,
    );

Map<String, dynamic> _$ClanToJson(Clan instance) =>
    <String, dynamic>{
      'id': instance.id,
      'datumRegistracije': instance.datumRegistracije?.toIso8601String(),
      'korisnikId': instance.korisnikId,
    };
