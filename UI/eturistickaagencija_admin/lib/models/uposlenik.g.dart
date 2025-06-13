// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uposlenik.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************


Uposlenik _$UposlenikFromJson(Map<String, dynamic> json) => Uposlenik(
      json['id'] as int?,
      json['korisnikId'] as int?,
      json['aktivan'] as bool?,
      json['datumZaposlenja'] == null
          ? null
          : DateTime.parse(json['datumZaposlenja'] as String),
    );

Map<String, dynamic> _$UposlenikToJson(Uposlenik instance) => <String, dynamic>{
      'id': instance.id,
      'korisnikId': instance.korisnikId,
      'aktivan': instance.aktivan,
      'datumZaposlenja': instance.datumZaposlenja?.toIso8601String(),
      
    };
