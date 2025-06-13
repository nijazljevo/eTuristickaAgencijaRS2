// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'termin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Termin _$TerminFromJson(Map<String, dynamic> json) => Termin(
      json['id'] as int?,
      (json['cijena'] as num?)?.toDouble(),
      (json['popust'] as num?)?.toDouble(),
      (json['cijenaPopust'] as num?)?.toDouble(),
      json['hotelId'] as int?,
      json['destinacijaId'] as int?,
      json['aktivanTermin'] as bool?,
      json['datumPolaska'] == null
          ? null
          : DateTime.parse(json['datumPolaska'] as String),
          json['datumDolaska'] == null
          ? null
          : DateTime.parse(json['datumDolaska'] as String),
      json['gradId'] as int?,
    );

Map<String, dynamic> _$TerminToJson(Termin instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cijena': instance.cijena,
      'popust': instance.popust,
      'cijenaPopust': instance.cijenaPopust,
      'hotelId': instance.hotelId,
      'destinacijaId': instance.destinacijaId,
      'aktivanTermin': instance.aktivanTermin,
      'datumPolaska': instance.datumPolaska?.toIso8601String(),
      'datumDolaska': instance.datumDolaska?.toIso8601String(),
      'gradId': instance.gradId,
    };
